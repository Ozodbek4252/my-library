# Book Collection

A personal library and reading tracker. Its core job: you are standing in a
bookstore, you scan a barcode, and within about two seconds you know whether the
book is already on your shelf, in which edition, and whether you have read it.

Built from the design in [`design_handoff_book_collection/`](design_handoff_book_collection/).

## The data model

Three entities, and getting them right matters more than any single screen:

```
Work        the book itself — 1984 by George Orwell
 └─ Edition a published printing — Penguin, English, Paperback, 2013, ISBN …
     └─ Copy  your physical item — bought at Daunt, £8.99, Bedroom shelf 4
```

- **Reading state lives on the Work.** You do not re-read a book by owning it twice.
- **ISBN identifies an Edition.** A different ISBN for a book you own is a new
  *edition*, never a duplicate; the same ISBN twice is a second *copy*.
- **Knowing an edition is not owning it.** A wishlisted book, or one you used
  to own, is stored as an Edition with no owned Copy — so a scan says "not in
  your library yet" rather than claiming you have it.
- **A wanted book keeps the edition it was scanned as.** Its ISBN, cover, page
  count and year are recorded when it is wishlisted, so buying it later adds a
  Copy to that edition instead of starting from a blank one.
- Two books that merely share a title are not duplicates — matching uses title
  **and** author.

## Architecture

```
lib/
  core/          theme tokens, typography, routing, shared widgets, utils
  domain/models/ enums and the aggregates the UI reads
  data/
    local/       Drift (SQLite) schema and generated code
    metadata/    BookMetadataRepository + bundled catalogue and Open Library
    repositories/library, reading, wishlist, statistics, scanning
    seed/        the sample library
  features/      one folder per screen area, presentation only
```

- **Persistence** — Drift over SQLite. Relational, indexed, and queried in SQL so
  filtering, searching and sorting stay fast on a large collection. Schema
  changes ship as migrations; existing libraries are never rebuilt.
- **State** — Riverpod. Repositories expose streams; widgets never touch the
  database.
- **Navigation** — go_router with a `StatefulShellRoute` for the four tabs. Scan
  is pushed over the shell, because the design hides the nav there.
- **Book metadata** — everything goes through `BookMetadataRepository`, and the
  UI cannot tell which provider answered. Three are chained, in order:

  1. **`BookScraperSource`** — the project's own Laravel service, which holds
     the Uzbek ISBNs the global providers do not have.
  2. **`LocalCatalogSource`** — a bundled catalogue, so the sample library and
     the bookstore flow work with no signal at all.
  3. **`OpenLibrarySource`** — everything else.

## Covers

An edition can have a cover from three places, in this order:

1. **A picture the user supplied** — tap the cover on the Add or Edit screen to
   photograph the book or pick an image. This is the answer for a book with no
   barcode, where no provider has anything to offer.
2. **A cover URL** from the lookup service, cached on device.
3. **The typographic placeholder** — a coloured block with the title and author,
   used whenever there is no artwork and whenever an image fails to load.

Picked images are copied out of the system cache into the app's own directory,
because the picker hands back a file the system may delete. Replaced and removed
covers are cleaned up on save, and a deleted edition takes its cover with it.

## The lookup service

The app talks to the `book-scraper` API, which exposes three endpoints:

| Endpoint | Used for |
| --- | --- |
| `GET /api/v1/books/{isbn}` | The barcode scan, and "Fill in from ISBN" on the editor |
| `GET /api/v1/books?q=&per_page=` | "Search all editions" when a book is not on your shelves |
| `POST /api/v1/books/suggestions` | A book no provider knows, offered back after you type it in |

The base URL is a compile-time constant with a deployed default; override it for
a local stack or another deployment:

```sh
flutter run --dart-define=BOOK_API_BASE_URL=http://192.168.1.20:8000
flutter run --dart-define=BOOK_API_BASE_URL=          # switch the service off
```

With or without the `/api/v1` suffix both work. `BOOK_API_TOKEN` sets a Sanctum
bearer token for when the service re-enables `auth:sanctum`.

Two details the service dictates and the client handles:

- Languages arrive as Uzbek names — `O'zbekcha`, `Ruscha`, `Inglizcha` — with
  several different apostrophes. They are folded to one English name each so
  filters and statistics group correctly; anything unrecognised passes through.
- `404` means "no such book" and `422` means "bad check digit". Neither is a
  transport failure, so neither stops the next provider from being tried.

Suggestions are never sent without asking. When a scan finds nothing and you
type the book in yourself, the app offers once to share the bibliographic
fields — title, author, edition — and never your notes, purchase details or
shelves.

## Running it

```sh
flutter pub get
dart run build_runner build     # regenerate the Drift code after schema changes
flutter run
```

A first launch seeds a realistic sample library — several languages, multiple
editions of one work, multiple copies of one edition, every reading status, a
wishlist and a year of reading history. Reset it from Profile → Sample library.

Scanning needs a real camera; on a simulator use **Enter manually** on the
scanner, which runs the same lookup path.

## Tests

```sh
flutter test
```

Covers ISBN validation and barcode parsing, duplicate/edition/copy resolution,
search, filters, sorting, reading progress, statistics, the seed data, and the
screens themselves.

## Deliberately not built

No price tracking or alerts, no lending tracker, no recommendations, no shelf
photo recognition, no social features, no collection valuation, no gamification.

Importing from Goodreads/LibraryThing/CSV is not implemented; the Import screen
says so rather than offering rows that do nothing. Export (CSV, JSON, printable
list) works.
