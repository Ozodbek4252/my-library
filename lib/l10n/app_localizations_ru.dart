// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppL10nRu extends AppL10n {
  AppL10nRu([String locale = 'ru']) : super(locale);

  @override
  String get languageName => 'Русский';

  @override
  String get appTitle => 'Книжная коллекция';

  @override
  String get navLibrary => 'Библиотека';

  @override
  String get navReading => 'Чтение';

  @override
  String get navScan => 'Сканер';

  @override
  String get navWishlist => 'Желаемое';

  @override
  String get navProfile => 'Профиль';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionEdit => 'Изменить';

  @override
  String get actionClear => 'Очистить';

  @override
  String get actionReset => 'Сбросить';

  @override
  String get actionTryAgain => 'Повторить';

  @override
  String get actionBackToLibrary => 'В библиотеку';

  @override
  String get actionBackToWishlist => 'К желаемому';

  @override
  String get actionScanBook => 'Сканировать книгу';

  @override
  String get actionScanBarcode => 'Сканировать штрихкод';

  @override
  String get actionAddManually => 'Добавить вручную';

  @override
  String get actionAddItManually => 'Добавить вручную';

  @override
  String get actionScanNext => 'Сканировать ещё';

  @override
  String get actionOpenBook => 'Открыть книгу';

  @override
  String get actionEnterIsbnManually => 'Ввести ISBN вручную';

  @override
  String get actionKeepIt => 'Оставить';

  @override
  String get actionNotYet => 'Не сейчас';

  @override
  String get actionShowAll => 'Показать все';

  @override
  String get actionAddBook => 'Добавить книгу';

  @override
  String get actionGoToLibrary => 'В библиотеку';

  @override
  String get onboardingHeadlineFirst => 'Все ваши книги —';

  @override
  String get onboardingHeadlineSecond => 'у вас в кармане.';

  @override
  String get onboardingSubhead =>
      'Отсканируйте штрихкод в магазине и за две секунды узнайте, есть ли книга на вашей полке.';

  @override
  String get onboardingStart => 'Начать библиотеку';

  @override
  String get onboardingScanFirst => 'Отсканировать первую книгу';

  @override
  String get libraryTitle => 'Библиотека';

  @override
  String get librarySearchHint => 'Название, автор, ISBN…';

  @override
  String get libraryStatTotal => 'Всего';

  @override
  String get libraryStatUnread => 'Не прочитано';

  @override
  String get libraryStatReading => 'Читаю';

  @override
  String get libraryStatRead => 'Прочитано';

  @override
  String libraryCountLine(int shown, int total, String sort) {
    return 'Показано $shown из $total · сортировка: $sort';
  }

  @override
  String libraryShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count полки',
      many: '$count полок',
      few: '$count полки',
      one: '1 полка',
    );
    return '$_temp0';
  }

  @override
  String get libraryEmptyTitle => 'На полках пусто';

  @override
  String get libraryEmptyMessage =>
      'Отсканируйте штрихкод книги, которая у вас есть, — остальное заполнится само.';

  @override
  String get libraryLoading => 'Открываем вашу библиотеку…';

  @override
  String get libraryErrorTitle => 'Не удалось прочитать библиотеку';

  @override
  String get libraryErrorMessage =>
      'Локальная база вернула ошибку. Потяните вниз, чтобы повторить.';

  @override
  String get libraryNoMatchesTitle => 'Ничего не найдено';

  @override
  String libraryNoMatchesFor(String query) {
    return 'В вашей библиотеке нет ничего по запросу «$query». Возможно, этой книги у вас ещё нет.';
  }

  @override
  String get libraryNoFilterMatches => 'Нет книг, подходящих под эти фильтры.';

  @override
  String get libraryClearFilters => 'Сбросить фильтры';

  @override
  String bookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count книги',
      many: '$count книг',
      few: '$count книги',
      one: '1 книга',
    );
    return '$_temp0';
  }

  @override
  String shelfCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count полки',
      many: '$count полок',
      few: '$count полки',
      one: '$count полка',
    );
    return '$_temp0';
  }

  @override
  String get filterTitle => 'Фильтр';

  @override
  String filterShowBooks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показать $count книги',
      many: 'Показать $count книг',
      few: 'Показать $count книги',
      one: 'Показать 1 книгу',
    );
    return '$_temp0';
  }

  @override
  String get filterLoadFailed => 'Не удалось загрузить фильтры.';

  @override
  String get sortTitle => 'Сортировка';

  @override
  String get groupReadingStatus => 'Статус чтения';

  @override
  String get groupLanguage => 'Язык';

  @override
  String get groupGenre => 'Жанр';

  @override
  String get groupFormat => 'Формат';

  @override
  String get groupPublisher => 'Издательство';

  @override
  String get groupAuthor => 'Автор';

  @override
  String get groupSeries => 'Серия';

  @override
  String get sortRecentlyAdded => 'Недавно добавленные';

  @override
  String get sortTitleOption => 'Название';

  @override
  String get sortAuthor => 'Автор';

  @override
  String get sortPages => 'Страницы';

  @override
  String get sortPublicationDate => 'Дата издания';

  @override
  String get sortRating => 'Оценка';

  @override
  String get statusUnread => 'Не прочитано';

  @override
  String get statusReading => 'Читаю';

  @override
  String get statusRead => 'Прочитано';

  @override
  String get statusDnf => 'Брошено';

  @override
  String get statusRereading => 'Перечитываю';

  @override
  String get statusRereadBadge => 'Перечит.';

  @override
  String get ownershipOwned => 'В наличии';

  @override
  String get ownershipWishlist => 'В желаемом';

  @override
  String get ownershipPreviouslyOwned => 'Была раньше';

  @override
  String get conditionNew => 'Новая';

  @override
  String get conditionLikeNew => 'Как новая';

  @override
  String get conditionGood => 'Хорошая';

  @override
  String get conditionAcceptable => 'Приемлемая';

  @override
  String get conditionDamaged => 'Повреждена';

  @override
  String get priorityHigh => 'Высокий';

  @override
  String get priorityMedium => 'Средний';

  @override
  String get priorityLow => 'Низкий';

  @override
  String get photoFront => 'Обложка';

  @override
  String get photoBack => 'Задняя сторона';

  @override
  String get photoSpine => 'Корешок';

  @override
  String get photoSpecialEdition => 'Особое издание';

  @override
  String get photoDamage => 'Повреждение';

  @override
  String get photoSigned => 'С автографом';

  @override
  String get searchTry => 'Попробуйте';

  @override
  String get searchRecent => 'Недавние';

  @override
  String searchInYourLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count в вашей библиотеке',
      many: '$count в вашей библиотеке',
      few: '$count в вашей библиотеке',
      one: '1 в вашей библиотеке',
    );
    return '$_temp0';
  }

  @override
  String get searchNotInLibrary => 'Нет в вашей библиотеке?';

  @override
  String get searchAllEditions => 'Искать среди всех изданий';

  @override
  String get searchAllEditionsSection => 'Все издания';

  @override
  String get searchFailed => 'Не удалось выполнить поиск.';

  @override
  String searchNoEditionsFound(String query) {
    return 'По запросу «$query» изданий не найдено.';
  }

  @override
  String get searchLookupUnreachable =>
      'Не удалось связаться со справочником книг. Ваша собственная библиотека по-прежнему полностью доступна для поиска.';

  @override
  String get searchLookupFailed => 'Поиск не удался. Попробуйте через минуту.';

  @override
  String get searchPromoTitle => 'Вы в книжном?';

  @override
  String get searchPromoSubtitle => 'Сканировать быстрее, чем набирать.';

  @override
  String get searchPromoAction => 'Сканер';

  @override
  String get scannerTitle => 'Наведите на штрихкод';

  @override
  String get scannerSubtitle => 'Обычно он на задней обложке';

  @override
  String get scannerIsbnTitle => 'Отсканируйте ISBN';

  @override
  String get scannerIsbnSubtitle => 'Номер заполним за вас';

  @override
  String get scannerSearchByTitle => 'Искать по названию';

  @override
  String get scannerEnterManually => 'Ввести вручную';

  @override
  String get scannerTypeTheNumber => 'Набрать номер';

  @override
  String get scannerLookingUp => 'Ищем…';

  @override
  String get scannerGotIt => 'Готово';

  @override
  String get scannerStartingTitle => 'Запускаем камеру…';

  @override
  String get scannerStartingMessage => 'Одну секунду.';

  @override
  String get scannerDeniedTitle => 'Доступ к камере выключен';

  @override
  String get scannerDeniedMessage =>
      'Для сканирования нужна камера. Включите её в настройках или наберите 13 цифр под штрихкодом.';

  @override
  String get scannerOpenSettings => 'Открыть настройки';

  @override
  String get scannerUnsupportedTitle => 'Камеры нет';

  @override
  String get scannerUnsupportedMessage =>
      'Это устройство не умеет сканировать штрихкоды. Книгу можно добавить по ISBN или вручную.';

  @override
  String get scannerAddByHand => 'Добавить книгу вручную';

  @override
  String get scannerFailedTitle => 'Камера не запустилась';

  @override
  String get scannerFailedMessage =>
      'При открытии камеры что-то пошло не так. Повторите или введите ISBN сами.';

  @override
  String get isbnSheetTitle => 'Введите ISBN';

  @override
  String get isbnSheetSubtitle =>
      '10 или 13 цифр, напечатанных под штрихкодом.';

  @override
  String get isbnSheetLookUp => 'Найти';

  @override
  String get isbnSheetUseNumber => 'Использовать этот номер';

  @override
  String get isbnSheetAddWithout => 'Добавить без ISBN';

  @override
  String get isbnSheetEmpty => 'Введите номер, напечатанный под штрихкодом.';

  @override
  String get isbnSheetInvalid =>
      'Это не похоже на корректный ISBN. Проверьте цифры и повторите.';

  @override
  String get isbnInvalidToast => 'Этот ISBN некорректен';

  @override
  String get scanFailBarcodeTitle => 'Не удалось прочитать штрихкод';

  @override
  String get scanFailBarcodeMessage =>
      'Мало света или код помят. Повторите или наберите 13 цифр под ним.';

  @override
  String get scanFailNotFoundTitle => 'Этот ISBN нам неизвестен';

  @override
  String scanFailNotFoundMessage(String isbn) {
    return 'По $isbn книга не найдена. Возможно, это местное издание. Её всё равно можно добавить вручную.';
  }

  @override
  String get scanFailNetworkTitle => 'Нет соединения';

  @override
  String get scanFailNetworkMessage =>
      'Не удалось связаться со справочником книг. Библиотека работает и офлайн — повторите или введите данные сами.';

  @override
  String get scanFailUnknownTitle => 'Что-то пошло не так';

  @override
  String get scanFailUnknownMessage =>
      'Поиск неожиданно не удался. Повторите или введите данные сами.';

  @override
  String get scanFailThatCode => 'этот код';

  @override
  String get scanOwnedBanner => 'Эта книга у вас уже есть';

  @override
  String get scanNewBanner => 'Ещё нет в вашей библиотеке';

  @override
  String get scanYourCopies => 'ВАШИ ЭКЗЕМПЛЯРЫ';

  @override
  String get scanScannedCopy => 'ОТСКАНИРОВАННЫЙ ЭКЗЕМПЛЯР';

  @override
  String scanEditionsOnShelves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count издания на ваших полках',
      many: '$count изданий на ваших полках',
      few: '$count издания на ваших полках',
      one: '1 издание на ваших полках',
    );
    return '$_temp0';
  }

  @override
  String get scanAddAnotherCopy => 'Добавить ещё экземпляр';

  @override
  String get scanAddAsAnotherEdition => 'Добавить как другое издание';

  @override
  String get scanAddToLibrary => 'Добавить в библиотеку';

  @override
  String get scanAddWithDetails => 'Добавить с деталями';

  @override
  String get scanWishlistIt => 'В желаемое';

  @override
  String get scanAlreadyWishlisted => 'Уже в желаемом';

  @override
  String scanWishlistNote(String month) {
    return 'В желаемом с $month — после добавления запись оттуда исчезнет.';
  }

  @override
  String scanEnrichedNote(String summary) {
    return '$summary — из этого сканирования. Ничто из введённого вами не изменилось.';
  }

  @override
  String get scanEditionMissing => 'Нет данных об издании';

  @override
  String scanCopiesSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count экземпляра',
      many: '$count экземпляров',
      few: '$count экземпляра',
      one: '$count экземпляр',
    );
    return '$_temp0';
  }

  @override
  String get toastAddedToLibrary => 'Добавлено в библиотеку';

  @override
  String get toastEditionAdded => 'Издание добавлено в библиотеку';

  @override
  String get toastAnotherCopyAdded => 'Ещё один экземпляр добавлен';

  @override
  String get toastAddedClearedWishlist =>
      'Добавлено в библиотеку · убрано из желаемого';

  @override
  String get toastAddedToWishlist => 'Добавлено в желаемое';

  @override
  String get toastChangesSaved => 'Изменения сохранены';

  @override
  String get toastCopyUpdated => 'Экземпляр обновлён';

  @override
  String get toastCopyRemoved => 'Экземпляр удалён';

  @override
  String get toastRemovedFromLibrary => 'Удалено из библиотеки';

  @override
  String toastCopyRemovedEditionsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Экземпляр удалён · осталось $count издания',
      many: 'Экземпляр удалён · осталось $count изданий',
      few: 'Экземпляр удалён · осталось $count издания',
      one: 'Экземпляр удалён · осталось 1 издание',
    );
    return '$_temp0';
  }

  @override
  String get toastMovedToLibrary => 'Перемещено в библиотеку';

  @override
  String get toastRemovedFromWishlist => 'Убрано из желаемого';

  @override
  String get toastProgressSaved => 'Прогресс сохранён';

  @override
  String toastFinished(String year) {
    return 'Прочитано · добавлено в историю $year';
  }

  @override
  String toastMarkedAs(String status) {
    return 'Отмечено: $status';
  }

  @override
  String get toastMainEditionUpdated => 'Основное издание обновлено';

  @override
  String get toastCopyAdded => 'Экземпляр добавлен в библиотеку';

  @override
  String get toastPhotoAdded => 'Фото добавлено';

  @override
  String get toastPhotoRemoved => 'Фото удалено';

  @override
  String get toastTitleRequired => 'Название обязательно';

  @override
  String get toastCouldNotSave => 'Не удалось сохранить книгу';

  @override
  String get toastCouldNotAdd => 'Не удалось добавить книгу';

  @override
  String get toastCouldNotWishlist => 'Не удалось добавить в желаемое';

  @override
  String get toastCouldNotOpenPhotos => 'Не удалось открыть галерею';

  @override
  String get toastCouldNotOpenCamera => 'Не удалось открыть камеру';

  @override
  String get toastCouldNotOpenPictures => 'Не удалось открыть ваши изображения';

  @override
  String get toastCouldNotOpenCropper => 'Не удалось открыть кадрирование';

  @override
  String toastFilledFromIsbn(String title) {
    return 'Заполнено из «$title»';
  }

  @override
  String get toastIsbnNotFound => 'Этот ISBN нам неизвестен — заполните сами';

  @override
  String get toastIsbnOffline => 'Нет соединения — заполните сами';

  @override
  String get toastIsbnLookupFailed => 'Поиск не удался — заполните сами';

  @override
  String get toastSampleRestored => 'Демо-библиотека восстановлена';

  @override
  String toastExported(String file) {
    return 'Экспортировано: $file';
  }

  @override
  String get toastExportFailed =>
      'Экспорт не удался — не получилось записать файл';

  @override
  String get addBookTitle => 'Добавить книгу';

  @override
  String get addEditionTitle => 'Добавить издание';

  @override
  String get editBookTitle => 'Изменить книгу';

  @override
  String get editCopyTitle => 'Изменить экземпляр';

  @override
  String get editCopyNotFoundTitle => 'Экземпляр не найден';

  @override
  String get editCopyNotFoundMessage =>
      'Этого экземпляра больше нет в вашей библиотеке.';

  @override
  String get sectionTheBook => 'Книга';

  @override
  String get sectionThisEdition => 'Это издание';

  @override
  String get sectionStatus => 'Статус';

  @override
  String get sectionRating => 'Оценка';

  @override
  String get sectionOwnership => 'Владение';

  @override
  String get sectionPurchase => 'Покупка';

  @override
  String get sectionCondition => 'Состояние';

  @override
  String get sectionLocation => 'Расположение';

  @override
  String get sectionTags => 'Теги';

  @override
  String get sectionPersonalNotes => 'Личные заметки';

  @override
  String get sectionEditionYouOwn => 'Ваше издание';

  @override
  String get sectionMyCopy => 'Мой экземпляр';

  @override
  String get sectionPersonalNote => 'Личная заметка';

  @override
  String get sectionPhotosOfMyCopy => 'Фото моего экземпляра';

  @override
  String get sectionWhatIWant => 'Что я хочу';

  @override
  String get sectionNote => 'Заметка';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldAuthor => 'Автор';

  @override
  String get fieldOriginalTitle => 'Оригинальное название';

  @override
  String get fieldOriginalLanguage => 'Язык оригинала';

  @override
  String get fieldGenre => 'Жанр';

  @override
  String get fieldSeries => 'Серия';

  @override
  String get fieldFirstPublished => 'Первое издание';

  @override
  String get fieldDescription => 'Описание';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldIsbn10 => 'ISBN-10';

  @override
  String get fieldLanguage => 'Язык';

  @override
  String get fieldPublisher => 'Издательство';

  @override
  String get fieldEdition => 'Издание';

  @override
  String get fieldFormat => 'Формат';

  @override
  String get fieldPublished => 'Издано';

  @override
  String get fieldPages => 'Страниц';

  @override
  String get fieldCountry => 'Страна';

  @override
  String get fieldTranslator => 'Переводчик';

  @override
  String get fieldIllustrators => 'Иллюстраторы';

  @override
  String get fieldDimensions => 'Размеры';

  @override
  String get fieldWeight => 'Вес';

  @override
  String weightGrams(int grams) {
    return '$grams г';
  }

  @override
  String get fieldPurchased => 'Куплено';

  @override
  String get fieldPrice => 'Цена';

  @override
  String get fieldWhere => 'Где';

  @override
  String get fieldStore => 'Магазин';

  @override
  String get fieldGift => 'Подарок';

  @override
  String get fieldGiftFrom => 'Подарок от';

  @override
  String get fieldCurrency => 'Валюта';

  @override
  String get fieldDate => 'Дата';

  @override
  String get fieldAdded => 'Добавлено';

  @override
  String get fieldPriority => 'Приоритет';

  @override
  String get fieldCover => 'Обложка';

  @override
  String get hintRequired => 'Обязательно';

  @override
  String get hintAuthors => 'Несколько — через запятую';

  @override
  String get hintGenres => 'Художественная, История…';

  @override
  String get hintFormats => 'Мягкая обложка, Твёрдая обложка…';

  @override
  String get hintIsbn => '978…';

  @override
  String get hintNotRecorded => 'Не указано';

  @override
  String get hintChoose => 'Выбрать';

  @override
  String get hintWhereBought => 'Где вы её купили';

  @override
  String get hintBlankIfPurchased => 'Оставьте пустым, если куплено';

  @override
  String get hintTags => 'антиутопия, перечитано';

  @override
  String get hintNotes => 'Что стоит помнить об этом экземпляре…';

  @override
  String get hintLocation => 'Дом › Спальня › Шкаф 2 › Полка 4';

  @override
  String get coverSheetTitle => 'Обложка';

  @override
  String get coverSheetSubtitle =>
      'Сфотографируйте книгу или выберите готовое изображение. Дальше вы её кадрируете — тяните любой край или начните с 2:3, в котором показывается обложка.';

  @override
  String get coverTakePhoto => 'Сделать фото';

  @override
  String get coverChoosePicture => 'Выбрать изображение';

  @override
  String get coverAdjustCrop => 'Изменить кадрирование';

  @override
  String get coverRemove => 'Удалить обложку';

  @override
  String get coverCropTitle => 'Кадрируйте обложку';

  @override
  String get coverCropUse => 'Применить';

  @override
  String get addFillFromIsbn => 'Заполнить по ISBN';

  @override
  String get addLookingUp => 'Ищем…';

  @override
  String get addScanHint =>
      'Нажмите на обложку, чтобы сфотографировать книгу. Сканирование заполняет все поля ниже автоматически.';

  @override
  String get addScanInstead => 'Сканировать →';

  @override
  String get addEditHint =>
      'Нажмите на обложку, чтобы сфотографировать это издание. Изменения здесь относятся к книге и изданию на её странице; данные о покупке хранятся в экземпляре.';

  @override
  String get addSaveChanges => 'Сохранить изменения';

  @override
  String get addToWishlist => 'Добавить в желаемое';

  @override
  String get scanIsbnSemantic => 'Отсканировать ISBN';

  @override
  String get shareTitle => 'Поделиться этой книгой?';

  @override
  String shareMessage(String isbn) {
    return 'Ни один справочник не знает $isbn. Если отправить название, автора и данные издания, которые вы только что ввели, следующий человек сможет найти эту книгу. Ваши заметки, покупки и полки не отправляются никогда.';
  }

  @override
  String get shareConfirm => 'Поделиться';

  @override
  String get shareCancel => 'Оставить себе';

  @override
  String get shareOffline =>
      'Не удалось связаться с базой книг — ваша книга всё равно сохранена';

  @override
  String get shareRejected => 'База книг не приняла запись';

  @override
  String get detailsErrorTitle => 'Не удалось открыть книгу';

  @override
  String get detailsErrorMessage =>
      'При чтении из вашей библиотеки что-то пошло не так.';

  @override
  String get detailsRemovedTitle => 'Больше нет в вашей библиотеке';

  @override
  String get detailsRemovedMessage => 'Эта книга удалена.';

  @override
  String get detailsNoEdition => 'Издание пока не указано.';

  @override
  String get detailsUpdateProgress => 'Обновить прогресс';

  @override
  String detailsPagesOf(int current, int total) {
    return '$current из $total страниц';
  }

  @override
  String detailsPageOnly(int current) {
    return 'Страница $current';
  }

  @override
  String detailsEditionsOfWork(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count издания этого произведения',
      many: '$count изданий этого произведения',
      few: '$count издания этого произведения',
      one: '1 издание этого произведения',
    );
    return '$_temp0';
  }

  @override
  String get detailsAddAnotherCopyOrTranslation =>
      'Добавьте ещё экземпляр или перевод';

  @override
  String get detailsMenuEditBook => 'Изменить данные книги';

  @override
  String get detailsMenuAllEditions => 'Все издания произведения';

  @override
  String get detailsMenuEditCopy => 'Изменить этот экземпляр';

  @override
  String get detailsRemoveCopy => 'Удалить этот экземпляр';

  @override
  String detailsGiftFrom(String name) {
    return 'От $name';
  }

  @override
  String get detailsGiftPurchased => 'Куплено';

  @override
  String get detailsGiftAFriend => 'друга';

  @override
  String detailsBookNumber(int number) {
    return 'Книга $number';
  }

  @override
  String get detailsNotRated => 'Без оценки';

  @override
  String get detailsSeriesLabel => 'Серия';

  @override
  String get photoSheetTitle => 'Добавить фото';

  @override
  String get photoSheetSubtitle =>
      'Фото вашего экземпляра хранятся отдельно от официальной обложки.';

  @override
  String get photoDeleteTitle => 'Удалить это фото?';

  @override
  String photoDeleteMessage(String type) {
    return 'Фото «$type» вашего экземпляра будет удалено. Книга и её данные останутся.';
  }

  @override
  String get photoDeleteConfirm => 'Удалить фото';

  @override
  String get removeCopyTitle => 'Удалить этот экземпляр?';

  @override
  String removeCopyMessage(String descriptor, String title, String survives) {
    return 'Ваш экземпляр «$title» ($descriptor) будет удалён вместе с данными о покупке и фотографиями. $survives';
  }

  @override
  String get removeCopyConfirm => 'Удалить экземпляр';

  @override
  String get survivesOtherCopy =>
      'Ваш другой экземпляр этого издания останется.';

  @override
  String survivesOtherEditions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ваши другие $count издания останутся.',
      many: 'Ваши другие $count изданий останутся.',
      few: 'Ваши другие $count издания останутся.',
      one: 'Ваше другое издание останется.',
    );
    return '$_temp0';
  }

  @override
  String get survivesNothing =>
      'Книга будет полностью удалена из вашей библиотеки.';

  @override
  String get editionsExplainerOne =>
      'Одно произведение, один экземпляр. Статус чтения принадлежит произведению, всё остальное — экземпляру.';

  @override
  String editionsExplainerMany(String copies, String editions) {
    return 'Одно произведение, $copies в $editions. Статус чтения принадлежит произведению, всё остальное — экземпляру.';
  }

  @override
  String editionsCopyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count экземпляра',
      many: '$count экземпляров',
      few: '$count экземпляра',
      one: '1 экземпляр',
    );
    return '$_temp0';
  }

  @override
  String editionsEditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изданиях',
      many: '$count изданиях',
      few: '$count изданиях',
      one: '1 издании',
    );
    return '$_temp0';
  }

  @override
  String get editionsErrorMessage =>
      'Не удалось прочитать эти издания из вашей библиотеки.';

  @override
  String get editionsAddAnother => '+ Добавить ещё издание';

  @override
  String get editionsReadingCopy => 'Читаемый экземпляр';

  @override
  String get editionsGiftTag => 'Подарок';

  @override
  String get editionsShowAsMain => 'Сделать основным';

  @override
  String get editionsAddAnotherCopy => 'Добавить ещё экземпляр';

  @override
  String get editionsNotOwnedYet => 'Пока нет у вас';

  @override
  String get editionsUnknownLanguage => 'Язык неизвестен';

  @override
  String editionsFirstPublished(int year) {
    return 'первое издание $year';
  }

  @override
  String editionsFromPerson(String name) {
    return 'от $name';
  }

  @override
  String get editionsAddCopyTitle => 'Добавить ещё экземпляр?';

  @override
  String editionsAddCopyMessage(String format) {
    return 'Второй экземпляр ($format) будет добавлен на ваши полки. Откуда он взялся, можно указать позже.';
  }

  @override
  String get editionsAddCopyConfirm => 'Добавить экземпляр';

  @override
  String get editionsGenericFormat => 'издание';

  @override
  String editionsPagesShort(int count) {
    return '$count с.';
  }

  @override
  String get readingTitle => 'Чтение';

  @override
  String get readingTabNow => 'Читаю сейчас';

  @override
  String get readingTabHistory => 'История';

  @override
  String get readingUpNext => 'Следующие · с ваших полок';

  @override
  String get readingUpdatePage => 'Обновить страницу';

  @override
  String get readingMarkFinished => 'Отметить прочитанной';

  @override
  String get readingEmptyTitle => 'Сейчас ничего не читается';

  @override
  String get readingEmptyWithShelves =>
      'Выберите что-нибудь с полок и поставьте статус «Читаю».';

  @override
  String get readingEmptyNoShelves =>
      'Добавьте книгу в библиотеку и поставьте статус «Читаю», чтобы следить за прогрессом здесь.';

  @override
  String get readingErrorMessage => 'Не удалось загрузить текущее чтение.';

  @override
  String get readingHistoryError => 'Не удалось загрузить историю чтения.';

  @override
  String get readingHistoryEmptyTitle => 'Прочитанных книг пока нет';

  @override
  String get readingHistoryEmptyMessage =>
      'Когда вы отметите книгу прочитанной, она появится здесь, сгруппированная по месяцу завершения.';

  @override
  String readingReadInYear(int year) {
    return 'Прочитано в $year';
  }

  @override
  String get readingPagesLabel => 'Страниц';

  @override
  String get readingAvgRating => 'Средняя оценка';

  @override
  String readingPagesOf(int current, int total) {
    return '$current / $total страниц';
  }

  @override
  String get readingPagesRead => 'страниц прочитано';

  @override
  String readingStartedOn(String date) {
    return 'Начато $date';
  }

  @override
  String get readingNotStarted => 'Ещё не начато';

  @override
  String readingDaysIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '1 день',
    );
    return '$_temp0';
  }

  @override
  String get readingToday => 'сегодня';

  @override
  String readingFinishedOn(String date) {
    return 'Прочитано $date';
  }

  @override
  String progressStarted(String date) {
    return 'Начато $date';
  }

  @override
  String progressPagesTotal(int count) {
    return '$count страниц';
  }

  @override
  String progressPercentToGo(int percent, int left) {
    return '$percent% · осталось $left страниц';
  }

  @override
  String get progressNoPageCount =>
      'Укажите число страниц у этого издания, чтобы видеть проценты';

  @override
  String get progressPlusTen => '+10 страниц';

  @override
  String get progressSave => 'Сохранить прогресс';

  @override
  String get progressFinished => 'Прочитал';

  @override
  String get progressGone => 'Этой книги больше нет в вашей библиотеке.';

  @override
  String get wishlistTitle => 'Желаемое';

  @override
  String wishlistHighPriority(int count) {
    return '$count с высоким приоритетом';
  }

  @override
  String wishlistAll(int count) {
    return 'Все $count';
  }

  @override
  String get wishlistErrorMessage => 'Не удалось загрузить список желаемого.';

  @override
  String get wishlistEmptyTitle => 'Список пока пуст';

  @override
  String get wishlistEmptyMessage =>
      'Отсканируйте книгу, которую хотите, но пока не имеете, — она попадёт сюда, а не на полки.';

  @override
  String get wishlistNoFilterTitle => 'Ничего не подходит';

  @override
  String get wishlistNoFilterMessage => 'Попробуйте другой фильтр.';

  @override
  String get wishlistDetailError => 'Не удалось загрузить эту запись.';

  @override
  String get wishlistRemovedTitle => 'Больше нет в желаемом';

  @override
  String get wishlistRemovedMessage => 'Эта запись удалена.';

  @override
  String get wishlistBadge => 'ЖЕЛАЕМОЕ';

  @override
  String wishlistAddedOn(String date) {
    return 'Добавлено $date';
  }

  @override
  String get wishlistNotePlaceholder =>
      'Нажмите, чтобы добавить заметку о нужном издании.';

  @override
  String get wishlistBought => 'Купил — перенести в библиотеку';

  @override
  String get wishlistRemove => 'Убрать из желаемого';

  @override
  String get wishlistMoveTitle => 'Перенести в библиотеку?';

  @override
  String wishlistMoveMessage(String title) {
    return '«$title» будет добавлена на ваши полки как ваш экземпляр и убрана из желаемого. Данные об издании и покупке можно заполнить дальше.';
  }

  @override
  String get wishlistMoveConfirm => 'Добавить в библиотеку';

  @override
  String get wishlistRemoveTitle => 'Убрать из желаемого?';

  @override
  String wishlistRemoveMessage(String title) {
    return '«$title» будет убрана из желаемого вместе с нужным изданием и вашей заметкой. Библиотеки это не затронет.';
  }

  @override
  String get wishlistRemoveConfirm => 'Убрать из желаемого';

  @override
  String get wishlistDesiredLanguage => 'Желаемый язык';

  @override
  String get wishlistDesiredFormat => 'Желаемый формат';

  @override
  String get wishlistDesiredEdition => 'Желаемое издание';

  @override
  String get statsThisYear => 'Этот год';

  @override
  String statsRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statsBooksRead => 'Книг прочитано за год';

  @override
  String get statsPagesRead => 'Страниц прочитано';

  @override
  String get statsCurrentlyReading => 'Читаю сейчас';

  @override
  String get statsAverageRating => 'Средняя оценка';

  @override
  String get statsBooksPerMonth => 'Книг завершено по месяцам';

  @override
  String get statsByLanguage => 'По языкам';

  @override
  String get statsByGenre => 'По жанрам';

  @override
  String get statsMostReadAuthors => 'Самые читаемые авторы';

  @override
  String statsBestMonth(String month, String books, String pages) {
    return 'Лучший месяц: $month, $books · $pages страниц';
  }

  @override
  String get statsNoneYet => 'В этом году прочитанных книг пока нет.';

  @override
  String get statsEmptyTitle => 'Прочитанных книг пока нет';

  @override
  String get statsEmptyMessage =>
      'Отметьте книгу прочитанной, и цифры начнут заполняться. Здесь ничего не выдумано — всё с ваших полок.';

  @override
  String get statsError => 'Не удалось посчитать статистику.';

  @override
  String get statsOther => 'Другие';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileMyLibrary => 'Моя библиотека';

  @override
  String get profileReadingStatistics => 'Статистика чтения';

  @override
  String profileStatsSubtitle(String books, String pages) {
    return '$books за год · $pages страниц';
  }

  @override
  String get profileStatsFallback => 'Посчитано по вашему журналу чтения';

  @override
  String get profileGroupLibrary => 'Библиотека';

  @override
  String get profileGroupData => 'Данные';

  @override
  String get profileGroupApp => 'Приложение';

  @override
  String get profileShelves => 'Полки и места';

  @override
  String get profileCovers => 'Обложки книг';

  @override
  String get profileCoversWithTitles => 'С названиями';

  @override
  String get profileCoversOnly => 'Только обложки';

  @override
  String get profileStatsStrip => 'Строка статистики';

  @override
  String get profileShown => 'Показана';

  @override
  String get profileHidden => 'Скрыта';

  @override
  String get profileImportExport => 'Импорт и экспорт';

  @override
  String get profileStorage => 'Хранение';

  @override
  String get profileStorageValue => 'На этом устройстве';

  @override
  String get profileSampleLibrary => 'Демо-библиотека';

  @override
  String get profileSampleReset => 'Сбросить';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileAppearance => 'Оформление';

  @override
  String get profileAppearanceValue => 'Бумага';

  @override
  String get profileShowOnboarding => 'Показать вступление снова';

  @override
  String get profileVersion => 'Версия';

  @override
  String profileFooter(String version) {
    return 'Book Collection $version · ваша библиотека хранится на устройстве';
  }

  @override
  String get profileShelvesTitle => 'Полки и места';

  @override
  String get profileShelvesSubtitle =>
      'Где лежат ваши экземпляры. Место задаётся на странице редактирования экземпляра.';

  @override
  String get profileShelvesEmpty => 'Места пока не указаны.';

  @override
  String get profileStorageTitle => 'Где хранится ваша библиотека';

  @override
  String get profileStorageBody =>
      'Всё — книги, издания, экземпляры, история чтения и список желаемого — хранится в локальной базе на этом устройстве. Она работает без связи, что и нужно в книжном магазине.\n\nВ сеть приложение выходит только чтобы найти книгу, которую вы отсканировали, но не имеете. Да и тогда сперва отвечает встроенный каталог.';

  @override
  String get profileResetTitle => 'Вернуть демо-библиотеку?';

  @override
  String get profileResetMessage =>
      'Каждая добавленная вами книга, издание, экземпляр, заметка, фото, запись о чтении и желаемое будут удалены и заменены демо-коллекцией. Это нельзя отменить.';

  @override
  String get profileResetConfirm => 'Удалить всё и сбросить';

  @override
  String get profileLanguageTitle => 'Язык';

  @override
  String get profileLanguageSubtitle =>
      'Меняет язык самого приложения. Ваши книги остаются на своих языках.';

  @override
  String get importTitle => 'Импорт и экспорт';

  @override
  String get importIntro => 'Библиотека ваша. Забрать её можно в любой момент.';

  @override
  String get importSectionExport => 'Экспорт';

  @override
  String get importSectionImport => 'Импорт';

  @override
  String get importCsvLabel => 'CSV';

  @override
  String get importCsvSubtitle => 'Все поля, по строке на экземпляр';

  @override
  String get importJsonLabel => 'JSON';

  @override
  String get importJsonSubtitle =>
      'Полная структура — произведения, издания и экземпляры';

  @override
  String get importPrintableLabel => 'Список для печати';

  @override
  String get importPrintableSubtitle => 'Простой список ваших полок';

  @override
  String get importNotBuiltTitle => 'Пока не сделано';

  @override
  String get importNotBuiltMessage =>
      'Импорт из Goodreads, LibraryThing или CSV запланирован, но ещё не готов. Пока самый быстрый способ наполнить полку — сканирование: штрихкод заполняет все поля за вас.';

  @override
  String get importScanInstead => 'Отсканировать книгу';

  @override
  String get unknownAuthor => 'Автор неизвестен';

  @override
  String get unrated => 'Без оценки';

  @override
  String authorsAndOthers(String first, int count) {
    return '$first и ещё $count';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '1 день',
    );
    return '$_temp0';
  }

  @override
  String get durationToday => 'сегодня';

  @override
  String get locationHint => 'Разделяйте уровни знаком ›';

  @override
  String get locationTapToChange => 'Нажмите, чтобы изменить';

  @override
  String get locationNone => 'Место не указано';

  @override
  String enrichFilledOne(String field) {
    return 'Заполнено: $field';
  }

  @override
  String enrichFilledMany(String head, String last) {
    return 'Заполнено: $head и $last';
  }

  @override
  String get enrichIsbn => 'ISBN';

  @override
  String get enrichIsbn10 => 'ISBN-10';

  @override
  String get enrichPublisher => 'издательство';

  @override
  String get enrichPublicationDate => 'дата издания';

  @override
  String get enrichYear => 'год';

  @override
  String get enrichLanguage => 'язык';

  @override
  String get enrichFormat => 'формат';

  @override
  String get enrichEditionName => 'название издания';

  @override
  String get enrichPageCount => 'число страниц';

  @override
  String get enrichCover => 'обложка';

  @override
  String get enrichDimensions => 'размеры';

  @override
  String get enrichWeight => 'вес';

  @override
  String get enrichTranslator => 'переводчик';

  @override
  String get enrichCountry => 'страна';

  @override
  String get enrichIllustrators => 'иллюстраторы';

  @override
  String get enrichDescription => 'описание';

  @override
  String get enrichOriginalTitle => 'оригинальное название';

  @override
  String get enrichOriginalLanguage => 'язык оригинала';

  @override
  String get enrichSeries => 'серия';

  @override
  String get enrichSeriesNumber => 'номер в серии';

  @override
  String get enrichFirstPublished => 'первое издание';

  @override
  String get enrichGenre => 'жанр';
}
