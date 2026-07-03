# KnightPath — Design Implementation & Asset Production Guide

**Companion to:** knightpath-prd.md (v1.1) · Stitch prompt pack v2 (Daylight Kingdom)
**Principle:** You don't code those screens — you **assemble** them. Mockup quality = ~70% illustrated assets (PNGs in the bundle) + ~30% native SwiftUI layout. Duolingo, Royal Match, and Clash Royale all work this way.

---

## 1. The Three Buckets

Every visual element in the mockups falls into exactly one bucket:

| Bucket | What | Examples |
|---|---|---|
| **A. Generated image assets** | Illustrated art, shipped as PNG | Bot portraits, Pathy, chess pieces, logo, icons, badges |
| **B. Pure SwiftUI code** | Layout, shapes, text, effects | Buttons, cards, pills, rings, board grid, glows, tab bar |
| **C. Lottie animations** | Celebration/motion effects | Confetti, star burst, level-up, streak flame |

Rule of thumb: if it has a face, texture, or painterly detail → Bucket A. If it's geometry, text, or color → Bucket B. If it explodes or celebrates → Bucket C.

---

## 2. Bucket A — Complete Asset Inventory (what to create)

All images: **PNG with transparent background**, generated at high res, exported at @1x/@2x/@3x (design at 3x, let Xcode downscale). Sizes below are the @3x pixel size to generate/export at.

### 2.1 Brand (4 assets)
| Asset | Size (@3x) | Used in |
|---|---|---|
| `logo-shield` (knight in purple shield + gold crown + laurels) | 900×900 | Splash, Home header, badges |
| `logo-knight-mark` (knight head only, simplified) | 450×450 | Tab bar, small placements, watermark |
| `app-icon` (shield mark on gradient, NO transparency) | 1024×1024 | App Store / home screen |
| `bg-chess-pattern` (faint lavender board corner pattern, tileable) | 1200×1200 | Splash, onboarding backgrounds |

### 2.2 Pathy the Mascot (10 poses)
`pathy-idle, pathy-point, pathy-cheer, pathy-think, pathy-wince, pathy-teach (wand), pathy-wave, pathy-shrug, pathy-sleep, pathy-celebrate (confetti pose)`
- Size: 750×750 each · full body, consistent proportions
- Used in: onboarding, Path map (beside current node), coach overlay, post-game, empty states
- **Create these SECOND (after style anchor) — Pathy appears everywhere, his style defines the app**

### 2.3 Bot Portraits (9 bots × 3 expressions = 27 assets)
Expressions per bot: `neutral` (intro card, path node, in-game HUD), `smug/taunt` (mid-game events), `defeated` (your victory screen). Optional 4th `victorious` for when the bot wins.
- Size: 900×900, bust/half-body crop, consistent framing (head center at same height across all bots)
- Naming: `bot-greg-neutral`, `bot-greg-defeated`, etc.
- The 9: Rookie Ryan, Fast Fiona, Greedy Greg, Castle King, Gambit Gwen, Tactic Tara, Silent Sofia, Endgame Eli, The Grandmaster
- Give each a signature color accent within the shared palette (Greg=gold/green, Tara=dark purple, etc.) so nodes are scannable on the path

### 2.4 Chess Pieces (12 assets — THE most important set)
`piece-w-king/queen/rook/bishop/knight/pawn` + same 6 in black
- Size: 600×600 each, **identical camera angle and lighting across all 12**, slight 3/4 top-down view (2.5D), soft baked drop shadow OR export shadowless and add shadow in SwiftUI (recommended — cleaner)
- White pieces: warm ivory with subtle shading. Black: charcoal with highlights (never pure #000)
- **Readability test before accepting:** place at 44pt on both green (#779952) and cream (#EDEED1) squares — every piece must be instantly identifiable. Reject pretty-but-ambiguous sets
- Consider a 13th–24th asset later: a second piece set as unlockable cosmetic

### 2.5 Mode & Node Icons (10 assets)
| Asset | Size | Used in |
|---|---|---|
| `icon-passplay` (purple + gold knight pair) | 450×450 | Home mode card |
| `icon-puzzles` (purple puzzle piece, 3D) | 450×450 | Home card, tab bar active, path node |
| `icon-practice` (target + arrow) | 450×450 | Home mode card |
| `icon-boss` (gold crown with gem) | 450×450 | Home mode card |
| `node-drill` (stopwatch in purple hex) | 450×450 | Path drill node |
| `node-trophy` (gold trophy on pedestal) | 600×600 | Path chapter-end node |
| `icon-coin` (gold coin, crown emboss) | 300×300 | Everywhere money appears |
| `icon-xp` (purple hex "XP" badge) | 300×300 | Reward rows, counters |
| `icon-star-gold` + `icon-star-empty` | 300×300 | Stars everywhere |
| `icon-streak-flame` | 300×300 | Streak UI |
| `icon-freeze` (ice cube) | 300×300 | Streak freeze item |
| `icon-chest` (gold chest, closed + open) | 450×450 ×2 | Trophy node rewards |

### 2.6 Badges (8 for v1)
Hexagonal gold badges + their locked (gray silhouette) variants — generate the gold version, create locked variant in code with `.saturation(0)` + opacity (no extra asset needed).
`badge-first-victory (trophy), badge-7streak (flame), badge-ch1 (book/1), badge-tactical (crossed swords), badge-puzzle-solver (puzzle), badge-arena (shield), badge-streak-legend (crown-flame), badge-endgame (knight)` — 450×450 each

### 2.7 Path Map Decorations (6–8 assets)
Faint background doodles: `deco-castle-1, deco-castle-2, deco-flag, deco-tree, deco-cloud`, oversized ghost pieces `deco-ghost-pawn, deco-ghost-knight, deco-ghost-queen`
- Very low-contrast lavender/gray line-art or soft fills, 600–900px
- These sell the "kingdom world" feel for almost no effort

### 2.8 Onboarding Heroes (2 assets)
Pages 1–2 need one illustration each: `onboard-bots-lineup` (3–4 bots posed together), `onboard-rewards` (coins/stars/XP burst). Page 3 is a live board — no asset. 1050×1050 each.

**Total v1 asset count: ~75 images.** At ~15–20 finals/day with a locked pipeline, that's a focused week of generation, in parallel with Phase 0 code.

---

## 3. How to CREATE the assets (the pipeline)

The whole game is **style consistency**. Same problem as your ShotPlan heroes. The method:

### Step 1 — Lock a Style Anchor (do this first, spend a full day on it)
Write one master style paragraph used in EVERY generation prompt:

```
STYLE ANCHOR (prepend to every asset prompt):
"3D-rendered cartoon game asset in the style of premium mobile games
(Royal Match / Clash Royale quality). Soft studio lighting from top-left,
smooth rounded shapes, warm friendly proportions, subtle subsurface
scattering, high detail, clean silhouette. Palette: royal purple #7C3AED,
gold #F5A623, ivory white, warm charcoal. Rendered on a plain solid
light-gray background for easy removal. Square composition, subject
centered, no text, no watermark."
```

Generate ONE hero asset (recommend: Pathy-idle or the logo shield) until it's *perfect*. That image becomes your **visual reference** — attach it (image-to-image / reference-image mode) to every subsequent generation. Prompt alone drifts; prompt + reference image locks style.

### Step 2 — Character sheets before variants
For Pathy and each bot: first generate a NEUTRAL master portrait with the anchor + reference. Once approved, generate expressions/poses using THAT character's master as the reference image + "same character, same style, now looking defeated and sad, head in hands." This is how you get 3 consistent expressions per bot.

### Step 3 — Batch by family, not by screen
Generate all 12 chess pieces in one session (same seed/reference), all 9 bot neutrals in one session, all icons in one session. Cross-session drift is real; within-session consistency is much higher.

### Step 4 — Cleanup pipeline (every asset)
1. **Background removal** → transparent PNG (Adobe Express / remove.bg / Photoshop; you have the Adobe MCP connected — `image_remove_background` does exactly this)
2. **Trim + center** on square canvas with consistent padding (10% margin)
3. **Downscale** from generation res to the @3x target (never upscale)
4. **Naming + drop into Assets.xcassets** (use folders/namespaces: `Bots/`, `Pieces/`, `Icons/`, `Pathy/`)

### Step 5 — Consistency QA gate
Before accepting any batch, place them side by side on a white and a lavender artboard. Check: same lighting direction, same saturation level, same "material" (all clay-3D, no odd photoreal one), silhouettes readable at 40pt. Reject and regenerate outliers — one off-style asset poisons the premium feel.

### Tools
- **Generation:** gpt-image-2 (your Pinterest pipeline) or FLUX via Hugging Face — both fine; pick ONE for the whole project (different models = different look)
- **Bg removal / cleanup:** Adobe Express MCP (`image_remove_background`, `image_crop_and_resize`)
- **Vector exceptions:** simple flat icons (tab bar inactive states, settings icons) — don't generate these; use **SF Symbols** (free, native, Dynamic Type-aware). Only *reward/game* icons get the 3D treatment

---

## 4. Bucket B — What is PURE SWIFTUI (do NOT create assets for these)

| Element | Implementation |
|---|---|
| **Chunky 3D button** (the signature) | Two RoundedRectangles: darker `#5B21B6` behind, main `#7C3AED` offset -4pt up; on press animate offset to 0 + haptic. ~15 lines. Build once as `KPButton` |
| Cards, pills, chips | `RoundedRectangle(cornerRadius: 16).stroke(#E5E0F0, lineWidth: 2)` + white fill |
| XP ring around avatar | `Circle().trim(from: 0, to: progress).stroke(purple, style: .init(lineWidth: 6, lineCap: .round)).rotationEffect(-90°)` |
| Progress bars | `Capsule` over `Capsule` |
| **Chess board** | `LazyVGrid` 8 columns of `Rectangle().fill(isDark ? green : cream)` + piece `Image()` overlays; coordinates as `Text` |
| Selection glow | `.shadow(color: .purple.opacity(0.6), radius: 12)` under the piece image |
| Legal move dots / capture rings | `Circle().fill(purple)` 10pt / `Circle().stroke(gold, lineWidth: 3)` |
| Last-move tint / check glow | square overlay `.fill(yellow.opacity(0.35))` / animated red shadow on king |
| Tab bar | Custom HStack (not TabView default) — SF Symbols + purple active pill |
| Speech bubbles | RoundedRectangle + triangle Path, or just a capsule with tail image |
| Locked states | `.saturation(0).opacity(0.5)` on the colored asset + lock SF Symbol |
| Dashed path trail | `Path` through node points + `.stroke(style: StrokeStyle(lineWidth: 4, dash: [1, 12]))` |
| Star reveal, counter count-up | SwiftUI animation + `contentTransition(.numericText())` + haptic ticks |
| All text | Real `Text` with SF Rounded (`.fontDesign(.rounded)`) — NEVER text baked into images (mockups do this; you must not: localization, Dynamic Type, crispness) |

**Anti-goal:** do not screenshot-slice the mockups into the app. Mockup text/spacing is AI-fudged; native rebuild is crisper and accessible.

---

## 5. Bucket C — Lottie Animations (5 for v1)

Add via the free `lottie-ios` SPM package. Get animations from lottiefiles.com (huge free library) or commission/export from After Effects later.

| Animation | Trigger |
|---|---|
| `confetti-burst` | Victory screen, Perfect Day, chapter complete |
| `star-pop` | Each star reveal on post-game |
| `level-up-ring` | XP ring completes a level |
| `coin-rain` (small) | Trophy chest open |
| `flame-flicker` | Streak milestone |

Fallback if Lottie feels heavy: SwiftUI particle systems via `TimelineView + Canvas` — confetti is ~40 lines. Start with Lottie; it's one line to play: `LottieView(animation: .named("confetti")).playing()`.

---

## 6. Production Order (maps to PRD Phase 0–1)

1. **Style anchor + logo shield + Pathy-idle** ← everything else depends on this
2. **12 chess pieces** ← blocks the board, the core screen
3. **Pathy's remaining 9 poses**
4. **Reward icon set** (coin, XP, stars, flame) ← blocks economy UI
5. **First 3 bots × 3 expressions** (Ryan, Greg, Tara — the Phase 1 test trio)
6. **Mode/node icons + badges**
7. **Remaining 6 bots**
8. **Decorations + onboarding heroes** (polish tier, can slip to Phase 3)

## 7. Asset ↔ Screen Traceability (quick check)

- **Splash:** logo-shield, bg-pattern → rest is code
- **Home:** logo, bot portrait (next opponent), 4 mode icons, coin/flame icons → cards/buttons/tab = code
- **Path:** bot portraits, node icons, trophy, Pathy, decorations → trail/stars-layout/banner = code
- **Game:** 12 pieces, 2 bot expressions, avatar → board/HUD/dots/glows = 100% code
- **Victory:** bot-defeated, star icon, coin/XP icons, Pathy-celebrate + confetti Lottie → counters/cards = code
- **Puzzles/Profile:** icon set + badges → everything else = code

If an element isn't in the inventory above, default assumption: **it's SwiftUI, not an asset.**
