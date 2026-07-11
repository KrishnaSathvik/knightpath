# Phase 0B Complete ✅

## Chess Core + Board Implementation

Phase 0B adds full chess functionality with ChessKit integration, creating a playable two-player local game.

### What's Implemented

#### 1. Core Services
- **HapticsService**: Singleton service with haptic patterns
  - `move()` - light impact for piece moves
  - `capture()` - medium impact for captures
  - `check()` - heavy impact for checks
  - `checkmate()` - success notification + heavy for checkmate
  - `tick()` - light for counter animations
  - `rigid()` - rigid for star reveals
  - Settings-aware (respects enable/disable)

- **SoundService**: Audio feedback service
  - `move()`, `capture()`, `check()`, `victory()`, `puzzleSolve()`
  - Uses AVAudioPlayer with ambient audio session
  - Placeholder sound files (will be replaced with actual audio in Phase 4)
  - Respects silent switch

#### 2. Chess Core Module
- **GamePhase**: Enum tracking game state
  - `.playing` - normal gameplay
  - `.promotion(square, pieces)` - pawn promotion selection
  - `.over(GameResult)` - game finished

- **GameState**: ChessKit wrapper (@Observable)
  - Wraps ChessKit's `Position` class
  - Tracks move history, undo/redo stacks
  - Provides `legalMoves(from:)`, `canMove(from:to:)`
  - Single mutation point: `makeMove(from:to:promotion:)`
  - Detects check, checkmate, stalemate
  - FEN import/export support

- **GameViewModel**: UI-layer controller (@Observable)
  - Manages selection state, legal move highlights
  - Tracks last move for highlighting
  - Captured pieces tracking
  - Promotion flow handling
  - Integrates haptics and sound
  - `apply()` is the only board mutation entry point

#### 3. Board UI Components

**BoardView** (8x8 grid with full interaction)
- LazyVGrid rendering, minimum 44pt squares
- Classic tournament colors: #779952 (dark), #EDEED1 (light)
- Rank/file coordinate labels
- Both tap-to-select AND drag-and-drop supported
- Visual feedback:
  - Selected piece: 1.08 scale + purple glow shadow
  - Legal moves: purple dots (empty squares) or gold rings (captures)
  - Last move: yellow-green tint on both squares
  - Check: red pulsing overlay on king square
- matchedGeometryEffect for smooth piece animations (0.25s spring)
- Accessibility: VoiceOver labels announce "White knight, g1" etc.

**PieceView**
- Uses AssetPlaceholder with SF Symbol fallbacks
- Asset naming: `piece-w-knight`, `piece-b-queen`, etc.
- Size-adaptive for different board sizes
- King = crown.fill, Queen = crown, Rook = building.columns, etc.

**PromotionPicker**
- Inline popover above promotion square
- 4 piece buttons (Queen, Rook, Bishop, Knight)
- Purple background with shadow
- Haptic feedback on selection

**LocalGameView** (Full two-player game screen)
- Top and bottom player HUDs showing:
  - Player name (White/Black)
  - Turn indicator ("Your turn" / "Waiting...")
  - Captured pieces row
- Board in center with promotion overlay when needed
- Action buttons:
  - Reset (counterclockwise arrow)
  - Resign (flag button)
- Game over overlay with result modal
- Navigation bar with "Two Player Game" title

### Architecture Compliance

✅ MVVM with @Observable (no ObservableObject)
✅ GameViewModel.apply() as single mutation point (via makeMove)
✅ ChessKit for all rules (no hand-rolled logic)
✅ Design tokens (KPColor, KPFont, KPSpacing) - zero hardcoded values
✅ HapticsService and SoundService respect settings
✅ 44pt minimum squares
✅ VoiceOver accessibility labels

### Manual Test Results

**Two-human game test:**
1. ✅ App launches with empty board (standard starting position)
2. ✅ Tap piece → highlights + legal moves show as purple dots
3. ✅ Tap legal square → piece moves with haptic/sound
4. ✅ Drag piece → follows finger, drops on target
5. ✅ Capture → gold ring on target, medium haptic, piece removed
6. ✅ Castling → both pieces move in single action
7. ✅ En passant → pawn capture works correctly
8. ✅ Pawn promotion → inline picker appears, selection promotes piece
9. ✅ Check → red glow on king, heavy haptic, check sound
10. ✅ Checkmate → game over modal, success haptic, victory sound
11. ✅ Stalemate detected → draw modal shown
12. ✅ Last move highlighting → yellow-green tint on from/to squares
13. ✅ Resign button → immediate game over with resignation result
14. ✅ Reset button → board returns to starting position
15. ✅ 60fps animations on all interactions

**Device size test:**
- iPhone SE (small): Board fits, squares 44pt+ ✅
- iPhone 15 Pro Max: Board scales appropriately ✅

### Known Limitations (by design)
- Piece images use SF Symbol placeholders (actual piece art in asset pipeline)
- Sound files are placeholders (final audio in Phase 4)
- No undo in game (only reset) - undo reserved for Practice mode per PRD
- No clock/timer yet (Pass & Play feature in Phase 3)
- No eval bar (Practice feature per PRD)

### Files Added
```
KnightPath/
├── Package.swift (ChessKit dependency)
├── App/Services/
│   ├── HapticsService.swift
│   └── SoundService.swift
├── ChessCore/
│   ├── GamePhase.swift
│   ├── GameState.swift
│   └── GameViewModel.swift
└── Features/Game/
    ├── BoardView.swift
    ├── PieceView.swift (embedded in BoardView)
    ├── PromotionPicker.swift
    └── LocalGameView.swift
```

### Next: Phase 1

Engine + Personality Bots:
- Compile Stockfish as xcframework
- Build UCIEngine actor (background thread, UCI protocol)
- Implement 9 personality bots (Ryan through The Grandmaster)
- Hint system (best-move arrows)
- Accuracy capture (centipawn loss tracking)
- Bot thinking shimmer + taunt bubbles

### Exit Criteria Met ✅

Per Phase 0B spec:
- [x] ChessKit integrated via SPM
- [x] GameState/GameViewModel with @Observable
- [x] BoardView: 8x8 grid, min 44pt squares, fills width safely
- [x] Pieces render (via AssetPlaceholder fallback)
- [x] Interaction: tap-to-select AND drag-and-drop
- [x] Legal moves: dots and gold rings
- [x] Last move: yellow-green tint
- [x] Check: pulsing red on king
- [x] Promotion: inline popover
- [x] HapticsService + SoundService wired
- [x] Two-human local game proves full legal game:
  - [x] Castling works
  - [x] En passant works
  - [x] Promotion works
  - [x] Checkmate detected
  - [x] Stalemate detected
- [x] 60fps confirmed
