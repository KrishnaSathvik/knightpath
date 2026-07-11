# KnightPath asset pipeline

The manifest is the source of truth for all 85 generated assets. Raw art remains outside the app until it passes through the importer.

## Setup

```bash
python3 -m pip install Pillow
```

## Workflow

1. Save transparent source PNGs in `asset-pipeline/raw/` using exact manifest names (for example, `pathy-idle.png`).
2. Import every available raw and create the Xcode 1x/2x/3x image sets:

   ```bash
   python3 asset-pipeline/import.py
   ```

3. Review completion and copy missing names into the next generation prompt:

   ```bash
   python3 asset-pipeline/status.py
   ```

4. Generate visual QA sheets after each imported family:

   ```bash
   python3 asset-pipeline/contact_sheet.py
   ```

QA output is written to `asset-pipeline/qa/`. Pieces must pass `pieces-44px-readability.png` on both `#779952` and `#EDEED1` before the next family begins.

The importer is idempotent. Replacing a raw PNG and running it again safely replaces that asset's image set. Fully opaque non-decoration assets produce a warning; unknown filenames are never imported.
