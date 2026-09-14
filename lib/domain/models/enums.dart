/// Whether the user owns the book, wants it, or used to own it.
/// Ownership lives on a [Copy] and is independent of reading status.
enum Ownership {
  owned('Owned'),
  wishlist('Wishlist'),
  previouslyOwned('Previously owned');

  const Ownership(this.label);
  final String label;

  static Ownership fromName(String? name) =>
      Ownership.values.firstWhere((e) => e.name == name, orElse: () => Ownership.owned);
}

/// Reading status lives on the Work, not the Copy — you do not re-read a book
/// by owning it twice.
enum ReadingStatus {
  unread('Unread'),
  reading('Reading'),
  read('Read'),
  dnf('DNF'),
  rereading('Re-reading');

  const ReadingStatus(this.label);
  final String label;

  bool get isActive => this == reading || this == rereading;
  bool get isFinished => this == read;

  static ReadingStatus fromName(String? name) => ReadingStatus.values
      .firstWhere((e) => e.name == name, orElse: () => ReadingStatus.unread);

  static ReadingStatus fromLabel(String label) => ReadingStatus.values
      .firstWhere((e) => e.label == label, orElse: () => ReadingStatus.unread);
}

enum Condition {
  newCondition('New'),
  likeNew('Like new'),
  good('Good'),
  acceptable('Acceptable'),
  damaged('Damaged');

  const Condition(this.label);
  final String label;

  static Condition fromName(String? name) =>
      Condition.values.firstWhere((e) => e.name == name, orElse: () => Condition.good);
}

enum Priority {
  high('High'),
  medium('Medium'),
  low('Low');

  const Priority(this.label);
  final String label;

  static Priority fromName(String? name) =>
      Priority.values.firstWhere((e) => e.name == name, orElse: () => Priority.medium);
}

enum PhotoType {
  front('Front'),
  back('Back'),
  spine('Spine'),
  specialEdition('Special edition'),
  damage('Damage'),
  signed('Signed');

  const PhotoType(this.label);
  final String label;

  static PhotoType fromName(String? name) =>
      PhotoType.values.firstWhere((e) => e.name == name, orElse: () => PhotoType.front);
}

/// How the library grid or list is presented. Persisted per user.
enum LibraryView { grid, list }

enum SortOption {
  recentlyAdded('Recently added'),
  title('Title'),
  author('Author'),
  pages('Pages'),
  publicationDate('Publication date'),
  rating('Rating');

  const SortOption(this.label);
  final String label;

  static SortOption fromName(String? name) => SortOption.values
      .firstWhere((e) => e.name == name, orElse: () => SortOption.recentlyAdded);
}

/// The groups a library filter can belong to. Options within a group are
/// OR-ed, groups are AND-ed together.
enum FilterGroup {
  status('Reading status'),
  language('Language'),
  genre('Genre'),
  format('Format'),
  publisher('Publisher'),
  author('Author'),
  series('Series');

  const FilterGroup(this.title);
  final String title;
}

/// A field a scan was able to fill in on a record already in the library.
///
/// Stored as a value rather than a word so the note shown afterwards can be
/// written in whichever language the interface is in.
enum EnrichedField {
  isbn,
  isbn10,
  publisher,
  publicationDate,
  year,
  language,
  format,
  editionName,
  pageCount,
  cover,
  dimensions,
  weight,
  translator,
  country,
  illustrators,
  description,
  originalTitle,
  originalLanguage,
  series,
  seriesNumber,
  firstPublished,
  genre,
}
