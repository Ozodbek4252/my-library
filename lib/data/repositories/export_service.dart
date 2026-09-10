import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/utils/formatting.dart';
import '../../domain/models/enums.dart';
import '../local/database.dart';

/// Turns the collection into a file the user can keep. Two shapes: a flat CSV
/// with one row per copy, and a JSON tree that preserves works, editions and
/// copies as they are stored.
class ExportService {
  ExportService(this._db);

  final AppDatabase _db;

  Future<String> toCsv() async {
    final rows = await _rows();
    final buffer = StringBuffer();

    const headers = [
      'Title',
      'Authors',
      'Original title',
      'Original language',
      'Genres',
      'Series',
      'Series index',
      'First published',
      'ISBN-13',
      'ISBN-10',
      'Publisher',
      'Edition',
      'Language',
      'Format',
      'Published',
      'Pages',
      'Country',
      'Translator',
      'Ownership',
      'Reading status',
      'Rating',
      'Current page',
      'Started',
      'Finished',
      'Purchase date',
      'Price',
      'Currency',
      'Store',
      'Gift from',
      'Condition',
      'Location',
      'Tags',
      'Notes',
      'Added',
    ];
    buffer.writeln(headers.map(_escape).join(','));

    for (final row in rows) {
      buffer.writeln(
        [
          row.work.title,
          row.work.authors.join('; '),
          row.work.originalTitle ?? '',
          row.work.originalLanguage ?? '',
          row.work.genres.join('; '),
          row.work.seriesName ?? '',
          row.work.seriesIndex?.toString() ?? '',
          row.work.firstPublished?.toString() ?? '',
          row.edition?.isbn13 ?? '',
          row.edition?.isbn10 ?? '',
          row.edition?.publisher ?? '',
          row.edition?.editionName ?? '',
          row.edition?.language ?? '',
          row.edition?.format ?? '',
          row.edition?.publicationDate ??
              row.edition?.publishedYear?.toString() ??
              '',
          row.edition?.pageCount?.toString() ?? '',
          row.edition?.country ?? '',
          row.edition?.translator ?? '',
          Ownership.fromName(row.copy?.ownership).label,
          ReadingStatus.fromName(row.work.readingStatus).label,
          row.work.rating?.toString() ?? '',
          row.work.currentPage.toString(),
          _date(row.work.startDate),
          _date(row.work.finishDate),
          _date(row.copy?.purchaseDate),
          row.copy?.purchasePrice?.toString() ?? '',
          row.copy?.currency ?? '',
          row.copy?.store ?? '',
          row.copy?.giftFrom ?? '',
          row.copy?.condition == null
              ? ''
              : Condition.fromName(row.copy!.condition).label,
          row.copy?.location ?? '',
          row.tags.join('; '),
          row.copy?.notes ?? '',
          _date(row.copy?.addedDate),
        ].map(_escape).join(','),
      );
    }

    return buffer.toString();
  }

  Future<String> toJson() async {
    final works = await _db.select(_db.works).get();
    final editions = await _db.select(_db.editions).get();
    final copies = await _db.select(_db.copies).get();
    final wishes = await _db.select(_db.wishlistItems).get();
    final entries = await _db.select(_db.readingEntries).get();
    final tagLinks = await _db.select(_db.copyTags).get();
    final tags = {for (final t in await _db.select(_db.tags).get()) t.id: t.name};

    final payload = {
      'format': 'book-collection-export',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'works': [
        for (final work in works)
          {
            'id': work.id,
            'title': work.title,
            'authors': work.authors,
            'originalTitle': work.originalTitle,
            'originalLanguage': work.originalLanguage,
            'description': work.description,
            'genres': work.genres,
            'series': work.seriesName,
            'seriesIndex': work.seriesIndex,
            'firstPublished': work.firstPublished,
            'reading': {
              'status': work.readingStatus,
              'currentPage': work.currentPage,
              'startDate': work.startDate?.toIso8601String(),
              'finishDate': work.finishDate?.toIso8601String(),
              'rating': work.rating,
            },
            'editions': [
              for (final edition in editions.where((e) => e.workId == work.id))
                {
                  'id': edition.id,
                  'isbn13': edition.isbn13,
                  'isbn10': edition.isbn10,
                  'publisher': edition.publisher,
                  'editionName': edition.editionName,
                  'language': edition.language,
                  'format': edition.format,
                  'publicationDate': edition.publicationDate,
                  'publishedYear': edition.publishedYear,
                  'pageCount': edition.pageCount,
                  'country': edition.country,
                  'translator': edition.translator,
                  'illustrators': edition.illustrators,
                  'dimensions': edition.dimensions,
                  'weightGrams': edition.weightGrams,
                  'coverUrl': edition.coverUrl,
                  'copies': [
                    for (final copy
                        in copies.where((c) => c.editionId == edition.id))
                      {
                        'id': copy.id,
                        'ownership': copy.ownership,
                        'purchaseDate': copy.purchaseDate?.toIso8601String(),
                        'purchasePrice': copy.purchasePrice,
                        'currency': copy.currency,
                        'store': copy.store,
                        'isGift': copy.isGift,
                        'giftFrom': copy.giftFrom,
                        'condition': copy.condition,
                        'location': copy.location,
                        'notes': copy.notes,
                        'addedDate': copy.addedDate.toIso8601String(),
                        'tags': [
                          for (final link
                              in tagLinks.where((l) => l.copyId == copy.id))
                            tags[link.tagId] ?? link.tagId,
                        ],
                      },
                  ],
                },
            ],
          },
      ],
      'wishlist': [
        for (final wish in wishes)
          {
            'workId': wish.workId,
            'desiredLanguage': wish.desiredLanguage,
            'desiredFormat': wish.desiredFormat,
            'desiredEdition': wish.desiredEdition,
            'priority': wish.priority,
            'notes': wish.notes,
            'dateAdded': wish.dateAdded.toIso8601String(),
          },
      ],
      'readingHistory': [
        for (final entry in entries)
          {
            'workId': entry.workId,
            'editionId': entry.editionId,
            'startDate': entry.startDate?.toIso8601String(),
            'finishDate': entry.finishDate.toIso8601String(),
            'pagesRead': entry.pagesRead,
            'rating': entry.rating,
            'finished': entry.finished,
          },
      ],
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// A plain-text list of the shelves, for printing or pasting somewhere.
  Future<String> toPrintableList() async {
    final rows = await _rows();
    final byLocation = <String, List<_ExportRow>>{};
    for (final row in rows) {
      final key = (row.copy?.location ?? '').trim().isEmpty
          ? 'Unshelved'
          : row.copy!.location!;
      byLocation.putIfAbsent(key, () => []).add(row);
    }

    final buffer = StringBuffer()
      ..writeln('MY LIBRARY')
      ..writeln(Fmt.date(DateTime.now()))
      ..writeln('${rows.length} copies')
      ..writeln();

    final keys = byLocation.keys.toList()..sort();
    for (final key in keys) {
      buffer
        ..writeln(key.toUpperCase())
        ..writeln('-' * key.length);
      final items = byLocation[key]!
        ..sort((a, b) => a.work.title.compareTo(b.work.title));
      for (final row in items) {
        buffer.writeln(
          '  ${row.work.title} — ${Fmt.authors(row.work.authors)}'
          '${row.edition?.language == null ? '' : ' (${row.edition!.language})'}',
        );
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  Future<List<_ExportRow>> _rows() async {
    final query = _db.select(_db.copies).join([
      innerJoin(_db.editions, _db.editions.id.equalsExp(_db.copies.editionId)),
      innerJoin(_db.works, _db.works.id.equalsExp(_db.editions.workId)),
    ])
      ..orderBy([OrderingTerm.asc(_db.works.title)]);

    final rows = await query.get();
    final tagLinks = await _db.select(_db.copyTags).get();
    final tagNames = {
      for (final t in await _db.select(_db.tags).get()) t.id: t.name,
    };

    return [
      for (final row in rows)
        () {
          final copy = row.readTable(_db.copies);
          return _ExportRow(
            work: row.readTable(_db.works),
            edition: row.readTable(_db.editions),
            copy: copy,
            tags: [
              for (final link in tagLinks.where((l) => l.copyId == copy.id))
                tagNames[link.tagId] ?? link.tagId,
            ],
          );
        }(),
    ];
  }

  static String _date(DateTime? value) =>
      value == null ? '' : value.toIso8601String().split('T').first;

  /// RFC 4180 quoting: wrap in quotes and double any quote inside.
  static String _escape(String value) {
    if (!value.contains(RegExp('[",\n\r]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }
}

class _ExportRow {
  const _ExportRow({
    required this.work,
    required this.edition,
    required this.copy,
    required this.tags,
  });

  final Work work;
  final Edition? edition;
  final Copy? copy;
  final List<String> tags;
}
