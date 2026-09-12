import '../../core/utils/isbn.dart';
import '../../data/local/database.dart';
import 'enums.dart';

/// A book being entered or edited, before it becomes rows in the database.
/// Shared by manual entry, the scan result sheet and metadata lookups, so the
/// UI never has to know where the values came from.
class BookDraft {
  BookDraft({
    this.workId,
    this.editionId,
    this.copyId,
    this.title = '',
    List<String>? authors,
    this.originalTitle,
    this.originalLanguage,
    this.description,
    List<String>? genres,
    this.seriesName,
    this.seriesIndex,
    this.firstPublished,
    this.isbn13,
    this.isbn10,
    this.publisher,
    this.publicationDate,
    this.publishedYear,
    this.language,
    this.format,
    this.editionName,
    this.pageCount,
    this.coverUrl,
    this.coverImagePath,
    this.coverColorIndex = 0,
    this.dimensions,
    this.weightGrams,
    this.translator,
    List<String>? illustrators,
    this.country,
    this.ownership = Ownership.owned,
    this.readingStatus = ReadingStatus.unread,
  })  : authors = authors ?? [],
        genres = genres ?? [],
        illustrators = illustrators ?? [];

  String? workId;
  String? editionId;
  String? copyId;

  // Work level
  String title;
  List<String> authors;
  String? originalTitle;
  String? originalLanguage;
  String? description;
  List<String> genres;
  String? seriesName;
  int? seriesIndex;
  int? firstPublished;

  // Edition level
  String? isbn13;
  String? isbn10;
  String? publisher;
  String? publicationDate;
  int? publishedYear;
  String? language;
  String? format;
  String? editionName;
  int? pageCount;
  String? coverUrl;

  /// A cover the user photographed or picked, stored by [ImageStore].
  String? coverImagePath;
  int coverColorIndex;
  String? dimensions;
  double? weightGrams;
  String? translator;
  List<String> illustrators;
  String? country;

  // Status
  Ownership ownership;
  ReadingStatus readingStatus;

  bool get isValid => title.trim().isNotEmpty;

  String get authorLine => authors.join(', ');

  set authorLine(String value) {
    authors = value
        .split(RegExp(r'\s*[,;&]\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String get genreLine => genres.join(', ');

  set genreLine(String value) {
    genres = value
        .split(RegExp(r'\s*[,;]\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String get isbnDisplay {
    final value = isbn13 ?? isbn10;
    return value == null ? '' : Isbn.display(value);
  }

  set isbnInput(String value) {
    final normalized = Isbn.normalize(value);
    if (normalized.isEmpty) {
      isbn13 = null;
      isbn10 = null;
      return;
    }
    if (normalized.length == 10) {
      isbn10 = normalized;
      isbn13 = Isbn.to13(normalized);
    } else {
      isbn13 = normalized;
      isbn10 = Isbn.to10(normalized);
    }
  }

  BookDraft copy() => BookDraft(
        workId: workId,
        editionId: editionId,
        copyId: copyId,
        title: title,
        authors: [...authors],
        originalTitle: originalTitle,
        originalLanguage: originalLanguage,
        description: description,
        genres: [...genres],
        seriesName: seriesName,
        seriesIndex: seriesIndex,
        firstPublished: firstPublished,
        isbn13: isbn13,
        isbn10: isbn10,
        publisher: publisher,
        publicationDate: publicationDate,
        publishedYear: publishedYear,
        language: language,
        format: format,
        editionName: editionName,
        pageCount: pageCount,
        coverUrl: coverUrl,
        coverImagePath: coverImagePath,
        coverColorIndex: coverColorIndex,
        dimensions: dimensions,
        weightGrams: weightGrams,
        translator: translator,
        illustrators: [...illustrators],
        country: country,
        ownership: ownership,
        readingStatus: readingStatus,
      );

  /// Pre-fills the editor from rows already in the database.
  factory BookDraft.fromRows({
    required Work work,
    Edition? edition,
    Copy? copy,
  }) =>
      BookDraft(
        workId: work.id,
        editionId: edition?.id,
        copyId: copy?.id,
        title: work.title,
        authors: [...work.authors],
        originalTitle: work.originalTitle,
        originalLanguage: work.originalLanguage,
        description: work.description,
        genres: [...work.genres],
        seriesName: work.seriesName,
        seriesIndex: work.seriesIndex,
        firstPublished: work.firstPublished,
        isbn13: edition?.isbn13,
        isbn10: edition?.isbn10,
        publisher: edition?.publisher,
        publicationDate: edition?.publicationDate,
        publishedYear: edition?.publishedYear,
        language: edition?.language,
        format: edition?.format,
        editionName: edition?.editionName,
        pageCount: edition?.pageCount,
        coverUrl: edition?.coverUrl,
        coverImagePath: edition?.coverImagePath,
        coverColorIndex: edition?.coverColorIndex ?? 0,
        dimensions: edition?.dimensions,
        weightGrams: edition?.weightGrams,
        translator: edition?.translator,
        illustrators: [...?edition?.illustrators],
        country: edition?.country,
        ownership: Ownership.fromName(copy?.ownership),
        readingStatus: ReadingStatus.fromName(work.readingStatus),
      );
}

/// The user's own details for one physical copy. Kept apart from [BookDraft]
/// because these fields belong to a copy, never to the book or the edition.
class CopyDraft {
  CopyDraft({
    this.id,
    this.ownership = Ownership.owned,
    this.purchaseDate,
    this.purchasePrice,
    this.currency,
    this.store,
    this.isGift = false,
    this.giftFrom,
    this.condition,
    this.location,
    this.notes,
    List<String>? tags,
  }) : tags = tags ?? [];

  String? id;
  Ownership ownership;
  DateTime? purchaseDate;
  double? purchasePrice;
  String? currency;
  String? store;
  bool isGift;
  String? giftFrom;
  Condition? condition;
  String? location;
  String? notes;
  List<String> tags;

  factory CopyDraft.fromRow(Copy copy, {List<String> tags = const []}) => CopyDraft(
        id: copy.id,
        ownership: Ownership.fromName(copy.ownership),
        purchaseDate: copy.purchaseDate,
        purchasePrice: copy.purchasePrice,
        currency: copy.currency,
        store: copy.store,
        isGift: copy.isGift,
        giftFrom: copy.giftFrom,
        condition:
            copy.condition == null ? null : Condition.fromName(copy.condition),
        location: copy.location,
        notes: copy.notes,
        tags: [...tags],
      );

  CopyDraft copy() => CopyDraft(
        id: id,
        ownership: ownership,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice,
        currency: currency,
        store: store,
        isGift: isGift,
        giftFrom: giftFrom,
        condition: condition,
        location: location,
        notes: notes,
        tags: [...tags],
      );
}
