"""Embed `pricing_data.json` into the server as a Dart constant.

The Serverpod server has no reliable asset path at runtime, so the pricing
dataset ships as source. Re-run this whenever the pricing data changes:

    python ml/train_pricing.py
    python ml/export_dart.py
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "pricing_data.json"
TARGET = (
    ROOT.parent
    / "vyaparsetu_ai"
    / "vyaparsetu_ai_server"
    / "lib"
    / "src"
    / "pricing"
    / "pricing_dataset.dart"
)


def main() -> int:
    payload = SOURCE.read_text(encoding="utf-8")
    if "'''" in payload:
        raise SystemExit("pricing data contains a triple quote; refusing to embed")

    TARGET.parent.mkdir(parents=True, exist_ok=True)
    TARGET.write_text(
        "// GENERATED FILE - do not edit by hand.\n"
        "// Source: ml/data/*.csv and ml/train_pricing.py\n"
        "// Regenerate: python ml/train_pricing.py && python ml/export_dart.py\n\n"
        "/// Pricing dataset (WPI index, cost profiles, comparable prices).\n"
        "const pricingDatasetJson = r'''\n"
        f"{payload}\n"
        "''';\n",
        encoding="utf-8",
    )
    print(f"wrote {TARGET} ({TARGET.stat().st_size / 1024:.1f} KB)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
