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
  filtering, searching and sorting stay fast on a large collection.
- **State** — Riverpod. Repositories expose streams; widgets never touch the
  database.
- **Navigation** — go_router with a `StatefulShellRoute` for the four tabs. Scan
  is pushed over the shell, because the design hides the nav there.
- **Book metadata** — everything goes through `BookMetadataRepository`. A
  bundled catalogue answers first (instant, works with no signal), Open Library
  fills the gaps. The UI cannot tell which one answered.

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
