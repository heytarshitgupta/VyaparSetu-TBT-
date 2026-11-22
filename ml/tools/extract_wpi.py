"""Extract the latest WPI index values we use for pricing from the raw workbook.

Source: Office of the Economic Adviser (DPIIT), Wholesale Price Index,
base year 2022-23. The raw workbook is large (about 19 MB), so only the handful
of group-level series used by the pricing engine are kept in the repository.

Usage:
    python ml/tools/extract_wpi.py "C:\\path\\to\\wpi.xlsx" ml/data/wpi_index.csv
"""

from __future__ import annotations

import csv
import sys
from pathlib import Path

import pandas as pd

# Group-level series referenced by the pricing profiles. These match the
# `group` column of the workbook exactly.
WPI_GROUPS = [
    "Manufacture Of Food Products",
    "Food Articles",
    "Manufacture Of Textiles",
    "Manufacture Of Wearing Apparel",
    "Manufacture Of Leather And Related Products",
    "Manufacture Of Wood And Products Of Wood And Cork, Except Furniture; Manufacture Of Articles Of Straw And Plaiting Materials",
    "Manufacture Of Other Non-Metallic Mineral Products",
    "Manufacture Of Fabricated Metal Products, Except Machinery And Equipment",
    "Manufacture Of Basic Metals",
    "Manufacture Of Motor Vehicles, Trailers And Semi-Trailers",
    "Manufacture Of Machinery And Equipment N.E.C.",
]


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 2

    source = Path(sys.argv[1])
    destination = Path(sys.argv[2])

    frame = pd.read_excel(source, sheet_name="WPI Data")
    frame = frame.dropna(subset=["year", "month", "group", "index_value"])

    latest_year = int(frame["year"].max())
    latest = frame[frame["year"] == latest_year]
    # Pick the last month present for the latest year.
    month_order = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ]
    months = [m for m in month_order if m in set(latest["month"])]
    latest_month = months[-1]
    latest = latest[latest["month"] == latest_month]

    rows = []
    for group in WPI_GROUPS:
        match = latest[latest["group"] == group]
        if match.empty:
            print(f"warning: no WPI row for {group!r}")
            continue
        rows.append(
            {
                "group": group,
                "year": latest_year,
                "month": latest_month,
                "index_value": round(float(match["index_value"].mean()), 2),
            }
        )

    overall = latest[latest["major_group"] == "Wholesale Price Index"]
    if not overall.empty:
        rows.append(
            {
                "group": "All Commodities",
                "year": latest_year,
                "month": latest_month,
                "index_value": round(float(overall["index_value"].mean()), 2),
            }
        )

    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle, fieldnames=["group", "year", "month", "index_value"]
        )
        writer.writeheader()
        writer.writerows(rows)

    print(f"wrote {len(rows)} rows to {destination}")
    for row in rows:
        print(row)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
