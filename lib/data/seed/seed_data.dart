import '../../domain/models/enums.dart';

/// One book the sample library starts with, described by the catalogue ISBN it
/// points at. Metadata is never repeated here — it comes from the catalogue,
/// exactly as it would from a real lookup.
class SeedBook {
  const SeedBook({
    required this.catalogKey,
    this.status = ReadingStatus.unread,
    this.rating,
    this.currentPage = 0,
    this.startedDaysAgo,
    this.finishedAtFraction,
    this.readingDays,
    this.ownership = Ownership.owned,
    this.copies = const [SeedCopy()],
    this.sameWorkAs,
  });

  /// Key into the bundled catalogue.
  final String catalogKey;

  final ReadingStatus status;
  final double? rating;
  final int currentPage;
  final int? startedDaysAgo;

  /// Where in the current year this read finished, as a fraction of the time
  /// elapsed since 1 January. Keeps the sample statistics meaningful whatever
  /// day the app is first opened.
  final double? finishedAtFraction;
  final int? readingDays;

  final Ownership ownership;
  final List<SeedCopy> copies;

  /// Set when this edition belongs to a work seeded earlier — a second
  /// translation or printing of a book already on the shelves.
  final String? sameWorkAs;
}

class SeedCopy {
  const SeedCopy({
    this.purchasedDaysAgo,
    this.price,
    this.currency,
    this.store,
    this.isGift = false,
    this.giftFrom,
    this.condition = Condition.good,
    this.location,
    this.notes,
    this.tags = const [],
  });

  final int? purchasedDaysAgo;
  final double? price;
  final String? currency;
  final String? store;
  final bool isGift;
  final String? giftFrom;
  final Condition condition;
  final String? location;
  final String? notes;
  final List<String> tags;
}

class SeedWish {
  const SeedWish({
    required this.catalogKey,
    required this.priority,
    this.desiredLanguage,
    this.desiredFormat,
    this.desiredEdition,
    this.notes,
    this.addedDaysAgo = 30,
  });

  final String catalogKey;
  final Priority priority;
  final String? desiredLanguage;
  final String? desiredFormat;
  final String? desiredEdition;
  final String? notes;
  final int addedDaysAgo;
}

const seedBooks = <SeedBook>[
  SeedBook(
    catalogKey: '1984_penguin',
    status: ReadingStatus.read,
    rating: 5,
    finishedAtFraction: .85,
    readingDays: 9,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 1030,
        price: 8.99,
        currency: 'GBP',
        store: 'Daunt Books, Marylebone',
        condition: Condition.good,
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 4',
        notes: 'Second reading. The appendix on Newspeak is the whole '
            'argument — read it first next time.',
        tags: ['dystopia', 're-read', 'annotated', 'university'],
      ),
    ],
  ),
  // Same work, different edition — the case a scan must never call a duplicate.
  SeedBook(
    catalogKey: '1984_ast',
    sameWorkAs: '1984_penguin',
    copies: [
      SeedCopy(
        purchasedDaysAgo: 240,
        isGift: true,
        giftFrom: 'Ilya',
        condition: Condition.likeNew,
        location: 'Home › Study › Bookshelf 1 › Shelf 1',
        notes: 'Подарок на день рождения. Перевод Голышева читается совсем '
            'иначе, чем оригинал.',
        tags: ['dystopia', 'gift'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'atomic',
    status: ReadingStatus.reading,
    currentPage: 237,
    startedDaysAgo: 26,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 34,
        price: 16.99,
        currency: 'GBP',
        store: 'Waterstones, Piccadilly',
        condition: Condition.newCondition,
        location: 'Home › Living room › Side table',
        tags: ['habits'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'master',
    status: ReadingStatus.reading,
    currentPage: 118,
    startedDaysAgo: 69,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 300,
        price: 1290,
        currency: 'RUB',
        store: 'Фаланстер, Москва',
        condition: Condition.newCondition,
        location: 'Home › Study › Bookshelf 1 › Shelf 2',
        notes: 'Читаю медленно, по главе за вечер.',
        tags: ['russian', 'slow-read'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'dispossessed',
    status: ReadingStatus.read,
    rating: 5,
    finishedAtFraction: .71,
    readingDays: 12,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 690,
        price: 9.99,
        currency: 'GBP',
        store: 'Foyles, Charing Cross Road',
        location: 'Home › Study › Bookshelf 1 › Shelf 3',
        tags: ['sf-masterworks', 'utopia'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'pachinko',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .93,
    readingDays: 16,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 420,
        price: 9.99,
        currency: 'GBP',
        store: 'Blackwell\'s, Oxford',
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 3',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'sweetgrass',
    copies: [
      SeedCopy(
        purchasedDaysAgo: 95,
        price: 10.99,
        currency: 'GBP',
        store: 'Daunt Books, Marylebone',
        condition: Condition.newCondition,
        location: 'Home › Living room › Bookshelf 3 › Shelf 1',
        tags: ['nature', 'to-read-slowly'],
      ),
    ],
  ),
  // Two copies of one edition — a reading copy and a spare kept for lending.
  SeedBook(
    catalogKey: 'meditations',
    status: ReadingStatus.rereading,
    rating: 5,
    currentPage: 64,
    startedDaysAgo: 11,
    finishedAtFraction: .98,
    readingDays: 21,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 1400,
        price: 12.99,
        currency: 'GBP',
        store: 'Hatchards, Piccadilly',
        condition: Condition.acceptable,
        location: 'Home › Bedroom › Nightstand',
        notes: 'Spine cracked, corners soft. The one I actually read.',
        tags: ['stoicism', 're-read'],
      ),
      SeedCopy(
        purchasedDaysAgo: 200,
        isGift: true,
        giftFrom: 'Dad',
        condition: Condition.newCondition,
        location: 'Home › Study › Bookshelf 1 › Shelf 4',
        notes: 'Still shrink-wrapped.',
        tags: ['stoicism', 'gift'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'klara',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .66,
    readingDays: 6,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 610,
        price: 20,
        currency: 'GBP',
        store: 'Daunt Books, Marylebone',
        location: 'Home › Living room › Bookshelf 3 › Shelf 2',
        tags: ['signed'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'balance',
    copies: [
      SeedCopy(
        purchasedDaysAgo: 140,
        price: 4,
        currency: 'GBP',
        store: 'Oxfam Books, Bloomsbury',
        condition: Condition.acceptable,
        location: 'Home › Study › Bookshelf 1 › Shelf 3',
        tags: ['secondhand'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'sapiens',
    status: ReadingStatus.read,
    rating: 3,
    finishedAtFraction: .78,
    readingDays: 22,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 900,
        price: 10.99,
        currency: 'GBP',
        store: 'Airport, Heathrow T5',
        location: 'Home › Living room › Bookshelf 3 › Shelf 3',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'wolfhall',
    status: ReadingStatus.dnf,
    currentPage: 190,
    startedDaysAgo: 300,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 330,
        price: 9.99,
        currency: 'GBP',
        store: 'Waterstones, Gower Street',
        location: 'Home › Study › Bookshelf 1 › Shelf 3',
        notes: 'Put it down at the Anne Boleyn chapters. Will come back to it.',
        tags: ['abandoned-for-now'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'brilliant_it',
    copies: [
      SeedCopy(
        purchasedDaysAgo: 60,
        price: 18,
        currency: 'EUR',
        store: 'Libreria Feltrinelli, Napoli',
        condition: Condition.newCondition,
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 1',
        notes: 'Comprato a Napoli, dove è ambientato. Leggerlo in italiano.',
        tags: ['italian', 'napoli'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'newname',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .19,
    readingDays: 11,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 500,
        price: 12.99,
        currency: 'GBP',
        store: 'London Review Bookshop',
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 1',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'lefthand',
    status: ReadingStatus.read,
    rating: 5,
    finishedAtFraction: .26,
    readingDays: 7,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 640,
        price: 9.99,
        currency: 'GBP',
        store: 'Foyles, Charing Cross Road',
        location: 'Home › Study › Bookshelf 1 › Shelf 3',
        tags: ['sf-masterworks'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'neverletmego',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .61,
    readingDays: 5,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 800,
        price: 8.99,
        currency: 'GBP',
        store: 'Waterstones, Gower Street',
        location: 'Home › Living room › Bookshelf 3 › Shelf 2',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'norwegian',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .55,
    readingDays: 9,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 1200,
        condition: Condition.acceptable,
        isGift: true,
        giftFrom: 'Sara',
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 3',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'selevi',
    status: ReadingStatus.read,
    rating: 5,
    finishedAtFraction: .41,
    readingDays: 4,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 380,
        price: 12,
        currency: 'EUR',
        store: 'Libreria Feltrinelli, Torino',
        location: 'Home › Study › Bookshelf 1 › Shelf 2',
        tags: ['italian'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'podpolya',
    copies: [
      SeedCopy(
        purchasedDaysAgo: 150,
        price: 640,
        currency: 'RUB',
        store: 'Подписные издания, Санкт-Петербург',
        condition: Condition.newCondition,
        location: 'Home › Study › Bookshelf 1 › Shelf 2',
        tags: ['russian'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'maladies',
    status: ReadingStatus.dnf,
    currentPage: 240,
    startedDaysAgo: 420,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 450,
        price: 11.99,
        currency: 'GBP',
        store: 'Blackwell\'s, Oxford',
        location: 'Home › Living room › Bookshelf 3 › Shelf 3',
        notes: 'Excellent, but heavy going after the chemotherapy chapters.',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'thinking',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .11,
    readingDays: 30,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 1100,
        price: 10.99,
        currency: 'GBP',
        store: 'Amazon',
        location: 'Home › Living room › Bookshelf 3 › Shelf 3',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'circe',
    status: ReadingStatus.read,
    rating: 5,
    finishedAtFraction: .04,
    readingDays: 6,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 720,
        price: 16.99,
        currency: 'GBP',
        store: 'Hatchards, Piccadilly',
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 2',
        tags: ['mythology'],
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'hamnet',
    status: ReadingStatus.read,
    rating: 4,
    finishedAtFraction: .48,
    readingDays: 8,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 560,
        price: 8.99,
        currency: 'GBP',
        store: 'Waterstones, Piccadilly',
        location: 'Home › Bedroom › Bookshelf 2 › Shelf 2',
      ),
    ],
  ),
  SeedBook(
    catalogKey: 'alchemist',
    status: ReadingStatus.read,
    rating: 2,
    ownership: Ownership.previouslyOwned,
    finishedAtFraction: .34,
    readingDays: 3,
    copies: [
      SeedCopy(
        purchasedDaysAgo: 2000,
        condition: Condition.acceptable,
        location: 'Given away',
        notes: 'Passed it on to a friend. Did not need to keep it.',
      ),
    ],
  ),
];

const seedWishes = <SeedWish>[
  SeedWish(
    catalogKey: 'overstory_norton',
    priority: Priority.high,
    desiredLanguage: 'English',
    desiredFormat: 'Hardcover',
    desiredEdition: 'Norton, first printing',
    notes: 'Only the Norton hardback — the paperback typesetting is cramped. '
        'Saw a copy at Daunt, Marylebone.',
    addedDaysAgo: 209,
  ),
  SeedWish(
    catalogKey: 'piranesi',
    priority: Priority.high,
    desiredLanguage: 'English',
    desiredFormat: 'Any format',
    notes: 'Everyone who has read it says the less I know going in, the better.',
    addedDaysAgo: 240,
  ),
  SeedWish(
    catalogKey: 'solaris',
    priority: Priority.medium,
    desiredLanguage: 'Polish',
    desiredFormat: 'Paperback',
    desiredEdition: 'Wydawnictwo Literackie',
    notes: 'The English translations all go through the French. Worth learning '
        'enough Polish for.',
    addedDaysAgo: 120,
  ),
  SeedWish(
    catalogKey: 'austerlitz',
    priority: Priority.medium,
    desiredLanguage: 'English',
    desiredFormat: 'Paperback',
    desiredEdition: 'Penguin Modern Classics',
    addedDaysAgo: 88,
  ),
  SeedWish(
    catalogKey: 'flights',
    priority: Priority.low,
    desiredLanguage: 'English',
    desiredFormat: 'Paperback',
    desiredEdition: 'Fitzcarraldo Editions',
    notes: 'The blue Fitzcarraldo one, not the American cover.',
    addedDaysAgo: 45,
  ),
];
