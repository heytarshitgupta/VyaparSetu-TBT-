"""Print the group-level series available in the raw WPI workbook (debug helper)."""

from __future__ import annotations

import sys

import pandas as pd

if __name__ == "__main__":
    source = sys.argv[1]
    frame = pd.read_excel(source, sheet_name="WPI Data")
    frame = frame.dropna(subset=["group"])
    for group in sorted({str(g) for g in frame["group"].unique()}):
        print(group)
