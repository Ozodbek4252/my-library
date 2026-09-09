# Handoff: Book Collection — personal library & reading tracker (mobile app)

## Overview
Book Collection is a personal book inventory and reading-tracking mobile app. Its core job:
a user standing in a bookstore scans a barcode and, within ~2 seconds, knows whether they
already own the book, which edition, whether they've read it, and whether it's on their wishlist.

Secondary jobs: browsing a large library (hundreds to thousands of books) as a visual shelf,
tracking reading progress, maintaining a wishlist, and reviewing yearly reading statistics.

Explicitly **out of scope** (do not build): price tracking/alerts, lending tracker,
recommendations, AI shelf-photo recognition, social features (friends, clubs, public profiles),
collection value tracking.

## About the Design Files
The file in this bundle (`Book Collection.dc.html`) is a **design reference created in HTML** —
an interactive prototype showing intended look and behavior. It is **not production code to copy**.
The task is to **recreate these designs in the target codebase's existing environment**
(React Native, SwiftUI, Flutter, Kotlin/Compose, etc.) using its established patterns, navigation,
and component library. If no codebase exists yet, choose the most appropriate framework for a
mobile app and implement the designs there.

The prototype is a single self-contained HTML component: a fixed 390×844 phone viewport with a
screen-index chip rail above it (a prototype affordance only — **not part of the product**).
Likewise the scanner's "Simulate: owned / new / failed scan" buttons stand in for a real camera
and must not ship.

## Fidelity
**High-fidelity.** Final colors, typography, spacing, and interactions. Recreate pixel-accurately
using the codebase's libraries. All measurements below are in CSS px against a 390pt-wide iPhone
viewport (i.e. 1pt = 1px), 844pt tall.

The only placeholder content: **book covers are typographic placeholders** (solid colored rect,
serif title top-left, uppercase author bottom-left, dark 4–7px spine strip on the left edge).
In production these are real cover images fetched by ISBN; keep the typographic block as the
fallback for missing artwork, preserving the same aspect ratio, radius, and shadow.

---

## Design Tokens

### Color
| Token | Hex | Use |
|---|---|---|
| paper | `#F7F3EB` | app background |
| paper-raised | `#FCFAF5` | cards, fields, list surfaces |
| paper-sunken | `#F1EADC` | note blocks, table headers |
| paper-chip | `#EFE9DB` | neutral chips, tag pills |
| desk | `#E4DED2` | canvas behind the phone (prototype only) |
| ink | `#1A1714` | primary text, primary buttons, active nav |
| ink-2 | `#2A251F` | secondary headings |
| ink-body | `#4A443C` | body text |
| muted | `#7A7167` | supporting text |
| muted-2 | `#8A8177` | metadata |
| faint | `#A0968A` | labels, tertiary |
| faintest | `#B4AA9C` / `#C0B6A6` | disabled, chevrons |
| rule | `#E7E0D2` | list dividers |
| rule-strong | `#E0D8C9` | card borders |
| rule-inner | `#EFE8DA` | inner row dividers |
| dashed | `#CFC5B4` | dashed placeholder borders |
| accent (rust) | `#8A3B2C` | links, destructive, progress fill, active cursor |
| accent-dark | `#6E2C20` | link hover |
| accent-wash | `#FBF1EE` / `#F3E2DC` | destructive button bg / high-priority pill bg |
| success | `#3B5C3F` on `#E7EDE4` (border `#CDDAC6`) | "Read", "already own" banner |
| in-progress | `#7A5B33` on `#F5E7D3` | "Reading" badge |
| highlight | `#D9A87C` / `#E9C79A` | scanner reticle, scanned-copy card border, onboarding accent |
| highlight-wash | `#FBF4E9` (border `#EBDCC5` / `#D9A87C`) | scanned-copy card, info note |
| star | `#B9873F` (empty `#DCD3C2`) | ratings |
| dark-scene | `#100E0C`, radial `#332C25`→`#15120E` | scanner & scan-result backgrounds |
| onboarding bg | `#1E1B17`; text `#F5EEE1`, sub `#A79C8D` | onboarding |

Chart palette: `#2A2521`, `#8A3B2C`, `#8A6B3A`, `#B9AE9C`; bars `#C4BAA6` with the best month `#1A1714`, empty months `#EAE3D6`.

Cover placeholder palette (bg / fg): `#1F1D1A`/`#E8DCC8`, `#E4DCC6`/`#241F19`, `#2F4A3C`/`#E5DDCB`,
`#7A2E2E`/`#F0E4D2`, `#4B2E5A`/`#EADFEA`, `#4A5D3A`/`#EDE6D2`, `#6B5B3E`/`#F2E9D6`,
`#D9C48A`/`#2A2418`, `#8A3B2C`/`#F4E6D6`, `#C9532F`/`#FBEEDD`, `#26364F`/`#DFE4EA`, `#B08A4E`/`#2A2114`.

### Typography
Two families only.
- **Newsreader** (serif, Google Fonts; weights 300–600, italic available) — all display: screen
  titles, book titles, big numbers, statistics figures, personal notes (italic).
- **Instrument Sans** (Google Fonts; 400/500/600/700) — all UI: labels, body, buttons, metadata.

Scale (family / size / weight / line-height / tracking):
| Role | Spec |
|---|---|
| Onboarding headline | Newsreader 42 / 400 / 1.06 / −0.02em |
| Screen title | Newsreader 31 / 400 / 1.1 / −0.015em |
| Detail hero title | Newsreader 27 / 400 / 1.1 / −0.01em |
| Sheet / section title | Newsreader 22 / 400 / 1.2 |
| Stat figure (large) | Newsreader 30 / 400 / 1 |
| Stat figure (small) | Newsreader 21 / 400 / 1 |
| Progress number (sheet) | Newsreader 58 / 400 / 1 |
| Personal note | Newsreader 15–15.5 italic / 1.55 |
| Body | Instrument Sans 13.5–14.5 / 400 / 1.5–1.62 |
| List primary | Instrument Sans 14.5 / 500 / 1.25 |
| List secondary | Instrument Sans 12.5 / 400 |
| Metadata | Instrument Sans 11–12 / 400 |
| Section label (all-caps) | Instrument Sans 10 / 400 / uppercase / 0.14em |
| Micro label (stat caption) | Instrument Sans 9.5 / uppercase / 0.1em |
| Button | Instrument Sans 14–15.5 / 500–600 |
| Chip | Instrument Sans 13 / 500 |
| Pill / badge | Instrument Sans 11–11.5 / 600 |
| Nav label | Instrument Sans 10 / 500 (600 active) / 0.02em |
| Cover placeholder title | Newsreader 12 (grid) / 1.16 |
| Cover placeholder author | Instrument Sans 6.5–7.5 / uppercase / 0.13–0.14em / opacity .82 |

Long-form text blocks use `text-wrap: pretty`.

### Spacing
Screen horizontal padding **22px**. Top padding 60px (below the 52px status bar), bottom padding
**112px** on nav screens (88px nav + clearance), 40px on modal-style screens.
Vertical rhythm: 6 / 7 / 9 / 11 / 14 / 16 / 20 / 24 / 26px. Section label margin `26px 0 10px`.
Grid gap `16px 12px`. Chip/button gaps 7–9px. List row padding `13–15px 0`.

### Radius
3px covers · 2px small thumbnails · 7px pills · 8–9px chips/tags · 10–11px inputs, small buttons ·
13px primary buttons · 14–16px cards · 20px dialog · 24–26px bottom sheets · 42px phone screen ·
50% circular icon buttons.

### Shadow
- Cover (grid): `0 1px 2px rgba(26,23,20,.2), 0 6px 16px rgba(26,23,20,.13)`
- Cover (large/detail): `0 6px 22px rgba(0,0,0,.45)` + `1px solid rgba(255,255,255,.12)` border
- Thumbnail: `0 1px 3px rgba(26,23,20,.18)`
- Scan FAB icon: `0 3px 10px rgba(26,23,20,.28)`
- Dialog: `0 20px 50px rgba(12,10,8,.4)` · Toast: `0 10px 30px rgba(12,10,8,.32)`
- Segmented-control active thumb: `0 1px 2px rgba(26,23,20,.12)`

### Motion
| Name | Spec |
|---|---|
| `sheet` | `translateY(100%) → 0`, 280–320ms `cubic-bezier(.2,.8,.3,1)` |
| `rise` | opacity 0→1 + `translateY(14px)→0`, 220–240ms ease-out (dialog, toast) |
| `scanline` | `translateY(−70px) ↔ 70px`, 1.6s ease-in-out alternate infinite |
| `pulse` | opacity .35↔.9, 1.1s infinite (text cursor) |
| `shimmer` | background-position −260px→260px, 1.3s linear infinite (skeletons) |
| `spin` | 360°, 0.9s linear infinite (sync spinner) |

---

## Data model (the spine of this product)

Three entities. Getting this right matters more than any single screen.

**Work** — the abstract book. Fields: `title`, `author`, `originalTitle`, `originalLanguage`,
`genre`, `description`, `seriesName`, `seriesIndex`, `firstPublished`.

**Edition** — a published printing of a Work. Fields: `isbn` (unique key for scanning),
`language`, `publisher`, `editionName`, `format` (Paperback | Hardcover | …), `publishedYear`,
`pageCount`, `countryOfPublication`, `translator`, `coverUrl`.

**Copy** — the user's physical item. One Copy → one Edition → one Work. Fields:
`ownership` (Owned | Wishlist | Previously owned), `purchaseDate`, `purchasePrice`, `currency`,
`store`, `isGift`, `giftFrom`, `condition` (New | Like new | Good | Acceptable | Damaged),
`location` (hierarchical path, e.g. Home › Bedroom › Bookshelf 2 › Shelf 4), `notes`, `tags[]`,
`photos[]` (typed: Front | Back | Spine | Special edition | Damage | Signed), `addedDate`.

**Reading state lives on the Work, not the Copy** — you don't re-read a book by owning it twice.
Fields: `status` (Unread | Reading | Read | DNF | Re-reading), `currentPage`, `startDate`,
`finishDate`, `rating` (1–5), reading-session history entries.

**Wishlist item** attaches to a Work with desired attributes rather than a specific Copy:
`desiredLanguage`, `desiredFormat`, `desiredEdition`, `priority` (High | Medium | Low),
`notes`, `dateAdded`.

Consequence for the UI: a scan resolves ISBN → Edition → Work. Ownership is judged at Work level
("do I own this book?") and then disambiguated at Copy level ("which edition?"). A second edition
of an owned Work is **never** rejected as a duplicate — it is offered as "Add as another edition".

---

## Screens

Twenty-four states. Each entry gives purpose, layout, and exact component specs.

### 1. Onboarding
Full-bleed `#1E1B17`. Three cover placeholders (96×144) at top:96, centered, 12px gap, in a
900px-perspective row — left card `rotateY(18deg) rotate(-4deg)`, center `rotateY(0) translateZ(26px)`,
right `rotateY(-18deg) rotate(4deg)`, shadow `0 12px 34px rgba(0,0,0,.5)`.
Bottom-anchored content, 30px side padding, 44px bottom:
headline "Every book you own, / *in your pocket.*" (Newsreader 42, second line italic `#D9A87C`);
subhead `#A79C8D` 14.5/1.5, max-width 300, 32px below;
primary button 54px, `#F5EEE1` on dark, radius 14, label "Start my library";
secondary 54px, transparent, 1px `rgba(245,238,225,.24)`, "Import from Goodreads";
3-dot pager 26px below (active 22×3 `#D9A87C`, inactive 8×3 `rgba(245,238,225,.25)`).
No bottom nav.

### 2. Empty library
Title "Library" (Newsreader 30) top-left. Centered column, offset −40px:
three 52×78 dashed `#CFC5B4` cover outlines (7px gap), 24px below them
"Your shelves are empty" (Newsreader 23), sub 14/1.5 `#7A7167` max-width 250:
"Scan the barcode on a book you own — the rest fills itself in."
Primary 50px ink button with barcode icon + "Scan a book"; text button "Add manually" in `#8A3B2C`.
Bottom nav present.

### 3. Loading
Skeleton of the Library: 34×150 title block, 44px search block, 3-column grid of 9 cover skeletons
(2:3, radius 3) each with two text bars. All skeletons animate `shimmer` over
`linear-gradient(90deg,#EAE3D6 8%,#F3EDE2 18%,#EAE3D6 33%)` at 520px background-size.
Footer at bottom:130 — 15px spinning rust arc + "Syncing 214 books…" 12.5px `#7A7167`.
Auto-advances to Library after 2.6s in the prototype; in production, on data ready.

### 4. Library (primary screen)
Header row: "Library" (Newsreader 31) + sub "214 books · 12 shelves" (12.5 `#8A8177`);
right, a segmented grid/list control — 3px-padded `#EBE4D7` track, radius 10, each button
32×30 radius 8, active thumb `#FCFAF5` with the segmented shadow and ink icon, inactive `#8A8177`.

Stats strip (toggleable): 1px `#E0D8C9` rules top and bottom, 11px vertical padding, four equal
columns — figure Newsreader 21, caption 9.5 uppercase 0.1em `#8A8177`. Values: Total 214,
Unread 58, Reading 2, Read 154.

Controls row, 14px below, 8px gap: search field (flex, 42px, `#FCFAF5`, 1px `#E0D8C9`, radius 11,
magnifier + placeholder "Title, author, ISBN…" 14px `#8A8177`); filter button 42×42 (inverts to
ink fill when filters are active); sort button 42×42.

Active-filter row (only when filters exist): ink pills 28px, radius 8, label + "×", plus a
"Clear" text button in rust.

Count line: "${N} of 214 shown · sorted by ${sort}" 11px `#8A8177`.

**Grid view** — `grid-template-columns: repeat(3, minmax(0,1fr))`, gap `16px 12px`, padding
`16px 22px 0`. Each cell is a min-width:0 column, 7px gap:
cover (aspect 2:3, radius 3, cover shadow) containing a `linear-gradient(103deg, rgba(255,255,255,.13),
rgba(0,0,0,.14) 62%, rgba(0,0,0,.24))` sheen, a 5px `rgba(0,0,0,.28)` left spine, the placeholder
title (Newsreader 12, padding `11px 9px 8px 13px`) and author (6.5px uppercase, bottom 8 left 13);
status badge top-right 6/6 — "Reading" = 17px-tall `#F5E7D3`/`#7A5B33` pill 8.5px/700, "Read" =
17px circle `rgba(247,243,235,.92)` with a `#3B5C3F` check, others none.
**The title's right padding must reserve room for the badge: 56px when the Reading pill is shown,
30px for the read check, else 9px.**
Caption block (toggleable): title 11.5/500 `#2A251F`, author 10.5 `#8A8177`, both single-line
ellipsis (requires min-width:0 on the cell).

**List view** — rows with 13px padding, 1px `#E7E0D2` divider: 38×57 thumbnail (radius 2, 3px spine),
title 14.5/500, author 12.5 `#8A8177`, meta line 11px `#A0968A`
("English · Penguin · Paperback · 2013"), and a right-aligned status pill.

Sorting: Recently added (default) · Title · Author · Pages · Publication date · Rating.
Filtering: reading status, language, genre, format, publisher (plus author and series in production).
Filters are AND-combined across groups.

### 5. Search
Field takes focus: 44px, 1.5px `#1A1714` border, magnifier, query text, blinking 1.5×18px rust caret;
"Cancel" text button right. Sections: **Try** — suggestion chips ("Unread philosophy", "English books",
"Penguin", "Added this month", "Rated 5★"), 34px, radius 9, 1px `#E0D8C9`. **Recent** — rows with
clock icon, query, right-aligned count. Bottom promo card: 38px ink rounded square with barcode
icon, "In a bookstore? / Scanning is faster than typing.", 34px ink "Scan" button.
Search covers title, author, ISBN, publisher, genre, and tags.

### 6. Search results
Same field, unfocused, with a clear "×". Count line "${N} in your library", then list rows
identical to Library list view. Footer: "Not in your library? **Search all editions**" (rust).

### 21. Empty state (no results) — same screen, empty branch
Centered from 120px: 40px outline magnifier `#CFC5B4`, "No matches" (Newsreader 22),
"Nothing in your library for “${query}”. It may be a book you don't own yet." (max-width 230);
46px ink "Scan its barcode" button; "Add it manually" text button.

### 7. Barcode scanner
Dark scene: base `#100E0C` + `radial-gradient(120% 70% at 50% 38%, #3A332B, #17140F 62%, #0C0A08)`.
Reticle inset `top:118 left/right:40 bottom:290`, dimmed surround via
`box-shadow: 0 0 0 2000px rgba(10,9,7,.55)`, four 34px `#E9C79A` 2.5px corner brackets (14px outer radius),
a mock barcode of 26 `#E9C79A` bars (2–4px wide, 58–82px tall) at 0.5 opacity, and a 2px
`linear-gradient(90deg,transparent,#E9C79A,transparent)` sweep line with a 14px glow running `scanline`.
Above: "Point at the barcode" (Newsreader 19, `#F5EEE1`) and "Usually on the back cover" (12.5 `#8F857A`).
Bottom: two 48px translucent buttons "Search by title" / "Enter manually"; close × top-left, 36px circle.
**Prototype-only:** the "Simulate: owned / new / failed" controls — replace with the live camera.
Performance requirement: recognition to result in under ~2s; keep the camera warm when the tab is
reachable and allow continuous scanning ("Scan next" on every result).

### 8. Scan result — already owned  ⟵ the product's most important screen
Camera scene dims; a `#F7F3EB` sheet rises from the bottom (radius 26 top, 22px padding,
max-height 730, scrollable, `sheet` animation) with a 38×4 `#DCD3C2` grabber.
1. **Verdict banner** first, always: `#E7EDE4` on `#CDDAC6` border, radius 12, check icon,
   "You already own this book" 15.5/600 `#294229`.
2. **Book block**: 96×144 cover, title (Newsreader 26), author, then pills — reading status
   ("Read · Mar 2023" on `#E7EDE4`) and rating ("★ 5.0" on `#EFE7D8`) — and "2 editions on your shelves".
3. **Your copies** card: `#FCFAF5`, 1px `#E0D8C9`, radius 14; header bar `#F1EADC` with the
   10px uppercase label; one row per copy — 26×38 colour chip, "Russian · АСТ · Hardcover" 13.5/600,
   "2024 · 320 pp · Bedroom, Shelf 4" 11.5 `#8A8177`.
4. **Scanned copy** card: distinguished by a 1.5px `#D9A87C` border on `#FBF4E9`, header `#F5E7D3`,
   showing "English · Penguin Clothbound · Hardcover", "2025 · 352 pp · ISBN …".
5. Actions: primary 52px ink **"Add as another edition"**; below, "Wishlist it" and "Scan next".
All five bookstore questions (own it? which edition? read it? wishlisted? key details?) are
answered on this one sheet — never split across screens.

### 9. Scan result — new book
Same sheet mechanics. Neutral banner `#EFE9DB` with a plus icon: "Not in your library yet".
Book block with 96×144 cover and a 12.5/1.6 metadata stack (language · publisher / format · year ·
pages / ISBN). If the Work is wishlisted, a `#FBF4E9` info note: "On your wishlist since Jan 2026 —
adding it will clear it from there." Actions: 52px ink "Add to library"; "Add with details" and
"Scan next". Adding shows the success toast and returns to Library.

### 22. Error state — failed scan
Same dark scene; sheet with a 40px `#F3E2DC` rounded-square alert icon in rust,
"Couldn't read that barcode" (Newsreader 22) and "Low light, or the code may be creased. Try again,
or type the 13 digits printed under it." Actions: 50px ink "Try again", 50px outlined
"Enter ISBN manually". The same pattern serves offline and lookup-failure errors — always name the
likely cause and offer a manual path.

### 10. Add book (manual)
Modal-style screen. Top bar: "Cancel" / "Add book" / "Save" (rust text buttons, 14.5/600).
Cover dropzone 76×114 dashed, image icon + "Cover"; beside it "Scanning fills every field below
automatically. **Scan instead →**".
Three grouped field cards under uppercase labels:
**The book** — Title, Author, Original title, Genre, Description.
**This edition** — ISBN, Language, Publisher, Format, Published, Pages, Country, Translator.
Rows are 13px-padded with a 96px `#8A8177` label column and a 13.5/500 value; unfilled values
render `#A0968A`.
**Status** — two chip rows: ownership (Owned / Wishlist / Previously owned) and reading
(Unread / Reading / Read / DNF / Re-reading). Chip = 34px, radius 9; selected is ink fill + `#F7F3EB` text.
Footer: 52px ink "Add to library".

### 11. Book details
**Hero** — full-bleed block tinted with the cover's dominant colour, overlaid
`linear-gradient(180deg, rgba(12,10,8,.42), rgba(12,10,8,.82))`. Floating controls at top:56 —
36px back circle `rgba(20,17,14,.42)` with 8px backdrop blur, "Edit" pill, and a 36px "⋯" circle.
Content at padding `112px 24px 22px`: 108×162 cover (radius 3, heavy shadow, hairline light border)
beside title (Newsreader 27 `#FAF6EE`), author `#C4B9A9`, and three glass pills
(ownership · reading status · rating) on `rgba(250,246,238,.16)`.
**Progress card** (only when Reading): `#FCFAF5` card — "237 of 320 pages" left, "74%" (Newsreader 22)
right, 5px `#E7E0D2` track with a rust fill, and a 42px outlined "Update progress" button.
**Description** 14/1.62 `#4A443C`.
**Editions row**: tappable card showing two overlapped 20×29 spines (−7px overlap, 1.5px paper
border between), "3 editions of this work" + "English Penguin · Russian АСТ · Clothbound", chevron.
**The edition you own** table: Language, Publisher, Edition, Format, Published, Pages, Genre,
Original title, ISBN. Rows 11px, 104px label column, right-aligned 13/500 values.
**My copy** table: Purchased, Price, Where, Gift, Condition, Location, Added.
**Tags**: `#EFE9DB` pills, 27px, "#dystopia" etc.
**Personal note**: `#F1EADC` block, uppercase label, Newsreader 15.5 italic.
**Photos of my copy**: 66px squares — Front / Spine / Signed, plus a dashed "+" tile.
Photos of the user's copy are always kept distinct from the official cover.

### 12. Edit copy
Back/Save top bar. Sections: reading-status chips; a 5-star picker (29px glyphs, `#B9873F` filled,
`#DCD3C2` empty, with "4.0" beside it); **Purchase** field card (Date, Price, Currency, Store,
Gift from); **Condition** chips (New / Like new / Good / Acceptable / Damaged); **Location**
breadcrumb card ("Home › Bedroom › Bookshelf 2 › Shelf 4", each level tappable);
**Personal notes** textarea (min 96px, Newsreader italic, blinking caret).
Footer: 50px "Remove this copy" — `#FBF1EE` fill, `#E3CBC4` border, rust label; opens the confirm dialog.

### 13. Multiple editions
Back circle, then "1984" (Newsreader 29) + "George Orwell · first published 1949", and the model
explainer: "One work, three copies. Reading status belongs to the work; everything else belongs to the copy."
Edition cards (radius 14, `#FCFAF5` / 1px `#E0D8C9`): 44×66 spine chip, language 14.5/600 with a
qualifier pill ("Reading copy", "Gift"), an edition line and a copy line
("336 pp · £8.99 · Home › Bedroom › Shelf 4"). A just-scanned, not-yet-added edition is rendered on
`#FBF4E9` with a **dashed** `#D9A87C` border and a `#F5E7D3` "Just scanned" pill.
Footer: dashed 50px "+ Add another edition".

### 14. Wishlist
"Wishlist" title + "7 books · 2 high priority". Horizontally scrolling filter chips
(All 7 / High 2 / English / Hardcover). Rows: 38×57 thumbnail, title, author, desired-attributes
line ("English · Hardcover · Norton") 11px `#A0968A`, and a priority pill —
High `#F3E2DC`/`#8A3B2C`, Medium `#EFE9DB`/`#6B635A`, Low `#EFE9DB`/`#A0968A`.
No prices anywhere.

### 15. Wishlist detail
Back circle; 104×156 cover beside an uppercase "Wishlist" pill, title (Newsreader 25), author,
"Added 12 Feb 2026". **What I want** table: Language, Format, Edition, Priority, Added.
**Note** block (`#F1EADC`, Newsreader italic). Actions: 52px ink
"I bought it — move to library" (converts the wishlist item into an owned Copy) and an outlined
"Remove from wishlist" which opens a confirm dialog.

### 16. Reading — Currently reading
"Reading" title, then two tabs (chips) "Currently reading" / "History".
One card per in-progress book (radius 16, `#FCFAF5`, 1px `#E0D8C9`, 16px padding):
76×114 cover; title (Newsreader 20), author; a big percentage (Newsreader 27) with
"237 / 320 pages" beside it; a 5px track with rust fill; "Started 14 Aug · 12 days in".
Two buttons: 42px ink "Update page" and 42px outlined "Mark finished".
Below: "Up next · from your shelves" — a row of 62×93 unread covers.

### 17. Reading history (tab)
Stat strip: 31 Read in 2026 · 9,842 Pages · 4.2 Avg rating.
Month headings (10px uppercase) with book rows beneath: 34×51 thumbnail, title, author,
"Finished 2 Sep · 3 days" and a right-aligned `#B9873F` star string.

### 18. Reading progress (bottom sheet)
Grabber, book title (Newsreader 22), "Started 14 Aug 2026 · 320 pages".
Centered "237 / 320" (Newsreader 58 + 17px `#A0968A`), then "74% · 83 pages to go".
6px track with rust fill. Stepper row: 56px "−", flexible "+10 pages", 56px "+" (adds 25).
Footer: 52px ink "Save progress" and outlined "Finished it" (jumps to 100%, moves the book to
history, and prompts for a rating via toast).

### 19. Statistics
"This year" + "1 Jan – 9 Sep 2026".
Four-cell 2×2 metric grid built from a 1px `#E0D8C9` gap over a bordered radius-14 container:
31 Books read this year · 9,842 Pages read · 2 Currently reading · 4.2 Average rating
(figures Newsreader 30, labels 11px).
**Books finished per month** — 118px column chart, max bar width 18px, radius `3px 3px 0 0`,
`#C4BAA6` bars with the best month in `#1A1714` and zero months as 3px `#EAE3D6` stubs,
single-letter month labels, bottom rule; caption "Best month: June, 6 books · 1,918 pages".
**By language** — a single 12px stacked bar (radius 6) plus a swatch legend
(English 62 · Russian 18 · Italian 12 · Other 8).
**By genre** — labelled 7px bars with counts.
**Most read authors** — ranked table rows.
No dashboard chrome, no gauges, no KPI cards with deltas.

### 20. Profile / Settings
"Profile"; identity card with a 52px ink avatar (initials in Newsreader 21),
"Maya Kessler" and "214 books · since Mar 2021". Then a tappable "Reading statistics" row.
Grouped setting lists (uppercase group labels, bordered `#FCFAF5` cards, 14px rows with a
right-aligned value and chevron):
**Library** — Shelves & locations (12), Custom fields (3), Scanner (Fast mode);
**Data** — Import & export, Backup (iCloud), Offline covers (On);
**App** — Appearance (Paper), About (2.4).
Footer: "Book Collection 2.4 · your library lives on your device".

### 23. Import / Export
Back circle, "Import & export" (Newsreader 29), intro line.
**Import** rows with a 32px `#EFE9DB` mark tile: CSV "From a spreadsheet / Map your own columns";
GR "Goodreads export / library_export.csv"; LT "LibraryThing / TSV or CSV";
⌘ "Another Book Collection backup / .bookcol file".
**Last import** card: "2 Mar 2026", "198 rows · 191 matched by ISBN · 5 matched by title ·
**2 need review**" (rust), and a 6px split bar (96% `#4A5D3A`, 4% `#8A3B2C`).
**Export** rows: CSV (every field, one row per copy), JSON (full structure, works and copies),
Printable list (a PDF of your shelves).

### 24. Confirmation dialog
Centered over a `rgba(20,17,13,.5)` scrim, 34px inset, radius 20, `rise` animation.
"Remove this copy?" (Newsreader 22) + a consequence-specific body: "Your English Penguin paperback
of 1984 will be deleted, along with its purchase details and photos. Your other edition stays."
Buttons stacked: destructive 50px `#8A3B2C` "Remove copy", then a plain 50px "Keep it".
Destructive dialogs always name what is lost **and** what survives.

### Toast
Bottom-anchored (bottom:104, 20px insets), ink `#1A1714`, radius 13, 14px padding, a
`#B5D0A8` check icon and 13.5/500 label; `rise` in, auto-dismiss at 2.4s.
Copy in use: "Added to your library", "Copy removed · 1 edition left",
"Finished · added to 2026 history", "Marked as read · rate it?".

### Bottom navigation
88px tall, `rgba(247,243,235,.93)` with 16px backdrop blur, 1px `#E4DCCC` top border,
items top-aligned with 9px top padding. Five equal items, icon (21px stroke 1.8) over a 10px label;
active `#1A1714` (label 600), inactive `#A0968A`.
**Library · Reading · Scan · Wishlist · Profile.** Scan is visually promoted: its icon sits in a
46×34 ink rounded rectangle (radius 11) with the FAB shadow and a `#F7F3EB` glyph.
Active-tab mapping: Library also owns Details / Editions / Results / Empty / Loading;
Wishlist owns Wishlist detail; Profile owns Statistics and Import/Export.
The nav is hidden on Onboarding, Search, Scanner, all scan results, Add, Edit, and Import/Export.

---

## Interactions & Behavior

**Bookstore flow (the one to optimise).** Scan tab → camera live immediately → ISBN decoded →
lookup → result sheet. Owned and not-owned share one sheet layout so the verdict always lands in
the same place. Every result offers "Scan next" so a user can work through a shelf without
returning to a home screen.

**Duplicate detection.** Match on ISBN first (exact Edition), then on normalised title+author
(same Work, different Edition). Exact-Edition match → "You already own this book" with that copy
highlighted, and the option to add a second physical copy. Same-Work match → the owned-book sheet
with the scanned edition shown as a distinct card and "Add as another edition" as the primary
action. Never a blocking "duplicate" error.

**Wishlist reconciliation.** Adding a Work that is wishlisted clears the wishlist item and says so
before the user commits.

**Filters and sorting.** Filters are multi-select within a group, AND-ed across groups; applied
filters appear as removable ink pills on the Library header and invert the filter button; the
sheet's primary button reads "Show ${N} books" when a filter is active, "Done" otherwise.
Sort is single-select with a rust check on the active row and closes the sheet on pick.

**Progress.** −10 / +10 / +25 steppers, clamped to 0…pageCount. "Finished it" sets the page to
the total, moves the Work to Read with today's finish date, and prompts for a rating.

**Loading.** Cover-shaped shimmer skeletons that match the real grid, never spinners on a blank page.

**Errors.** Named cause + a manual escape hatch, presented in the same sheet position as a success.

**Gestures to add in production** (not in the prototype): swipe-to-dismiss on sheets, pull-to-refresh
on Library, long-press a cover for a quick-action menu (mark read, edit, wishlist).

## State Management
- `screen` + `prev` — navigation; the prototype flattens a real nav stack. Use the platform's
  navigator; the "back" affordance returns to `prev`.
- `view`: 'grid' | 'list' — persisted per user.
- `filters: string[]`, `sort: string` — persisted for the session; sort persisted per user.
- `query: string` — search input; results derive from it.
- `sheet`: null | 'filter' | 'sort' | 'progress' | 'confirm' — one modal at a time.
- `bookId` — the Work being viewed.
- `page` — current reading page for the active book.
- `readingTab`: 'now' | 'history'.
- `toast` — transient message with a 2.4s timer (clear the timer on unmount).
- Per-edit drafts: `editRating`, `editStatus`, `condition`.

**Data needs.** Local-first: the library must be fully readable and searchable offline (the app
advertises "your library lives on your device", and bookstores have poor signal). Cover images are
cached locally. The only network call in the core flow is ISBN → book metadata; cache lookups, and
on failure fall back to the manual-entry path. Import parses CSV/TSV with ISBN-first matching and a
review queue for unmatched rows.

## Assets
- **Fonts:** Newsreader and Instrument Sans (Google Fonts, SIL Open Font License). Bundle them.
- **Icons:** 24-box stroke icons, 1.8–2.2 weight, round caps — search, filter, sort, barcode, chevron,
  check, plus, alert, clock, image, back, and the five nav glyphs. Substitute your codebase's icon
  set at matching sizes and weights.
- **Book covers:** none shipped. Fetch by ISBN (Open Library / Google Books or your provider) and
  cache. The typographic placeholder is the required fallback.
- **Photography:** none. Photos of the user's copy are user-generated.
- No brand or logo assets are used.

## Files
- `Book Collection.dc.html` — the complete interactive prototype (all 24 states). Open it in a
  browser; the chip rail above the phone jumps directly to any screen, and the app itself is
  navigable via the bottom nav, filter/sort sheets, scan flow, progress sheet, and dialogs.
- `support.js` — runtime for the prototype file only. Not part of the design; do not port it.
