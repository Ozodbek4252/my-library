import 'package:flutter/widgets.dart';

import '../domain/models/enums.dart';
import '../l10n/app_localizations.dart';

// A screen that names the type — a helper taking an [AppL10n] rather than a
// context — needs only this one import.
export '../l10n/app_localizations.dart' show AppL10n;

/// `context.l10n` instead of `AppL10n.of(context)` everywhere.
extension L10nContext on BuildContext {
  AppL10n get l10n => AppL10n.of(this);
}

/// Domain values keep a stable `name` for storage and matching, and a constant
/// English `label` for exports; `display` is the one meant for the screen.
/// Keeping them apart is what lets a filter chosen in English still match
/// after the interface is switched to Uzbek, and keeps an exported CSV
/// readable by tools that do not speak the user's language.
extension ReadingStatusL10n on ReadingStatus {
  String display(AppL10n l10n) => switch (this) {
        ReadingStatus.unread => l10n.statusUnread,
        ReadingStatus.reading => l10n.statusReading,
        ReadingStatus.read => l10n.statusRead,
        ReadingStatus.dnf => l10n.statusDnf,
        ReadingStatus.rereading => l10n.statusRereading,
      };
}

extension OwnershipL10n on Ownership {
  String display(AppL10n l10n) => switch (this) {
        Ownership.owned => l10n.ownershipOwned,
        Ownership.wishlist => l10n.ownershipWishlist,
        Ownership.previouslyOwned => l10n.ownershipPreviouslyOwned,
      };
}

extension ConditionL10n on Condition {
  String display(AppL10n l10n) => switch (this) {
        Condition.newCondition => l10n.conditionNew,
        Condition.likeNew => l10n.conditionLikeNew,
        Condition.good => l10n.conditionGood,
        Condition.acceptable => l10n.conditionAcceptable,
        Condition.damaged => l10n.conditionDamaged,
      };
}

extension PriorityL10n on Priority {
  String display(AppL10n l10n) => switch (this) {
        Priority.high => l10n.priorityHigh,
        Priority.medium => l10n.priorityMedium,
        Priority.low => l10n.priorityLow,
      };
}

extension PhotoTypeL10n on PhotoType {
  String display(AppL10n l10n) => switch (this) {
        PhotoType.front => l10n.photoFront,
        PhotoType.back => l10n.photoBack,
        PhotoType.spine => l10n.photoSpine,
        PhotoType.specialEdition => l10n.photoSpecialEdition,
        PhotoType.damage => l10n.photoDamage,
        PhotoType.signed => l10n.photoSigned,
      };
}

extension SortOptionL10n on SortOption {
  String display(AppL10n l10n) => switch (this) {
        SortOption.recentlyAdded => l10n.sortRecentlyAdded,
        SortOption.title => l10n.sortTitleOption,
        SortOption.author => l10n.sortAuthor,
        SortOption.pages => l10n.sortPages,
        SortOption.publicationDate => l10n.sortPublicationDate,
        SortOption.rating => l10n.sortRating,
      };
}

extension FilterGroupL10n on FilterGroup {
  String display(AppL10n l10n) => switch (this) {
        FilterGroup.status => l10n.groupReadingStatus,
        FilterGroup.language => l10n.groupLanguage,
        FilterGroup.genre => l10n.groupGenre,
        FilterGroup.format => l10n.groupFormat,
        FilterGroup.publisher => l10n.groupPublisher,
        FilterGroup.author => l10n.groupAuthor,
        FilterGroup.series => l10n.groupSeries,
      };
}

/// Text that needs both a translation and a value formatted for the locale.
extension L10nFormat on AppL10n {
  /// "George Orwell", "Orwell & Blair", "Orwell & 2 others".
  String authorsOf(List<String> authors) {
    if (authors.isEmpty) return unknownAuthor;
    if (authors.length <= 2) return authors.join(' & ');
    return authorsAndOthers(authors.first, authors.length - 1);
  }

  String ratingOf(double? r) =>
      r == null || r == 0 ? unrated : '★ ${r.toStringAsFixed(1)}';

  /// "3 days" / "today" — how long a read took.
  String daysBetween(DateTime from, DateTime to) {
    final days = to.difference(from).inDays;
    return days <= 0 ? durationToday : durationDays(days);
  }
}

extension EnrichedFieldL10n on EnrichedField {
  String display(AppL10n l10n) => switch (this) {
        EnrichedField.isbn => l10n.enrichIsbn,
        EnrichedField.isbn10 => l10n.enrichIsbn10,
        EnrichedField.publisher => l10n.enrichPublisher,
        EnrichedField.publicationDate => l10n.enrichPublicationDate,
        EnrichedField.year => l10n.enrichYear,
        EnrichedField.language => l10n.enrichLanguage,
        EnrichedField.format => l10n.enrichFormat,
        EnrichedField.editionName => l10n.enrichEditionName,
        EnrichedField.pageCount => l10n.enrichPageCount,
        EnrichedField.cover => l10n.enrichCover,
        EnrichedField.dimensions => l10n.enrichDimensions,
        EnrichedField.weight => l10n.enrichWeight,
        EnrichedField.translator => l10n.enrichTranslator,
        EnrichedField.country => l10n.enrichCountry,
        EnrichedField.illustrators => l10n.enrichIllustrators,
        EnrichedField.description => l10n.enrichDescription,
        EnrichedField.originalTitle => l10n.enrichOriginalTitle,
        EnrichedField.originalLanguage => l10n.enrichOriginalLanguage,
        EnrichedField.series => l10n.enrichSeries,
        EnrichedField.seriesNumber => l10n.enrichSeriesNumber,
        EnrichedField.firstPublished => l10n.enrichFirstPublished,
        EnrichedField.genre => l10n.enrichGenre,
      };
}

extension EnrichedFieldsL10n on List<EnrichedField> {
  /// "Filled in the cover, page count and year" — what a scan topped up on a
  /// record already in the library, said out loud.
  String summary(AppL10n l10n) {
    final names = [for (final field in this) field.display(l10n)];
    if (names.isEmpty) return '';
    if (names.length == 1) return l10n.enrichFilledOne(names.single);
    return l10n.enrichFilledMany(
      names.sublist(0, names.length - 1).join(', '),
      names.last,
    );
  }
}
