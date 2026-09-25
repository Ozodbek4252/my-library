// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppL10nUz extends AppL10n {
  AppL10nUz([String locale = 'uz']) : super(locale);

  @override
  String get languageName => 'Oʻzbekcha';

  @override
  String get appTitle => 'Shelf: My Book Library';

  @override
  String get navLibrary => 'Kutubxona';

  @override
  String get navReading => 'Oʻqish';

  @override
  String get navScan => 'Skaner';

  @override
  String get navWishlist => 'Istaklar';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionCancel => 'Bekor qilish';

  @override
  String get actionSave => 'Saqlash';

  @override
  String get actionDone => 'Tayyor';

  @override
  String get actionEdit => 'Tahrirlash';

  @override
  String get actionClear => 'Tozalash';

  @override
  String get actionReset => 'Qayta oʻrnatish';

  @override
  String get actionTryAgain => 'Qayta urinish';

  @override
  String get actionBackToLibrary => 'Kutubxonaga qaytish';

  @override
  String get actionBackToWishlist => 'Istaklarga qaytish';

  @override
  String get actionScanBook => 'Kitobni skanerlash';

  @override
  String get actionScanBarcode => 'Shtrix-kodini skanerlash';

  @override
  String get actionAddManually => 'Qoʻlda qoʻshish';

  @override
  String get actionAddItManually => 'Qoʻlda qoʻshish';

  @override
  String get actionScanNext => 'Keyingisini skanerlash';

  @override
  String get actionOpenBook => 'Kitobni ochish';

  @override
  String get actionEnterIsbnManually => 'ISBN ni qoʻlda kiritish';

  @override
  String get actionKeepIt => 'Qoldirish';

  @override
  String get actionNotYet => 'Hozir emas';

  @override
  String get actionShowAll => 'Hammasini koʻrsatish';

  @override
  String get actionAddBook => 'Kitob qoʻshish';

  @override
  String get actionGoToLibrary => 'Kutubxonaga oʻtish';

  @override
  String get onboardingHeadlineFirst => 'Barcha kitoblaringiz —';

  @override
  String get onboardingHeadlineSecond => 'cho‘ntagingizda.';

  @override
  String get onboardingSubhead =>
      'Doʻkonda shtrix-kodni skanerlang va ikki soniyada kitob javoningizda bor-yoʻqligini biling.';

  @override
  String get onboardingStart => 'Kutubxonamni boshlash';

  @override
  String get onboardingScanFirst => 'Birinchi kitobni skanerlash';

  @override
  String get libraryTitle => 'Kutubxona';

  @override
  String get librarySearchHint => 'Nomi, muallifi, ISBN…';

  @override
  String get libraryStatTotal => 'Jami';

  @override
  String get libraryStatUnread => 'Oʻqilmagan';

  @override
  String get libraryStatReading => 'Oʻqilmoqda';

  @override
  String get libraryStatRead => 'Oʻqilgan';

  @override
  String libraryCountLine(int shown, int total, String sort) {
    return '$total tadan $shown ta koʻrsatilgan · $sort boʻyicha';
  }

  @override
  String libraryShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count javon',
      one: '1 javon',
    );
    return '$_temp0';
  }

  @override
  String get libraryEmptyTitle => 'Javonlaringiz boʻsh';

  @override
  String get libraryEmptyMessage =>
      'Oʻzingizdagi kitobning shtrix-kodini skanerlang — qolgani oʻzi toʻladi.';

  @override
  String get libraryLoading => 'Kutubxonangiz ochilmoqda…';

  @override
  String get libraryErrorTitle => 'Kutubxonani oʻqib boʻlmadi';

  @override
  String get libraryErrorMessage =>
      'Mahalliy maʼlumotlar bazasi xato qaytardi. Qayta urinish uchun pastga torting.';

  @override
  String get libraryNoMatchesTitle => 'Mos kelmadi';

  @override
  String libraryNoMatchesFor(String query) {
    return 'Kutubxonangizda “$query” boʻyicha hech nima yoʻq. Bu hali sizda boʻlmagan kitob boʻlishi mumkin.';
  }

  @override
  String get libraryNoFilterMatches => 'Bu filtrlarga mos kitob yoʻq.';

  @override
  String get libraryClearFilters => 'Filtrlarni tozalash';

  @override
  String bookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kitob',
      one: '1 kitob',
    );
    return '$_temp0';
  }

  @override
  String shelfCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta javon',
    );
    return '$_temp0';
  }

  @override
  String get filterTitle => 'Filtr';

  @override
  String filterShowBooks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kitobni koʻrsatish',
      one: '1 kitobni koʻrsatish',
    );
    return '$_temp0';
  }

  @override
  String get filterLoadFailed => 'Filtrlarni yuklab boʻlmadi.';

  @override
  String get sortTitle => 'Saralash';

  @override
  String get groupReadingStatus => 'Oʻqish holati';

  @override
  String get groupLanguage => 'Til';

  @override
  String get groupGenre => 'Janr';

  @override
  String get groupFormat => 'Format';

  @override
  String get groupPublisher => 'Nashriyot';

  @override
  String get groupAuthor => 'Muallif';

  @override
  String get groupSeries => 'Turkum';

  @override
  String get sortRecentlyAdded => 'Yaqinda qoʻshilgan';

  @override
  String get sortTitleOption => 'Nomi';

  @override
  String get sortAuthor => 'Muallifi';

  @override
  String get sortPages => 'Sahifalar';

  @override
  String get sortPublicationDate => 'Nashr sanasi';

  @override
  String get sortRating => 'Baho';

  @override
  String get statusUnread => 'Oʻqilmagan';

  @override
  String get statusReading => 'Oʻqilmoqda';

  @override
  String get statusRead => 'Oʻqilgan';

  @override
  String get statusDnf => 'Tashlangan';

  @override
  String get statusRereading => 'Qayta oʻqilmoqda';

  @override
  String get statusRereadBadge => 'Qayta';

  @override
  String get ownershipOwned => 'Menda bor';

  @override
  String get ownershipWishlist => 'Istaklarda';

  @override
  String get ownershipPreviouslyOwned => 'Avval bor edi';

  @override
  String get conditionNew => 'Yangi';

  @override
  String get conditionLikeNew => 'Yangidek';

  @override
  String get conditionGood => 'Yaxshi';

  @override
  String get conditionAcceptable => 'Oʻrtacha';

  @override
  String get conditionDamaged => 'Shikastlangan';

  @override
  String get priorityHigh => 'Yuqori';

  @override
  String get priorityMedium => 'Oʻrta';

  @override
  String get priorityLow => 'Past';

  @override
  String get photoFront => 'Old tomon';

  @override
  String get photoBack => 'Orqa tomon';

  @override
  String get photoSpine => 'Muqova qirrasi';

  @override
  String get photoSpecialEdition => 'Maxsus nashr';

  @override
  String get photoDamage => 'Shikast';

  @override
  String get photoSigned => 'Imzoli';

  @override
  String get searchTry => 'Sinab koʻring';

  @override
  String get searchRecent => 'Yaqinda qidirilgan';

  @override
  String searchInYourLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kutubxonangizda $count ta',
      one: 'Kutubxonangizda 1 ta',
    );
    return '$_temp0';
  }

  @override
  String get searchNotInLibrary => 'Kutubxonangizda yoʻqmi?';

  @override
  String get searchAllEditions => 'Barcha nashrlarni qidirish';

  @override
  String get searchAllEditionsSection => 'Barcha nashrlar';

  @override
  String get searchFailed => 'Qidiruvni bajarib boʻlmadi.';

  @override
  String searchNoEditionsFound(String query) {
    return '“$query” boʻyicha nashr topilmadi.';
  }

  @override
  String get searchLookupUnreachable =>
      'Kitob maʼlumotlariga ulanib boʻlmadi. Oʻz kutubxonangiz baribir toʻliq qidiriladi.';

  @override
  String get searchLookupFailed =>
      'Qidiruv muvaffaqiyatsiz tugadi. Birozdan keyin qayta urining.';

  @override
  String get searchPromoTitle => 'Kitob doʻkonidamisiz?';

  @override
  String get searchPromoSubtitle => 'Skanerlash yozishdan tezroq.';

  @override
  String get searchPromoAction => 'Skaner';

  @override
  String get scannerTitle => 'Shtrix-kodga qarating';

  @override
  String get scannerSubtitle => 'Odatda orqa muqovada boʻladi';

  @override
  String get scannerIsbnTitle => 'ISBN ni skanerlang';

  @override
  String get scannerIsbnSubtitle => 'Raqamni oʻzimiz toʻldiramiz';

  @override
  String get scannerSearchByTitle => 'Nomi boʻyicha qidirish';

  @override
  String get scannerEnterManually => 'Qoʻlda kiritish';

  @override
  String get scannerEnterIsbn => 'ISBNni kiriting';

  @override
  String get scannerLookingUp => 'Qidirilmoqda…';

  @override
  String get scannerGotIt => 'Topildi';

  @override
  String get scannerStartingTitle => 'Kamera ishga tushmoqda…';

  @override
  String get scannerStartingMessage => 'Bir lahza.';

  @override
  String get scannerDeniedTitle => 'Kameraga ruxsat yoʻq';

  @override
  String get scannerDeniedMessage =>
      'Skanerlash uchun kamera kerak. Sozlamalardan yoqing yoki shtrix-kod ostidagi 13 raqamni yozing.';

  @override
  String get scannerOpenSettings => 'Sozlamalarni ochish';

  @override
  String get scannerUnsupportedTitle => 'Kamera yoʻq';

  @override
  String get scannerUnsupportedMessage =>
      'Bu qurilma shtrix-kodni skanerlay olmaydi. Kitobni ISBN orqali yoki qoʻlda qoʻshishingiz mumkin.';

  @override
  String get scannerAddByHand => 'Kitobni qoʻlda qoʻshish';

  @override
  String get scannerFailedTitle => 'Kamera ishga tushmadi';

  @override
  String get scannerFailedMessage =>
      'Kamerani ochishda xatolik yuz berdi. Qayta urining yoki ISBN ni oʻzingiz kiriting.';

  @override
  String get isbnSheetTitle => 'ISBN kiriting';

  @override
  String get isbnSheetSubtitle => 'Shtrix-kod ostidagi 10 yoki 13 ta raqam.';

  @override
  String get isbnSheetLookUp => 'Qidirish';

  @override
  String get isbnSheetUseNumber => 'Shu raqamni ishlatish';

  @override
  String get isbnSheetEmpty => 'Shtrix-kod ostidagi raqamni kiriting.';

  @override
  String get isbnSheetInvalid =>
      'Bu ISBN ga oʻxshamaydi. Raqamlarni tekshirib, qayta urining.';

  @override
  String get isbnInvalidToast => 'Bu ISBN notoʻgʻri';

  @override
  String get scanFailBarcodeTitle => 'Shtrix-kod oʻqilmadi';

  @override
  String get scanFailBarcodeMessage =>
      'Yorugʻlik kam yoki kod gʻijimlangan boʻlishi mumkin. Qayta urining yoki ostidagi 13 raqamni yozing.';

  @override
  String get scanFailNotFoundTitle => 'Bu ISBN bizga notanish';

  @override
  String scanFailNotFoundMessage(String isbn) {
    return '$isbn boʻyicha kitob topilmadi. Bu mahalliy nashr boʻlishi mumkin. Uni qoʻlda qoʻshsangiz ham boʻladi.';
  }

  @override
  String get scanFailNetworkTitle => 'Internet yoʻq';

  @override
  String get scanFailNetworkMessage =>
      'Kitob maʼlumotlariga ulanib boʻlmadi. Kutubxonangiz oflayn ishlaydi — qayta urining yoki maʼlumotlarni oʻzingiz kiriting.';

  @override
  String get scanFailUnknownTitle => 'Xatolik yuz berdi';

  @override
  String get scanFailUnknownMessage =>
      'Qidiruv kutilmaganda muvaffaqiyatsiz tugadi. Qayta urining yoki maʼlumotlarni oʻzingiz kiriting.';

  @override
  String get scanFailThatCode => 'bu kod';

  @override
  String get scanOwnedBanner => 'Bu kitob sizda bor';

  @override
  String get scanNewBanner => 'Kutubxonangizda hali yoʻq';

  @override
  String get scanYourCopies => 'SIZDAGI NUSXALAR';

  @override
  String get scanScannedCopy => 'SKANERLANGAN NUSXA';

  @override
  String scanEditionsOnShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Javoningizda $count ta nashr',
      one: 'Javoningizda 1 ta nashr',
    );
    return '$_temp0';
  }

  @override
  String get scanAddAnotherCopy => 'Yana bir nusxa qoʻshish';

  @override
  String get scanAddAsAnotherEdition => 'Boshqa nashr sifatida qoʻshish';

  @override
  String get scanAddToLibrary => 'Kutubxonaga qoʻshish';

  @override
  String get scanAddWithDetails => 'Maʼlumotlar bilan qoʻshish';

  @override
  String get scanWishlistIt => 'Istaklarga qoʻshish';

  @override
  String get scanAlreadyWishlisted => 'Allaqachon istaklarda';

  @override
  String scanWishlistNote(String month) {
    return '$month dan beri istaklaringizda — qoʻshsangiz, u yerdan oʻchadi.';
  }

  @override
  String scanEnrichedNote(String summary) {
    return '$summary — shu skanerlashdan. Siz kiritgan hech narsa oʻzgarmadi.';
  }

  @override
  String get scanEditionMissing => 'Nashr maʼlumotlari yoʻq';

  @override
  String scanCopiesSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nusxa',
    );
    return '$_temp0';
  }

  @override
  String get toastAddedToLibrary => 'Kutubxonaga qoʻshildi';

  @override
  String get toastEditionAdded => 'Nashr kutubxonaga qoʻshildi';

  @override
  String get toastAnotherCopyAdded => 'Yana bir nusxa qoʻshildi';

  @override
  String get toastAddedClearedWishlist =>
      'Kutubxonaga qoʻshildi · istaklardan oʻchirildi';

  @override
  String get toastAddedToWishlist => 'Istaklarga qoʻshildi';

  @override
  String get toastChangesSaved => 'Oʻzgarishlar saqlandi';

  @override
  String get toastCopyUpdated => 'Nusxa yangilandi';

  @override
  String get toastCopyRemoved => 'Nusxa oʻchirildi';

  @override
  String get toastRemovedFromLibrary => 'Kutubxonadan oʻchirildi';

  @override
  String toastCopyRemovedEditionsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nusxa oʻchirildi · $count nashr qoldi',
      one: 'Nusxa oʻchirildi · 1 nashr qoldi',
    );
    return '$_temp0';
  }

  @override
  String get toastMovedToLibrary => 'Kutubxonaga koʻchirildi';

  @override
  String get toastRemovedFromWishlist => 'Istaklardan oʻchirildi';

  @override
  String get toastProgressSaved => 'Jarayon saqlandi';

  @override
  String toastFinished(String year) {
    return 'Tugatildi · $year tarixiga qoʻshildi';
  }

  @override
  String toastMarkedAs(String status) {
    return '$status deb belgilandi';
  }

  @override
  String get toastMainEditionUpdated => 'Asosiy nashr yangilandi';

  @override
  String get toastCopyAdded => 'Nusxa kutubxonaga qoʻshildi';

  @override
  String get toastPhotoAdded => 'Rasm qoʻshildi';

  @override
  String get toastPhotoRemoved => 'Rasm oʻchirildi';

  @override
  String get toastTitleRequired => 'Nomi kiritilishi shart';

  @override
  String get toastCouldNotSave => 'Bu kitobni saqlab boʻlmadi';

  @override
  String get toastCouldNotAdd => 'Bu kitobni qoʻshib boʻlmadi';

  @override
  String get toastCouldNotWishlist => 'Istaklarga qoʻshib boʻlmadi';

  @override
  String get toastCouldNotOpenPhotos => 'Rasmlar kutubxonasini ochib boʻlmadi';

  @override
  String get toastCouldNotOpenCamera => 'Kamerani ochib boʻlmadi';

  @override
  String get toastCouldNotOpenPictures => 'Rasmlaringizni ochib boʻlmadi';

  @override
  String get toastCouldNotOpenCropper => 'Kesish oynasini ochib boʻlmadi';

  @override
  String toastFilledFromIsbn(String title) {
    return '$title dan toʻldirildi';
  }

  @override
  String get toastIsbnNotFound =>
      'Bu ISBN bizga notanish — oʻzingiz toʻldiring';

  @override
  String get toastIsbnOffline => 'Internet yoʻq — oʻzingiz toʻldiring';

  @override
  String get toastIsbnLookupFailed =>
      'Qidiruv muvaffaqiyatsiz — oʻzingiz toʻldiring';

  @override
  String get toastSampleRestored => 'Namuna kutubxona tiklandi';

  @override
  String toastExported(String file) {
    return '$file eksport qilindi';
  }

  @override
  String get toastExportFailed =>
      'Eksport muvaffaqiyatsiz — faylni yozib boʻlmadi';

  @override
  String get addBookTitle => 'Kitob qoʻshish';

  @override
  String get addEditionTitle => 'Nashr qoʻshish';

  @override
  String get editBookTitle => 'Kitobni tahrirlash';

  @override
  String get editCopyTitle => 'Nusxani tahrirlash';

  @override
  String get editCopyNotFoundTitle => 'Nusxa topilmadi';

  @override
  String get editCopyNotFoundMessage => 'Bu nusxa endi kutubxonangizda yo‘q.';

  @override
  String get sectionTheBook => 'Kitob';

  @override
  String get sectionThisEdition => 'Ushbu nashr';

  @override
  String get sectionStatus => 'Holat';

  @override
  String get sectionRating => 'Baho';

  @override
  String get sectionOwnership => 'Egalik';

  @override
  String get sectionPurchase => 'Xarid';

  @override
  String get sectionCondition => 'Holati';

  @override
  String get sectionLocation => 'Joylashuv';

  @override
  String get sectionTags => 'Teglar';

  @override
  String get sectionPersonalNotes => 'Shaxsiy izohlar';

  @override
  String get sectionEditionYouOwn => 'Sizdagi nashr';

  @override
  String get sectionMyCopy => 'Mening nusxam';

  @override
  String get sectionPersonalNote => 'Shaxsiy izoh';

  @override
  String get sectionPhotosOfMyCopy => 'Nusxamning rasmlari';

  @override
  String get sectionWhatIWant => 'Nimani istayman';

  @override
  String get sectionNote => 'Izoh';

  @override
  String get fieldTitle => 'Nomi';

  @override
  String get fieldAuthor => 'Muallif';

  @override
  String get fieldOriginalTitle => 'Asl nomi';

  @override
  String get fieldOriginalLanguage => 'Asl tili';

  @override
  String get fieldGenre => 'Janr';

  @override
  String get fieldSeries => 'Turkum';

  @override
  String get fieldFirstPublished => 'Birinchi nashr';

  @override
  String get fieldDescription => 'Tavsif';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldIsbn10 => 'ISBN-10';

  @override
  String get fieldLanguage => 'Til';

  @override
  String get fieldPublisher => 'Nashriyot';

  @override
  String get fieldEdition => 'Nashr';

  @override
  String get fieldFormat => 'Format';

  @override
  String get fieldPublished => 'Nashr etilgan';

  @override
  String get fieldPages => 'Sahifalar';

  @override
  String get fieldCountry => 'Mamlakat';

  @override
  String get fieldTranslator => 'Tarjimon';

  @override
  String get fieldIllustrators => 'Rassomlar';

  @override
  String get fieldDimensions => 'Oʻlchamlari';

  @override
  String get fieldWeight => 'Ogʻirligi';

  @override
  String weightGrams(int grams) {
    return '$grams g';
  }

  @override
  String get fieldPurchased => 'Xarid qilingan';

  @override
  String get fieldPrice => 'Narxi';

  @override
  String get fieldWhere => 'Qayerdan';

  @override
  String get fieldStore => 'Doʻkon';

  @override
  String get fieldGift => 'Sovgʻa';

  @override
  String get fieldGiftFrom => 'Kimdan sovgʻa';

  @override
  String get fieldCurrency => 'Valyuta';

  @override
  String get fieldDate => 'Sana';

  @override
  String get fieldAdded => 'Qoʻshilgan';

  @override
  String get fieldPriority => 'Muhimligi';

  @override
  String get fieldCover => 'Muqova';

  @override
  String get hintRequired => 'Majburiy';

  @override
  String get hintAuthors => 'Bir nechtasini vergul bilan ajrating';

  @override
  String get hintGenres => 'Badiiy, Tarix…';

  @override
  String get hintFormats => 'Yumshoq muqova, Qattiq muqova…';

  @override
  String get hintIsbn => '978…';

  @override
  String get hintNotRecorded => 'Kiritilmagan';

  @override
  String get hintChoose => 'Tanlang';

  @override
  String get hintWhereBought => 'Qayerdan sotib olgansiz';

  @override
  String get hintBlankIfPurchased => 'Sotib olingan boʻlsa boʻsh qoldiring';

  @override
  String get hintTags => 'distopiya, qayta-oʻqilgan';

  @override
  String get hintNotes => 'Bu nusxa haqida esda qolarli narsa…';

  @override
  String get hintLocation => 'Uy › Yotoqxona › Javon 2 › Tokcha 4';

  @override
  String get coverSheetTitle => 'Muqova';

  @override
  String get coverSheetSubtitle =>
      'Kitobni suratga oling yoki mavjud rasmni tanlang. Keyin kadrlaysiz — istalgan chekkani torting yoki muqova koʻrsatiladigan 2:3 dan boshlang.';

  @override
  String get coverTakePhoto => 'Suratga olish';

  @override
  String get coverChoosePicture => 'Rasm tanlash';

  @override
  String get coverAdjustCrop => 'Kesishni oʻzgartirish';

  @override
  String get coverRemove => 'Muqovani oʻchirish';

  @override
  String get coverCropTitle => 'Muqovani kadrlang';

  @override
  String get coverCropUse => 'Ishlatish';

  @override
  String get addFillFromIsbn => 'ISBN orqali toʻldirish';

  @override
  String get addLookingUp => 'Qidirilmoqda…';

  @override
  String get addScanHint =>
      'Kitobni suratga olish uchun muqovaga bosing. Skanerlash quyidagi barcha maydonlarni oʻzi toʻldiradi.';

  @override
  String get addScanInstead => 'Skanerlash →';

  @override
  String get addEditHint =>
      'Bu nashrni suratga olish uchun muqovaga bosing. Bu yerdagi oʻzgarishlar kitob va uning maʼlumotlar sahifasidagi nashrga tegishli; xarid maʼlumotlari nusxada saqlanadi.';

  @override
  String get addSaveChanges => 'Oʻzgarishlarni saqlash';

  @override
  String get addToWishlist => 'Istaklarga qoʻshish';

  @override
  String get scanIsbnSemantic => 'ISBN ni skanerlash';

  @override
  String get detailsErrorTitle => 'Bu kitobni ochib boʻlmadi';

  @override
  String get detailsErrorMessage =>
      'Uni kutubxonangizdan oʻqishda xatolik yuz berdi.';

  @override
  String get detailsRemovedTitle => 'Endi kutubxonangizda yoʻq';

  @override
  String get detailsRemovedMessage => 'Bu kitob oʻchirilgan.';

  @override
  String get detailsNoEdition => 'Hali nashr kiritilmagan.';

  @override
  String get detailsUpdateProgress => 'Jarayonni yangilash';

  @override
  String detailsPagesOf(int current, int total) {
    return '$total sahifadan $current tasi';
  }

  @override
  String detailsPageOnly(int current) {
    return '$current-sahifa';
  }

  @override
  String detailsEditionsOfWork(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu asarning $count ta nashri',
      one: 'Bu asarning 1 ta nashri',
    );
    return '$_temp0';
  }

  @override
  String get detailsAddAnotherCopyOrTranslation =>
      'Yana bir nusxa yoki tarjima qoʻshing';

  @override
  String get detailsMenuEditBook => 'Kitob maʼlumotlarini tahrirlash';

  @override
  String get detailsMenuAllEditions => 'Bu asarning barcha nashrlari';

  @override
  String get detailsMenuEditCopy => 'Bu nusxani tahrirlash';

  @override
  String get detailsRemoveCopy => 'Bu nusxani oʻchirish';

  @override
  String detailsGiftFrom(String name) {
    return '$name dan';
  }

  @override
  String get detailsGiftPurchased => 'Sotib olingan';

  @override
  String get detailsGiftAFriend => 'bir doʻstdan';

  @override
  String detailsBookNumber(int number) {
    return '$number-kitob';
  }

  @override
  String get detailsNotRated => 'Baholanmagan';

  @override
  String get detailsSeriesLabel => 'Turkum';

  @override
  String get photoSheetTitle => 'Rasm qoʻshish';

  @override
  String get photoSheetSubtitle =>
      'Nusxangizning rasmlari rasmiy muqovadan alohida saqlanadi.';

  @override
  String get photoDeleteTitle => 'Bu rasm oʻchirilsinmi?';

  @override
  String photoDeleteMessage(String type) {
    return 'Nusxangizning “$type” rasmi oʻchiriladi. Kitob va uning maʼlumotlari qoladi.';
  }

  @override
  String get photoDeleteConfirm => 'Rasmni oʻchirish';

  @override
  String get removeCopyTitle => 'Bu nusxa oʻchirilsinmi?';

  @override
  String removeCopyMessage(String descriptor, String title, String survives) {
    return '$title kitobining $descriptor nusxasi xarid maʼlumotlari va rasmlari bilan birga oʻchiriladi. $survives';
  }

  @override
  String get removeCopyConfirm => 'Nusxani oʻchirish';

  @override
  String get survivesOtherCopy => 'Bu nashrning boshqa nusxangiz qoladi.';

  @override
  String survivesOtherEditions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Boshqa $count ta nashringiz qoladi.',
      one: 'Boshqa nashringiz qoladi.',
    );
    return '$_temp0';
  }

  @override
  String get survivesNothing => 'Kitob kutubxonangizdan butunlay oʻchiriladi.';

  @override
  String get editionsExplainerOne =>
      'Bitta asar, bitta nusxa. Oʻqish holati asarga, qolgani esa nusxaga tegishli.';

  @override
  String editionsExplainerMany(String copies, String editions) {
    return 'Bitta asar, $editions boʻyicha $copies. Oʻqish holati asarga, qolgani esa nusxaga tegishli.';
  }

  @override
  String editionsCopyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nusxa',
      one: '1 nusxa',
    );
    return '$_temp0';
  }

  @override
  String editionsEditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nashr',
      one: '1 nashr',
    );
    return '$_temp0';
  }

  @override
  String get editionsErrorMessage =>
      'Bu nashrlarni kutubxonangizdan oʻqib boʻlmadi.';

  @override
  String get editionsAddAnother => '+ Yana bir nashr qoʻshish';

  @override
  String get editionsReadingCopy => 'Oʻqiladigan nusxa';

  @override
  String get editionsGiftTag => 'Sovgʻa';

  @override
  String get editionsShowAsMain => 'Asosiy qilish';

  @override
  String get editionsAddAnotherCopy => 'Yana bir nusxa qoʻshish';

  @override
  String get editionsNotOwnedYet => 'Hali sizda yoʻq';

  @override
  String get editionsUnknownLanguage => 'Til nomaʼlum';

  @override
  String editionsFirstPublished(int year) {
    return 'birinchi nashri $year';
  }

  @override
  String editionsFromPerson(String name) {
    return '$name dan';
  }

  @override
  String get editionsAddCopyTitle => 'Yana bir nusxa qoʻshilsinmi?';

  @override
  String editionsAddCopyMessage(String format) {
    return 'Bu $format ning ikkinchi nusxasi javoningizga qoʻshiladi. Qayerdan kelganini keyin toʻldirishingiz mumkin.';
  }

  @override
  String get editionsAddCopyConfirm => 'Nusxa qoʻshish';

  @override
  String get editionsGenericFormat => 'nashr';

  @override
  String editionsPagesShort(int count) {
    return '$count bet';
  }

  @override
  String get readingTitle => 'Oʻqish';

  @override
  String get readingTabNow => 'Hozir oʻqilmoqda';

  @override
  String get readingTabHistory => 'Tarix';

  @override
  String get readingUpNext => 'Navbatda · javoningizdan';

  @override
  String get readingUpdatePage => 'Sahifani yangilash';

  @override
  String get readingMarkFinished => 'Tugatildi deb belgilash';

  @override
  String get readingEmptyTitle => 'Hozir hech nima oʻqilmayapti';

  @override
  String get readingEmptyWithShelves =>
      'Javoningizdan birortasini tanlab, “Oʻqilmoqda” qilib qoʻying.';

  @override
  String get readingEmptyNoShelves =>
      'Kutubxonangizga kitob qoʻshing, keyin uni “Oʻqilmoqda” qilib belgilang.';

  @override
  String get readingErrorMessage => 'Hozirgi oʻqishlaringizni yuklab boʻlmadi.';

  @override
  String get readingHistoryError => 'Oʻqish tarixingizni yuklab boʻlmadi.';

  @override
  String get readingHistoryEmptyTitle => 'Hali tugatilgan kitob yoʻq';

  @override
  String get readingHistoryEmptyMessage =>
      'Kitobni oʻqilgan deb belgilaganingizda u shu yerda, tugatgan oyingiz boʻyicha guruhlanib paydo boʻladi.';

  @override
  String readingReadInYear(int year) {
    return '$year da oʻqilgan';
  }

  @override
  String get readingPagesLabel => 'Sahifa';

  @override
  String get readingAvgRating => 'Oʻrtacha baho';

  @override
  String readingPagesOf(int current, int total) {
    return '$total sahifadan $current tasi';
  }

  @override
  String get readingPagesRead => 'sahifa oʻqilgan';

  @override
  String readingStartedOn(String date) {
    return '$date da boshlangan';
  }

  @override
  String get readingNotStarted => 'Hali boshlanmagan';

  @override
  String readingDaysIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun boʻldi',
      one: '1 kun boʻldi',
    );
    return '$_temp0';
  }

  @override
  String get readingToday => 'bugun';

  @override
  String readingFinishedOn(String date) {
    return '$date da tugatilgan';
  }

  @override
  String progressStarted(String date) {
    return '$date da boshlangan';
  }

  @override
  String progressPagesTotal(int count) {
    return '$count sahifa';
  }

  @override
  String progressPercentToGo(int percent, int left) {
    return '$percent% · $left sahifa qoldi';
  }

  @override
  String get progressNoPageCount =>
      'Foizni kuzatish uchun bu nashrga sahifalar sonini qoʻshing';

  @override
  String get progressPlusTen => '+10 sahifa';

  @override
  String get progressSave => 'Jarayonni saqlash';

  @override
  String get progressFinished => 'Tugatdim';

  @override
  String get progressGone => 'Bu kitob endi kutubxonangizda yoʻq.';

  @override
  String get wishlistTitle => 'Istaklar';

  @override
  String wishlistHighPriority(int count) {
    return '$count ta yuqori muhim';
  }

  @override
  String wishlistAll(int count) {
    return 'Hammasi $count';
  }

  @override
  String get wishlistErrorMessage => 'Istaklar roʻyxatini yuklab boʻlmadi.';

  @override
  String get wishlistEmptyTitle => 'Roʻyxat hali boʻsh';

  @override
  String get wishlistEmptyMessage =>
      'Xohlagan, ammo sizda yoʻq kitobni skanerlang — u javoningizga emas, shu yerga tushadi.';

  @override
  String get wishlistNoFilterTitle => 'Mos kelmadi';

  @override
  String get wishlistNoFilterMessage => 'Boshqa filtrni sinab koʻring.';

  @override
  String get wishlistDetailError => 'Bu istak yozuvini yuklab boʻlmadi.';

  @override
  String get wishlistRemovedTitle => 'Endi istaklaringizda yoʻq';

  @override
  String get wishlistRemovedMessage => 'Bu yozuv oʻchirilgan.';

  @override
  String get wishlistBadge => 'ISTAKLAR';

  @override
  String wishlistAddedOn(String date) {
    return '$date da qoʻshilgan';
  }

  @override
  String get wishlistNotePlaceholder =>
      'Qanday nashr kerakligi haqida izoh qoʻshish uchun bosing.';

  @override
  String get wishlistBought => 'Sotib oldim — kutubxonaga koʻchirish';

  @override
  String get wishlistRemove => 'Istaklardan oʻchirish';

  @override
  String get wishlistMoveTitle => 'Kutubxonaga koʻchirilsinmi?';

  @override
  String wishlistMoveMessage(String title) {
    return '$title javoningizga oʻzingizniki sifatida qoʻshiladi va istaklardan oʻchiriladi. Nashr va xarid maʼlumotlarini keyin toʻldirishingiz mumkin.';
  }

  @override
  String get wishlistMoveConfirm => 'Kutubxonaga qoʻshish';

  @override
  String get wishlistRemoveTitle => 'Istaklardan oʻchirilsinmi?';

  @override
  String wishlistRemoveMessage(String title) {
    return '$title istaklaringizdan, xohlagan nashringiz va izohingiz bilan birga oʻchiriladi. Kutubxonangizga taʼsir qilmaydi.';
  }

  @override
  String get wishlistRemoveConfirm => 'Istaklardan oʻchirish';

  @override
  String get wishlistDesiredLanguage => 'Kerakli til';

  @override
  String get wishlistDesiredFormat => 'Kerakli format';

  @override
  String get wishlistDesiredEdition => 'Kerakli nashr';

  @override
  String get statsThisYear => 'Shu yil';

  @override
  String statsRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statsBooksRead => 'Shu yil oʻqilgan kitoblar';

  @override
  String get statsPagesRead => 'Oʻqilgan sahifalar';

  @override
  String get statsCurrentlyReading => 'Hozir oʻqilmoqda';

  @override
  String get statsAverageRating => 'Oʻrtacha baho';

  @override
  String get statsBooksPerMonth => 'Oyiga tugatilgan kitoblar';

  @override
  String get statsByLanguage => 'Tillar boʻyicha';

  @override
  String get statsByGenre => 'Janrlar boʻyicha';

  @override
  String get statsMostReadAuthors => 'Eng koʻp oʻqilgan mualliflar';

  @override
  String statsBestMonth(String month, String books, String pages) {
    return 'Eng samarali oy: $month, $books · $pages sahifa';
  }

  @override
  String get statsNoneYet => 'Bu yil hali tugatilgan kitob yoʻq.';

  @override
  String get statsEmptyTitle => 'Hali tugatilgan kitob yoʻq';

  @override
  String get statsEmptyMessage =>
      'Kitobni oʻqilgan deb belgilang va bu raqamlar toʻla boshlaydi. Bu yerda hech nima oʻylab topilmagan — hammasi oʻz javoningizdan.';

  @override
  String get statsError => 'Statistikani hisoblab boʻlmadi.';

  @override
  String get statsOther => 'Boshqa';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileMyLibrary => 'Mening kutubxonam';

  @override
  String get profileReadingStatistics => 'Oʻqish statistikasi';

  @override
  String profileStatsSubtitle(String books, String pages) {
    return 'Shu yil $books · $pages sahifa';
  }

  @override
  String get profileStatsFallback => 'Oʻqish jurnalingiz asosida hisoblangan';

  @override
  String get profileGroupLibrary => 'Kutubxona';

  @override
  String get profileGroupData => 'Maʼlumotlar';

  @override
  String get profileGroupApp => 'Ilova';

  @override
  String get profileShelves => 'Javonlar va joylar';

  @override
  String get profileCovers => 'Kitob muqovalari';

  @override
  String get profileCoversWithTitles => 'Nomlari bilan';

  @override
  String get profileCoversOnly => 'Faqat muqova';

  @override
  String get profileStatsStrip => 'Kutubxona statistikasi';

  @override
  String get profileShown => 'Koʻrsatilgan';

  @override
  String get profileHidden => 'Yashirilgan';

  @override
  String get profileImportExport => 'Import va eksport';

  @override
  String get profileStorage => 'Saqlash';

  @override
  String get profileStorageValue => 'Shu qurilmada';

  @override
  String get profileSampleLibrary => 'Namuna kutubxona';

  @override
  String get profileSampleReset => 'Tiklash';

  @override
  String get profileLanguage => 'Til';

  @override
  String get profileAppearance => 'Koʻrinish';

  @override
  String get profileAppearanceValue => 'Qogʻoz';

  @override
  String get profileShowOnboarding => 'Tanishtiruvni qayta koʻrsatish';

  @override
  String get profileVersion => 'Versiya';

  @override
  String profileFooter(String version) {
    return 'Shelf: My Book Library $version · kutubxonangiz shu qurilmada saqlanadi';
  }

  @override
  String get profileShelvesTitle => 'Javonlar va joylar';

  @override
  String get profileShelvesSubtitle =>
      'Nusxalaringiz qayerda turadi. Har bir nusxaning tahrirlash sahifasidan joyini belgilang.';

  @override
  String get profileShelvesEmpty => 'Hali joy kiritilmagan.';

  @override
  String get profileStorageTitle => 'Kutubxonangiz qayerda saqlanadi';

  @override
  String get profileStorageBody =>
      'Hammasi — kitoblar, nashrlar, nusxalar, oʻqish tarixi va istaklar roʻyxati — shu qurilmadagi mahalliy bazada saqlanadi. U internetsiz ishlaydi, doʻkonda kerak boʻlgani ham shu.\n\nIlova tarmoqqa faqat skanerlagan, ammo sizda boʻlmagan kitobni qidirish uchun murojaat qiladi. Unda ham avval ichki katalog javob beradi.';

  @override
  String get profileResetTitle => 'Namuna kutubxonaga qaytarilsinmi?';

  @override
  String get profileResetMessage =>
      'Siz qoʻshgan har bir kitob, nashr, nusxa, izoh, rasm, oʻqish yozuvi va istak oʻchiriladi va namuna toʻplam bilan almashtiriladi. Buni orqaga qaytarib boʻlmaydi.';

  @override
  String get profileResetConfirm => 'Hammasini oʻchirib, tiklash';

  @override
  String get profileLanguageTitle => 'Til';

  @override
  String get profileLanguageSubtitle =>
      'Ilovaning oʻz matnini oʻzgartiradi. Kitoblaringiz oʻz tilida qoladi.';

  @override
  String get importTitle => 'Import va eksport';

  @override
  String get importIntro =>
      'Kutubxona sizniki. Istalgan vaqtda chiqarib olishingiz mumkin.';

  @override
  String get importSectionExport => 'Eksport';

  @override
  String get importSectionImport => 'Import';

  @override
  String get importCsvLabel => 'CSV';

  @override
  String get importCsvSubtitle => 'Har bir maydon, nusxaga bitta qator';

  @override
  String get importJsonLabel => 'JSON';

  @override
  String get importJsonSubtitle =>
      'Toʻliq tuzilma — asarlar, nashrlar va nusxalar';

  @override
  String get importPrintableLabel => 'Chop etiladigan roʻyxat';

  @override
  String get importPrintableSubtitle => 'Javonlaringizning oddiy roʻyxati';

  @override
  String get importNotBuiltTitle => 'Hali tayyor emas';

  @override
  String get importNotBuiltMessage =>
      'Goodreads, LibraryThing yoki CSV fayldan import qilish rejalashtirilgan, lekin hali qilinmagan. Shu paytgacha javonni toʻldirishning eng tez yoʻli — skanerlash: shtrix-kod barcha maydonlarni oʻzi toʻldiradi.';

  @override
  String get importScanInstead => 'Oʻrniga kitob skanerlash';

  @override
  String get unknownAuthor => 'Muallif nomaʼlum';

  @override
  String get unrated => 'Baholanmagan';

  @override
  String authorsAndOthers(String first, int count) {
    return '$first va yana $count ta';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun',
      one: '1 kun',
    );
    return '$_temp0';
  }

  @override
  String get durationToday => 'bugun';

  @override
  String get locationHint => 'Har bir bosqichni › bilan ajrating';

  @override
  String get locationTapToChange => 'Oʻzgartirish uchun bosing';

  @override
  String get locationNone => 'Joy koʻrsatilmagan';

  @override
  String enrichFilledOne(String field) {
    return '$field toʻldirildi';
  }

  @override
  String enrichFilledMany(String head, String last) {
    return '$head va $last toʻldirildi';
  }

  @override
  String get enrichIsbn => 'ISBN';

  @override
  String get enrichIsbn10 => 'ISBN-10';

  @override
  String get enrichPublisher => 'nashriyot';

  @override
  String get enrichPublicationDate => 'nashr sanasi';

  @override
  String get enrichYear => 'yil';

  @override
  String get enrichLanguage => 'til';

  @override
  String get enrichFormat => 'format';

  @override
  String get enrichEditionName => 'nashr nomi';

  @override
  String get enrichPageCount => 'sahifalar soni';

  @override
  String get enrichCover => 'muqova';

  @override
  String get enrichDimensions => 'oʻlchamlar';

  @override
  String get enrichWeight => 'ogʻirlik';

  @override
  String get enrichTranslator => 'tarjimon';

  @override
  String get enrichCountry => 'mamlakat';

  @override
  String get enrichIllustrators => 'rassomlar';

  @override
  String get enrichDescription => 'tavsif';

  @override
  String get enrichOriginalTitle => 'asl nom';

  @override
  String get enrichOriginalLanguage => 'asl til';

  @override
  String get enrichSeries => 'turkum';

  @override
  String get enrichSeriesNumber => 'turkumdagi raqam';

  @override
  String get enrichFirstPublished => 'birinchi nashr';

  @override
  String get enrichGenre => 'janr';
}
