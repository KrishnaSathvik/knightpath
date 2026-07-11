#!/usr/bin/env python3
"""Import raw KnightPath PNGs into the Xcode asset catalog."""
import json
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    raise SystemExit("Pillow is required. Install it with: python3 -m pip install Pillow")

ROOT = Path(__file__).resolve().parent
MANIFEST = ROOT / "manifest.json"
RAW = ROOT / "raw"


def load_manifest():
    return json.loads(MANIFEST.read_text())


def alpha_is_opaque(image):
    return image.getchannel("A").getextrema()[0] == 255


def prepare(source, target):
    image = Image.open(source).convert("RGBA")
    if image.getbbox() is None:
        raise ValueError("image is fully transparent")
    image = image.crop(image.getbbox())
    side = max(image.size)
    canvas_side = max(1, round(side / 0.8))  # 10% margin on every side
    canvas = Image.new("RGBA", (canvas_side, canvas_side), (0, 0, 0, 0))
    canvas.alpha_composite(image, ((canvas_side - image.width) // 2, (canvas_side - image.height) // 2))
    return canvas.resize(tuple(target), Image.Resampling.LANCZOS)


def contents(name):
    return {
        "images": [
            {"filename": f"{name}@1x.png", "idiom": "universal", "scale": "1x"},
            {"filename": f"{name}@2x.png", "idiom": "universal", "scale": "2x"},
            {"filename": f"{name}@3x.png", "idiom": "universal", "scale": "3x"},
        ],
        "info": {"author": "xcode", "version": 1},
    }


def ensure_namespace(path):
    path.mkdir(parents=True, exist_ok=True)
    metadata = path / "Contents.json"
    metadata.write_text(json.dumps({
        "info": {"author": "xcode", "version": 1},
        "properties": {"provides-namespace": False},
    }, indent=2) + "\n")


def main():
    manifest = load_manifest()
    catalog = ROOT.parent / manifest["assets_catalog"]
    RAW.mkdir(exist_ok=True)
    imported = 0
    unknown = sorted(p.stem for p in RAW.glob("*.png") if p.stem not in {a["name"] for a in manifest["assets"]})
    for name in unknown:
        print(f"WARNING unknown raw asset (not imported): {name}.png", file=sys.stderr)

    for asset in manifest["assets"]:
        source = RAW / f'{asset["name"]}.png'
        if not source.exists():
            continue
        original = Image.open(source).convert("RGBA")
        if alpha_is_opaque(original) and asset["name"] != "app-icon" and asset["family"] != "deco":
            print(f'WARNING {asset["name"]}: fully opaque; transparency expected', file=sys.stderr)
        target3 = asset["size_3x"]
        image3 = prepare(source, target3)
        namespace = catalog / f'{asset["namespace"]}.folder'
        ensure_namespace(namespace)
        imageset = namespace / f'{asset["name"]}.imageset'
        imageset.mkdir(parents=True, exist_ok=True)
        for old in imageset.glob("*.png"):
            old.unlink()
        for scale in (1, 2, 3):
            size = (max(1, round(target3[0] * scale / 3)), max(1, round(target3[1] * scale / 3)))
            variant = image3 if scale == 3 else image3.resize(size, Image.Resampling.LANCZOS)
            variant.save(imageset / f'{asset["name"]}@{scale}x.png', optimize=True)
        (imageset / "Contents.json").write_text(json.dumps(contents(asset["name"]), indent=2) + "\n")
        asset["status"] = "imported"
        imported += 1
        print(f'Imported {asset["name"]}')

    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Done: {imported} raw asset(s) processed")


if __name__ == "__main__":
    main()
