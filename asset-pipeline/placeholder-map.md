# AssetPlaceholder → manifest map

Generated from the current Swift sources. Dynamic names are expanded against the known bot roster and chess piece enums.

| Usage | Manifest asset(s) |
|---|---|
| `DesignSystem/AssetPlaceholder.swift` previews | `piece-w-knight`, `bot-greg-neutral`, `icon-coin`, `pathy-idle` |
| `DesignSystem/DesignSystemGallery.swift` | `piece-w-knight`, `bot-greg-neutral`, `pathy-idle` |
| `Features/Onboarding/SplashView.swift` | `logo-shield` |
| `Features/Home/HomeView.swift` | `logo-knight-mark`, `bot-ryan-neutral` |
| `Features/Profile/ProfileView.swift` | `pathy-idle` |
| `Features/Game/BoardView.swift` | `piece-{w,b}-{king,queen,rook,bishop,knight,pawn}` (12 assets) |
| `Features/Path/PathMapView.swift` | `bot-{ryan,fiona,greg,castle-king,gwen,tara,sofia,eli,grandmaster}-neutral` (9 assets) |
| `Features/Game/BotGameView.swift` | `bot-{ryan,fiona,greg,castle-king,gwen,tara,sofia,eli,grandmaster}-neutral` (9 assets) |

## Corrections applied

- `bot-greg` → `bot-greg-neutral` in the design-system gallery.
- `avatar` → `pathy-idle` in Profile because `avatar` is not in the approved inventory; Pathy is the existing player-facing character asset.

All current `AssetPlaceholder` paths now resolve to manifest names.
