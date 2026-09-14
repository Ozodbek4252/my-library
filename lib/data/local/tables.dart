import 'package:drift/drift.dart';

/// Stores a list of short strings in one column, separated by a character that
/// cannot appear in an author name, genre or illustrator name.
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter<List<String>, String> {
  const StringListConverter();
  static const _sep = '|';

  @override
  List<String> fromSql(String fromDb) =>
      fromDb.split(_sep).where((e) => e.isNotEmpty).toList();

  /// Stored wrapped in separators ("|Fiction|History|") so a LIKE '%|X|%'
  /// filter matches a whole entry and never a substring of one.
  @override
  String toSql(List<String> value) =>
      value.isEmpty ? '' : '$_sep${value.join(_sep)}$_sep';
}

/// The intellectual work — "1984 by George Orwell".
/// Reading state lives here, never on a copy.
class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get authors => text().map(const StringListConverter())();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get genres => text().map(const StringListConverter())();
  TextColumn get seriesName => text().nullable()();
  IntColumn get seriesIndex => integer().nullable()();
  IntColumn get firstPublished => integer().nullable()();

  /// The edition shown for this work in lists. Denormalised so the library
  /// query can filter and sort on edition columns in SQL. Not declared as a
  /// foreign key because Editions already points back at Works.
  TextColumn get primaryEditionId => text().nullable()();

  // Reading state
  TextColumn get readingStatus => text().withDefault(const Constant('unread'))();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get finishDate => dateTime().nullable()();
  RealColumn get rating => real().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A specific published version of a [Works] row. ISBN identifies an edition.
class Editions extends Table {
  TextColumn get id => text()();
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get isbn13 => text().nullable()();
  TextColumn get isbn10 => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get publicationDate => text().nullable()();
  IntColumn get publishedYear => integer().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get format => text().nullable()();
  TextColumn get editionName => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  TextColumn get coverUrl => text().nullable()();
  /// A cover the user photographed or picked themselves, stored in the app's
  /// own directory. Takes precedence over [coverUrl]: if someone went to the
  /// trouble of photographing their copy, that is the cover they want to see.
  TextColumn get coverImagePath => text().nullable()();
  /// Index into the cover placeholder palette, so a missing cover still gets a
  /// stable colour across restarts.
  IntColumn get coverColorIndex => integer().withDefault(const Constant(0))();
  TextColumn get dimensions => text().nullable()();
  RealColumn get weightGrams => real().nullable()();
  TextColumn get translator => text().nullable()();
  TextColumn get illustrators => text().map(const StringListConverter())();
  TextColumn get country => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The user's physical item. A user can own several copies of one edition.
class Copies extends Table {
  TextColumn get id => text()();
  TextColumn get editionId =>
      text().references(Editions, #id, onDelete: KeyAction.cascade)();
  TextColumn get ownership => text().withDefault(const Constant('owned'))();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  RealColumn get purchasePrice => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get store => text().nullable()();
  BoolColumn get isGift => boolean().withDefault(const Constant(false))();
  TextColumn get giftFrom => text().nullable()();
  TextColumn get condition => text().nullable()();
  /// Hierarchical path, e.g. "Home › Bedroom › Bookshelf 2 › Shelf 4".
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get addedDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CopyPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get copyId => text().references(Copies, #id, onDelete: KeyAction.cascade)();
  TextColumn get path => text()();
  TextColumn get type => text().withDefault(const Constant('front'))();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

class CopyTags extends Table {
  TextColumn get copyId => text().references(Copies, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId => text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {copyId, tagId};
}

/// A wanted book. Attaches to a work with desired attributes rather than to a
/// concrete copy. Deliberately carries no price fields.
class WishlistItems extends Table {
  TextColumn get id => text()();
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();
  /// The exact edition wanted, when it is known — a scan captures an ISBN, a
  /// cover and a page count, and throwing those away would mean asking for
  /// them again the day the book is bought.
  TextColumn get editionId => text().nullable()();
  TextColumn get desiredLanguage => text().nullable()();
  TextColumn get desiredFormat => text().nullable()();
  TextColumn get desiredEdition => text().nullable()();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dateAdded => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One completed (or abandoned) read of a work. Statistics and the reading
/// history are derived from these rows, never from hardcoded values.
class ReadingEntries extends Table {
  TextColumn get id => text()();
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get editionId => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get finishDate => dateTime()();
  IntColumn get pagesRead => integer().withDefault(const Constant(0))();
  RealColumn get rating => real().nullable()();
  TextColumn get notes => text().nullable()();
  /// False when the read was abandoned (DNF).
  BoolColumn get finished => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RecentSearch')
class RecentSearches extends Table {
  TextColumn get query => text()();
  DateTimeColumn get searchedAt => dateTime()();
  IntColumn get resultCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {query};
}
