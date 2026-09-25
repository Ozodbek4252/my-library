# Shelf — app icon 4b

Mark: four square-capped book spines on the app's own paper ground, the last one falling 13°
outward — the end of a shelf, mid-use.

## Colors
| Role | Hex |
|---|---|
| Ground | `#F1EADC` paper |
| Spine 1 | `#1A1714` ink |
| Spine 2 | `#8A3B2C` rust |
| Spine 3 | `#D9A87C` sand |
| Leaning spine | `#4A5D3A` olive |
| Spine strip | `rgba(0,0,0,.2)` inset, 22% of each spine's width |

## Geometry (as % of the artboard's inner box; padding is 22% per side)
Widths × heights: 22×100, 15×86, 20×94, 14×74 rotated +13° about its **bottom-right** corner,
so it falls away from the stack into the right margin. No gap element — the spines are evenly
spaced by a 2.8%-of-tile layout gap.
Spine caps are square (corner radius 1.2% of the tile). Tile corner radius is 22.5% of the tile.
The right padding must stay ≥ the lean's sweep (`height × sin θ` ≈ 17 units) or the tilted spine
clips the edge.

## Files
- `icon-1024-square.png` — master, full-bleed, no corner rounding. **Use this for iOS** (the system
  applies the squircle mask).
- `icon-1024-rounded.png` — pre-rounded at 22.5%, for web, docs, and anywhere unmasked.
- `android-foreground-1024.png` — adaptive-icon foreground, art inset to 30% so it survives circle,
  squircle and teardrop masks. Pair with a solid `#F1EADC` background layer.
- `icon-1024-monochrome.png` — single-ink on white, for notifications, tinted modes and print.
- `ios/` — 180, 167, 152, 120, 87, 80, 60, 40 (square, unmasked).
- `android/` — 512, 192, 144, 96, 72, 48 (rounded).
- `web/` — 256, 128, 64, 32 favicons.

All sizes are downscaled from the 1024 master. For production, re-export from vector or from the
source component (`Shelf Icon 4b.dc.html`) rather than upscaling these.
