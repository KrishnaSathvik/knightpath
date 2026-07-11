#!/usr/bin/env python3
"""Generate family QA sheets and the 44px chess-piece readability gate."""
import json
import math
from collections import defaultdict
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    raise SystemExit("Pillow is required. Install it with: python3 -m pip install Pillow")

ROOT = Path(__file__).resolve().parent
manifest = json.loads((ROOT / "manifest.json").read_text())
catalog = ROOT.parent / manifest["assets_catalog"]
qa = ROOT / "qa"
qa.mkdir(exist_ok=True)
font = ImageFont.load_default()
backgrounds = [("white", "#FFFFFF"), ("lavender", "#F7F4FF"), ("board-green", "#779952")]


def source(asset):
    return catalog / f'{asset["namespace"]}.folder' / f'{asset["name"]}.imageset' / f'{asset["name"]}@3x.png'


def fit(image, size):
    copy = image.copy()
    copy.thumbnail((size, size), Image.Resampling.LANCZOS)
    return copy


families = defaultdict(list)
for asset in manifest["assets"]:
    if asset["status"] == "imported" and source(asset).exists():
        families[asset["family"]].append(asset)

for family, assets in sorted(families.items()):
    cell_w, cell_h = 280, 250
    cols = min(4, len(assets))
    rows = math.ceil(len(assets) / cols)
    sheet = Image.new("RGB", (cols * cell_w, rows * cell_h), "white")
    draw = ImageDraw.Draw(sheet)
    for i, asset in enumerate(assets):
        x, y = (i % cols) * cell_w, (i // cols) * cell_h
        image = Image.open(source(asset)).convert("RGBA")
        draw.text((x + 8, y + 7), asset["name"], fill="#251B35", font=font)
        cursor = x + 8
        for label, color in backgrounds:
            draw.rectangle((cursor, y + 28, cursor + 80, y + 228), fill=color)
            for size, top in ((80, 36), (44, 126), (22, 184)):
                item = fit(image, size)
                sheet.paste(item, (cursor + (80-item.width)//2, y + top), item)
            cursor += 88
    sheet.save(qa / f"{family}.png")
    print(f"Wrote qa/{family}.png")

pieces = families.get("pieces", [])
if pieces:
    colors = ["#779952", "#EDEED1"]
    cell_w, cell_h = 150, 100
    sheet = Image.new("RGB", (6 * cell_w, math.ceil(len(pieces) / 6) * cell_h), "white")
    draw = ImageDraw.Draw(sheet)
    for i, asset in enumerate(pieces):
        x, y = (i % 6) * cell_w, (i // 6) * cell_h
        draw.text((x + 4, y + 4), asset["name"], fill="#251B35", font=font)
        image = fit(Image.open(source(asset)).convert("RGBA"), 44)
        for j, color in enumerate(colors):
            bx = x + 20 + j * 58
            draw.rectangle((bx, y + 28, bx + 44, y + 72), fill=color)
            sheet.paste(image, (bx + (44-image.width)//2, y + 28 + (44-image.height)//2), image)
    sheet.save(qa / "pieces-44px-readability.png")
    print("Wrote qa/pieces-44px-readability.png")
