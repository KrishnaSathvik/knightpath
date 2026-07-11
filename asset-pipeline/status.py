#!/usr/bin/env python3
"""Print asset completion and generation-ready missing names."""
import json
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent
manifest = json.loads((ROOT / "manifest.json").read_text())
families = defaultdict(list)
for asset in manifest["assets"]:
    families[asset["family"]].append(asset)

total_done = sum(a["status"] == "imported" for a in manifest["assets"])
print(f"KnightPath assets: {total_done}/{len(manifest['assets'])} imported")
for family in sorted(families):
    assets = families[family]
    done = sum(a["status"] == "imported" for a in assets)
    print(f"\n{family}: {done}/{len(assets)}")
    missing = [a["name"] for a in assets if a["status"] != "imported"]
    if missing:
        print("  missing: " + ", ".join(missing))
