# KnightPath — Product Requirements Document

**Version:** 1.2 · **Platform:** iOS 17+ (SwiftUI) · **Status:** Draft for v1 build
**v1.2 changes:** Design direction pivoted from dark "Nocturne Arcade" to light **"Daylight Kingdom"** (Duolingo-style bright game energy, royal purple + gold identity, classic green board for proven readability) — validated via Stitch/AI mockups of all 10 screens. Added asset production plan (three-bucket implementation model, ~75-asset inventory) — full details in companion doc *knightpath-asset-implementation-guide.md*.
**v1.1 changes:** Mixed-node Path, mini-match drills, Pathy mascot/coach, competitive positioning — informed by Duolingo Chess analysis (their chess course is Duolingo's fastest-growing; validates the gamified-chess market)

---

## 1. Vision

KnightPath is a gamified chess RPG for iOS. Instead of the utilitarian, desktop-era chess apps that dominate the App Store, KnightPath treats chess like a modern mobile game: a winding path of character opponents, XP and coin progression, daily puzzle streaks, boss battles with twisted rules, and a board that feels premium — haptics, fluid animations, and a readable 2.5D aesthetic.

**One-liner:** *Duolingo's progression + chess.com's engine + a mobile game's polish.*

**Why now / why us:** App Store chess is split between serious tools (chess.com, Lichess) and abandoned, dated apps. Nobody owns "chess as a fun mobile game." The engine work is commoditized (Stockfish is free); the differentiation is 100% product and design — our strength.

## 2. Goals & Non-Goals

**v1 Goals**
- Ship a complete single-device chess game: bot path, pass-and-play, daily puzzles
- Make losing feel productive (XP on loss, coach-style feedback)
- Session loop that brings players back daily (streaks, first-win bonus)
- 60fps board interactions, zero jank, App Store-quality polish

**Non-Goals (v1)**
- Online multiplayer (no backend, no accounts)
- Store / IAP / monetization
- Learning curriculum (full lesson system)
- Boss battles (v1.5)
- iPad-optimized layout (works, not optimized)

## 3. Target Users

1. **Casual returners** — played chess as a kid, intimidated by chess.com's rating culture. Want fun, not Elo anxiety.
2. **Mobile gamers** — respond to progression, unlocks, streaks. Chess is the content; the game loop is the product.
3. **Improvers** — want to get better without reading theory. Bots-as-curriculum + hints + accuracy scores serve them.

## 4. Feature Specification

### 4.1 App Shell
| Feature | Spec |
|---|---|
| Splash | KnightPath logotype + knight-piece mark, subtitle "Every move writes your story." 1.2s, animated fade → shimmer on the knight |
| Onboarding | 3 screens max: (1) "Battle characters, not levels" (2) "Earn XP & coins every game — even losses" (3) Interactive: a real mini-board, "Make your first move" (guided knight move) → confetti → Home |
| Home Hub | Mode cards + player level ring + coin/XP counters + daily streak flame. Bottom tab bar: **Home · Path · Puzzles · Profile** |

### 4.2 Game Modes

**A. The Path (Player vs Bots + mixed nodes)** — flagship mode
- Vertical scrolling map (Duolingo/Candy Crush style) of **mixed node types**, not just opponents — variety per scroll is what makes the path feel premium and un-grindy:
  - **⚔ Bot node** — character match (the 9-bot roster)
  - **🧩 Puzzle node** — 3 themed tactics puzzles (fork, pin, mate-in-2) drawn from the puzzle DB
  - **⏱ Drill node** — mini-match: timed micro-challenge from a set FEN ("Checkmate with K+R in 60s", "Win this endgame vs the bot", "Promote a pawn in 8 moves")
  - **🏆 Trophy node** — chapter review at the end of each section: a puzzle gauntlet mixing that chapter's themes; awards a chapter badge + coin chest
- **v1 path = 3 chapters, ~21 nodes:** e.g. Ch.1: Ryan → puzzles → Fiona → drill → Greg → trophy · Ch.2: Castle King → puzzles → Gwen → drill → Tara → trophy · Ch.3: Sofia → drill → Eli → puzzles → The Grandmaster → crown trophy
- Beat/complete a node to unlock the next; bot stars: 1★ win, 2★ win with ≥75% accuracy, 3★ win with ≥85% accuracy and no hints; puzzle/drill nodes: stars by speed/first-try
- Replayable — earn coins on replays (reduced), stars can be improved
- Each bot: pre-match intro card (portrait, flavor text, "weakness" hint), in-game one-line taunts on events (game start, big capture, check, win, lose)

**B. Pass & Play (Human vs Human, same device)**
- Setup: names (optional), timer off / 5 / 10 min, board flip mode
- Flip mode: board rotates 180° per turn with "Pass to Black" privacy interstitial; non-flip mode mirrors the top HUD upside down
- Both players earn small XP (participation) — keeps the economy alive in couch play

**C. Daily Puzzles**
- 5 puzzles/day from bundled Lichess puzzle DB slice (~10k rated puzzles shipped offline, themed: forks, pins, mates)
- Streak system with flame counter; streak-freeze consumable purchasable with coins
- Puzzle rating adapts: solve fast → harder tomorrow
- Bonus: "Perfect Day" (5/5 first-try) = coin multiplier

**D. Practice (v1-lite)**
- Free board vs any *unlocked* bot, any color, takebacks unlimited, coach overlay ON by default (see 4.4)
- Full learning curriculum deferred to v2

**E. Boss Battles (v1.5, spec'd now)**
- Rule-twisted matches, unlocked every 3 path nodes: e.g. *The Hoarder* (starts with extra knight), *The Clock* (win in ≤30 moves), *The Phoenix* (queen revives once), *The Fog* (fog-of-war, see only squares your pieces attack)
- Big one-time XP/coin payouts + exclusive piece-set cosmetic per boss

### 4.3 Bot Roster (v1 = 9 bots)

| # | Bot | Persona | Skill | Engine behavior |
|---|---|---|---|---|
| 1 | Rookie Ryan | Beginner | SF 0–2 | Sample top-6 MultiPV w/ high temperature; 40% chance to ignore defenses of hanging pieces |
| 2 | Fast Fiona | Blitz attacker | SF 6–8 | 0.3s movetime cap; +bonus for checks/captures toward enemy king; −penalty on defensive moves |
| 3 | Greedy Greg | Material hunter | SF 4–6 | +0.5 eval bump on any capture before selection → takes poisoned pawns organically |
| 4 | Castle King | Defensive | SF 7–9 | Opening book forces early castle; penalize pawn moves near own king; prefers quiet development |
| 5 | Gambit Gwen | Trickster | SF 8–10 | Opening book of gambits; prefers moves creating sharp eval swings; punishes greed |
| 6 | Tactic Tara | Tactical | SF 10–13 | Deeper search on forcing moves; prefers lines with sharp eval deltas (forks/pins/skewers) |
| 7 | Silent Sofia | Positional squeezer | SF 12–14 | Penalize captures/checks unless clearly winning; prefers small steady eval gains |
| 8 | Endgame Eli | Endgame monster | SF 12–15 | Trade bonus when equal/ahead; full engine strength after move 30 |
| 9 | The Grandmaster | Final boss | SF 20 | Full-strength Stockfish, no filters. Beating them = "Knight's Crown" badge + exclusive board theme |

**Implementation note:** one Stockfish instance + MultiPV = ranked candidate list; each personality is a scoring/sampling function over candidates (~30 lines Swift each). Add randomized 0.5–2.0s "thinking" delay to all bots.

### 4.3b Pathy — the Coach Mascot

One friendly character owns every *supportive* touchpoint (bots are opponents; Pathy is on the player's side). Modeled on Duolingo's single-coach pattern (Oscar), Trailie-style for KnightPath.

- **Character:** "Pathy," a small knight-piece character with expressive eyes and a plume. Appears at ~15% screen scale — presence, not clutter
- **Where Pathy shows up:** onboarding narrator · coach-overlay feedback voice ("Careful — that leaves your bishop hanging") · post-game report reactions · empty/locked states · streak reminders · celebration moments (star reveals, chapter badges)
- **Tone:** encouraging, lightly funny, never condescending; loss lines always constructive ("Eli got you in the endgame — want to drill K+P endings?")
- **Asset plan:** one character sheet, ~10 poses (idle, cheer, think, wince, sleep, point, celebrate, teach, wave, shrug). AI-generated with a locked style reference for consistency; revisit with an artist post-launch
- **Rule:** Pathy never plays chess against you and never taunts — that's the bots' job. Clean emotional separation: bots create tension, Pathy resolves it

### 4.4 In-Game Features
- **Hints:** engine best-move arrow. 3 free/game on Path; unlimited in Practice; extra hints cost coins. Using hints caps stars at 2★
- **Coach overlay (Practice + Ryan/Fiona tiers):** post-move feedback when eval drops sharply — "Careful — that leaves your bishop hanging." Driven by eval delta thresholds (blunder ≤ −2.0, mistake ≤ −1.0, inaccuracy ≤ −0.5)
- **Eval bar:** optional (settings), off by default on Path (keeps tension), on in Practice
- **HUD:** captured-pieces row + material diff (+2 / +5), move list drawer, undo (Practice only), resign/draw
- **Post-game report:** result, accuracy %, best move, worst blunder (tap to review on board), XP/coin breakdown with animated counters
- **Accuracy:** computed by comparing each player move against engine top choice (centipawn-loss based, chess.com-style)

### 4.5 Economy — XP & Coins

**Separate jobs (never cross):**
- **XP → permanent progression.** Player level (1–50), unlocks bots-ahead-of-path previews, profile badges, mode unlocks. Cannot be bought. Ever.
- **Coins → spendables.** Hints, undo tokens, puzzle streak-freeze, retry-with-takeback; v2: cosmetics store (board themes, piece sets, bot skins)

**Earning table (v1 tuning start):**
| Event | XP | Coins |
|---|---|---|
| Path win | 100 × bot tier | 50 × bot tier |
| Path loss | 25 × bot tier | 10 |
| Accuracy bonus (≥85%) | +50 | +25 |
| No-hint bonus | +25 | +10 |
| Path replay win | 20 | 15 |
| Pass & Play (per player) | 15 | 5 |
| Puzzle solved | 10 | 5 |
| Drill node cleared | 30 | 20 |
| Trophy node (chapter review) | 150 | 100 + chest |
| Perfect Day (5/5 first try) | +50 | +50 |
| First win of the day | +50 | +25 |
| Daily streak milestone (7/30/100) | badge | 100/500/2000 |

**Design rules:** losses always pay something ("you learned something"); no energy/hearts system — unlimited play, always; coins never gate progression (no pay-to-win feel even pre-monetization).

---

## 5. UI/UX Design

### 5.1 Design Language

**Direction:** "Daylight Kingdom" — bright, playful, premium game feel: Duolingo's game energy with a royal chess identity. Duolingo owns green; **we own royal purple + gold** (chess = royalty, crowns — no chess app owns purple). Clean white canvas, lavender-tinted sections, chunky pressable 3D buttons, celebratory gold reward moments, stylized 2.5D pieces (not photoreal — unreadable at phone size). Board stays classic tournament green: the proven lowest-eye-strain, highest-readability scheme, and on a light UI the green board becomes the natural visual anchor of the game screen.

**Rationale for the pivot from dark:** blue-tinted dark palettes read as fintech/SaaS (the exact vibe to avoid), blue board squares hurt piece readability and eye comfort, and a bright kingdom world makes the Path map dramatically more screenshot-able and shareable.

**Design tokens**
```
// Color
bg.base         #FFFFFF   (primary canvas)
bg.soft         #F7F4FF   (lavender-tinted sections, hero cards)
card.border     #E5E0F0   (2px outlined cards)
brand.primary   #7C3AED   (royal purple — CTAs, selection, active states, XP)
brand.dark      #5B21B6   (3D button bottom edge)
accent.gold     #F5A623   (coins, stars, crowns, rewards)
success         #58CC02   (wins, correct, accuracy)
danger          #FF4B4B   (check glow, blunders)
streak          #FF9600   (flame)
text.primary    #3C3654   (dark plum — never pure black)
text.secondary  #8B84A3
board.dark      #779952   (classic tournament green)
board.light     #EDEED1   (buff cream)
board.select    purple glow ring · legal dots purple · capture rings gold

// Type
Display: SF Rounded Bold        (titles, bot names, numbers)
Body:    SF Pro Text            (UI copy)
Numerals: monospaced digits for clocks/counters

// Shape & depth
radius.card 16 (2px #E5E0F0 border) · radius.button 14 · radius.board-square 4
signature component: chunky 3D button — solid purple fill over #5B21B6
bottom edge (4pt), presses down on tap. Instantly says "game, not SaaS."
shadows: soft plum-tinted (see asset guide §B), never harsh black

// Motion
standard ease: spring(response 0.35, damping 0.8)
piece slide: matchedGeometryEffect, 0.25s
reward counters: count-up 0.8s with haptic ticks
celebrations: Lottie (confetti-burst, star-pop, level-up-ring, coin-rain, flame)
```

**Haptics map:** move = light impact · capture = medium · check = heavy · checkmate = success notification + heavy · reward counter = light ticks · star earned = rigid.

**Sound:** wooden thock (move), sharper clack (capture), low sting (check), fanfare (win), soft chime (puzzle solve). Global mute respects silent switch.

### 5.2 Screen-by-Screen

**S1 Splash** — white canvas with faint lavender board pattern in corners, centered logo shield (white knight in purple shield, gold crown + laurels) with subtle gold sparkles, "KnightPath" in SF Rounded dark plum, subtitle fades in: *"Every move writes your story."* Auto-advance 1.2s.

**S2 Onboarding (3 pages)** — bright pages with illustrated heroes (bots-lineup, rewards burst); page 3 is a live 4×4 mini-board where the user drags a knight to a pulsing purple target square (Pathy points and coaches via speech bubble) → confetti burst → "Begin your Path" CTA activates.

**S3 Home Hub**
- Top bar: avatar + purple XP level ring, gold coin pill, streak flame; centered logo + "Your chess adventure awaits" strapline
- Hero card (lavender bg.soft): "Continue Your Path" — next bot portrait, name, difficulty pips, chunky purple 3D "Challenge" CTA
- Mode grid (2-col outlined cards, 3D icon per card): Pass & Play · Daily Puzzles (progress chip) · Practice · Boss Battles (locked, "Coming soon")
- Bottom tab bar: Home · Path · Puzzles · Profile (purple active state)

**S4 The Path** — vertical scroll map on white/soft-lavender, dotted purple trail connecting **mixed nodes** (bot ⚔ / puzzle 🧩 / drill ⏱ / trophy 🏆, each visually distinct: bots = circular portraits, puzzles = purple square tiles, drills = stopwatch hexes, trophies = gold pedestal). Completed nodes show stars + green check, current node raised with purple glow ring, locked nodes are pale silhouettes ("???"). Chapter ribbon banner at top ("Chapter 1 — First Steps"); background decorated with faint lavender castle/flag/tree doodles and oversized ghost chess pieces — the "kingdom world" feel. Pathy idles near the current node, points at it on scroll-to. Tap bot node → intro card (portrait, flavor line, difficulty pips, weakness hint, best result, reward preview) → "Challenge" CTA; tap puzzle/drill → objective card → "Start."

**S5 Game Screen** (the product)
- Layout (portrait): opponent HUD (portrait, name, taunt bubble, captured pieces, clock pill) → board (edge-to-edge, min 44pt squares on all devices) → player HUD → action row (round white icon buttons: hint · flip · move list · menu)
- **Anchor rule:** the area around the board stays extra clean and white so the green board is the clear visual anchor of the screen
- Selection: tapped piece lifts (scale 1.08) with purple glow ring under it, legal squares show purple dots, capture squares show gold rings; both tap-tap and drag supported; last move tinted yellow-green; check = pulsing red glow on king
- Promotion: inline popover of 4 pieces above the pawn
- Bot presence: small portrait "thinking" shimmer during delay; taunt lines appear as brief speech bubbles (dismissible, disable in settings)
- Pass & Play flip: 0.4s 3D rotation with "Pass to Black" full-screen privacy card ("Tap when ready")

**S6 Post-Game Report** — result banner (Victory/Defeat with bot reaction line) → animated star reveal → XP/coin count-up with ticks → accuracy dial → "Best move / Biggest mistake" cards (tap → board review scrubber) → CTAs: Next Bot / Rematch / Home.

**S7 Daily Puzzles** — streak header, 5 puzzle slots as cards; in-puzzle: "White to move — find the win," wrong move shakes + haptic, right move auto-plays reply; Perfect Day celebration screen.

**S8 Profile** — level, badges wall, lifetime stats (games, accuracy trend sparkline, favorite opening), settings (sound, haptics, eval bar, taunts, board theme).

### 5.3 UX Rules
- Every reward is *felt*: nothing increments silently — counters animate, haptics tick
- Never show Elo numbers to the player in v1 — stars, levels, accuracy only (removes rating anxiety)
- One-hand reachability: primary CTAs in the bottom 40% of screen
- Empty/locked states always tease ("Beat Tactic Tara to unlock") — never dead-end
- Reduce Motion + VoiceOver support: board squares are accessibility elements with coordinate labels; pieces announce "White knight, g1"

### 5.4 Design Implementation — The Three Buckets

Screens are **assembled, not coded**: mockup-quality UI = ~70% illustrated PNG assets + ~30% native SwiftUI (the Duolingo/Royal Match model). Full inventory, generation pipeline, and specs live in the companion doc **knightpath-asset-implementation-guide.md**. Summary:

- **Bucket A — Generated image assets (~75 for v1):** logo set, 10 Pathy poses, 9 bots × 3 expressions (neutral/taunt/defeated), 12 chess pieces (single camera angle + lighting, must pass a 44pt readability test on both square colors), 3D reward/mode/node icons, 8 badges, path-map kingdom decorations, 2 onboarding heroes. All transparent PNGs, designed at @3x.
- **Bucket B — Pure SwiftUI (never assets):** the chunky 3D button, cards/pills/rings/progress bars, the entire board (LazyVGrid + piece images + glow/dot/ring overlays), dashed path trail, tab bar, speech bubbles, locked states (desaturate in code), all text (real Text with SF Rounded — never baked into images).
- **Bucket C — Lottie animations (5):** confetti-burst, star-pop, level-up-ring, coin-rain, flame — via lottie-ios, sourced from LottieFiles.

**Asset pipeline (consistency is everything):** lock one Style Anchor prompt + one perfected reference image (Pathy-idle or logo) → attach that reference to every generation → character sheets before expression variants → batch by family in single sessions → background-removal + trim + @3x export → side-by-side QA gate per batch (same lighting/saturation/material or regenerate). One image model for the whole project.

**Production order:** style anchor + logo + Pathy-idle → 12 pieces → Pathy poses → reward icons → Ryan/Greg/Tara ×3 expressions (Phase 1 test trio) → mode/node icons + badges → remaining bots → decorations/onboarding.

---

## 6. Technical Architecture

### 6.1 Stack
- **UI:** SwiftUI, iOS 17+, MVVM + Observation framework (`@Observable`)
- **Chess rules:** ChessKit (Swift package) — move gen, legality, FEN/PGN, mate detection. Never hand-roll rules
- **Engine:** Stockfish (C++), compiled as xcframework, wrapped in a Swift `UCIEngine` actor communicating over UCI text protocol on a background thread
- **Persistence:** SwiftData — PlayerProfile, GameRecord, PuzzleProgress, BotProgress
- **Animation:** lottie-ios (SPM) for celebration effects; SwiftUI springs/matchedGeometryEffect for everything else
- **Assets:** Assets.xcassets with namespaced folders (Bots/, Pieces/, Icons/, Pathy/, Badges/, Deco/), all illustrated art as @1x/2x/3x transparent PNGs; flat utility icons from SF Symbols (never generated)
- **Puzzles:** bundled SQLite slice of Lichess puzzle DB (~10k rows: FEN, moves, rating, themes)
- **No backend for v1.** Everything offline. (Design IDs/models so CloudKit sync can bolt on later.)

### 6.2 Module Map
```
KnightPath/
├── App/                  # entry, routing, DI container
├── DesignSystem/         # tokens, components (KPButton, KPCard, LevelRing, CoinPill)
├── ChessCore/            # ChessKit wrapper: GameState, MoveValidator, PGN io
├── Engine/               # UCIEngine actor, EngineConfig, PersonalityFilter
├── Bots/                 # BotDefinition, roster data, taunt lines, portraits
├── Economy/              # RewardCalculator, XP/Coin ledger, LevelCurve
├── Features/
│   ├── Splash/ Onboarding/ Home/
│   ├── Path/             # map UI, node state machine
│   ├── Game/             # BoardView, GameViewModel, HUD, PromotionPicker
│   ├── PostGame/         # report, accuracy calc, review scrubber
│   ├── Puzzles/          # daily set, streak logic
│   ├── Practice/
│   └── Profile/
└── Persistence/          # SwiftData models + migrations
```

### 6.3 Key Designs

**GameState (single source of truth)**
```swift
@Observable final class GameViewModel {
    private(set) var board: Board          // ChessKit
    private(set) var moveHistory: [Move]
    private(set) var clocks: (white: TimeInterval, black: TimeInterval)?
    private(set) var phase: GamePhase      // .playing, .promotion, .over(Result)
    // Only mutation entry point → trivial undo/redo/replay
    func apply(_ move: Move) throws
}
```

**Personality layer over one engine**
```swift
struct BotDefinition {
    let skillLevel: Int            // UCI Skill Level 0–20
    let moveTimeMs: ClosedRange<Int>
    let multiPV: Int               // candidate count
    let scorer: (Candidate, Board) -> Double   // personality bias
    let temperature: Double        // sampling randomness
    let thinkingDelay: ClosedRange<Double>
}
// pipeline: engine.analyze(fen, multiPV) → candidates
//   → candidates.map { $0.eval + bot.scorer($0, board) }
//   → softmaxSample(temperature) → delay → play
```

**Accuracy** — per move: centipawn loss vs engine top line at fixed depth (analyze async during opponent's turn to hide latency); map average CPL → 0–100% via chess.com-style curve; blunder/mistake/inaccuracy thresholds at −200/−100/−50 cp.

**Engine lifecycle** — one long-lived Stockfish process per game session; `ucinewgame` between matches; hard watchdog: if bestmove not returned in movetime×3, fall back to first legal candidate (never hang the UI).

### 6.4 Performance Targets
- Board interaction ≥ 60fps on iPhone 12 and up
- Bot response: delay window masks engine time; total ≤ 2.5s at any level
- Cold start → Home ≤ 2s; app size ≤ 120MB (Stockfish NNUE net is the big item — use small net)

---

## 7. Implementation Plan

**Phase 0 — Foundation (Week 1–2)**
- Project setup, DesignSystem tokens/components (KPButton 3D, cards, pills, rings), ChessKit integration
- BoardView: render, tap/drag moves, legal dots, animations, haptics
- **Asset track (parallel):** lock Style Anchor + reference image; produce logo set, Pathy-idle, all 12 chess pieces (pass readability gate)
- ✅ Exit: two humans can play a full legal game with polish, using final piece art

**Phase 1 — Engine & Bots (Week 3–4)**
- Stockfish xcframework + UCIEngine actor + watchdog
- PersonalityFilter pipeline; implement Ryan, Greg, Tara first (max-contrast trio) → validate feel, then remaining 6
- Hint arrows, eval capture for accuracy
- **Asset track (parallel):** Pathy's remaining poses, reward icon set, Ryan/Greg/Tara portraits ×3 expressions
- ✅ Exit: all 9 bots playable, each *feels* distinct in blind testing

**Phase 2 — Game Loop & Economy (Week 5–6)**
- Mixed-node Path map UI (bot/puzzle/drill/trophy) + node progression + stars; bot intro cards + taunts
- Drill engine: FEN-start micro-challenges with objective checkers (mate-in-N, win-by-move-X, promote) — reuses GameViewModel + engine
- RewardCalculator, XP levels, SwiftData persistence
- Post-game report with accuracy + review scrubber; Pathy reaction set integrated
- ✅ Exit: full loop — challenge → play → report → earn → unlock, across all node types

**Phase 3 — Modes & Shell (Week 7–8)**
- Pass & Play (flip + interstitial), Daily Puzzles + streaks (bundle DB)
- Splash, onboarding (interactive page 3), Home hub, Profile
- ✅ Exit: feature-complete v1

**Phase 4 — Polish & Ship (Week 9–10)**
- Sound design, Reduce Motion/VoiceOver pass, iPad sanity check
- Tuning: bot difficulty curve + economy numbers via playtests
- TestFlight beta (target 20+ testers), crash/perf hardening, App Store assets
- ✅ Exit: App Store submission

**v1.5 roadmap:** Boss battles (4 bosses) · coin Store with cosmetics · Game Center leaderboards (puzzle streaks)
**v2 roadmap:** Learning curriculum · CloudKit sync · online async multiplayer · more path chapters

---

## 7b. Competitive Positioning

| | chess.com / Lichess | Duolingo Chess | **KnightPath** |
|---|---|---|---|
| Identity | Serious tool, rating culture | Beginner course, one coach bot | **Game-first chess RPG** |
| Opponents | Rated humans + bots | Oscar only — known weakness: either blunders or crushes, poor difficulty matching | **9 personality bots that feel human at every level** |
| Progression | Elo | Course sections | XP/coins/stars/characters — no visible Elo |
| Beyond beginner | Yes | Caps at course end | Path scales to full-strength boss |

**App Store positioning line:** *"Chess opponents that feel human — at every level."* Duolingo validated the gamified-chess market (fastest-growing course, millions of learners); their difficulty-matching complaint is precisely what our personality engine solves. Skill-promise framing for marketing: "From your first move to club-level play."

## 8. Success Metrics (v1)
- D1 retention ≥ 35%, D7 ≥ 15% (mobile-game benchmarks, not utility-app)
- Median session ≥ 8 min; ≥ 2 games/session
- Puzzle streak participation ≥ 40% of DAU
- Path completion to bot #5 ≥ 25% of players in week 1
- Crash-free sessions ≥ 99.5%

## 9. Risks & Mitigations
| Risk | Mitigation |
|---|---|
| Stockfish integration complexity (C++/threading) | Isolate behind UCIEngine actor + watchdog; spike in Phase 1 week 1; fallback: pure-Swift engine (weaker but ships) |
| Bots feel same-y despite configs | Blind playtest gate in Phase 1; exaggerate personality biases — mobile players need obvious character |
| Difficulty cliff (Ryan → Grandmaster) | Star system lets weaker players progress at 1★; tune with playtest CPL data |
| Economy inflation/boredom | Numbers in a remote-config-style plist for fast tuning without releases |
| Lichess puzzle DB licensing | CC0 — free to use; credit in About screen as goodwill |
| Asset style drift across ~75 generated images | Style Anchor + reference-image pipeline, batch-by-family, per-batch QA gate (asset guide §3); one image model for the whole project |
| App size from NNUE | Ship small net; Skill Level capping doesn't need the big net |

## 10. Open Questions
1. ~~Bot portraits: AI-generated vs commissioned?~~ **Resolved (v1.2):** AI-generated with locked style reference — validated by mockup round; revisit artist post-launch
2. Timer in Path games — untimed v1 (recommended) or optional?
3. Should The Grandmaster be beatable at launch, or intentionally near-impossible (badge = prestige)?
