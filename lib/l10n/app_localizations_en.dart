// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get appTitle => 'Book Collection';

  @override
  String get navLibrary => 'Library';

  @override
  String get navReading => 'Reading';

  @override
  String get navScan => 'Scan';

  @override
  String get navWishlist => 'Wishlist';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDone => 'Done';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get actionBackToLibrary => 'Back to library';

  @override
  String get actionBackToWishlist => 'Back to wishlist';

  @override
  String get actionScanBook => 'Scan a book';

  @override
  String get actionScanBarcode => 'Scan its barcode';

  @override
  String get actionAddManually => 'Add manually';

  @override
  String get actionAddItManually => 'Add it manually';

  @override
  String get actionScanNext => 'Scan next';

  @override
  String get actionOpenBook => 'Open book';

  @override
  String get actionEnterIsbnManually => 'Enter ISBN manually';

  @override
  String get actionKeepIt => 'Keep it';

  @override
  String get actionNotYet => 'Not yet';

  @override
  String get actionShowAll => 'Show all';

  @override
  String get actionAddBook => 'Add a book';

  @override
  String get actionGoToLibrary => 'Go to library';

  @override
  String get onboardingHeadlineFirst => 'Every book you own,';

  @override
  String get onboardingHeadlineSecond => 'in your pocket.';

  @override
  String get onboardingSubhead =>
      'Scan a barcode in the bookstore and know in two seconds whether it\'s already on your shelf.';

  @override
  String get onboardingStart => 'Start my library';

  @override
  String get onboardingScanFirst => 'Scan my first book';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySearchHint => 'Title, author, ISBN…';

  @override
  String get libraryStatTotal => 'Total';

  @override
  String get libraryStatUnread => 'Unread';

  @override
  String get libraryStatReading => 'Reading';

  @override
  String get libraryStatRead => 'Read';

  @override
  String libraryCountLine(int shown, int total, String sort) {
    return '$shown of $total shown · sorted by $sort';
  }

  @override
  String libraryShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shelves',
      one: '1 shelf',
    );
    return '$_temp0';
  }

  @override
  String get libraryEmptyTitle => 'Your shelves are empty';

  @override
  String get libraryEmptyMessage =>
      'Scan the barcode on a book you own — the rest fills itself in.';

  @override
  String get libraryLoading => 'Opening your library…';

  @override
  String get libraryErrorTitle => 'Your library couldn\'t be read';

  @override
  String get libraryErrorMessage =>
      'The local database returned an error. Pull down to try again.';

  @override
  String get libraryNoMatchesTitle => 'No matches';

  @override
  String libraryNoMatchesFor(String query) {
    return 'Nothing in your library for “$query”. It may be a book you don\'t own yet.';
  }

  @override
  String get libraryNoFilterMatches => 'No books match these filters.';

  @override
  String get libraryClearFilters => 'Clear filters';

  @override
  String bookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books',
      one: '1 book',
    );
    return '$_temp0';
  }

  @override
  String shelfCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shelves',
      one: '1 shelf',
    );
    return '$_temp0';
  }

  @override
  String get filterTitle => 'Filter';

  @override
  String filterShowBooks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count books',
      one: 'Show 1 book',
    );
    return '$_temp0';
  }

  @override
  String get filterLoadFailed => 'Filters couldn\'t be loaded.';

  @override
  String get sortTitle => 'Sort by';

  @override
  String get groupReadingStatus => 'Reading status';

  @override
  String get groupLanguage => 'Language';

  @override
  String get groupGenre => 'Genre';

  @override
  String get groupFormat => 'Format';

  @override
  String get groupPublisher => 'Publisher';

  @override
  String get groupAuthor => 'Author';

  @override
  String get groupSeries => 'Series';

  @override
  String get sortRecentlyAdded => 'Recently added';

  @override
  String get sortTitleOption => 'Title';

  @override
  String get sortAuthor => 'Author';

  @override
  String get sortPages => 'Pages';

  @override
  String get sortPublicationDate => 'Publication date';

  @override
  String get sortRating => 'Rating';

  @override
  String get statusUnread => 'Unread';

  @override
  String get statusReading => 'Reading';

  @override
  String get statusRead => 'Read';

  @override
  String get statusDnf => 'DNF';

  @override
  String get statusRereading => 'Re-reading';

  @override
  String get statusRereadBadge => 'Re-read';

  @override
  String get ownershipOwned => 'Owned';

  @override
  String get ownershipWishlist => 'Wishlist';

  @override
  String get ownershipPreviouslyOwned => 'Previously owned';

  @override
  String get conditionNew => 'New';

  @override
  String get conditionLikeNew => 'Like new';

  @override
  String get conditionGood => 'Good';

  @override
  String get conditionAcceptable => 'Acceptable';

  @override
  String get conditionDamaged => 'Damaged';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get photoFront => 'Front';

  @override
  String get photoBack => 'Back';

  @override
  String get photoSpine => 'Spine';

  @override
  String get photoSpecialEdition => 'Special edition';

  @override
  String get photoDamage => 'Damage';

  @override
  String get photoSigned => 'Signed';

  @override
  String get searchTry => 'Try';

  @override
  String get searchRecent => 'Recent';

  @override
  String searchInYourLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in your library',
      one: '1 in your library',
    );
    return '$_temp0';
  }

  @override
  String get searchNotInLibrary => 'Not in your library?';

  @override
  String get searchAllEditions => 'Search all editions';

  @override
  String get searchAllEditionsSection => 'All editions';

  @override
  String get searchFailed => 'The search could not be run.';

  @override
  String searchNoEditionsFound(String query) {
    return 'No editions found for “$query”.';
  }

  @override
  String get searchLookupUnreachable =>
      'We couldn\'t reach the book lookup. Your own library is still fully searchable.';

  @override
  String get searchLookupFailed => 'The lookup failed. Try again in a moment.';

  @override
  String get searchPromoTitle => 'In a bookstore?';

  @override
  String get searchPromoSubtitle => 'Scanning is faster than typing.';

  @override
  String get searchPromoAction => 'Scan';

  @override
  String get scannerTitle => 'Point at the barcode';

  @override
  String get scannerSubtitle => 'Usually on the back cover';

  @override
  String get scannerIsbnTitle => 'Scan the ISBN';

  @override
  String get scannerIsbnSubtitle => 'We\'ll fill in the number for you';

  @override
  String get scannerSearchByTitle => 'Search by title';

  @override
  String get scannerEnterManually => 'Enter manually';

  @override
  String get scannerTypeTheNumber => 'Type the number';

  @override
  String get scannerLookingUp => 'Looking it up…';

  @override
  String get scannerGotIt => 'Got it';

  @override
  String get scannerStartingTitle => 'Starting the camera…';

  @override
  String get scannerStartingMessage => 'One moment.';

  @override
  String get scannerDeniedTitle => 'Camera access is off';

  @override
  String get scannerDeniedMessage =>
      'Scanning needs the camera. Turn it on in Settings, or type the 13 digits printed under the barcode.';

  @override
  String get scannerOpenSettings => 'Open Settings';

  @override
  String get scannerUnsupportedTitle => 'No camera here';

  @override
  String get scannerUnsupportedMessage =>
      'This device cannot scan barcodes. You can still add books by ISBN or by hand.';

  @override
  String get scannerAddByHand => 'Add book by hand';

  @override
  String get scannerFailedTitle => 'The camera didn\'t start';

  @override
  String get scannerFailedMessage =>
      'Something went wrong opening the camera. Try again, or enter the ISBN yourself.';

  @override
  String get isbnSheetTitle => 'Enter ISBN';

  @override
  String get isbnSheetSubtitle =>
      'The 10 or 13 digits printed under the barcode.';

  @override
  String get isbnSheetLookUp => 'Look it up';

  @override
  String get isbnSheetUseNumber => 'Use this number';

  @override
  String get isbnSheetAddWithout => 'Add without an ISBN';

  @override
  String get isbnSheetEmpty => 'Enter the number printed under the barcode.';

  @override
  String get isbnSheetInvalid =>
      'That doesn\'t look like a valid ISBN. Check the digits and try again.';

  @override
  String get isbnInvalidToast => 'That ISBN is not valid';

  @override
  String get scanFailBarcodeTitle => 'Couldn\'t read that barcode';

  @override
  String get scanFailBarcodeMessage =>
      'Low light, or the code may be creased. Try again, or type the 13 digits printed under it.';

  @override
  String get scanFailNotFoundTitle => 'We don\'t know that ISBN';

  @override
  String scanFailNotFoundMessage(String isbn) {
    return 'No book matches $isbn. It may be a local printing. You can still add it by hand.';
  }

  @override
  String get scanFailNetworkTitle => 'No connection';

  @override
  String get scanFailNetworkMessage =>
      'We couldn\'t reach the book lookup. Your library still works offline — try again, or enter the details yourself.';

  @override
  String get scanFailUnknownTitle => 'Something went wrong';

  @override
  String get scanFailUnknownMessage =>
      'The lookup failed unexpectedly. Try again, or enter the details yourself.';

  @override
  String get scanFailThatCode => 'that code';

  @override
  String get scanOwnedBanner => 'You already own this book';

  @override
  String get scanNewBanner => 'Not in your library yet';

  @override
  String get scanYourCopies => 'YOUR COPIES';

  @override
  String get scanScannedCopy => 'SCANNED COPY';

  @override
  String scanEditionsOnShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count editions on your shelves',
      one: '1 edition on your shelves',
    );
    return '$_temp0';
  }

  @override
  String get scanAddAnotherCopy => 'Add another copy';

  @override
  String get scanAddAsAnotherEdition => 'Add as another edition';

  @override
  String get scanAddToLibrary => 'Add to library';

  @override
  String get scanAddWithDetails => 'Add with details';

  @override
  String get scanWishlistIt => 'Wishlist it';

  @override
  String get scanAlreadyWishlisted => 'Already wishlisted';

  @override
  String scanWishlistNote(String month) {
    return 'On your wishlist since $month — adding it will clear it from there.';
  }

  @override
  String scanEnrichedNote(String summary) {
    return '$summary from this scan. Nothing you had already entered was changed.';
  }

  @override
  String get scanEditionMissing => 'Edition details missing';

  @override
  String scanCopiesSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copies',
    );
    return '$_temp0';
  }

  @override
  String get toastAddedToLibrary => 'Added to your library';

  @override
  String get toastEditionAdded => 'Edition added to your library';

  @override
  String get toastAnotherCopyAdded => 'Another copy added to your library';

  @override
  String get toastAddedClearedWishlist =>
      'Added to your library · cleared from wishlist';

  @override
  String get toastAddedToWishlist => 'Added to your wishlist';

  @override
  String get toastChangesSaved => 'Changes saved';

  @override
  String get toastCopyUpdated => 'Copy updated';

  @override
  String get toastCopyRemoved => 'Copy removed';

  @override
  String get toastRemovedFromLibrary => 'Removed from your library';

  @override
  String toastCopyRemovedEditionsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copy removed · $count editions left',
      one: 'Copy removed · 1 edition left',
    );
    return '$_temp0';
  }

  @override
  String get toastMovedToLibrary => 'Moved to your library';

  @override
  String get toastRemovedFromWishlist => 'Removed from your wishlist';

  @override
  String get toastProgressSaved => 'Progress saved';

  @override
  String toastFinished(String year) {
    return 'Finished · added to $year history';
  }

  @override
  String toastMarkedAs(String status) {
    return 'Marked as $status';
  }

  @override
  String get toastMainEditionUpdated => 'Main edition updated';

  @override
  String get toastCopyAdded => 'Copy added to your library';

  @override
  String get toastPhotoAdded => 'Photo added';

  @override
  String get toastPhotoRemoved => 'Photo removed';

  @override
  String get toastTitleRequired => 'A title is required';

  @override
  String get toastCouldNotSave => 'Couldn\'t save this book';

  @override
  String get toastCouldNotAdd => 'Couldn\'t add this book';

  @override
  String get toastCouldNotWishlist => 'Couldn\'t add to your wishlist';

  @override
  String get toastCouldNotOpenPhotos => 'Couldn\'t open the photo library';

  @override
  String get toastCouldNotOpenCamera => 'Couldn\'t open the camera';

  @override
  String get toastCouldNotOpenPictures => 'Couldn\'t open your pictures';

  @override
  String get toastCouldNotOpenCropper => 'Couldn\'t open the cropper';

  @override
  String toastFilledFromIsbn(String title) {
    return 'Filled in from $title';
  }

  @override
  String get toastIsbnNotFound =>
      'We don\'t know that ISBN — fill it in yourself';

  @override
  String get toastIsbnOffline => 'No connection — fill it in yourself';

  @override
  String get toastIsbnLookupFailed => 'Lookup failed — fill it in yourself';

  @override
  String get toastSampleRestored => 'Sample library restored';

  @override
  String toastExported(String file) {
    return 'Exported $file';
  }

  @override
  String get toastExportFailed => 'Export failed — couldn\'t write the file';

  @override
  String get addBookTitle => 'Add book';

  @override
  String get addEditionTitle => 'Add edition';

  @override
  String get editBookTitle => 'Edit book';

  @override
  String get editCopyTitle => 'Edit copy';

  @override
  String get editCopyNotFoundTitle => 'Copy not found';

  @override
  String get editCopyNotFoundMessage =>
      'This copy is no longer in your library.';

  @override
  String get sectionTheBook => 'The book';

  @override
  String get sectionThisEdition => 'This edition';

  @override
  String get sectionStatus => 'Status';

  @override
  String get sectionRating => 'Rating';

  @override
  String get sectionOwnership => 'Ownership';

  @override
  String get sectionPurchase => 'Purchase';

  @override
  String get sectionCondition => 'Condition';

  @override
  String get sectionLocation => 'Location';

  @override
  String get sectionTags => 'Tags';

  @override
  String get sectionPersonalNotes => 'Personal notes';

  @override
  String get sectionEditionYouOwn => 'The edition you own';

  @override
  String get sectionMyCopy => 'My copy';

  @override
  String get sectionPersonalNote => 'Personal note';

  @override
  String get sectionPhotosOfMyCopy => 'Photos of my copy';

  @override
  String get sectionWhatIWant => 'What I want';

  @override
  String get sectionNote => 'Note';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldAuthor => 'Author';

  @override
  String get fieldOriginalTitle => 'Original title';

  @override
  String get fieldOriginalLanguage => 'Original language';

  @override
  String get fieldGenre => 'Genre';

  @override
  String get fieldSeries => 'Series';

  @override
  String get fieldFirstPublished => 'First published';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldIsbn10 => 'ISBN-10';

  @override
  String get fieldLanguage => 'Language';

  @override
  String get fieldPublisher => 'Publisher';

  @override
  String get fieldEdition => 'Edition';

  @override
  String get fieldFormat => 'Format';

  @override
  String get fieldPublished => 'Published';

  @override
  String get fieldPages => 'Pages';

  @override
  String get fieldCountry => 'Country';

  @override
  String get fieldTranslator => 'Translator';

  @override
  String get fieldIllustrators => 'Illustrators';

  @override
  String get fieldDimensions => 'Dimensions';

  @override
  String get fieldWeight => 'Weight';

  @override
  String weightGrams(int grams) {
    return '$grams g';
  }

  @override
  String get fieldPurchased => 'Purchased';

  @override
  String get fieldPrice => 'Price';

  @override
  String get fieldWhere => 'Where';

  @override
  String get fieldStore => 'Store';

  @override
  String get fieldGift => 'Gift';

  @override
  String get fieldGiftFrom => 'Gift from';

  @override
  String get fieldCurrency => 'Currency';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldAdded => 'Added';

  @override
  String get fieldPriority => 'Priority';

  @override
  String get fieldCover => 'Cover';

  @override
  String get hintRequired => 'Required';

  @override
  String get hintAuthors => 'Separate several with a comma';

  @override
  String get hintGenres => 'Fiction, History…';

  @override
  String get hintFormats => 'Paperback, Hardcover…';

  @override
  String get hintIsbn => '978…';

  @override
  String get hintNotRecorded => 'Not recorded';

  @override
  String get hintChoose => 'Choose';

  @override
  String get hintWhereBought => 'Where you bought it';

  @override
  String get hintBlankIfPurchased => 'Leave blank if purchased';

  @override
  String get hintTags => 'dystopia, re-read';

  @override
  String get hintNotes => 'Anything worth remembering about this copy…';

  @override
  String get hintLocation => 'Home › Bedroom › Bookshelf 2 › Shelf 4';

  @override
  String get coverSheetTitle => 'Cover';

  @override
  String get coverSheetSubtitle =>
      'Photograph the book, or pick a picture you already have. You frame it next — drag any edge, or start from the 2:3 a cover is shown at.';

  @override
  String get coverTakePhoto => 'Take a photo';

  @override
  String get coverChoosePicture => 'Choose a picture';

  @override
  String get coverAdjustCrop => 'Adjust the crop';

  @override
  String get coverRemove => 'Remove cover';

  @override
  String get coverCropTitle => 'Frame the cover';

  @override
  String get coverCropUse => 'Use';

  @override
  String get addFillFromIsbn => 'Fill in from ISBN';

  @override
  String get addLookingUp => 'Looking up…';

  @override
  String get addScanHint =>
      'Tap the cover to photograph the book. Scanning fills every field below automatically.';

  @override
  String get addScanInstead => 'Scan instead →';

  @override
  String get addEditHint =>
      'Tap the cover to photograph this edition. Changes here apply to the book and the edition shown on its details screen; purchase details live on the copy.';

  @override
  String get addSaveChanges => 'Save changes';

  @override
  String get addToWishlist => 'Add to wishlist';

  @override
  String get scanIsbnSemantic => 'Scan the ISBN';

  @override
  String get shareTitle => 'Share this book?';

  @override
  String shareMessage(String isbn) {
    return 'No lookup service knows $isbn. Sending the title, author and edition details you just entered would let the next person scanning this book find it. Your own notes, purchase details and shelves are never sent.';
  }

  @override
  String get shareConfirm => 'Share it';

  @override
  String get shareCancel => 'Keep it to myself';

  @override
  String get shareOffline =>
      'Couldn\'t reach the book database — your book is saved anyway';

  @override
  String get shareRejected => 'The book database wouldn\'t accept it';

  @override
  String get detailsErrorTitle => 'This book couldn\'t be opened';

  @override
  String get detailsErrorMessage =>
      'Something went wrong reading it from your library.';

  @override
  String get detailsRemovedTitle => 'No longer in your library';

  @override
  String get detailsRemovedMessage => 'This book has been removed.';

  @override
  String get detailsNoEdition => 'No edition recorded yet.';

  @override
  String get detailsUpdateProgress => 'Update progress';

  @override
  String detailsPagesOf(int current, int total) {
    return '$current of $total pages';
  }

  @override
  String detailsPageOnly(int current) {
    return 'Page $current';
  }

  @override
  String detailsEditionsOfWork(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count editions of this work',
      one: '1 edition of this work',
    );
    return '$_temp0';
  }

  @override
  String get detailsAddAnotherCopyOrTranslation =>
      'Add another copy or translation';

  @override
  String get detailsMenuEditBook => 'Edit book details';

  @override
  String get detailsMenuAllEditions => 'All editions of this work';

  @override
  String get detailsMenuEditCopy => 'Edit this copy';

  @override
  String get detailsRemoveCopy => 'Remove this copy';

  @override
  String detailsGiftFrom(String name) {
    return 'From $name';
  }

  @override
  String get detailsGiftPurchased => 'Purchased';

  @override
  String get detailsGiftAFriend => 'a friend';

  @override
  String detailsBookNumber(int number) {
    return 'Book $number';
  }

  @override
  String get detailsNotRated => 'Not rated';

  @override
  String get detailsSeriesLabel => 'Series';

  @override
  String get photoSheetTitle => 'Add a photo';

  @override
  String get photoSheetSubtitle =>
      'Photos of your copy are kept separate from the official cover.';

  @override
  String get photoDeleteTitle => 'Delete this photo?';

  @override
  String photoDeleteMessage(String type) {
    return 'The $type photo of your copy will be removed. The book and its details stay.';
  }

  @override
  String get photoDeleteConfirm => 'Delete photo';

  @override
  String get removeCopyTitle => 'Remove this copy?';

  @override
  String removeCopyMessage(String descriptor, String title, String survives) {
    return 'Your $descriptor copy of $title will be deleted, along with its purchase details and photos. $survives';
  }

  @override
  String get removeCopyConfirm => 'Remove copy';

  @override
  String get survivesOtherCopy => 'Your other copy of this edition stays.';

  @override
  String survivesOtherEditions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your other $count editions stay.',
      one: 'Your other edition stays.',
    );
    return '$_temp0';
  }

  @override
  String get survivesNothing =>
      'The book will be removed from your library entirely.';

  @override
  String get editionsExplainerOne =>
      'One work, one copy. Reading status belongs to the work; everything else belongs to the copy.';

  @override
  String editionsExplainerMany(String copies, String editions) {
    return 'One work, $copies across $editions. Reading status belongs to the work; everything else belongs to the copy.';
  }

  @override
  String editionsCopyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copies',
      one: '1 copy',
    );
    return '$_temp0';
  }

  @override
  String editionsEditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count editions',
      one: '1 edition',
    );
    return '$_temp0';
  }

  @override
  String get editionsErrorMessage =>
      'These editions couldn\'t be read from your library.';

  @override
  String get editionsAddAnother => '+ Add another edition';

  @override
  String get editionsReadingCopy => 'Reading copy';

  @override
  String get editionsGiftTag => 'Gift';

  @override
  String get editionsShowAsMain => 'Show as main';

  @override
  String get editionsAddAnotherCopy => 'Add another copy';

  @override
  String get editionsNotOwnedYet => 'Not owned yet';

  @override
  String get editionsUnknownLanguage => 'Unknown language';

  @override
  String editionsFirstPublished(int year) {
    return 'first published $year';
  }

  @override
  String editionsFromPerson(String name) {
    return 'from $name';
  }

  @override
  String get editionsAddCopyTitle => 'Add another copy?';

  @override
  String editionsAddCopyMessage(String format) {
    return 'A second copy of this $format will be added to your shelves. You can fill in where it came from afterwards.';
  }

  @override
  String get editionsAddCopyConfirm => 'Add copy';

  @override
  String get editionsGenericFormat => 'edition';

  @override
  String editionsPagesShort(int count) {
    return '$count pp';
  }

  @override
  String get readingTitle => 'Reading';

  @override
  String get readingTabNow => 'Currently reading';

  @override
  String get readingTabHistory => 'History';

  @override
  String get readingUpNext => 'Up next · from your shelves';

  @override
  String get readingUpdatePage => 'Update page';

  @override
  String get readingMarkFinished => 'Mark finished';

  @override
  String get readingEmptyTitle => 'Nothing on the go';

  @override
  String get readingEmptyWithShelves =>
      'Pick something from your shelves and set it to Reading.';

  @override
  String get readingEmptyNoShelves =>
      'Add a book to your library, then set it to Reading to track your progress here.';

  @override
  String get readingErrorMessage => 'Your current reads could not be loaded.';

  @override
  String get readingHistoryError => 'Your reading history could not be loaded.';

  @override
  String get readingHistoryEmptyTitle => 'No finished books yet';

  @override
  String get readingHistoryEmptyMessage =>
      'When you mark a book as read it appears here, grouped by the month you finished it.';

  @override
  String readingReadInYear(int year) {
    return 'Read in $year';
  }

  @override
  String get readingPagesLabel => 'Pages';

  @override
  String get readingAvgRating => 'Avg rating';

  @override
  String readingPagesOf(int current, int total) {
    return '$current / $total pages';
  }

  @override
  String get readingPagesRead => 'pages read';

  @override
  String readingStartedOn(String date) {
    return 'Started $date';
  }

  @override
  String get readingNotStarted => 'Not started yet';

  @override
  String readingDaysIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in',
      one: '1 day in',
    );
    return '$_temp0';
  }

  @override
  String get readingToday => 'today';

  @override
  String readingFinishedOn(String date) {
    return 'Finished $date';
  }

  @override
  String progressStarted(String date) {
    return 'Started $date';
  }

  @override
  String progressPagesTotal(int count) {
    return '$count pages';
  }

  @override
  String progressPercentToGo(int percent, int left) {
    return '$percent% · $left pages to go';
  }

  @override
  String get progressNoPageCount =>
      'Add a page count to this edition to track a percentage';

  @override
  String get progressPlusTen => '+10 pages';

  @override
  String get progressSave => 'Save progress';

  @override
  String get progressFinished => 'Finished it';

  @override
  String get progressGone => 'This book is no longer in your library.';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String wishlistHighPriority(int count) {
    return '$count high priority';
  }

  @override
  String wishlistAll(int count) {
    return 'All $count';
  }

  @override
  String get wishlistErrorMessage => 'Your wishlist could not be loaded.';

  @override
  String get wishlistEmptyTitle => 'Nothing on the list yet';

  @override
  String get wishlistEmptyMessage =>
      'Scan a book you want but do not own, and it lands here instead of on your shelves.';

  @override
  String get wishlistNoFilterTitle => 'Nothing matches that';

  @override
  String get wishlistNoFilterMessage => 'Try another filter.';

  @override
  String get wishlistDetailError => 'This wishlist entry could not be loaded.';

  @override
  String get wishlistRemovedTitle => 'No longer on your wishlist';

  @override
  String get wishlistRemovedMessage => 'This entry has been removed.';

  @override
  String get wishlistBadge => 'WISHLIST';

  @override
  String wishlistAddedOn(String date) {
    return 'Added $date';
  }

  @override
  String get wishlistNotePlaceholder =>
      'Tap to add a note about the edition you are after.';

  @override
  String get wishlistBought => 'I bought it — move to library';

  @override
  String get wishlistRemove => 'Remove from wishlist';

  @override
  String get wishlistMoveTitle => 'Move to your library?';

  @override
  String wishlistMoveMessage(String title) {
    return '$title will be added to your shelves as an owned copy and cleared from the wishlist. You can fill in the edition and purchase details next.';
  }

  @override
  String get wishlistMoveConfirm => 'Add to library';

  @override
  String get wishlistRemoveTitle => 'Remove from wishlist?';

  @override
  String wishlistRemoveMessage(String title) {
    return '$title will be taken off your wishlist, along with the edition you wanted and your note. Your library is not affected.';
  }

  @override
  String get wishlistRemoveConfirm => 'Remove from wishlist';

  @override
  String get wishlistDesiredLanguage => 'Desired language';

  @override
  String get wishlistDesiredFormat => 'Desired format';

  @override
  String get wishlistDesiredEdition => 'Desired edition';

  @override
  String get statsThisYear => 'This year';

  @override
  String statsRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statsBooksRead => 'Books read this year';

  @override
  String get statsPagesRead => 'Pages read';

  @override
  String get statsCurrentlyReading => 'Currently reading';

  @override
  String get statsAverageRating => 'Average rating';

  @override
  String get statsBooksPerMonth => 'Books finished per month';

  @override
  String get statsByLanguage => 'By language';

  @override
  String get statsByGenre => 'By genre';

  @override
  String get statsMostReadAuthors => 'Most read authors';

  @override
  String statsBestMonth(String month, String books, String pages) {
    return 'Best month: $month, $books · $pages pages';
  }

  @override
  String get statsNoneYet => 'No finished books yet this year.';

  @override
  String get statsEmptyTitle => 'No finished books yet';

  @override
  String get statsEmptyMessage =>
      'Mark a book as read and these figures start filling in. Nothing here is made up — it all comes from your own shelves.';

  @override
  String get statsError => 'Your statistics could not be calculated.';

  @override
  String get statsOther => 'Other';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileMyLibrary => 'My library';

  @override
  String get profileReadingStatistics => 'Reading statistics';

  @override
  String profileStatsSubtitle(String books, String pages) {
    return '$books this year · $pages pages';
  }

  @override
  String get profileStatsFallback => 'Calculated from your reading log';

  @override
  String get profileGroupLibrary => 'Library';

  @override
  String get profileGroupData => 'Data';

  @override
  String get profileGroupApp => 'App';

  @override
  String get profileShelves => 'Shelves & locations';

  @override
  String get profileCovers => 'Book covers';

  @override
  String get profileCoversWithTitles => 'With titles';

  @override
  String get profileCoversOnly => 'Covers only';

  @override
  String get profileStatsStrip => 'Library stats strip';

  @override
  String get profileShown => 'Shown';

  @override
  String get profileHidden => 'Hidden';

  @override
  String get profileImportExport => 'Import & export';

  @override
  String get profileStorage => 'Storage';

  @override
  String get profileStorageValue => 'On this device';

  @override
  String get profileSampleLibrary => 'Sample library';

  @override
  String get profileSampleReset => 'Reset';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileAppearanceValue => 'Paper';

  @override
  String get profileShowOnboarding => 'Show onboarding again';

  @override
  String get profileVersion => 'Version';

  @override
  String profileFooter(String version) {
    return 'Book Collection $version · your library lives on your device';
  }

  @override
  String get profileShelvesTitle => 'Shelves & locations';

  @override
  String get profileShelvesSubtitle =>
      'Where your copies live. Set a location on any copy from its edit screen.';

  @override
  String get profileShelvesEmpty => 'No locations recorded yet.';

  @override
  String get profileStorageTitle => 'Where your library lives';

  @override
  String get profileStorageBody =>
      'Everything — books, editions, copies, reading history and your wishlist — is stored in a local database on this device. It works with no signal, which is what the bookstore flow needs.\n\nThe only time the app reaches the network is to look up a book you have scanned but do not own. Even then, a bundled catalogue answers first.';

  @override
  String get profileResetTitle => 'Reset to the sample library?';

  @override
  String get profileResetMessage =>
      'Every book, edition, copy, note, photo link, reading entry and wishlist item you have added will be deleted and replaced with the sample collection. This cannot be undone.';

  @override
  String get profileResetConfirm => 'Delete everything and reset';

  @override
  String get profileLanguageTitle => 'Language';

  @override
  String get profileLanguageSubtitle =>
      'Changes the app\'s own words. Your books keep the languages they were written in.';

  @override
  String get importTitle => 'Import & export';

  @override
  String get importIntro => 'Your library is yours. Take it out at any time.';

  @override
  String get importSectionExport => 'Export';

  @override
  String get importSectionImport => 'Import';

  @override
  String get importCsvLabel => 'CSV';

  @override
  String get importCsvSubtitle => 'Every field, one row per copy';

  @override
  String get importJsonLabel => 'JSON';

  @override
  String get importJsonSubtitle =>
      'Full structure — works, editions and copies';

  @override
  String get importPrintableLabel => 'Printable list';

  @override
  String get importPrintableSubtitle => 'A plain list of your shelves';

  @override
  String get importNotBuiltTitle => 'Not built yet';

  @override
  String get importNotBuiltMessage =>
      'Importing from a Goodreads, LibraryThing or CSV file is planned but not implemented. Until then, scanning is the fastest way to fill a shelf — a barcode fills in every field for you.';

  @override
  String get importScanInstead => 'Scan a book instead';

  @override
  String get unknownAuthor => 'Unknown author';

  @override
  String get unrated => 'Unrated';

  @override
  String authorsAndOthers(String first, int count) {
    return '$first & $count others';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get durationToday => 'today';

  @override
  String get locationHint => 'Separate each level with ›';

  @override
  String get locationTapToChange => 'Tap to change it';

  @override
  String get locationNone => 'No location yet';

  @override
  String enrichFilledOne(String field) {
    return 'Filled in the $field';
  }

  @override
  String enrichFilledMany(String head, String last) {
    return 'Filled in the $head and $last';
  }

  @override
  String get enrichIsbn => 'ISBN';

  @override
  String get enrichIsbn10 => 'ISBN-10';

  @override
  String get enrichPublisher => 'publisher';

  @override
  String get enrichPublicationDate => 'publication date';

  @override
  String get enrichYear => 'year';

  @override
  String get enrichLanguage => 'language';

  @override
  String get enrichFormat => 'format';

  @override
  String get enrichEditionName => 'edition name';

  @override
  String get enrichPageCount => 'page count';

  @override
  String get enrichCover => 'cover';

  @override
  String get enrichDimensions => 'dimensions';

  @override
  String get enrichWeight => 'weight';

  @override
  String get enrichTranslator => 'translator';

  @override
  String get enrichCountry => 'country';

  @override
  String get enrichIllustrators => 'illustrators';

  @override
  String get enrichDescription => 'description';

  @override
  String get enrichOriginalTitle => 'original title';

  @override
  String get enrichOriginalLanguage => 'original language';

  @override
  String get enrichSeries => 'series';

  @override
  String get enrichSeriesNumber => 'series number';

  @override
  String get enrichFirstPublished => 'first published';

  @override
  String get enrichGenre => 'genre';
}
