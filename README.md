# ♞ KnightPath

**A gamified chess adventure for iOS.** Battle character opponents along a winding path, earn XP and coins, keep your puzzle streak alive, and climb from your first move to club-level play — chess that feels like a modern mobile game, not a desktop tool.

> *Every move writes your story.*

**Status:** 🚧 Pre-development — design & planning complete, Phase 0 build starting
**Platform:** iOS 17+ · SwiftUI

---

## Why KnightPath

App Store chess splits into two camps: serious rating-driven tools (chess.com, Lichess) and dated, abandoned apps. Nobody owns "chess as a fun mobile game." Duolingo Chess proved the demand — it became their fastest-growing course — but its single coach bot is a known weak spot: it either blunders carelessly or crushes you.

KnightPath's answer: **opponents that feel human at every level.** Nine personality bots (one Stockfish engine, nine distinct move-selection personalities), a mixed-node progression path, and an economy where even losing pays XP.

## Core Features (v1)

- **The Path** — 3 chapters of mixed nodes: character bot matches ⚔, tactics puzzles 🧩, timed drills ⏱, and chapter trophies 🏆. Stars for accuracy, unlock as you go.
- **9 personality bots** — from Rookie Ryan (hangs pieces, loves chaos) to The Grandmaster (full-strength Stockfish). Each is a scoring/sampling filter over MultiPV candidates — they play *differently*, not just harder.
- **Pass & Play** — two players, one device, board flip with privacy interstitial.
- **Daily Puzzles** — 5/day from the Lichess puzzle DB (CC0), streaks, Perfect Day bonuses.
- **Practice + coach** — free play vs any unlocked bot with move feedback from Pathy, the knight mascot.
- **XP & coins** — XP is permanent progression (never purchasable), coins are spendables. Losses always earn something. No energy system, ever.
- **Post-game reports** — accuracy %, best move, biggest mistake, board review scrubber.

**Design language:** "Daylight Kingdom" — bright Duolingo-style game energy with a royal purple + gold chess identity, classic tournament-green board, chunky 3D buttons, celebratory reward moments.

## Documentation

| Doc | Purpose |
|---|---|
| [`knightpath-prd.md`](knightpath-prd.md) | Product requirements v1.2 — features, bot configs, economy, UI/UX spec, architecture, 10-week plan |
| [`knightpath-asset-implementation-guide.md`](knightpath-asset-implementation-guide.md) | The three-bucket model (assets vs SwiftUI vs Lottie), ~75-asset inventory, generation pipeline |
| [`knightpath-stitch-prompts.md`](knightpath-stitch-prompts.md) | Design-tool prompt pack used to produce the screen mockups |
| [`knightpath-cursor-prompts.md`](knightpath-cursor-prompts.md) | Phased implementation prompts + `.cursorrules` for the agent-assisted build |
| `design-refs/` | Approved screen mockups (Home, Path, Game, Victory, Puzzles, etc.) |

## Tech Stack

| Layer | Choice |
|---|---|
| UI | SwiftUI, iOS 17+, MVVM + `@Observable` |
| Chess rules | [ChessKit](https://github.com/chesskit-app/chesskit-swift) — never hand-rolled |
| Engine | Stockfish (xcframework) behind a Swift `UCIEngine` actor, UCI protocol |
| Persistence | SwiftData (offline-first, no backend in v1) |
| Puzzles | Bundled SQLite slice of the Lichess puzzle database (CC0) |
| Animation | SwiftUI springs + `lottie-ios` for celebrations |

## Roadmap

- [x] PRD, design system, screen mockups, asset plan
- [ ] **Phase 0** — Design system components + ChessKit board (two-human legal game)
- [ ] **Phase 1** — Stockfish integration + 9 personality bots + hints/accuracy
- [ ] **Phase 2** — Path map, drills, economy, post-game reports
- [ ] **Phase 3** — Pass & Play, Daily Puzzles, onboarding, Home, Profile
- [ ] **Phase 4** — Lottie polish, accessibility, performance, TestFlight
- [ ] v1.5 — Boss Battles (rule-twisted matches), cosmetics store
- [ ] v2 — Learning curriculum, CloudKit sync, online async multiplayer

## Credits

- Chess engine: [Stockfish](https://stockfishchess.org) (GPLv3)
- Puzzle data: [Lichess puzzle database](https://database.lichess.org/#puzzles) (CC0)
- Rules library: ChessKit (Swift)

---

*KnightPath is an indie project currently in active development.*
