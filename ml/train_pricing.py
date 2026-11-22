"""Train the VyaparSetu market-price model and export it for Dart inference.

What this script does
---------------------
1. Loads the illustrative retail benchmark (`ml/data/retail_benchmark.csv`),
   the artisan cost profiles (`ml/data/pricing_profile.csv`) and the real WPI
   index values (`ml/data/wpi_index.csv`, base 2022-23).
2. Trains a text + category regression model that predicts the market ceiling
   (what a comparable product sells for at retail).
3. Measures accuracy honestly with leave-one-out cross-validation, because the
   benchmark is small. The numbers it prints are the numbers the app may quote.
4. Exports `pricing_model.json`, which the Dart pricing engine embeds and uses
   together with the deterministic cost floor.

Run:
    python ml/train_pricing.py

The model is a *prior*, not an oracle: the deterministic cost floor and the
live catalogue comparables are what make the recommendation defensible.
"""

from __future__ import annotations

import json
import math
import re
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import Ridge
from sklearn.metrics import mean_absolute_error, mean_absolute_percentage_error

ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"
OUTPUT = ROOT / "pricing_data.json"

TOKEN_PATTERN = re.compile(r"\b\w\w+\b")

SEGMENTS = ["Food", "Handloom", "Handicraft", "Manufacturing"]

# Keywords used to map a free-text category from the app to a benchmark segment.
SEGMENT_RULES = [
    ("Food", ["food", "homemade", "spice", "pickle", "honey", "oil", "jaggery", "gur"]),
    (
        "Manufacturing",
        ["metal", "brass", "copper", "bronze", "dhokra", "machine", "tool", "steel", "iron"],
    ),
    (
        "Handloom",
        ["handloom", "textile", "cloth", "embroidery", "apparel", "leather", "silk", "khadi", "pashmina", "shawl"],
    ),
    (
        "Handicraft",
        ["handicraft", "wood", "pottery", "ceramic", "terracotta", "clay", "decor", "craft", "jute", "bamboo"],
    ),
]


def segment_for(category: str, description: str) -> str:
    haystack = f"{category} {description}".lower()
    for segment, keywords in SEGMENT_RULES:
        if any(keyword in haystack for keyword in keywords):
            return segment
    return "Handicraft"


def tokenize(text: str) -> list[str]:
    return TOKEN_PATTERN.findall(text.lower())


class TextCategoryFeatures:
    """Minimal TF-IDF + one-hot encoder that mirrors what Dart will do."""

    def __init__(self) -> None:
        self.vocabulary: dict[str, int] = {}
        self.idf: np.ndarray = np.array([])

    def fit(self, texts: list[str]) -> "TextCategoryFeatures":
        document_frequency: dict[str, int] = {}
        for text in texts:
            for token in set(tokenize(text)):
                document_frequency[token] = document_frequency.get(token, 0) + 1
        tokens = sorted(document_frequency)
        self.vocabulary = {token: index for index, token in enumerate(tokens)}
        n_documents = len(texts)
        self.idf = np.array(
            [
                math.log((1 + n_documents) / (1 + document_frequency[token])) + 1
                for token in tokens
            ]
        )
        return self

    def transform(self, texts: list[str], segments: list[str]) -> np.ndarray:
        rows = np.zeros((len(texts), len(self.vocabulary) + len(SEGMENTS)))
        for row, (text, segment) in enumerate(zip(texts, segments)):
            counts: dict[int, int] = {}
            for token in tokenize(text):
                index = self.vocabulary.get(token)
                if index is not None:
                    counts[index] = counts.get(index, 0) + 1
            for index, count in counts.items():
                rows[row, index] = count * self.idf[index]
            norm = np.linalg.norm(rows[row, : len(self.vocabulary)])
            if norm > 0:
                rows[row, : len(self.vocabulary)] /= norm
            rows[row, len(self.vocabulary) + SEGMENTS.index(segment)] = 1.0
        return rows


def loocv(
    texts: list[str],
    segments: list[str],
    targets: np.ndarray,
    fit_predict,
) -> np.ndarray:
    predictions = np.zeros(len(targets))
    for index in range(len(targets)):
        mask = np.arange(len(targets)) != index
        train_texts = [texts[i] for i in np.flatnonzero(mask)]
        train_segments = [segments[i] for i in np.flatnonzero(mask)]
        features = TextCategoryFeatures().fit(train_texts)
        x_train = features.transform(train_texts, train_segments)
        x_test = features.transform([texts[index]], [segments[index]])
        model = fit_predict(x_train, targets[mask])
        predictions[index] = float(model.predict(x_test)[0])
    return predictions


def report(name: str, predictions: np.ndarray, targets: np.ndarray) -> dict:
    mae = float(mean_absolute_error(targets, predictions))
    mape = float(mean_absolute_percentage_error(targets, predictions))
    r2 = float(1 - np.sum((targets - predictions) ** 2) / np.sum((targets - targets.mean()) ** 2))
    print(f"{name:<22} MAE {mae:7.2f}   MAPE {mape * 100:5.1f}%   R2 {r2:6.3f}")
    return {"mae": round(mae, 2), "mape": round(mape, 4), "r2": round(r2, 4)}


def main() -> int:
    benchmark = pd.read_csv(DATA / "retail_benchmark.csv")
    profiles = pd.read_csv(DATA / "pricing_profile.csv")
    wpi = pd.read_csv(DATA / "wpi_index.csv")

    texts = [
        f"{row.Description} {row.Category}" for row in benchmark.itertuples()
    ]
    segments = [
        segment_for(str(row.Category), str(row.Description))
        for row in benchmark.itertuples()
    ]
    targets = benchmark["Selling_Price"].to_numpy(dtype=float)

    print(f"benchmark rows: {len(targets)}")
    print("segment counts:", pd.Series(segments).value_counts().to_dict())
    print()
    print("Leave-one-out cross-validation (lower error is better):")

    baseline = loocv(
        texts,
        segments,
        targets,
        lambda x, y: _ConstantPredictor(float(np.median(y))),
    )
    baseline_metrics = report("category median", baseline, targets)

    ridge = loocv(
        texts,
        segments,
        targets,
        lambda x, y: Ridge(alpha=1.0).fit(x, y),
    )
    ridge_metrics = report("Ridge (TF-IDF+cat)", ridge, targets)

    forest = loocv(
        texts,
        segments,
        targets,
        lambda x, y: RandomForestRegressor(
            n_estimators=200, min_samples_leaf=1, random_state=42
        ).fit(x, y),
    )
    forest_metrics = report("RandomForest", forest, targets)

    knn_predictions = {}
    for k in (1, 3, 5):
        predictions = _knn_loocv(texts, segments, targets, k=k, same_segment=True)
        knn_predictions[f"knn_{k}"] = (report(f"k-NN k={k} (same segment)", predictions, targets), predictions)
    global_knn = _knn_loocv(texts, segments, targets, k=3, same_segment=False)
    knn_predictions["knn_3_global"] = (
        report("k-NN k=3 (all segments)", global_knn, targets),
        global_knn,
    )

    wpi_map = {
        str(row.group): round(float(row.index_value) / 100.0, 4)
        for row in wpi.itertuples()
    }
    engine_predictions = _engine_loocv(
        texts, segments, targets, profiles, wpi_map
    )
    engine_metrics = report("shipped engine", engine_predictions, targets)

    candidates: dict[str, dict] = {
        "ridge": ridge_metrics,
        "random_forest": forest_metrics,
    }
    for name, (metrics, _predictions) in knn_predictions.items():
        candidates[name] = metrics

    best_name = min(candidates, key=lambda key: candidates[key]["mae"])
    best_metrics = candidates[best_name]
    print()
    print(f"selected model: {best_name} (MAE {best_metrics['mae']})")
    print()
    print("Metrics are leave-one-out on the illustrative benchmark only.")
    print("They are a floor for trust, not a guarantee: real accuracy is")
    print("measured against accepted quotes once the marketplace has traffic.")

    payload: dict = {
        "version": 3,
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "benchmark_rows": int(len(targets)),
        "shipped_engine": "cost_floor + comparable_band",
        "note": (
            "Regression metrics are recorded for transparency. The shipped "
            "engine does not use them: on this benchmark their error is too "
            "high to be sold as a price prediction. The engine uses the "
            "deterministic cost floor, real WPI inflation, and a comparable "
            "band that improves as real listings are added."
        ),
        "metrics": {
            "best_regression": best_name,
            "baseline_category_median": baseline_metrics,
            "ridge": ridge_metrics,
            "random_forest": forest_metrics,
            "shipped_engine": engine_metrics,
            "knn": {
                name: metrics
                for name, (metrics, _predictions) in knn_predictions.items()
            },
        },
        "segments": SEGMENTS,
        "wpi_period": f"{int(wpi.iloc[0].year)}-{wpi.iloc[0].month}",
        "wpi": {
            str(row.group): round(float(row.index_value) / 100.0, 4)
            for row in wpi.itertuples()
        },
        "comparables": [
            {
                "text": text,
                "segment": segment,
                "price": round(float(target), 2),
            }
            for text, segment, target in zip(texts, segments, targets)
        ],
        "cost_profiles": [
            {
                "name": str(row.product_name),
                "segment": segment_for(str(row.product_name), str(row.product_name)),
                "wpi_group": str(row.wpi_category),
                "base_material_cost": float(row.base_material_cost),
                "material_qty": float(row.material_qty),
                "labor_hours": float(row.labor_hours_per_unit),
                "hourly_wage": float(row.hourly_wage_inr),
                "packaging": float(row.packaging_cost_inr),
                "target_margin": float(row.target_margin_pct),
            }
            for row in profiles.itertuples()
        ],
    }

    OUTPUT.write_text(json.dumps(payload, separators=(",", ":")), encoding="utf-8")
    size_kb = OUTPUT.stat().st_size / 1024
    print(f"wrote {OUTPUT} ({size_kb:.1f} KB)")
    return 0


def _engine_loocv(
    texts: list[str],
    segments: list[str],
    targets: np.ndarray,
    profiles_frame: pd.DataFrame,
    wpi_map: dict[str, float],
) -> np.ndarray:
    """End-to-end mirror of the shipped Dart engine, evaluated leave-one-out."""
    token_sets = [set(tokenize(text)) for text in texts]
    profiles: list[dict] = []
    for row in profiles_frame.itertuples():
        name = str(row.product_name)
        profiles.append(
            {
                "name": name,
                "segment": segment_for(name, name),
                "wpi_group": str(row.wpi_category),
                "base": float(row.base_material_cost),
                "qty": float(row.material_qty),
                "hours": float(row.labor_hours_per_unit),
                "wage": float(row.hourly_wage_inr),
                "packaging": float(row.packaging_cost_inr),
                "margin": float(row.target_margin_pct),
            }
        )

    defaults = {
        "Food": ("Manufacture Of Food Products", 60, 1.0, 1.0, 45, 20, 0.25),
        "Handloom": ("Manufacture Of Textiles", 180, 1.5, 3.5, 55, 30, 0.30),
        "Handicraft": (
            "Manufacture Of Other Non-Metallic Mineral Products",
            150,
            1.5,
            3.0,
            50,
            30,
            0.30,
        ),
        "Manufacturing": (
            "Manufacture Of Fabricated Metal Products, Except Machinery And Equipment",
            200,
            2.0,
            2.0,
            75,
            15,
            0.20,
        ),
    }

    predictions = np.zeros(len(targets))
    for index in range(len(targets)):
        profile = _best_profile(token_sets[index], segments[index], profiles)
        if profile is None:
            group, base, qty, hours, wage, packaging, margin = defaults[
                segments[index]
            ]
            profile = {
                "name": f"{segments[index]} default",
                "wpi_group": group,
                "base": base,
                "qty": qty,
                "hours": hours,
                "wage": wage,
                "packaging": packaging,
                "margin": margin,
            }

        wpi_multiplier = _wpi_for(profile["wpi_group"], wpi_map)
        break_even = (
            profile["base"] * profile["qty"] * wpi_multiplier
            + profile["hours"] * profile["wage"]
            + profile["packaging"]
        )
        desired = break_even * (1 + profile["margin"])

        candidates: list[tuple[float, float]] = []
        for other in range(len(targets)):
            if other == index or segments[other] != segments[index]:
                continue
            a, b = token_sets[index], token_sets[other]
            shared = len(a & b)
            if shared == 0:
                continue
            candidates.append(
                (shared / math.sqrt(len(a) * len(b)), float(targets[other]))
            )
        candidates.sort(key=lambda item: item[0], reverse=True)
        top = candidates[:5]
        if top:
            weights = np.array([max(similarity, 0.05) for similarity, _ in top])
            prices = np.array([price for _, price in top])
            ceiling = float(np.average(prices, weights=weights))
        else:
            ceiling = desired * 1.35

        hard_floor = break_even * 1.02
        predictions[index] = (
            min(max(desired, hard_floor), ceiling)
            if ceiling >= hard_floor
            else max(desired, hard_floor)
        )
    return predictions


def _best_profile(
    tokens: set[str], segment: str, profiles: list[dict]
) -> dict | None:
    best: dict | None = None
    best_score = 0
    best_coverage = 0.0
    for profile in profiles:
        if profile["segment"] != segment:
            continue
        profile_tokens = set(tokenize(profile["name"]))
        shared = len(profile_tokens & tokens)
        if shared == 0:
            continue
        coverage = shared / len(profile_tokens)
        if shared > best_score or (
            shared == best_score and coverage > best_coverage
        ):
            best = profile
            best_score = shared
            best_coverage = coverage
    return best


def _wpi_for(group: str, wpi_map: dict[str, float]) -> float:
    if group in wpi_map:
        return wpi_map[group]
    for key, value in wpi_map.items():
        if key.startswith(group) or group.startswith(key):
            return value
    short = " ".join(group.split(" ")[:3])
    for key, value in wpi_map.items():
        if key.startswith(short):
            return value
    return wpi_map.get("All Commodities", 1.05)


def _knn_loocv(
    texts: list[str],
    segments: list[str],
    targets: np.ndarray,
    *,
    k: int,
    same_segment: bool,
) -> np.ndarray:
    """Mirror of the shipped Dart comparable band (binary cosine, top-k)."""
    token_sets = [set(tokenize(text)) for text in texts]
    predictions = np.zeros(len(targets))
    for index in range(len(targets)):
        candidates: list[tuple[float, float]] = []
        for other in range(len(targets)):
            if other == index:
                continue
            if same_segment and segments[other] != segments[index]:
                continue
            a, b = token_sets[index], token_sets[other]
            if not a or not b:
                continue
            shared = len(a & b)
            if shared == 0:
                continue
            similarity = shared / math.sqrt(len(a) * len(b))
            candidates.append((similarity, float(targets[other])))

        if not candidates:
            pool = [
                float(targets[other])
                for other in range(len(targets))
                if other != index
                and (not same_segment or segments[other] == segments[index])
            ]
            predictions[index] = (
                float(np.median(pool)) if pool else float(np.median(targets))
            )
            continue

        candidates.sort(key=lambda item: item[0], reverse=True)
        top = candidates[:k]
        weights = np.array([max(similarity, 0.05) for similarity, _ in top])
        prices = np.array([price for _, price in top])
        predictions[index] = float(np.average(prices, weights=weights))
    return predictions


class _ConstantPredictor:
    def __init__(self, value: float) -> None:
        self.value = value

    def predict(self, _x: np.ndarray) -> np.ndarray:
        return np.array([self.value])


if __name__ == "__main__":
    raise SystemExit(main())
