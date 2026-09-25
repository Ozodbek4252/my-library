import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shelf: My Book Library'**
  String get appTitle;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get navReading;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get navWishlist;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @actionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// No description provided for @actionBackToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Back to library'**
  String get actionBackToLibrary;

  /// No description provided for @actionBackToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Back to wishlist'**
  String get actionBackToWishlist;

  /// No description provided for @actionScanBook.
  ///
  /// In en, this message translates to:
  /// **'Scan a book'**
  String get actionScanBook;

  /// No description provided for @actionScanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan its barcode'**
  String get actionScanBarcode;

  /// No description provided for @actionAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get actionAddManually;

  /// No description provided for @actionAddItManually.
  ///
  /// In en, this message translates to:
  /// **'Add it manually'**
  String get actionAddItManually;

  /// No description provided for @actionScanNext.
  ///
  /// In en, this message translates to:
  /// **'Scan next'**
  String get actionScanNext;

  /// No description provided for @actionOpenBook.
  ///
  /// In en, this message translates to:
  /// **'Open book'**
  String get actionOpenBook;

  /// No description provided for @actionEnterIsbnManually.
  ///
  /// In en, this message translates to:
  /// **'Enter ISBN manually'**
  String get actionEnterIsbnManually;

  /// No description provided for @actionKeepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get actionKeepIt;

  /// No description provided for @actionNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get actionNotYet;

  /// No description provided for @actionShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get actionShowAll;

  /// No description provided for @actionAddBook.
  ///
  /// In en, this message translates to:
  /// **'Add a book'**
  String get actionAddBook;

  /// No description provided for @actionGoToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Go to library'**
  String get actionGoToLibrary;

  /// No description provided for @onboardingHeadlineFirst.
  ///
  /// In en, this message translates to:
  /// **'Every book you own,'**
  String get onboardingHeadlineFirst;

  /// No description provided for @onboardingHeadlineSecond.
  ///
  /// In en, this message translates to:
  /// **'in your pocket.'**
  String get onboardingHeadlineSecond;

  /// No description provided for @onboardingSubhead.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode in the bookstore and know in two seconds whether it\'s already on your shelf.'**
  String get onboardingSubhead;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start my library'**
  String get onboardingStart;

  /// No description provided for @onboardingScanFirst.
  ///
  /// In en, this message translates to:
  /// **'Scan my first book'**
  String get onboardingScanFirst;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @librarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Title, author, ISBN…'**
  String get librarySearchHint;

  /// No description provided for @libraryStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get libraryStatTotal;

  /// No description provided for @libraryStatUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get libraryStatUnread;

  /// No description provided for @libraryStatReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get libraryStatReading;

  /// No description provided for @libraryStatRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get libraryStatRead;

  /// No description provided for @libraryCountLine.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total} shown · sorted by {sort}'**
  String libraryCountLine(int shown, int total, String sort);

  /// No description provided for @libraryShelves.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 shelf} other{{count} shelves}}'**
  String libraryShelves(int count);

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your shelves are empty'**
  String get libraryEmptyTitle;

  /// No description provided for @libraryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Scan the barcode on a book you own — the rest fills itself in.'**
  String get libraryEmptyMessage;

  /// No description provided for @libraryLoading.
  ///
  /// In en, this message translates to:
  /// **'Opening your library…'**
  String get libraryLoading;

  /// No description provided for @libraryErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library couldn\'t be read'**
  String get libraryErrorTitle;

  /// No description provided for @libraryErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The local database returned an error. Pull down to try again.'**
  String get libraryErrorMessage;

  /// No description provided for @libraryNoMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get libraryNoMatchesTitle;

  /// No description provided for @libraryNoMatchesFor.
  ///
  /// In en, this message translates to:
  /// **'Nothing in your library for “{query}”. It may be a book you don\'t own yet.'**
  String libraryNoMatchesFor(String query);

  /// No description provided for @libraryNoFilterMatches.
  ///
  /// In en, this message translates to:
  /// **'No books match these filters.'**
  String get libraryNoFilterMatches;

  /// No description provided for @libraryClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get libraryClearFilters;

  /// No description provided for @bookCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book} other{{count} books}}'**
  String bookCount(int count);

  /// No description provided for @shelfCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 shelf} other{{count} shelves}}'**
  String shelfCount(int count);

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterShowBooks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Show 1 book} other{Show {count} books}}'**
  String filterShowBooks(int count);

  /// No description provided for @filterLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Filters couldn\'t be loaded.'**
  String get filterLoadFailed;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortTitle;

  /// No description provided for @groupReadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Reading status'**
  String get groupReadingStatus;

  /// No description provided for @groupLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get groupLanguage;

  /// No description provided for @groupGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get groupGenre;

  /// No description provided for @groupFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get groupFormat;

  /// No description provided for @groupPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get groupPublisher;

  /// No description provided for @groupAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get groupAuthor;

  /// No description provided for @groupSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get groupSeries;

  /// No description provided for @sortRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get sortRecentlyAdded;

  /// No description provided for @sortTitleOption.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortTitleOption;

  /// No description provided for @sortAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get sortAuthor;

  /// No description provided for @sortPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get sortPages;

  /// No description provided for @sortPublicationDate.
  ///
  /// In en, this message translates to:
  /// **'Publication date'**
  String get sortPublicationDate;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortRating;

  /// No description provided for @statusUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get statusUnread;

  /// No description provided for @statusReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get statusReading;

  /// No description provided for @statusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get statusRead;

  /// No description provided for @statusDnf.
  ///
  /// In en, this message translates to:
  /// **'DNF'**
  String get statusDnf;

  /// No description provided for @statusRereading.
  ///
  /// In en, this message translates to:
  /// **'Re-reading'**
  String get statusRereading;

  /// No description provided for @statusRereadBadge.
  ///
  /// In en, this message translates to:
  /// **'Re-read'**
  String get statusRereadBadge;

  /// No description provided for @ownershipOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get ownershipOwned;

  /// No description provided for @ownershipWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get ownershipWishlist;

  /// No description provided for @ownershipPreviouslyOwned.
  ///
  /// In en, this message translates to:
  /// **'Previously owned'**
  String get ownershipPreviouslyOwned;

  /// No description provided for @conditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get conditionNew;

  /// No description provided for @conditionLikeNew.
  ///
  /// In en, this message translates to:
  /// **'Like new'**
  String get conditionLikeNew;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get conditionGood;

  /// No description provided for @conditionAcceptable.
  ///
  /// In en, this message translates to:
  /// **'Acceptable'**
  String get conditionAcceptable;

  /// No description provided for @conditionDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get conditionDamaged;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @photoFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get photoFront;

  /// No description provided for @photoBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get photoBack;

  /// No description provided for @photoSpine.
  ///
  /// In en, this message translates to:
  /// **'Spine'**
  String get photoSpine;

  /// No description provided for @photoSpecialEdition.
  ///
  /// In en, this message translates to:
  /// **'Special edition'**
  String get photoSpecialEdition;

  /// No description provided for @photoDamage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get photoDamage;

  /// No description provided for @photoSigned.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get photoSigned;

  /// No description provided for @searchTry.
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get searchTry;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecent;

  /// No description provided for @searchInYourLibrary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 in your library} other{{count} in your library}}'**
  String searchInYourLibrary(int count);

  /// No description provided for @searchNotInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Not in your library?'**
  String get searchNotInLibrary;

  /// No description provided for @searchAllEditions.
  ///
  /// In en, this message translates to:
  /// **'Search all editions'**
  String get searchAllEditions;

  /// No description provided for @searchAllEditionsSection.
  ///
  /// In en, this message translates to:
  /// **'All editions'**
  String get searchAllEditionsSection;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'The search could not be run.'**
  String get searchFailed;

  /// No description provided for @searchNoEditionsFound.
  ///
  /// In en, this message translates to:
  /// **'No editions found for “{query}”.'**
  String searchNoEditionsFound(String query);

  /// No description provided for @searchLookupUnreachable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach the book lookup. Your own library is still fully searchable.'**
  String get searchLookupUnreachable;

  /// No description provided for @searchLookupFailed.
  ///
  /// In en, this message translates to:
  /// **'The lookup failed. Try again in a moment.'**
  String get searchLookupFailed;

  /// No description provided for @searchPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'In a bookstore?'**
  String get searchPromoTitle;

  /// No description provided for @searchPromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scanning is faster than typing.'**
  String get searchPromoSubtitle;

  /// No description provided for @searchPromoAction.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get searchPromoAction;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Point at the barcode'**
  String get scannerTitle;

  /// No description provided for @scannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Usually on the back cover'**
  String get scannerSubtitle;

  /// No description provided for @scannerIsbnTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the ISBN'**
  String get scannerIsbnTitle;

  /// No description provided for @scannerIsbnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll fill in the number for you'**
  String get scannerIsbnSubtitle;

  /// No description provided for @scannerSearchByTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by title'**
  String get scannerSearchByTitle;

  /// No description provided for @scannerEnterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get scannerEnterManually;

  /// No description provided for @scannerEnterIsbn.
  ///
  /// In en, this message translates to:
  /// **'Enter ISBN'**
  String get scannerEnterIsbn;

  /// No description provided for @scannerLookingUp.
  ///
  /// In en, this message translates to:
  /// **'Looking it up…'**
  String get scannerLookingUp;

  /// No description provided for @scannerGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get scannerGotIt;

  /// No description provided for @scannerStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Starting the camera…'**
  String get scannerStartingTitle;

  /// No description provided for @scannerStartingMessage.
  ///
  /// In en, this message translates to:
  /// **'One moment.'**
  String get scannerStartingMessage;

  /// No description provided for @scannerDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off'**
  String get scannerDeniedTitle;

  /// No description provided for @scannerDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Scanning needs the camera. Turn it on in Settings, or type the 13 digits printed under the barcode.'**
  String get scannerDeniedMessage;

  /// No description provided for @scannerOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get scannerOpenSettings;

  /// No description provided for @scannerUnsupportedTitle.
  ///
  /// In en, this message translates to:
  /// **'No camera here'**
  String get scannerUnsupportedTitle;

  /// No description provided for @scannerUnsupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'This device cannot scan barcodes. You can still add books by ISBN or by hand.'**
  String get scannerUnsupportedMessage;

  /// No description provided for @scannerAddByHand.
  ///
  /// In en, this message translates to:
  /// **'Add book by hand'**
  String get scannerAddByHand;

  /// No description provided for @scannerFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'The camera didn\'t start'**
  String get scannerFailedTitle;

  /// No description provided for @scannerFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong opening the camera. Try again, or enter the ISBN yourself.'**
  String get scannerFailedMessage;

  /// No description provided for @isbnSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter ISBN'**
  String get isbnSheetTitle;

  /// No description provided for @isbnSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The 10 or 13 digits printed under the barcode.'**
  String get isbnSheetSubtitle;

  /// No description provided for @isbnSheetLookUp.
  ///
  /// In en, this message translates to:
  /// **'Look it up'**
  String get isbnSheetLookUp;

  /// No description provided for @isbnSheetUseNumber.
  ///
  /// In en, this message translates to:
  /// **'Use this number'**
  String get isbnSheetUseNumber;

  /// No description provided for @isbnSheetEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter the number printed under the barcode.'**
  String get isbnSheetEmpty;

  /// No description provided for @isbnSheetInvalid.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a valid ISBN. Check the digits and try again.'**
  String get isbnSheetInvalid;

  /// No description provided for @isbnInvalidToast.
  ///
  /// In en, this message translates to:
  /// **'That ISBN is not valid'**
  String get isbnInvalidToast;

  /// No description provided for @scanFailBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read that barcode'**
  String get scanFailBarcodeTitle;

  /// No description provided for @scanFailBarcodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Low light, or the code may be creased. Try again, or type the 13 digits printed under it.'**
  String get scanFailBarcodeMessage;

  /// No description provided for @scanFailNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'We don\'t know that ISBN'**
  String get scanFailNotFoundTitle;

  /// No description provided for @scanFailNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No book matches {isbn}. It may be a local printing. You can still add it by hand.'**
  String scanFailNotFoundMessage(String isbn);

  /// No description provided for @scanFailNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get scanFailNetworkTitle;

  /// No description provided for @scanFailNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach the book lookup. Your library still works offline — try again, or enter the details yourself.'**
  String get scanFailNetworkMessage;

  /// No description provided for @scanFailUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get scanFailUnknownTitle;

  /// No description provided for @scanFailUnknownMessage.
  ///
  /// In en, this message translates to:
  /// **'The lookup failed unexpectedly. Try again, or enter the details yourself.'**
  String get scanFailUnknownMessage;

  /// No description provided for @scanFailThatCode.
  ///
  /// In en, this message translates to:
  /// **'that code'**
  String get scanFailThatCode;

  /// No description provided for @scanOwnedBanner.
  ///
  /// In en, this message translates to:
  /// **'You already own this book'**
  String get scanOwnedBanner;

  /// No description provided for @scanNewBanner.
  ///
  /// In en, this message translates to:
  /// **'Not in your library yet'**
  String get scanNewBanner;

  /// No description provided for @scanYourCopies.
  ///
  /// In en, this message translates to:
  /// **'YOUR COPIES'**
  String get scanYourCopies;

  /// No description provided for @scanScannedCopy.
  ///
  /// In en, this message translates to:
  /// **'SCANNED COPY'**
  String get scanScannedCopy;

  /// No description provided for @scanEditionsOnShelves.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 edition on your shelves} other{{count} editions on your shelves}}'**
  String scanEditionsOnShelves(int count);

  /// No description provided for @scanAddAnotherCopy.
  ///
  /// In en, this message translates to:
  /// **'Add another copy'**
  String get scanAddAnotherCopy;

  /// No description provided for @scanAddAsAnotherEdition.
  ///
  /// In en, this message translates to:
  /// **'Add as another edition'**
  String get scanAddAsAnotherEdition;

  /// No description provided for @scanAddToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get scanAddToLibrary;

  /// No description provided for @scanAddWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Add with details'**
  String get scanAddWithDetails;

  /// No description provided for @scanWishlistIt.
  ///
  /// In en, this message translates to:
  /// **'Wishlist it'**
  String get scanWishlistIt;

  /// No description provided for @scanAlreadyWishlisted.
  ///
  /// In en, this message translates to:
  /// **'Already wishlisted'**
  String get scanAlreadyWishlisted;

  /// No description provided for @scanWishlistNote.
  ///
  /// In en, this message translates to:
  /// **'On your wishlist since {month} — adding it will clear it from there.'**
  String scanWishlistNote(String month);

  /// No description provided for @scanEnrichedNote.
  ///
  /// In en, this message translates to:
  /// **'{summary} from this scan. Nothing you had already entered was changed.'**
  String scanEnrichedNote(String summary);

  /// No description provided for @scanEditionMissing.
  ///
  /// In en, this message translates to:
  /// **'Edition details missing'**
  String get scanEditionMissing;

  /// No description provided for @scanCopiesSuffix.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} copies}}'**
  String scanCopiesSuffix(int count);

  /// No description provided for @toastAddedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Added to your library'**
  String get toastAddedToLibrary;

  /// No description provided for @toastEditionAdded.
  ///
  /// In en, this message translates to:
  /// **'Edition added to your library'**
  String get toastEditionAdded;

  /// No description provided for @toastAnotherCopyAdded.
  ///
  /// In en, this message translates to:
  /// **'Another copy added to your library'**
  String get toastAnotherCopyAdded;

  /// No description provided for @toastAddedClearedWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to your library · cleared from wishlist'**
  String get toastAddedClearedWishlist;

  /// No description provided for @toastAddedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to your wishlist'**
  String get toastAddedToWishlist;

  /// No description provided for @toastChangesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get toastChangesSaved;

  /// No description provided for @toastCopyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Copy updated'**
  String get toastCopyUpdated;

  /// No description provided for @toastCopyRemoved.
  ///
  /// In en, this message translates to:
  /// **'Copy removed'**
  String get toastCopyRemoved;

  /// No description provided for @toastRemovedFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Removed from your library'**
  String get toastRemovedFromLibrary;

  /// No description provided for @toastCopyRemovedEditionsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Copy removed · 1 edition left} other{Copy removed · {count} editions left}}'**
  String toastCopyRemovedEditionsLeft(int count);

  /// No description provided for @toastMovedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Moved to your library'**
  String get toastMovedToLibrary;

  /// No description provided for @toastRemovedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from your wishlist'**
  String get toastRemovedFromWishlist;

  /// No description provided for @toastProgressSaved.
  ///
  /// In en, this message translates to:
  /// **'Progress saved'**
  String get toastProgressSaved;

  /// No description provided for @toastFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished · added to {year} history'**
  String toastFinished(String year);

  /// No description provided for @toastMarkedAs.
  ///
  /// In en, this message translates to:
  /// **'Marked as {status}'**
  String toastMarkedAs(String status);

  /// No description provided for @toastMainEditionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Main edition updated'**
  String get toastMainEditionUpdated;

  /// No description provided for @toastCopyAdded.
  ///
  /// In en, this message translates to:
  /// **'Copy added to your library'**
  String get toastCopyAdded;

  /// No description provided for @toastPhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get toastPhotoAdded;

  /// No description provided for @toastPhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get toastPhotoRemoved;

  /// No description provided for @toastTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'A title is required'**
  String get toastTitleRequired;

  /// No description provided for @toastCouldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save this book'**
  String get toastCouldNotSave;

  /// No description provided for @toastCouldNotAdd.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add this book'**
  String get toastCouldNotAdd;

  /// No description provided for @toastCouldNotWishlist.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add to your wishlist'**
  String get toastCouldNotWishlist;

  /// No description provided for @toastCouldNotOpenPhotos.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the photo library'**
  String get toastCouldNotOpenPhotos;

  /// No description provided for @toastCouldNotOpenCamera.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera'**
  String get toastCouldNotOpenCamera;

  /// No description provided for @toastCouldNotOpenPictures.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your pictures'**
  String get toastCouldNotOpenPictures;

  /// No description provided for @toastCouldNotOpenCropper.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the cropper'**
  String get toastCouldNotOpenCropper;

  /// No description provided for @toastFilledFromIsbn.
  ///
  /// In en, this message translates to:
  /// **'Filled in from {title}'**
  String toastFilledFromIsbn(String title);

  /// No description provided for @toastIsbnNotFound.
  ///
  /// In en, this message translates to:
  /// **'We don\'t know that ISBN — fill it in yourself'**
  String get toastIsbnNotFound;

  /// No description provided for @toastIsbnOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection — fill it in yourself'**
  String get toastIsbnOffline;

  /// No description provided for @toastIsbnLookupFailed.
  ///
  /// In en, this message translates to:
  /// **'Lookup failed — fill it in yourself'**
  String get toastIsbnLookupFailed;

  /// No description provided for @toastSampleRestored.
  ///
  /// In en, this message translates to:
  /// **'Sample library restored'**
  String get toastSampleRestored;

  /// No description provided for @toastExported.
  ///
  /// In en, this message translates to:
  /// **'Exported {file}'**
  String toastExported(String file);

  /// No description provided for @toastExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed — couldn\'t write the file'**
  String get toastExportFailed;

  /// No description provided for @addBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Add book'**
  String get addBookTitle;

  /// No description provided for @addEditionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add edition'**
  String get addEditionTitle;

  /// No description provided for @editBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit book'**
  String get editBookTitle;

  /// No description provided for @editCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit copy'**
  String get editCopyTitle;

  /// No description provided for @editCopyNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy not found'**
  String get editCopyNotFoundTitle;

  /// No description provided for @editCopyNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This copy is no longer in your library.'**
  String get editCopyNotFoundMessage;

  /// No description provided for @sectionTheBook.
  ///
  /// In en, this message translates to:
  /// **'The book'**
  String get sectionTheBook;

  /// No description provided for @sectionThisEdition.
  ///
  /// In en, this message translates to:
  /// **'This edition'**
  String get sectionThisEdition;

  /// No description provided for @sectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sectionStatus;

  /// No description provided for @sectionRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sectionRating;

  /// No description provided for @sectionOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get sectionOwnership;

  /// No description provided for @sectionPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get sectionPurchase;

  /// No description provided for @sectionCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get sectionCondition;

  /// No description provided for @sectionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sectionLocation;

  /// No description provided for @sectionTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get sectionTags;

  /// No description provided for @sectionPersonalNotes.
  ///
  /// In en, this message translates to:
  /// **'Personal notes'**
  String get sectionPersonalNotes;

  /// No description provided for @sectionEditionYouOwn.
  ///
  /// In en, this message translates to:
  /// **'The edition you own'**
  String get sectionEditionYouOwn;

  /// No description provided for @sectionMyCopy.
  ///
  /// In en, this message translates to:
  /// **'My copy'**
  String get sectionMyCopy;

  /// No description provided for @sectionPersonalNote.
  ///
  /// In en, this message translates to:
  /// **'Personal note'**
  String get sectionPersonalNote;

  /// No description provided for @sectionPhotosOfMyCopy.
  ///
  /// In en, this message translates to:
  /// **'Photos of my copy'**
  String get sectionPhotosOfMyCopy;

  /// No description provided for @sectionWhatIWant.
  ///
  /// In en, this message translates to:
  /// **'What I want'**
  String get sectionWhatIWant;

  /// No description provided for @sectionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get sectionNote;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get fieldAuthor;

  /// No description provided for @fieldOriginalTitle.
  ///
  /// In en, this message translates to:
  /// **'Original title'**
  String get fieldOriginalTitle;

  /// No description provided for @fieldOriginalLanguage.
  ///
  /// In en, this message translates to:
  /// **'Original language'**
  String get fieldOriginalLanguage;

  /// No description provided for @fieldGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get fieldGenre;

  /// No description provided for @fieldSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get fieldSeries;

  /// No description provided for @fieldFirstPublished.
  ///
  /// In en, this message translates to:
  /// **'First published'**
  String get fieldFirstPublished;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @fieldIsbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get fieldIsbn;

  /// No description provided for @fieldIsbn10.
  ///
  /// In en, this message translates to:
  /// **'ISBN-10'**
  String get fieldIsbn10;

  /// No description provided for @fieldLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get fieldLanguage;

  /// No description provided for @fieldPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get fieldPublisher;

  /// No description provided for @fieldEdition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get fieldEdition;

  /// No description provided for @fieldFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get fieldFormat;

  /// No description provided for @fieldPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get fieldPublished;

  /// No description provided for @fieldPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get fieldPages;

  /// No description provided for @fieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get fieldCountry;

  /// No description provided for @fieldTranslator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get fieldTranslator;

  /// No description provided for @fieldIllustrators.
  ///
  /// In en, this message translates to:
  /// **'Illustrators'**
  String get fieldIllustrators;

  /// No description provided for @fieldDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get fieldDimensions;

  /// No description provided for @fieldWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get fieldWeight;

  /// No description provided for @weightGrams.
  ///
  /// In en, this message translates to:
  /// **'{grams} g'**
  String weightGrams(int grams);

  /// No description provided for @fieldPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get fieldPurchased;

  /// No description provided for @fieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get fieldPrice;

  /// No description provided for @fieldWhere.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get fieldWhere;

  /// No description provided for @fieldStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get fieldStore;

  /// No description provided for @fieldGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get fieldGift;

  /// No description provided for @fieldGiftFrom.
  ///
  /// In en, this message translates to:
  /// **'Gift from'**
  String get fieldGiftFrom;

  /// No description provided for @fieldCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get fieldCurrency;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get fieldAdded;

  /// No description provided for @fieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get fieldPriority;

  /// No description provided for @fieldCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get fieldCover;

  /// No description provided for @hintRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get hintRequired;

  /// No description provided for @hintAuthors.
  ///
  /// In en, this message translates to:
  /// **'Separate several with a comma'**
  String get hintAuthors;

  /// No description provided for @hintGenres.
  ///
  /// In en, this message translates to:
  /// **'Fiction, History…'**
  String get hintGenres;

  /// No description provided for @hintFormats.
  ///
  /// In en, this message translates to:
  /// **'Paperback, Hardcover…'**
  String get hintFormats;

  /// No description provided for @hintIsbn.
  ///
  /// In en, this message translates to:
  /// **'978…'**
  String get hintIsbn;

  /// No description provided for @hintNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get hintNotRecorded;

  /// No description provided for @hintChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get hintChoose;

  /// No description provided for @hintWhereBought.
  ///
  /// In en, this message translates to:
  /// **'Where you bought it'**
  String get hintWhereBought;

  /// No description provided for @hintBlankIfPurchased.
  ///
  /// In en, this message translates to:
  /// **'Leave blank if purchased'**
  String get hintBlankIfPurchased;

  /// No description provided for @hintTags.
  ///
  /// In en, this message translates to:
  /// **'dystopia, re-read'**
  String get hintTags;

  /// No description provided for @hintNotes.
  ///
  /// In en, this message translates to:
  /// **'Anything worth remembering about this copy…'**
  String get hintNotes;

  /// No description provided for @hintLocation.
  ///
  /// In en, this message translates to:
  /// **'Home › Bedroom › Bookshelf 2 › Shelf 4'**
  String get hintLocation;

  /// No description provided for @coverSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get coverSheetTitle;

  /// No description provided for @coverSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photograph the book, or pick a picture you already have. You frame it next — drag any edge, or start from the 2:3 a cover is shown at.'**
  String get coverSheetSubtitle;

  /// No description provided for @coverTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get coverTakePhoto;

  /// No description provided for @coverChoosePicture.
  ///
  /// In en, this message translates to:
  /// **'Choose a picture'**
  String get coverChoosePicture;

  /// No description provided for @coverAdjustCrop.
  ///
  /// In en, this message translates to:
  /// **'Adjust the crop'**
  String get coverAdjustCrop;

  /// No description provided for @coverRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove cover'**
  String get coverRemove;

  /// No description provided for @coverCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Frame the cover'**
  String get coverCropTitle;

  /// No description provided for @coverCropUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get coverCropUse;

  /// No description provided for @addFillFromIsbn.
  ///
  /// In en, this message translates to:
  /// **'Fill in from ISBN'**
  String get addFillFromIsbn;

  /// No description provided for @addLookingUp.
  ///
  /// In en, this message translates to:
  /// **'Looking up…'**
  String get addLookingUp;

  /// No description provided for @addScanHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the cover to photograph the book. Scanning fills every field below automatically.'**
  String get addScanHint;

  /// No description provided for @addScanInstead.
  ///
  /// In en, this message translates to:
  /// **'Scan instead →'**
  String get addScanInstead;

  /// No description provided for @addEditHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the cover to photograph this edition. Changes here apply to the book and the edition shown on its details screen; purchase details live on the copy.'**
  String get addEditHint;

  /// No description provided for @addSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get addSaveChanges;

  /// No description provided for @addToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get addToWishlist;

  /// No description provided for @scanIsbnSemantic.
  ///
  /// In en, this message translates to:
  /// **'Scan the ISBN'**
  String get scanIsbnSemantic;

  /// No description provided for @detailsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'This book couldn\'t be opened'**
  String get detailsErrorTitle;

  /// No description provided for @detailsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong reading it from your library.'**
  String get detailsErrorMessage;

  /// No description provided for @detailsRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'No longer in your library'**
  String get detailsRemovedTitle;

  /// No description provided for @detailsRemovedMessage.
  ///
  /// In en, this message translates to:
  /// **'This book has been removed.'**
  String get detailsRemovedMessage;

  /// No description provided for @detailsNoEdition.
  ///
  /// In en, this message translates to:
  /// **'No edition recorded yet.'**
  String get detailsNoEdition;

  /// No description provided for @detailsUpdateProgress.
  ///
  /// In en, this message translates to:
  /// **'Update progress'**
  String get detailsUpdateProgress;

  /// No description provided for @detailsPagesOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} pages'**
  String detailsPagesOf(int current, int total);

  /// No description provided for @detailsPageOnly.
  ///
  /// In en, this message translates to:
  /// **'Page {current}'**
  String detailsPageOnly(int current);

  /// No description provided for @detailsEditionsOfWork.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 edition of this work} other{{count} editions of this work}}'**
  String detailsEditionsOfWork(int count);

  /// No description provided for @detailsAddAnotherCopyOrTranslation.
  ///
  /// In en, this message translates to:
  /// **'Add another copy or translation'**
  String get detailsAddAnotherCopyOrTranslation;

  /// No description provided for @detailsMenuEditBook.
  ///
  /// In en, this message translates to:
  /// **'Edit book details'**
  String get detailsMenuEditBook;

  /// No description provided for @detailsMenuAllEditions.
  ///
  /// In en, this message translates to:
  /// **'All editions of this work'**
  String get detailsMenuAllEditions;

  /// No description provided for @detailsMenuEditCopy.
  ///
  /// In en, this message translates to:
  /// **'Edit this copy'**
  String get detailsMenuEditCopy;

  /// No description provided for @detailsRemoveCopy.
  ///
  /// In en, this message translates to:
  /// **'Remove this copy'**
  String get detailsRemoveCopy;

  /// No description provided for @detailsGiftFrom.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String detailsGiftFrom(String name);

  /// No description provided for @detailsGiftPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get detailsGiftPurchased;

  /// No description provided for @detailsGiftAFriend.
  ///
  /// In en, this message translates to:
  /// **'a friend'**
  String get detailsGiftAFriend;

  /// No description provided for @detailsBookNumber.
  ///
  /// In en, this message translates to:
  /// **'Book {number}'**
  String detailsBookNumber(int number);

  /// No description provided for @detailsNotRated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get detailsNotRated;

  /// No description provided for @detailsSeriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get detailsSeriesLabel;

  /// No description provided for @photoSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get photoSheetTitle;

  /// No description provided for @photoSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photos of your copy are kept separate from the official cover.'**
  String get photoSheetSubtitle;

  /// No description provided for @photoDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get photoDeleteTitle;

  /// No description provided for @photoDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'The {type} photo of your copy will be removed. The book and its details stay.'**
  String photoDeleteMessage(String type);

  /// No description provided for @photoDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get photoDeleteConfirm;

  /// No description provided for @removeCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this copy?'**
  String get removeCopyTitle;

  /// No description provided for @removeCopyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your {descriptor} copy of {title} will be deleted, along with its purchase details and photos. {survives}'**
  String removeCopyMessage(String descriptor, String title, String survives);

  /// No description provided for @removeCopyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove copy'**
  String get removeCopyConfirm;

  /// No description provided for @survivesOtherCopy.
  ///
  /// In en, this message translates to:
  /// **'Your other copy of this edition stays.'**
  String get survivesOtherCopy;

  /// No description provided for @survivesOtherEditions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your other edition stays.} other{Your other {count} editions stay.}}'**
  String survivesOtherEditions(int count);

  /// No description provided for @survivesNothing.
  ///
  /// In en, this message translates to:
  /// **'The book will be removed from your library entirely.'**
  String get survivesNothing;

  /// No description provided for @editionsExplainerOne.
  ///
  /// In en, this message translates to:
  /// **'One work, one copy. Reading status belongs to the work; everything else belongs to the copy.'**
  String get editionsExplainerOne;

  /// No description provided for @editionsExplainerMany.
  ///
  /// In en, this message translates to:
  /// **'One work, {copies} across {editions}. Reading status belongs to the work; everything else belongs to the copy.'**
  String editionsExplainerMany(String copies, String editions);

  /// No description provided for @editionsCopyCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 copy} other{{count} copies}}'**
  String editionsCopyCount(int count);

  /// No description provided for @editionsEditionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 edition} other{{count} editions}}'**
  String editionsEditionCount(int count);

  /// No description provided for @editionsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'These editions couldn\'t be read from your library.'**
  String get editionsErrorMessage;

  /// No description provided for @editionsAddAnother.
  ///
  /// In en, this message translates to:
  /// **'+ Add another edition'**
  String get editionsAddAnother;

  /// No description provided for @editionsReadingCopy.
  ///
  /// In en, this message translates to:
  /// **'Reading copy'**
  String get editionsReadingCopy;

  /// No description provided for @editionsGiftTag.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get editionsGiftTag;

  /// No description provided for @editionsShowAsMain.
  ///
  /// In en, this message translates to:
  /// **'Show as main'**
  String get editionsShowAsMain;

  /// No description provided for @editionsAddAnotherCopy.
  ///
  /// In en, this message translates to:
  /// **'Add another copy'**
  String get editionsAddAnotherCopy;

  /// No description provided for @editionsNotOwnedYet.
  ///
  /// In en, this message translates to:
  /// **'Not owned yet'**
  String get editionsNotOwnedYet;

  /// No description provided for @editionsUnknownLanguage.
  ///
  /// In en, this message translates to:
  /// **'Unknown language'**
  String get editionsUnknownLanguage;

  /// No description provided for @editionsFirstPublished.
  ///
  /// In en, this message translates to:
  /// **'first published {year}'**
  String editionsFirstPublished(int year);

  /// No description provided for @editionsFromPerson.
  ///
  /// In en, this message translates to:
  /// **'from {name}'**
  String editionsFromPerson(String name);

  /// No description provided for @editionsAddCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add another copy?'**
  String get editionsAddCopyTitle;

  /// No description provided for @editionsAddCopyMessage.
  ///
  /// In en, this message translates to:
  /// **'A second copy of this {format} will be added to your shelves. You can fill in where it came from afterwards.'**
  String editionsAddCopyMessage(String format);

  /// No description provided for @editionsAddCopyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add copy'**
  String get editionsAddCopyConfirm;

  /// No description provided for @editionsGenericFormat.
  ///
  /// In en, this message translates to:
  /// **'edition'**
  String get editionsGenericFormat;

  /// No description provided for @editionsPagesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} pp'**
  String editionsPagesShort(int count);

  /// No description provided for @readingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get readingTitle;

  /// No description provided for @readingTabNow.
  ///
  /// In en, this message translates to:
  /// **'Currently reading'**
  String get readingTabNow;

  /// No description provided for @readingTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get readingTabHistory;

  /// No description provided for @readingUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up next · from your shelves'**
  String get readingUpNext;

  /// No description provided for @readingUpdatePage.
  ///
  /// In en, this message translates to:
  /// **'Update page'**
  String get readingUpdatePage;

  /// No description provided for @readingMarkFinished.
  ///
  /// In en, this message translates to:
  /// **'Mark finished'**
  String get readingMarkFinished;

  /// No description provided for @readingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the go'**
  String get readingEmptyTitle;

  /// No description provided for @readingEmptyWithShelves.
  ///
  /// In en, this message translates to:
  /// **'Pick something from your shelves and set it to Reading.'**
  String get readingEmptyWithShelves;

  /// No description provided for @readingEmptyNoShelves.
  ///
  /// In en, this message translates to:
  /// **'Add a book to your library, then set it to Reading to track your progress here.'**
  String get readingEmptyNoShelves;

  /// No description provided for @readingErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your current reads could not be loaded.'**
  String get readingErrorMessage;

  /// No description provided for @readingHistoryError.
  ///
  /// In en, this message translates to:
  /// **'Your reading history could not be loaded.'**
  String get readingHistoryError;

  /// No description provided for @readingHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No finished books yet'**
  String get readingHistoryEmptyTitle;

  /// No description provided for @readingHistoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'When you mark a book as read it appears here, grouped by the month you finished it.'**
  String get readingHistoryEmptyMessage;

  /// No description provided for @readingReadInYear.
  ///
  /// In en, this message translates to:
  /// **'Read in {year}'**
  String readingReadInYear(int year);

  /// No description provided for @readingPagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get readingPagesLabel;

  /// No description provided for @readingAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg rating'**
  String get readingAvgRating;

  /// No description provided for @readingPagesOf.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} pages'**
  String readingPagesOf(int current, int total);

  /// No description provided for @readingPagesRead.
  ///
  /// In en, this message translates to:
  /// **'pages read'**
  String get readingPagesRead;

  /// No description provided for @readingStartedOn.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String readingStartedOn(String date);

  /// No description provided for @readingNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started yet'**
  String get readingNotStarted;

  /// No description provided for @readingDaysIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day in} other{{count} days in}}'**
  String readingDaysIn(int count);

  /// No description provided for @readingToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get readingToday;

  /// No description provided for @readingFinishedOn.
  ///
  /// In en, this message translates to:
  /// **'Finished {date}'**
  String readingFinishedOn(String date);

  /// No description provided for @progressStarted.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String progressStarted(String date);

  /// No description provided for @progressPagesTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String progressPagesTotal(int count);

  /// No description provided for @progressPercentToGo.
  ///
  /// In en, this message translates to:
  /// **'{percent}% · {left} pages to go'**
  String progressPercentToGo(int percent, int left);

  /// No description provided for @progressNoPageCount.
  ///
  /// In en, this message translates to:
  /// **'Add a page count to this edition to track a percentage'**
  String get progressNoPageCount;

  /// No description provided for @progressPlusTen.
  ///
  /// In en, this message translates to:
  /// **'+10 pages'**
  String get progressPlusTen;

  /// No description provided for @progressSave.
  ///
  /// In en, this message translates to:
  /// **'Save progress'**
  String get progressSave;

  /// No description provided for @progressFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished it'**
  String get progressFinished;

  /// No description provided for @progressGone.
  ///
  /// In en, this message translates to:
  /// **'This book is no longer in your library.'**
  String get progressGone;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistHighPriority.
  ///
  /// In en, this message translates to:
  /// **'{count} high priority'**
  String wishlistHighPriority(int count);

  /// No description provided for @wishlistAll.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String wishlistAll(int count);

  /// No description provided for @wishlistErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist could not be loaded.'**
  String get wishlistErrorMessage;

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the list yet'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Scan a book you want but do not own, and it lands here instead of on your shelves.'**
  String get wishlistEmptyMessage;

  /// No description provided for @wishlistNoFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches that'**
  String get wishlistNoFilterTitle;

  /// No description provided for @wishlistNoFilterMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another filter.'**
  String get wishlistNoFilterMessage;

  /// No description provided for @wishlistDetailError.
  ///
  /// In en, this message translates to:
  /// **'This wishlist entry could not be loaded.'**
  String get wishlistDetailError;

  /// No description provided for @wishlistRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'No longer on your wishlist'**
  String get wishlistRemovedTitle;

  /// No description provided for @wishlistRemovedMessage.
  ///
  /// In en, this message translates to:
  /// **'This entry has been removed.'**
  String get wishlistRemovedMessage;

  /// No description provided for @wishlistBadge.
  ///
  /// In en, this message translates to:
  /// **'WISHLIST'**
  String get wishlistBadge;

  /// No description provided for @wishlistAddedOn.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String wishlistAddedOn(String date);

  /// No description provided for @wishlistNotePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a note about the edition you are after.'**
  String get wishlistNotePlaceholder;

  /// No description provided for @wishlistBought.
  ///
  /// In en, this message translates to:
  /// **'I bought it — move to library'**
  String get wishlistBought;

  /// No description provided for @wishlistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get wishlistRemove;

  /// No description provided for @wishlistMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to your library?'**
  String get wishlistMoveTitle;

  /// No description provided for @wishlistMoveMessage.
  ///
  /// In en, this message translates to:
  /// **'{title} will be added to your shelves as an owned copy and cleared from the wishlist. You can fill in the edition and purchase details next.'**
  String wishlistMoveMessage(String title);

  /// No description provided for @wishlistMoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get wishlistMoveConfirm;

  /// No description provided for @wishlistRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist?'**
  String get wishlistRemoveTitle;

  /// No description provided for @wishlistRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'{title} will be taken off your wishlist, along with the edition you wanted and your note. Your library is not affected.'**
  String wishlistRemoveMessage(String title);

  /// No description provided for @wishlistRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get wishlistRemoveConfirm;

  /// No description provided for @wishlistDesiredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Desired language'**
  String get wishlistDesiredLanguage;

  /// No description provided for @wishlistDesiredFormat.
  ///
  /// In en, this message translates to:
  /// **'Desired format'**
  String get wishlistDesiredFormat;

  /// No description provided for @wishlistDesiredEdition.
  ///
  /// In en, this message translates to:
  /// **'Desired edition'**
  String get wishlistDesiredEdition;

  /// No description provided for @statsThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get statsThisYear;

  /// No description provided for @statsRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String statsRange(String from, String to);

  /// No description provided for @statsBooksRead.
  ///
  /// In en, this message translates to:
  /// **'Books read this year'**
  String get statsBooksRead;

  /// No description provided for @statsPagesRead.
  ///
  /// In en, this message translates to:
  /// **'Pages read'**
  String get statsPagesRead;

  /// No description provided for @statsCurrentlyReading.
  ///
  /// In en, this message translates to:
  /// **'Currently reading'**
  String get statsCurrentlyReading;

  /// No description provided for @statsAverageRating.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get statsAverageRating;

  /// No description provided for @statsBooksPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Books finished per month'**
  String get statsBooksPerMonth;

  /// No description provided for @statsByLanguage.
  ///
  /// In en, this message translates to:
  /// **'By language'**
  String get statsByLanguage;

  /// No description provided for @statsByGenre.
  ///
  /// In en, this message translates to:
  /// **'By genre'**
  String get statsByGenre;

  /// No description provided for @statsMostReadAuthors.
  ///
  /// In en, this message translates to:
  /// **'Most read authors'**
  String get statsMostReadAuthors;

  /// No description provided for @statsBestMonth.
  ///
  /// In en, this message translates to:
  /// **'Best month: {month}, {books} · {pages} pages'**
  String statsBestMonth(String month, String books, String pages);

  /// No description provided for @statsNoneYet.
  ///
  /// In en, this message translates to:
  /// **'No finished books yet this year.'**
  String get statsNoneYet;

  /// No description provided for @statsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No finished books yet'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark a book as read and these figures start filling in. Nothing here is made up — it all comes from your own shelves.'**
  String get statsEmptyMessage;

  /// No description provided for @statsError.
  ///
  /// In en, this message translates to:
  /// **'Your statistics could not be calculated.'**
  String get statsError;

  /// No description provided for @statsOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get statsOther;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileMyLibrary.
  ///
  /// In en, this message translates to:
  /// **'My library'**
  String get profileMyLibrary;

  /// No description provided for @profileReadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Reading statistics'**
  String get profileReadingStatistics;

  /// No description provided for @profileStatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{books} this year · {pages} pages'**
  String profileStatsSubtitle(String books, String pages);

  /// No description provided for @profileStatsFallback.
  ///
  /// In en, this message translates to:
  /// **'Calculated from your reading log'**
  String get profileStatsFallback;

  /// No description provided for @profileGroupLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get profileGroupLibrary;

  /// No description provided for @profileGroupData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get profileGroupData;

  /// No description provided for @profileGroupApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get profileGroupApp;

  /// No description provided for @profileShelves.
  ///
  /// In en, this message translates to:
  /// **'Shelves & locations'**
  String get profileShelves;

  /// No description provided for @profileCovers.
  ///
  /// In en, this message translates to:
  /// **'Book covers'**
  String get profileCovers;

  /// No description provided for @profileCoversWithTitles.
  ///
  /// In en, this message translates to:
  /// **'With titles'**
  String get profileCoversWithTitles;

  /// No description provided for @profileCoversOnly.
  ///
  /// In en, this message translates to:
  /// **'Covers only'**
  String get profileCoversOnly;

  /// No description provided for @profileStatsStrip.
  ///
  /// In en, this message translates to:
  /// **'Library stats strip'**
  String get profileStatsStrip;

  /// No description provided for @profileShown.
  ///
  /// In en, this message translates to:
  /// **'Shown'**
  String get profileShown;

  /// No description provided for @profileHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get profileHidden;

  /// No description provided for @profileImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import & export'**
  String get profileImportExport;

  /// No description provided for @profileStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get profileStorage;

  /// No description provided for @profileStorageValue.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get profileStorageValue;

  /// No description provided for @profileSampleLibrary.
  ///
  /// In en, this message translates to:
  /// **'Sample library'**
  String get profileSampleLibrary;

  /// No description provided for @profileSampleReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get profileSampleReset;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileAppearanceValue.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get profileAppearanceValue;

  /// No description provided for @profileShowOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Show onboarding again'**
  String get profileShowOnboarding;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get profileVersion;

  /// No description provided for @profileFooter.
  ///
  /// In en, this message translates to:
  /// **'Shelf: My Book Library {version} · your library lives on your device'**
  String profileFooter(String version);

  /// No description provided for @profileShelvesTitle.
  ///
  /// In en, this message translates to:
  /// **'Shelves & locations'**
  String get profileShelvesTitle;

  /// No description provided for @profileShelvesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where your copies live. Set a location on any copy from its edit screen.'**
  String get profileShelvesSubtitle;

  /// No description provided for @profileShelvesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No locations recorded yet.'**
  String get profileShelvesEmpty;

  /// No description provided for @profileStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Where your library lives'**
  String get profileStorageTitle;

  /// No description provided for @profileStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Everything — books, editions, copies, reading history and your wishlist — is stored in a local database on this device. It works with no signal, which is what the bookstore flow needs.\n\nThe only time the app reaches the network is to look up a book you have scanned but do not own. Even then, a bundled catalogue answers first.'**
  String get profileStorageBody;

  /// No description provided for @profileResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset to the sample library?'**
  String get profileResetTitle;

  /// No description provided for @profileResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Every book, edition, copy, note, photo link, reading entry and wishlist item you have added will be deleted and replaced with the sample collection. This cannot be undone.'**
  String get profileResetMessage;

  /// No description provided for @profileResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything and reset'**
  String get profileResetConfirm;

  /// No description provided for @profileLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageTitle;

  /// No description provided for @profileLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Changes the app\'s own words. Your books keep the languages they were written in.'**
  String get profileLanguageSubtitle;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import & export'**
  String get importTitle;

  /// No description provided for @importIntro.
  ///
  /// In en, this message translates to:
  /// **'Your library is yours. Take it out at any time.'**
  String get importIntro;

  /// No description provided for @importSectionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get importSectionExport;

  /// No description provided for @importSectionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importSectionImport;

  /// No description provided for @importCsvLabel.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get importCsvLabel;

  /// No description provided for @importCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every field, one row per copy'**
  String get importCsvSubtitle;

  /// No description provided for @importJsonLabel.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get importJsonLabel;

  /// No description provided for @importJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full structure — works, editions and copies'**
  String get importJsonSubtitle;

  /// No description provided for @importPrintableLabel.
  ///
  /// In en, this message translates to:
  /// **'Printable list'**
  String get importPrintableLabel;

  /// No description provided for @importPrintableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A plain list of your shelves'**
  String get importPrintableSubtitle;

  /// No description provided for @importNotBuiltTitle.
  ///
  /// In en, this message translates to:
  /// **'Not built yet'**
  String get importNotBuiltTitle;

  /// No description provided for @importNotBuiltMessage.
  ///
  /// In en, this message translates to:
  /// **'Importing from a Goodreads, LibraryThing or CSV file is planned but not implemented. Until then, scanning is the fastest way to fill a shelf — a barcode fills in every field for you.'**
  String get importNotBuiltMessage;

  /// No description provided for @importScanInstead.
  ///
  /// In en, this message translates to:
  /// **'Scan a book instead'**
  String get importScanInstead;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown author'**
  String get unknownAuthor;

  /// No description provided for @unrated.
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get unrated;

  /// No description provided for @authorsAndOthers.
  ///
  /// In en, this message translates to:
  /// **'{first} & {count} others'**
  String authorsAndOthers(String first, int count);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String durationDays(int count);

  /// No description provided for @durationToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get durationToday;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Separate each level with ›'**
  String get locationHint;

  /// No description provided for @locationTapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change it'**
  String get locationTapToChange;

  /// No description provided for @locationNone.
  ///
  /// In en, this message translates to:
  /// **'No location yet'**
  String get locationNone;

  /// No description provided for @enrichFilledOne.
  ///
  /// In en, this message translates to:
  /// **'Filled in the {field}'**
  String enrichFilledOne(String field);

  /// No description provided for @enrichFilledMany.
  ///
  /// In en, this message translates to:
  /// **'Filled in the {head} and {last}'**
  String enrichFilledMany(String head, String last);

  /// No description provided for @enrichIsbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get enrichIsbn;

  /// No description provided for @enrichIsbn10.
  ///
  /// In en, this message translates to:
  /// **'ISBN-10'**
  String get enrichIsbn10;

  /// No description provided for @enrichPublisher.
  ///
  /// In en, this message translates to:
  /// **'publisher'**
  String get enrichPublisher;

  /// No description provided for @enrichPublicationDate.
  ///
  /// In en, this message translates to:
  /// **'publication date'**
  String get enrichPublicationDate;

  /// No description provided for @enrichYear.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get enrichYear;

  /// No description provided for @enrichLanguage.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get enrichLanguage;

  /// No description provided for @enrichFormat.
  ///
  /// In en, this message translates to:
  /// **'format'**
  String get enrichFormat;

  /// No description provided for @enrichEditionName.
  ///
  /// In en, this message translates to:
  /// **'edition name'**
  String get enrichEditionName;

  /// No description provided for @enrichPageCount.
  ///
  /// In en, this message translates to:
  /// **'page count'**
  String get enrichPageCount;

  /// No description provided for @enrichCover.
  ///
  /// In en, this message translates to:
  /// **'cover'**
  String get enrichCover;

  /// No description provided for @enrichDimensions.
  ///
  /// In en, this message translates to:
  /// **'dimensions'**
  String get enrichDimensions;

  /// No description provided for @enrichWeight.
  ///
  /// In en, this message translates to:
  /// **'weight'**
  String get enrichWeight;

  /// No description provided for @enrichTranslator.
  ///
  /// In en, this message translates to:
  /// **'translator'**
  String get enrichTranslator;

  /// No description provided for @enrichCountry.
  ///
  /// In en, this message translates to:
  /// **'country'**
  String get enrichCountry;

  /// No description provided for @enrichIllustrators.
  ///
  /// In en, this message translates to:
  /// **'illustrators'**
  String get enrichIllustrators;

  /// No description provided for @enrichDescription.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get enrichDescription;

  /// No description provided for @enrichOriginalTitle.
  ///
  /// In en, this message translates to:
  /// **'original title'**
  String get enrichOriginalTitle;

  /// No description provided for @enrichOriginalLanguage.
  ///
  /// In en, this message translates to:
  /// **'original language'**
  String get enrichOriginalLanguage;

  /// No description provided for @enrichSeries.
  ///
  /// In en, this message translates to:
  /// **'series'**
  String get enrichSeries;

  /// No description provided for @enrichSeriesNumber.
  ///
  /// In en, this message translates to:
  /// **'series number'**
  String get enrichSeriesNumber;

  /// No description provided for @enrichFirstPublished.
  ///
  /// In en, this message translates to:
  /// **'first published'**
  String get enrichFirstPublished;

  /// No description provided for @enrichGenre.
  ///
  /// In en, this message translates to:
  /// **'genre'**
  String get enrichGenre;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'ru':
      return AppL10nRu();
    case 'uz':
      return AppL10nUz();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
