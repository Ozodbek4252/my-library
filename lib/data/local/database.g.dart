// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorksTable extends Works with TableInfo<$WorksTable, Work> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> authors =
      GeneratedColumn<String>(
        'authors',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($WorksTable.$converterauthors);
  static const VerificationMeta _originalTitleMeta = const VerificationMeta(
    'originalTitle',
  );
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
    'original_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> genres =
      GeneratedColumn<String>(
        'genres',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($WorksTable.$convertergenres);
  static const VerificationMeta _seriesNameMeta = const VerificationMeta(
    'seriesName',
  );
  @override
  late final GeneratedColumn<String> seriesName = GeneratedColumn<String>(
    'series_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesIndexMeta = const VerificationMeta(
    'seriesIndex',
  );
  @override
  late final GeneratedColumn<int> seriesIndex = GeneratedColumn<int>(
    'series_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstPublishedMeta = const VerificationMeta(
    'firstPublished',
  );
  @override
  late final GeneratedColumn<int> firstPublished = GeneratedColumn<int>(
    'first_published',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryEditionIdMeta = const VerificationMeta(
    'primaryEditionId',
  );
  @override
  late final GeneratedColumn<String> primaryEditionId = GeneratedColumn<String>(
    'primary_edition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readingStatusMeta = const VerificationMeta(
    'readingStatus',
  );
  @override
  late final GeneratedColumn<String> readingStatus = GeneratedColumn<String>(
    'reading_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unread'),
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishDateMeta = const VerificationMeta(
    'finishDate',
  );
  @override
  late final GeneratedColumn<DateTime> finishDate = GeneratedColumn<DateTime>(
    'finish_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    authors,
    originalTitle,
    originalLanguage,
    description,
    genres,
    seriesName,
    seriesIndex,
    firstPublished,
    primaryEditionId,
    readingStatus,
    currentPage,
    startDate,
    finishDate,
    rating,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'works';
  @override
  VerificationContext validateIntegrity(
    Insertable<Work> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_title')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_title']!,
          _originalTitleMeta,
        ),
      );
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('series_name')) {
      context.handle(
        _seriesNameMeta,
        seriesName.isAcceptableOrUnknown(data['series_name']!, _seriesNameMeta),
      );
    }
    if (data.containsKey('series_index')) {
      context.handle(
        _seriesIndexMeta,
        seriesIndex.isAcceptableOrUnknown(
          data['series_index']!,
          _seriesIndexMeta,
        ),
      );
    }
    if (data.containsKey('first_published')) {
      context.handle(
        _firstPublishedMeta,
        firstPublished.isAcceptableOrUnknown(
          data['first_published']!,
          _firstPublishedMeta,
        ),
      );
    }
    if (data.containsKey('primary_edition_id')) {
      context.handle(
        _primaryEditionIdMeta,
        primaryEditionId.isAcceptableOrUnknown(
          data['primary_edition_id']!,
          _primaryEditionIdMeta,
        ),
      );
    }
    if (data.containsKey('reading_status')) {
      context.handle(
        _readingStatusMeta,
        readingStatus.isAcceptableOrUnknown(
          data['reading_status']!,
          _readingStatusMeta,
        ),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('finish_date')) {
      context.handle(
        _finishDateMeta,
        finishDate.isAcceptableOrUnknown(data['finish_date']!, _finishDateMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Work map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Work(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      authors: $WorksTable.$converterauthors.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}authors'],
        )!,
      ),
      originalTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_title'],
      ),
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      genres: $WorksTable.$convertergenres.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}genres'],
        )!,
      ),
      seriesName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_name'],
      ),
      seriesIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_index'],
      ),
      firstPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_published'],
      ),
      primaryEditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_edition_id'],
      ),
      readingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_status'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      finishDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finish_date'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorksTable createAlias(String alias) {
    return $WorksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, String> $converterauthors =
      const StringListConverter();
  static JsonTypeConverter2<List<String>, String, String> $convertergenres =
      const StringListConverter();
}

class Work extends DataClass implements Insertable<Work> {
  final String id;
  final String title;
  final List<String> authors;
  final String? originalTitle;
  final String? originalLanguage;
  final String? description;
  final List<String> genres;
  final String? seriesName;
  final int? seriesIndex;
  final int? firstPublished;

  /// The edition shown for this work in lists. Denormalised so the library
  /// query can filter and sort on edition columns in SQL. Not declared as a
  /// foreign key because Editions already points back at Works.
  final String? primaryEditionId;
  final String readingStatus;
  final int currentPage;
  final DateTime? startDate;
  final DateTime? finishDate;
  final double? rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Work({
    required this.id,
    required this.title,
    required this.authors,
    this.originalTitle,
    this.originalLanguage,
    this.description,
    required this.genres,
    this.seriesName,
    this.seriesIndex,
    this.firstPublished,
    this.primaryEditionId,
    required this.readingStatus,
    required this.currentPage,
    this.startDate,
    this.finishDate,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['authors'] = Variable<String>(
        $WorksTable.$converterauthors.toSql(authors),
      );
    }
    if (!nullToAbsent || originalTitle != null) {
      map['original_title'] = Variable<String>(originalTitle);
    }
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['genres'] = Variable<String>(
        $WorksTable.$convertergenres.toSql(genres),
      );
    }
    if (!nullToAbsent || seriesName != null) {
      map['series_name'] = Variable<String>(seriesName);
    }
    if (!nullToAbsent || seriesIndex != null) {
      map['series_index'] = Variable<int>(seriesIndex);
    }
    if (!nullToAbsent || firstPublished != null) {
      map['first_published'] = Variable<int>(firstPublished);
    }
    if (!nullToAbsent || primaryEditionId != null) {
      map['primary_edition_id'] = Variable<String>(primaryEditionId);
    }
    map['reading_status'] = Variable<String>(readingStatus);
    map['current_page'] = Variable<int>(currentPage);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || finishDate != null) {
      map['finish_date'] = Variable<DateTime>(finishDate);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorksCompanion toCompanion(bool nullToAbsent) {
    return WorksCompanion(
      id: Value(id),
      title: Value(title),
      authors: Value(authors),
      originalTitle: originalTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTitle),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      genres: Value(genres),
      seriesName: seriesName == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesName),
      seriesIndex: seriesIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesIndex),
      firstPublished: firstPublished == null && nullToAbsent
          ? const Value.absent()
          : Value(firstPublished),
      primaryEditionId: primaryEditionId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryEditionId),
      readingStatus: Value(readingStatus),
      currentPage: Value(currentPage),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      finishDate: finishDate == null && nullToAbsent
          ? const Value.absent()
          : Value(finishDate),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Work.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Work(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      authors: $WorksTable.$converterauthors.fromJson(
        serializer.fromJson<String>(json['authors']),
      ),
      originalTitle: serializer.fromJson<String?>(json['originalTitle']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      description: serializer.fromJson<String?>(json['description']),
      genres: $WorksTable.$convertergenres.fromJson(
        serializer.fromJson<String>(json['genres']),
      ),
      seriesName: serializer.fromJson<String?>(json['seriesName']),
      seriesIndex: serializer.fromJson<int?>(json['seriesIndex']),
      firstPublished: serializer.fromJson<int?>(json['firstPublished']),
      primaryEditionId: serializer.fromJson<String?>(json['primaryEditionId']),
      readingStatus: serializer.fromJson<String>(json['readingStatus']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      finishDate: serializer.fromJson<DateTime?>(json['finishDate']),
      rating: serializer.fromJson<double?>(json['rating']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'authors': serializer.toJson<String>(
        $WorksTable.$converterauthors.toJson(authors),
      ),
      'originalTitle': serializer.toJson<String?>(originalTitle),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'description': serializer.toJson<String?>(description),
      'genres': serializer.toJson<String>(
        $WorksTable.$convertergenres.toJson(genres),
      ),
      'seriesName': serializer.toJson<String?>(seriesName),
      'seriesIndex': serializer.toJson<int?>(seriesIndex),
      'firstPublished': serializer.toJson<int?>(firstPublished),
      'primaryEditionId': serializer.toJson<String?>(primaryEditionId),
      'readingStatus': serializer.toJson<String>(readingStatus),
      'currentPage': serializer.toJson<int>(currentPage),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'finishDate': serializer.toJson<DateTime?>(finishDate),
      'rating': serializer.toJson<double?>(rating),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Work copyWith({
    String? id,
    String? title,
    List<String>? authors,
    Value<String?> originalTitle = const Value.absent(),
    Value<String?> originalLanguage = const Value.absent(),
    Value<String?> description = const Value.absent(),
    List<String>? genres,
    Value<String?> seriesName = const Value.absent(),
    Value<int?> seriesIndex = const Value.absent(),
    Value<int?> firstPublished = const Value.absent(),
    Value<String?> primaryEditionId = const Value.absent(),
    String? readingStatus,
    int? currentPage,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> finishDate = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Work(
    id: id ?? this.id,
    title: title ?? this.title,
    authors: authors ?? this.authors,
    originalTitle: originalTitle.present
        ? originalTitle.value
        : this.originalTitle,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    description: description.present ? description.value : this.description,
    genres: genres ?? this.genres,
    seriesName: seriesName.present ? seriesName.value : this.seriesName,
    seriesIndex: seriesIndex.present ? seriesIndex.value : this.seriesIndex,
    firstPublished: firstPublished.present
        ? firstPublished.value
        : this.firstPublished,
    primaryEditionId: primaryEditionId.present
        ? primaryEditionId.value
        : this.primaryEditionId,
    readingStatus: readingStatus ?? this.readingStatus,
    currentPage: currentPage ?? this.currentPage,
    startDate: startDate.present ? startDate.value : this.startDate,
    finishDate: finishDate.present ? finishDate.value : this.finishDate,
    rating: rating.present ? rating.value : this.rating,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Work copyWithCompanion(WorksCompanion data) {
    return Work(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      authors: data.authors.present ? data.authors.value : this.authors,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      description: data.description.present
          ? data.description.value
          : this.description,
      genres: data.genres.present ? data.genres.value : this.genres,
      seriesName: data.seriesName.present
          ? data.seriesName.value
          : this.seriesName,
      seriesIndex: data.seriesIndex.present
          ? data.seriesIndex.value
          : this.seriesIndex,
      firstPublished: data.firstPublished.present
          ? data.firstPublished.value
          : this.firstPublished,
      primaryEditionId: data.primaryEditionId.present
          ? data.primaryEditionId.value
          : this.primaryEditionId,
      readingStatus: data.readingStatus.present
          ? data.readingStatus.value
          : this.readingStatus,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      finishDate: data.finishDate.present
          ? data.finishDate.value
          : this.finishDate,
      rating: data.rating.present ? data.rating.value : this.rating,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Work(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authors: $authors, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('description: $description, ')
          ..write('genres: $genres, ')
          ..write('seriesName: $seriesName, ')
          ..write('seriesIndex: $seriesIndex, ')
          ..write('firstPublished: $firstPublished, ')
          ..write('primaryEditionId: $primaryEditionId, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('currentPage: $currentPage, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    authors,
    originalTitle,
    originalLanguage,
    description,
    genres,
    seriesName,
    seriesIndex,
    firstPublished,
    primaryEditionId,
    readingStatus,
    currentPage,
    startDate,
    finishDate,
    rating,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Work &&
          other.id == this.id &&
          other.title == this.title &&
          other.authors == this.authors &&
          other.originalTitle == this.originalTitle &&
          other.originalLanguage == this.originalLanguage &&
          other.description == this.description &&
          other.genres == this.genres &&
          other.seriesName == this.seriesName &&
          other.seriesIndex == this.seriesIndex &&
          other.firstPublished == this.firstPublished &&
          other.primaryEditionId == this.primaryEditionId &&
          other.readingStatus == this.readingStatus &&
          other.currentPage == this.currentPage &&
          other.startDate == this.startDate &&
          other.finishDate == this.finishDate &&
          other.rating == this.rating &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorksCompanion extends UpdateCompanion<Work> {
  final Value<String> id;
  final Value<String> title;
  final Value<List<String>> authors;
  final Value<String?> originalTitle;
  final Value<String?> originalLanguage;
  final Value<String?> description;
  final Value<List<String>> genres;
  final Value<String?> seriesName;
  final Value<int?> seriesIndex;
  final Value<int?> firstPublished;
  final Value<String?> primaryEditionId;
  final Value<String> readingStatus;
  final Value<int> currentPage;
  final Value<DateTime?> startDate;
  final Value<DateTime?> finishDate;
  final Value<double?> rating;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.authors = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.description = const Value.absent(),
    this.genres = const Value.absent(),
    this.seriesName = const Value.absent(),
    this.seriesIndex = const Value.absent(),
    this.firstPublished = const Value.absent(),
    this.primaryEditionId = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startDate = const Value.absent(),
    this.finishDate = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorksCompanion.insert({
    required String id,
    required String title,
    required List<String> authors,
    this.originalTitle = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.description = const Value.absent(),
    required List<String> genres,
    this.seriesName = const Value.absent(),
    this.seriesIndex = const Value.absent(),
    this.firstPublished = const Value.absent(),
    this.primaryEditionId = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startDate = const Value.absent(),
    this.finishDate = const Value.absent(),
    this.rating = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       authors = Value(authors),
       genres = Value(genres),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Work> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? authors,
    Expression<String>? originalTitle,
    Expression<String>? originalLanguage,
    Expression<String>? description,
    Expression<String>? genres,
    Expression<String>? seriesName,
    Expression<int>? seriesIndex,
    Expression<int>? firstPublished,
    Expression<String>? primaryEditionId,
    Expression<String>? readingStatus,
    Expression<int>? currentPage,
    Expression<DateTime>? startDate,
    Expression<DateTime>? finishDate,
    Expression<double>? rating,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (authors != null) 'authors': authors,
      if (originalTitle != null) 'original_title': originalTitle,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (description != null) 'description': description,
      if (genres != null) 'genres': genres,
      if (seriesName != null) 'series_name': seriesName,
      if (seriesIndex != null) 'series_index': seriesIndex,
      if (firstPublished != null) 'first_published': firstPublished,
      if (primaryEditionId != null) 'primary_edition_id': primaryEditionId,
      if (readingStatus != null) 'reading_status': readingStatus,
      if (currentPage != null) 'current_page': currentPage,
      if (startDate != null) 'start_date': startDate,
      if (finishDate != null) 'finish_date': finishDate,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<List<String>>? authors,
    Value<String?>? originalTitle,
    Value<String?>? originalLanguage,
    Value<String?>? description,
    Value<List<String>>? genres,
    Value<String?>? seriesName,
    Value<int?>? seriesIndex,
    Value<int?>? firstPublished,
    Value<String?>? primaryEditionId,
    Value<String>? readingStatus,
    Value<int>? currentPage,
    Value<DateTime?>? startDate,
    Value<DateTime?>? finishDate,
    Value<double?>? rating,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      originalTitle: originalTitle ?? this.originalTitle,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      seriesName: seriesName ?? this.seriesName,
      seriesIndex: seriesIndex ?? this.seriesIndex,
      firstPublished: firstPublished ?? this.firstPublished,
      primaryEditionId: primaryEditionId ?? this.primaryEditionId,
      readingStatus: readingStatus ?? this.readingStatus,
      currentPage: currentPage ?? this.currentPage,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (authors.present) {
      map['authors'] = Variable<String>(
        $WorksTable.$converterauthors.toSql(authors.value),
      );
    }
    if (originalTitle.present) {
      map['original_title'] = Variable<String>(originalTitle.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(
        $WorksTable.$convertergenres.toSql(genres.value),
      );
    }
    if (seriesName.present) {
      map['series_name'] = Variable<String>(seriesName.value);
    }
    if (seriesIndex.present) {
      map['series_index'] = Variable<int>(seriesIndex.value);
    }
    if (firstPublished.present) {
      map['first_published'] = Variable<int>(firstPublished.value);
    }
    if (primaryEditionId.present) {
      map['primary_edition_id'] = Variable<String>(primaryEditionId.value);
    }
    if (readingStatus.present) {
      map['reading_status'] = Variable<String>(readingStatus.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (finishDate.present) {
      map['finish_date'] = Variable<DateTime>(finishDate.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authors: $authors, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('description: $description, ')
          ..write('genres: $genres, ')
          ..write('seriesName: $seriesName, ')
          ..write('seriesIndex: $seriesIndex, ')
          ..write('firstPublished: $firstPublished, ')
          ..write('primaryEditionId: $primaryEditionId, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('currentPage: $currentPage, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EditionsTable extends Editions with TableInfo<$EditionsTable, Edition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES works (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _isbn13Meta = const VerificationMeta('isbn13');
  @override
  late final GeneratedColumn<String> isbn13 = GeneratedColumn<String>(
    'isbn13',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isbn10Meta = const VerificationMeta('isbn10');
  @override
  late final GeneratedColumn<String> isbn10 = GeneratedColumn<String>(
    'isbn10',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicationDateMeta = const VerificationMeta(
    'publicationDate',
  );
  @override
  late final GeneratedColumn<String> publicationDate = GeneratedColumn<String>(
    'publication_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedYearMeta = const VerificationMeta(
    'publishedYear',
  );
  @override
  late final GeneratedColumn<int> publishedYear = GeneratedColumn<int>(
    'published_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editionNameMeta = const VerificationMeta(
    'editionName',
  );
  @override
  late final GeneratedColumn<String> editionName = GeneratedColumn<String>(
    'edition_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverImagePathMeta = const VerificationMeta(
    'coverImagePath',
  );
  @override
  late final GeneratedColumn<String> coverImagePath = GeneratedColumn<String>(
    'cover_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverColorIndexMeta = const VerificationMeta(
    'coverColorIndex',
  );
  @override
  late final GeneratedColumn<int> coverColorIndex = GeneratedColumn<int>(
    'cover_color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dimensionsMeta = const VerificationMeta(
    'dimensions',
  );
  @override
  late final GeneratedColumn<String> dimensions = GeneratedColumn<String>(
    'dimensions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
    'weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translatorMeta = const VerificationMeta(
    'translator',
  );
  @override
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
    'translator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  illustrators = GeneratedColumn<String>(
    'illustrators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($EditionsTable.$converterillustrators);
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workId,
    isbn13,
    isbn10,
    publisher,
    publicationDate,
    publishedYear,
    language,
    format,
    editionName,
    pageCount,
    coverUrl,
    coverImagePath,
    coverColorIndex,
    dimensions,
    weightGrams,
    translator,
    illustrators,
    country,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'editions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Edition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('isbn13')) {
      context.handle(
        _isbn13Meta,
        isbn13.isAcceptableOrUnknown(data['isbn13']!, _isbn13Meta),
      );
    }
    if (data.containsKey('isbn10')) {
      context.handle(
        _isbn10Meta,
        isbn10.isAcceptableOrUnknown(data['isbn10']!, _isbn10Meta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('publication_date')) {
      context.handle(
        _publicationDateMeta,
        publicationDate.isAcceptableOrUnknown(
          data['publication_date']!,
          _publicationDateMeta,
        ),
      );
    }
    if (data.containsKey('published_year')) {
      context.handle(
        _publishedYearMeta,
        publishedYear.isAcceptableOrUnknown(
          data['published_year']!,
          _publishedYearMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('edition_name')) {
      context.handle(
        _editionNameMeta,
        editionName.isAcceptableOrUnknown(
          data['edition_name']!,
          _editionNameMeta,
        ),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('cover_image_path')) {
      context.handle(
        _coverImagePathMeta,
        coverImagePath.isAcceptableOrUnknown(
          data['cover_image_path']!,
          _coverImagePathMeta,
        ),
      );
    }
    if (data.containsKey('cover_color_index')) {
      context.handle(
        _coverColorIndexMeta,
        coverColorIndex.isAcceptableOrUnknown(
          data['cover_color_index']!,
          _coverColorIndexMeta,
        ),
      );
    }
    if (data.containsKey('dimensions')) {
      context.handle(
        _dimensionsMeta,
        dimensions.isAcceptableOrUnknown(data['dimensions']!, _dimensionsMeta),
      );
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    }
    if (data.containsKey('translator')) {
      context.handle(
        _translatorMeta,
        translator.isAcceptableOrUnknown(data['translator']!, _translatorMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Edition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Edition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      )!,
      isbn13: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn13'],
      ),
      isbn10: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn10'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publicationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publication_date'],
      ),
      publishedYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}published_year'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      ),
      editionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_name'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      coverImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_path'],
      ),
      coverColorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color_index'],
      )!,
      dimensions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dimensions'],
      ),
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_grams'],
      ),
      translator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translator'],
      ),
      illustrators: $EditionsTable.$converterillustrators.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}illustrators'],
        )!,
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EditionsTable createAlias(String alias) {
    return $EditionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, String>
  $converterillustrators = const StringListConverter();
}

class Edition extends DataClass implements Insertable<Edition> {
  final String id;
  final String workId;
  final String? isbn13;
  final String? isbn10;
  final String? publisher;
  final String? publicationDate;
  final int? publishedYear;
  final String? language;
  final String? format;
  final String? editionName;
  final int? pageCount;
  final String? coverUrl;

  /// A cover the user photographed or picked themselves, stored in the app's
  /// own directory. Takes precedence over [coverUrl]: if someone went to the
  /// trouble of photographing their copy, that is the cover they want to see.
  final String? coverImagePath;

  /// Index into the cover placeholder palette, so a missing cover still gets a
  /// stable colour across restarts.
  final int coverColorIndex;
  final String? dimensions;
  final double? weightGrams;
  final String? translator;
  final List<String> illustrators;
  final String? country;
  final DateTime createdAt;
  const Edition({
    required this.id,
    required this.workId,
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
    required this.coverColorIndex,
    this.dimensions,
    this.weightGrams,
    this.translator,
    required this.illustrators,
    this.country,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    if (!nullToAbsent || isbn13 != null) {
      map['isbn13'] = Variable<String>(isbn13);
    }
    if (!nullToAbsent || isbn10 != null) {
      map['isbn10'] = Variable<String>(isbn10);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publicationDate != null) {
      map['publication_date'] = Variable<String>(publicationDate);
    }
    if (!nullToAbsent || publishedYear != null) {
      map['published_year'] = Variable<int>(publishedYear);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || format != null) {
      map['format'] = Variable<String>(format);
    }
    if (!nullToAbsent || editionName != null) {
      map['edition_name'] = Variable<String>(editionName);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || coverImagePath != null) {
      map['cover_image_path'] = Variable<String>(coverImagePath);
    }
    map['cover_color_index'] = Variable<int>(coverColorIndex);
    if (!nullToAbsent || dimensions != null) {
      map['dimensions'] = Variable<String>(dimensions);
    }
    if (!nullToAbsent || weightGrams != null) {
      map['weight_grams'] = Variable<double>(weightGrams);
    }
    if (!nullToAbsent || translator != null) {
      map['translator'] = Variable<String>(translator);
    }
    {
      map['illustrators'] = Variable<String>(
        $EditionsTable.$converterillustrators.toSql(illustrators),
      );
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EditionsCompanion toCompanion(bool nullToAbsent) {
    return EditionsCompanion(
      id: Value(id),
      workId: Value(workId),
      isbn13: isbn13 == null && nullToAbsent
          ? const Value.absent()
          : Value(isbn13),
      isbn10: isbn10 == null && nullToAbsent
          ? const Value.absent()
          : Value(isbn10),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publicationDate: publicationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publicationDate),
      publishedYear: publishedYear == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedYear),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      format: format == null && nullToAbsent
          ? const Value.absent()
          : Value(format),
      editionName: editionName == null && nullToAbsent
          ? const Value.absent()
          : Value(editionName),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      coverImagePath: coverImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImagePath),
      coverColorIndex: Value(coverColorIndex),
      dimensions: dimensions == null && nullToAbsent
          ? const Value.absent()
          : Value(dimensions),
      weightGrams: weightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGrams),
      translator: translator == null && nullToAbsent
          ? const Value.absent()
          : Value(translator),
      illustrators: Value(illustrators),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      createdAt: Value(createdAt),
    );
  }

  factory Edition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Edition(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      isbn13: serializer.fromJson<String?>(json['isbn13']),
      isbn10: serializer.fromJson<String?>(json['isbn10']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publicationDate: serializer.fromJson<String?>(json['publicationDate']),
      publishedYear: serializer.fromJson<int?>(json['publishedYear']),
      language: serializer.fromJson<String?>(json['language']),
      format: serializer.fromJson<String?>(json['format']),
      editionName: serializer.fromJson<String?>(json['editionName']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      coverImagePath: serializer.fromJson<String?>(json['coverImagePath']),
      coverColorIndex: serializer.fromJson<int>(json['coverColorIndex']),
      dimensions: serializer.fromJson<String?>(json['dimensions']),
      weightGrams: serializer.fromJson<double?>(json['weightGrams']),
      translator: serializer.fromJson<String?>(json['translator']),
      illustrators: $EditionsTable.$converterillustrators.fromJson(
        serializer.fromJson<String>(json['illustrators']),
      ),
      country: serializer.fromJson<String?>(json['country']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'isbn13': serializer.toJson<String?>(isbn13),
      'isbn10': serializer.toJson<String?>(isbn10),
      'publisher': serializer.toJson<String?>(publisher),
      'publicationDate': serializer.toJson<String?>(publicationDate),
      'publishedYear': serializer.toJson<int?>(publishedYear),
      'language': serializer.toJson<String?>(language),
      'format': serializer.toJson<String?>(format),
      'editionName': serializer.toJson<String?>(editionName),
      'pageCount': serializer.toJson<int?>(pageCount),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'coverImagePath': serializer.toJson<String?>(coverImagePath),
      'coverColorIndex': serializer.toJson<int>(coverColorIndex),
      'dimensions': serializer.toJson<String?>(dimensions),
      'weightGrams': serializer.toJson<double?>(weightGrams),
      'translator': serializer.toJson<String?>(translator),
      'illustrators': serializer.toJson<String>(
        $EditionsTable.$converterillustrators.toJson(illustrators),
      ),
      'country': serializer.toJson<String?>(country),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Edition copyWith({
    String? id,
    String? workId,
    Value<String?> isbn13 = const Value.absent(),
    Value<String?> isbn10 = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> publicationDate = const Value.absent(),
    Value<int?> publishedYear = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<String?> format = const Value.absent(),
    Value<String?> editionName = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> coverImagePath = const Value.absent(),
    int? coverColorIndex,
    Value<String?> dimensions = const Value.absent(),
    Value<double?> weightGrams = const Value.absent(),
    Value<String?> translator = const Value.absent(),
    List<String>? illustrators,
    Value<String?> country = const Value.absent(),
    DateTime? createdAt,
  }) => Edition(
    id: id ?? this.id,
    workId: workId ?? this.workId,
    isbn13: isbn13.present ? isbn13.value : this.isbn13,
    isbn10: isbn10.present ? isbn10.value : this.isbn10,
    publisher: publisher.present ? publisher.value : this.publisher,
    publicationDate: publicationDate.present
        ? publicationDate.value
        : this.publicationDate,
    publishedYear: publishedYear.present
        ? publishedYear.value
        : this.publishedYear,
    language: language.present ? language.value : this.language,
    format: format.present ? format.value : this.format,
    editionName: editionName.present ? editionName.value : this.editionName,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    coverImagePath: coverImagePath.present
        ? coverImagePath.value
        : this.coverImagePath,
    coverColorIndex: coverColorIndex ?? this.coverColorIndex,
    dimensions: dimensions.present ? dimensions.value : this.dimensions,
    weightGrams: weightGrams.present ? weightGrams.value : this.weightGrams,
    translator: translator.present ? translator.value : this.translator,
    illustrators: illustrators ?? this.illustrators,
    country: country.present ? country.value : this.country,
    createdAt: createdAt ?? this.createdAt,
  );
  Edition copyWithCompanion(EditionsCompanion data) {
    return Edition(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      isbn13: data.isbn13.present ? data.isbn13.value : this.isbn13,
      isbn10: data.isbn10.present ? data.isbn10.value : this.isbn10,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publicationDate: data.publicationDate.present
          ? data.publicationDate.value
          : this.publicationDate,
      publishedYear: data.publishedYear.present
          ? data.publishedYear.value
          : this.publishedYear,
      language: data.language.present ? data.language.value : this.language,
      format: data.format.present ? data.format.value : this.format,
      editionName: data.editionName.present
          ? data.editionName.value
          : this.editionName,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      coverImagePath: data.coverImagePath.present
          ? data.coverImagePath.value
          : this.coverImagePath,
      coverColorIndex: data.coverColorIndex.present
          ? data.coverColorIndex.value
          : this.coverColorIndex,
      dimensions: data.dimensions.present
          ? data.dimensions.value
          : this.dimensions,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      translator: data.translator.present
          ? data.translator.value
          : this.translator,
      illustrators: data.illustrators.present
          ? data.illustrators.value
          : this.illustrators,
      country: data.country.present ? data.country.value : this.country,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Edition(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('isbn13: $isbn13, ')
          ..write('isbn10: $isbn10, ')
          ..write('publisher: $publisher, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('language: $language, ')
          ..write('format: $format, ')
          ..write('editionName: $editionName, ')
          ..write('pageCount: $pageCount, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('coverColorIndex: $coverColorIndex, ')
          ..write('dimensions: $dimensions, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('translator: $translator, ')
          ..write('illustrators: $illustrators, ')
          ..write('country: $country, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workId,
    isbn13,
    isbn10,
    publisher,
    publicationDate,
    publishedYear,
    language,
    format,
    editionName,
    pageCount,
    coverUrl,
    coverImagePath,
    coverColorIndex,
    dimensions,
    weightGrams,
    translator,
    illustrators,
    country,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Edition &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.isbn13 == this.isbn13 &&
          other.isbn10 == this.isbn10 &&
          other.publisher == this.publisher &&
          other.publicationDate == this.publicationDate &&
          other.publishedYear == this.publishedYear &&
          other.language == this.language &&
          other.format == this.format &&
          other.editionName == this.editionName &&
          other.pageCount == this.pageCount &&
          other.coverUrl == this.coverUrl &&
          other.coverImagePath == this.coverImagePath &&
          other.coverColorIndex == this.coverColorIndex &&
          other.dimensions == this.dimensions &&
          other.weightGrams == this.weightGrams &&
          other.translator == this.translator &&
          other.illustrators == this.illustrators &&
          other.country == this.country &&
          other.createdAt == this.createdAt);
}

class EditionsCompanion extends UpdateCompanion<Edition> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String?> isbn13;
  final Value<String?> isbn10;
  final Value<String?> publisher;
  final Value<String?> publicationDate;
  final Value<int?> publishedYear;
  final Value<String?> language;
  final Value<String?> format;
  final Value<String?> editionName;
  final Value<int?> pageCount;
  final Value<String?> coverUrl;
  final Value<String?> coverImagePath;
  final Value<int> coverColorIndex;
  final Value<String?> dimensions;
  final Value<double?> weightGrams;
  final Value<String?> translator;
  final Value<List<String>> illustrators;
  final Value<String?> country;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EditionsCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.isbn13 = const Value.absent(),
    this.isbn10 = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.language = const Value.absent(),
    this.format = const Value.absent(),
    this.editionName = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.coverColorIndex = const Value.absent(),
    this.dimensions = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.translator = const Value.absent(),
    this.illustrators = const Value.absent(),
    this.country = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EditionsCompanion.insert({
    required String id,
    required String workId,
    this.isbn13 = const Value.absent(),
    this.isbn10 = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.language = const Value.absent(),
    this.format = const Value.absent(),
    this.editionName = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.coverColorIndex = const Value.absent(),
    this.dimensions = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.translator = const Value.absent(),
    required List<String> illustrators,
    this.country = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workId = Value(workId),
       illustrators = Value(illustrators),
       createdAt = Value(createdAt);
  static Insertable<Edition> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? isbn13,
    Expression<String>? isbn10,
    Expression<String>? publisher,
    Expression<String>? publicationDate,
    Expression<int>? publishedYear,
    Expression<String>? language,
    Expression<String>? format,
    Expression<String>? editionName,
    Expression<int>? pageCount,
    Expression<String>? coverUrl,
    Expression<String>? coverImagePath,
    Expression<int>? coverColorIndex,
    Expression<String>? dimensions,
    Expression<double>? weightGrams,
    Expression<String>? translator,
    Expression<String>? illustrators,
    Expression<String>? country,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (isbn13 != null) 'isbn13': isbn13,
      if (isbn10 != null) 'isbn10': isbn10,
      if (publisher != null) 'publisher': publisher,
      if (publicationDate != null) 'publication_date': publicationDate,
      if (publishedYear != null) 'published_year': publishedYear,
      if (language != null) 'language': language,
      if (format != null) 'format': format,
      if (editionName != null) 'edition_name': editionName,
      if (pageCount != null) 'page_count': pageCount,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (coverImagePath != null) 'cover_image_path': coverImagePath,
      if (coverColorIndex != null) 'cover_color_index': coverColorIndex,
      if (dimensions != null) 'dimensions': dimensions,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (translator != null) 'translator': translator,
      if (illustrators != null) 'illustrators': illustrators,
      if (country != null) 'country': country,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workId,
    Value<String?>? isbn13,
    Value<String?>? isbn10,
    Value<String?>? publisher,
    Value<String?>? publicationDate,
    Value<int?>? publishedYear,
    Value<String?>? language,
    Value<String?>? format,
    Value<String?>? editionName,
    Value<int?>? pageCount,
    Value<String?>? coverUrl,
    Value<String?>? coverImagePath,
    Value<int>? coverColorIndex,
    Value<String?>? dimensions,
    Value<double?>? weightGrams,
    Value<String?>? translator,
    Value<List<String>>? illustrators,
    Value<String?>? country,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EditionsCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      isbn13: isbn13 ?? this.isbn13,
      isbn10: isbn10 ?? this.isbn10,
      publisher: publisher ?? this.publisher,
      publicationDate: publicationDate ?? this.publicationDate,
      publishedYear: publishedYear ?? this.publishedYear,
      language: language ?? this.language,
      format: format ?? this.format,
      editionName: editionName ?? this.editionName,
      pageCount: pageCount ?? this.pageCount,
      coverUrl: coverUrl ?? this.coverUrl,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverColorIndex: coverColorIndex ?? this.coverColorIndex,
      dimensions: dimensions ?? this.dimensions,
      weightGrams: weightGrams ?? this.weightGrams,
      translator: translator ?? this.translator,
      illustrators: illustrators ?? this.illustrators,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (isbn13.present) {
      map['isbn13'] = Variable<String>(isbn13.value);
    }
    if (isbn10.present) {
      map['isbn10'] = Variable<String>(isbn10.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publicationDate.present) {
      map['publication_date'] = Variable<String>(publicationDate.value);
    }
    if (publishedYear.present) {
      map['published_year'] = Variable<int>(publishedYear.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (editionName.present) {
      map['edition_name'] = Variable<String>(editionName.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (coverImagePath.present) {
      map['cover_image_path'] = Variable<String>(coverImagePath.value);
    }
    if (coverColorIndex.present) {
      map['cover_color_index'] = Variable<int>(coverColorIndex.value);
    }
    if (dimensions.present) {
      map['dimensions'] = Variable<String>(dimensions.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (illustrators.present) {
      map['illustrators'] = Variable<String>(
        $EditionsTable.$converterillustrators.toSql(illustrators.value),
      );
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditionsCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('isbn13: $isbn13, ')
          ..write('isbn10: $isbn10, ')
          ..write('publisher: $publisher, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('language: $language, ')
          ..write('format: $format, ')
          ..write('editionName: $editionName, ')
          ..write('pageCount: $pageCount, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('coverColorIndex: $coverColorIndex, ')
          ..write('dimensions: $dimensions, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('translator: $translator, ')
          ..write('illustrators: $illustrators, ')
          ..write('country: $country, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CopiesTable extends Copies with TableInfo<$CopiesTable, Copy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES editions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ownershipMeta = const VerificationMeta(
    'ownership',
  );
  @override
  late final GeneratedColumn<String> ownership = GeneratedColumn<String>(
    'ownership',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('owned'),
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
    'store',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGiftMeta = const VerificationMeta('isGift');
  @override
  late final GeneratedColumn<bool> isGift = GeneratedColumn<bool>(
    'is_gift',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_gift" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _giftFromMeta = const VerificationMeta(
    'giftFrom',
  );
  @override
  late final GeneratedColumn<String> giftFrom = GeneratedColumn<String>(
    'gift_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedDateMeta = const VerificationMeta(
    'addedDate',
  );
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
    'added_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    editionId,
    ownership,
    purchaseDate,
    purchasePrice,
    currency,
    store,
    isGift,
    giftFrom,
    condition,
    location,
    notes,
    addedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Copy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('ownership')) {
      context.handle(
        _ownershipMeta,
        ownership.isAcceptableOrUnknown(data['ownership']!, _ownershipMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('store')) {
      context.handle(
        _storeMeta,
        store.isAcceptableOrUnknown(data['store']!, _storeMeta),
      );
    }
    if (data.containsKey('is_gift')) {
      context.handle(
        _isGiftMeta,
        isGift.isAcceptableOrUnknown(data['is_gift']!, _isGiftMeta),
      );
    }
    if (data.containsKey('gift_from')) {
      context.handle(
        _giftFromMeta,
        giftFrom.isAcceptableOrUnknown(data['gift_from']!, _giftFromMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('added_date')) {
      context.handle(
        _addedDateMeta,
        addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_addedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Copy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Copy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      )!,
      ownership: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ownership'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      store: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store'],
      ),
      isGift: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_gift'],
      )!,
      giftFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gift_from'],
      ),
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      addedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_date'],
      )!,
    );
  }

  @override
  $CopiesTable createAlias(String alias) {
    return $CopiesTable(attachedDatabase, alias);
  }
}

class Copy extends DataClass implements Insertable<Copy> {
  final String id;
  final String editionId;
  final String ownership;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? currency;
  final String? store;
  final bool isGift;
  final String? giftFrom;
  final String? condition;

  /// Hierarchical path, e.g. "Home › Bedroom › Bookshelf 2 › Shelf 4".
  final String? location;
  final String? notes;
  final DateTime addedDate;
  const Copy({
    required this.id,
    required this.editionId,
    required this.ownership,
    this.purchaseDate,
    this.purchasePrice,
    this.currency,
    this.store,
    required this.isGift,
    this.giftFrom,
    this.condition,
    this.location,
    this.notes,
    required this.addedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['edition_id'] = Variable<String>(editionId);
    map['ownership'] = Variable<String>(ownership);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || store != null) {
      map['store'] = Variable<String>(store);
    }
    map['is_gift'] = Variable<bool>(isGift);
    if (!nullToAbsent || giftFrom != null) {
      map['gift_from'] = Variable<String>(giftFrom);
    }
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['added_date'] = Variable<DateTime>(addedDate);
    return map;
  }

  CopiesCompanion toCompanion(bool nullToAbsent) {
    return CopiesCompanion(
      id: Value(id),
      editionId: Value(editionId),
      ownership: Value(ownership),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      store: store == null && nullToAbsent
          ? const Value.absent()
          : Value(store),
      isGift: Value(isGift),
      giftFrom: giftFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(giftFrom),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      addedDate: Value(addedDate),
    );
  }

  factory Copy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Copy(
      id: serializer.fromJson<String>(json['id']),
      editionId: serializer.fromJson<String>(json['editionId']),
      ownership: serializer.fromJson<String>(json['ownership']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      currency: serializer.fromJson<String?>(json['currency']),
      store: serializer.fromJson<String?>(json['store']),
      isGift: serializer.fromJson<bool>(json['isGift']),
      giftFrom: serializer.fromJson<String?>(json['giftFrom']),
      condition: serializer.fromJson<String?>(json['condition']),
      location: serializer.fromJson<String?>(json['location']),
      notes: serializer.fromJson<String?>(json['notes']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'editionId': serializer.toJson<String>(editionId),
      'ownership': serializer.toJson<String>(ownership),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'currency': serializer.toJson<String?>(currency),
      'store': serializer.toJson<String?>(store),
      'isGift': serializer.toJson<bool>(isGift),
      'giftFrom': serializer.toJson<String?>(giftFrom),
      'condition': serializer.toJson<String?>(condition),
      'location': serializer.toJson<String?>(location),
      'notes': serializer.toJson<String?>(notes),
      'addedDate': serializer.toJson<DateTime>(addedDate),
    };
  }

  Copy copyWith({
    String? id,
    String? editionId,
    String? ownership,
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<double?> purchasePrice = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<String?> store = const Value.absent(),
    bool? isGift,
    Value<String?> giftFrom = const Value.absent(),
    Value<String?> condition = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? addedDate,
  }) => Copy(
    id: id ?? this.id,
    editionId: editionId ?? this.editionId,
    ownership: ownership ?? this.ownership,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    currency: currency.present ? currency.value : this.currency,
    store: store.present ? store.value : this.store,
    isGift: isGift ?? this.isGift,
    giftFrom: giftFrom.present ? giftFrom.value : this.giftFrom,
    condition: condition.present ? condition.value : this.condition,
    location: location.present ? location.value : this.location,
    notes: notes.present ? notes.value : this.notes,
    addedDate: addedDate ?? this.addedDate,
  );
  Copy copyWithCompanion(CopiesCompanion data) {
    return Copy(
      id: data.id.present ? data.id.value : this.id,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      ownership: data.ownership.present ? data.ownership.value : this.ownership,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      currency: data.currency.present ? data.currency.value : this.currency,
      store: data.store.present ? data.store.value : this.store,
      isGift: data.isGift.present ? data.isGift.value : this.isGift,
      giftFrom: data.giftFrom.present ? data.giftFrom.value : this.giftFrom,
      condition: data.condition.present ? data.condition.value : this.condition,
      location: data.location.present ? data.location.value : this.location,
      notes: data.notes.present ? data.notes.value : this.notes,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Copy(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('ownership: $ownership, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('currency: $currency, ')
          ..write('store: $store, ')
          ..write('isGift: $isGift, ')
          ..write('giftFrom: $giftFrom, ')
          ..write('condition: $condition, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('addedDate: $addedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    editionId,
    ownership,
    purchaseDate,
    purchasePrice,
    currency,
    store,
    isGift,
    giftFrom,
    condition,
    location,
    notes,
    addedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Copy &&
          other.id == this.id &&
          other.editionId == this.editionId &&
          other.ownership == this.ownership &&
          other.purchaseDate == this.purchaseDate &&
          other.purchasePrice == this.purchasePrice &&
          other.currency == this.currency &&
          other.store == this.store &&
          other.isGift == this.isGift &&
          other.giftFrom == this.giftFrom &&
          other.condition == this.condition &&
          other.location == this.location &&
          other.notes == this.notes &&
          other.addedDate == this.addedDate);
}

class CopiesCompanion extends UpdateCompanion<Copy> {
  final Value<String> id;
  final Value<String> editionId;
  final Value<String> ownership;
  final Value<DateTime?> purchaseDate;
  final Value<double?> purchasePrice;
  final Value<String?> currency;
  final Value<String?> store;
  final Value<bool> isGift;
  final Value<String?> giftFrom;
  final Value<String?> condition;
  final Value<String?> location;
  final Value<String?> notes;
  final Value<DateTime> addedDate;
  final Value<int> rowid;
  const CopiesCompanion({
    this.id = const Value.absent(),
    this.editionId = const Value.absent(),
    this.ownership = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.store = const Value.absent(),
    this.isGift = const Value.absent(),
    this.giftFrom = const Value.absent(),
    this.condition = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopiesCompanion.insert({
    required String id,
    required String editionId,
    this.ownership = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.store = const Value.absent(),
    this.isGift = const Value.absent(),
    this.giftFrom = const Value.absent(),
    this.condition = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime addedDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       editionId = Value(editionId),
       addedDate = Value(addedDate);
  static Insertable<Copy> custom({
    Expression<String>? id,
    Expression<String>? editionId,
    Expression<String>? ownership,
    Expression<DateTime>? purchaseDate,
    Expression<double>? purchasePrice,
    Expression<String>? currency,
    Expression<String>? store,
    Expression<bool>? isGift,
    Expression<String>? giftFrom,
    Expression<String>? condition,
    Expression<String>? location,
    Expression<String>? notes,
    Expression<DateTime>? addedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (editionId != null) 'edition_id': editionId,
      if (ownership != null) 'ownership': ownership,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (currency != null) 'currency': currency,
      if (store != null) 'store': store,
      if (isGift != null) 'is_gift': isGift,
      if (giftFrom != null) 'gift_from': giftFrom,
      if (condition != null) 'condition': condition,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (addedDate != null) 'added_date': addedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopiesCompanion copyWith({
    Value<String>? id,
    Value<String>? editionId,
    Value<String>? ownership,
    Value<DateTime?>? purchaseDate,
    Value<double?>? purchasePrice,
    Value<String?>? currency,
    Value<String?>? store,
    Value<bool>? isGift,
    Value<String?>? giftFrom,
    Value<String?>? condition,
    Value<String?>? location,
    Value<String?>? notes,
    Value<DateTime>? addedDate,
    Value<int>? rowid,
  }) {
    return CopiesCompanion(
      id: id ?? this.id,
      editionId: editionId ?? this.editionId,
      ownership: ownership ?? this.ownership,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currency: currency ?? this.currency,
      store: store ?? this.store,
      isGift: isGift ?? this.isGift,
      giftFrom: giftFrom ?? this.giftFrom,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      addedDate: addedDate ?? this.addedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (ownership.present) {
      map['ownership'] = Variable<String>(ownership.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (isGift.present) {
      map['is_gift'] = Variable<bool>(isGift.value);
    }
    if (giftFrom.present) {
      map['gift_from'] = Variable<String>(giftFrom.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopiesCompanion(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('ownership: $ownership, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('currency: $currency, ')
          ..write('store: $store, ')
          ..write('isGift: $isGift, ')
          ..write('giftFrom: $giftFrom, ')
          ..write('condition: $condition, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('addedDate: $addedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CopyPhotosTable extends CopyPhotos
    with TableInfo<$CopyPhotosTable, CopyPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopyPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copyIdMeta = const VerificationMeta('copyId');
  @override
  late final GeneratedColumn<String> copyId = GeneratedColumn<String>(
    'copy_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('front'),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, copyId, path, type, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copy_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopyPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('copy_id')) {
      context.handle(
        _copyIdMeta,
        copyId.isAcceptableOrUnknown(data['copy_id']!, _copyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_copyIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CopyPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopyPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      copyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copy_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $CopyPhotosTable createAlias(String alias) {
    return $CopyPhotosTable(attachedDatabase, alias);
  }
}

class CopyPhoto extends DataClass implements Insertable<CopyPhoto> {
  final String id;
  final String copyId;
  final String path;
  final String type;
  final DateTime addedAt;
  const CopyPhoto({
    required this.id,
    required this.copyId,
    required this.path,
    required this.type,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['copy_id'] = Variable<String>(copyId);
    map['path'] = Variable<String>(path);
    map['type'] = Variable<String>(type);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  CopyPhotosCompanion toCompanion(bool nullToAbsent) {
    return CopyPhotosCompanion(
      id: Value(id),
      copyId: Value(copyId),
      path: Value(path),
      type: Value(type),
      addedAt: Value(addedAt),
    );
  }

  factory CopyPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopyPhoto(
      id: serializer.fromJson<String>(json['id']),
      copyId: serializer.fromJson<String>(json['copyId']),
      path: serializer.fromJson<String>(json['path']),
      type: serializer.fromJson<String>(json['type']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'copyId': serializer.toJson<String>(copyId),
      'path': serializer.toJson<String>(path),
      'type': serializer.toJson<String>(type),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  CopyPhoto copyWith({
    String? id,
    String? copyId,
    String? path,
    String? type,
    DateTime? addedAt,
  }) => CopyPhoto(
    id: id ?? this.id,
    copyId: copyId ?? this.copyId,
    path: path ?? this.path,
    type: type ?? this.type,
    addedAt: addedAt ?? this.addedAt,
  );
  CopyPhoto copyWithCompanion(CopyPhotosCompanion data) {
    return CopyPhoto(
      id: data.id.present ? data.id.value : this.id,
      copyId: data.copyId.present ? data.copyId.value : this.copyId,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopyPhoto(')
          ..write('id: $id, ')
          ..write('copyId: $copyId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, copyId, path, type, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopyPhoto &&
          other.id == this.id &&
          other.copyId == this.copyId &&
          other.path == this.path &&
          other.type == this.type &&
          other.addedAt == this.addedAt);
}

class CopyPhotosCompanion extends UpdateCompanion<CopyPhoto> {
  final Value<String> id;
  final Value<String> copyId;
  final Value<String> path;
  final Value<String> type;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const CopyPhotosCompanion({
    this.id = const Value.absent(),
    this.copyId = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopyPhotosCompanion.insert({
    required String id,
    required String copyId,
    required String path,
    this.type = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       copyId = Value(copyId),
       path = Value(path),
       addedAt = Value(addedAt);
  static Insertable<CopyPhoto> custom({
    Expression<String>? id,
    Expression<String>? copyId,
    Expression<String>? path,
    Expression<String>? type,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (copyId != null) 'copy_id': copyId,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopyPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? copyId,
    Value<String>? path,
    Value<String>? type,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return CopyPhotosCompanion(
      id: id ?? this.id,
      copyId: copyId ?? this.copyId,
      path: path ?? this.path,
      type: type ?? this.type,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (copyId.present) {
      map['copy_id'] = Variable<String>(copyId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopyPhotosCompanion(')
          ..write('id: $id, ')
          ..write('copyId: $copyId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({String? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CopyTagsTable extends CopyTags with TableInfo<$CopyTagsTable, CopyTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopyTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _copyIdMeta = const VerificationMeta('copyId');
  @override
  late final GeneratedColumn<String> copyId = GeneratedColumn<String>(
    'copy_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [copyId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copy_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopyTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('copy_id')) {
      context.handle(
        _copyIdMeta,
        copyId.isAcceptableOrUnknown(data['copy_id']!, _copyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_copyIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {copyId, tagId};
  @override
  CopyTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopyTag(
      copyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copy_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $CopyTagsTable createAlias(String alias) {
    return $CopyTagsTable(attachedDatabase, alias);
  }
}

class CopyTag extends DataClass implements Insertable<CopyTag> {
  final String copyId;
  final String tagId;
  const CopyTag({required this.copyId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['copy_id'] = Variable<String>(copyId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  CopyTagsCompanion toCompanion(bool nullToAbsent) {
    return CopyTagsCompanion(copyId: Value(copyId), tagId: Value(tagId));
  }

  factory CopyTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopyTag(
      copyId: serializer.fromJson<String>(json['copyId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'copyId': serializer.toJson<String>(copyId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  CopyTag copyWith({String? copyId, String? tagId}) =>
      CopyTag(copyId: copyId ?? this.copyId, tagId: tagId ?? this.tagId);
  CopyTag copyWithCompanion(CopyTagsCompanion data) {
    return CopyTag(
      copyId: data.copyId.present ? data.copyId.value : this.copyId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopyTag(')
          ..write('copyId: $copyId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(copyId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopyTag &&
          other.copyId == this.copyId &&
          other.tagId == this.tagId);
}

class CopyTagsCompanion extends UpdateCompanion<CopyTag> {
  final Value<String> copyId;
  final Value<String> tagId;
  final Value<int> rowid;
  const CopyTagsCompanion({
    this.copyId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopyTagsCompanion.insert({
    required String copyId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : copyId = Value(copyId),
       tagId = Value(tagId);
  static Insertable<CopyTag> custom({
    Expression<String>? copyId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (copyId != null) 'copy_id': copyId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopyTagsCompanion copyWith({
    Value<String>? copyId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return CopyTagsCompanion(
      copyId: copyId ?? this.copyId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (copyId.present) {
      map['copy_id'] = Variable<String>(copyId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopyTagsCompanion(')
          ..write('copyId: $copyId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES works (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _desiredLanguageMeta = const VerificationMeta(
    'desiredLanguage',
  );
  @override
  late final GeneratedColumn<String> desiredLanguage = GeneratedColumn<String>(
    'desired_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _desiredFormatMeta = const VerificationMeta(
    'desiredFormat',
  );
  @override
  late final GeneratedColumn<String> desiredFormat = GeneratedColumn<String>(
    'desired_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _desiredEditionMeta = const VerificationMeta(
    'desiredEdition',
  );
  @override
  late final GeneratedColumn<String> desiredEdition = GeneratedColumn<String>(
    'desired_edition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workId,
    editionId,
    desiredLanguage,
    desiredFormat,
    desiredEdition,
    priority,
    notes,
    dateAdded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishlistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    }
    if (data.containsKey('desired_language')) {
      context.handle(
        _desiredLanguageMeta,
        desiredLanguage.isAcceptableOrUnknown(
          data['desired_language']!,
          _desiredLanguageMeta,
        ),
      );
    }
    if (data.containsKey('desired_format')) {
      context.handle(
        _desiredFormatMeta,
        desiredFormat.isAcceptableOrUnknown(
          data['desired_format']!,
          _desiredFormatMeta,
        ),
      );
    }
    if (data.containsKey('desired_edition')) {
      context.handle(
        _desiredEditionMeta,
        desiredEdition.isAcceptableOrUnknown(
          data['desired_edition']!,
          _desiredEditionMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      ),
      desiredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desired_language'],
      ),
      desiredFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desired_format'],
      ),
      desiredEdition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desired_edition'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final String id;
  final String workId;

  /// The exact edition wanted, when it is known — a scan captures an ISBN, a
  /// cover and a page count, and throwing those away would mean asking for
  /// them again the day the book is bought.
  final String? editionId;
  final String? desiredLanguage;
  final String? desiredFormat;
  final String? desiredEdition;
  final String priority;
  final String? notes;
  final DateTime dateAdded;
  const WishlistItem({
    required this.id,
    required this.workId,
    this.editionId,
    this.desiredLanguage,
    this.desiredFormat,
    this.desiredEdition,
    required this.priority,
    this.notes,
    required this.dateAdded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    if (!nullToAbsent || editionId != null) {
      map['edition_id'] = Variable<String>(editionId);
    }
    if (!nullToAbsent || desiredLanguage != null) {
      map['desired_language'] = Variable<String>(desiredLanguage);
    }
    if (!nullToAbsent || desiredFormat != null) {
      map['desired_format'] = Variable<String>(desiredFormat);
    }
    if (!nullToAbsent || desiredEdition != null) {
      map['desired_edition'] = Variable<String>(desiredEdition);
    }
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date_added'] = Variable<DateTime>(dateAdded);
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      id: Value(id),
      workId: Value(workId),
      editionId: editionId == null && nullToAbsent
          ? const Value.absent()
          : Value(editionId),
      desiredLanguage: desiredLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredLanguage),
      desiredFormat: desiredFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredFormat),
      desiredEdition: desiredEdition == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredEdition),
      priority: Value(priority),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      dateAdded: Value(dateAdded),
    );
  }

  factory WishlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      editionId: serializer.fromJson<String?>(json['editionId']),
      desiredLanguage: serializer.fromJson<String?>(json['desiredLanguage']),
      desiredFormat: serializer.fromJson<String?>(json['desiredFormat']),
      desiredEdition: serializer.fromJson<String?>(json['desiredEdition']),
      priority: serializer.fromJson<String>(json['priority']),
      notes: serializer.fromJson<String?>(json['notes']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'editionId': serializer.toJson<String?>(editionId),
      'desiredLanguage': serializer.toJson<String?>(desiredLanguage),
      'desiredFormat': serializer.toJson<String?>(desiredFormat),
      'desiredEdition': serializer.toJson<String?>(desiredEdition),
      'priority': serializer.toJson<String>(priority),
      'notes': serializer.toJson<String?>(notes),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
    };
  }

  WishlistItem copyWith({
    String? id,
    String? workId,
    Value<String?> editionId = const Value.absent(),
    Value<String?> desiredLanguage = const Value.absent(),
    Value<String?> desiredFormat = const Value.absent(),
    Value<String?> desiredEdition = const Value.absent(),
    String? priority,
    Value<String?> notes = const Value.absent(),
    DateTime? dateAdded,
  }) => WishlistItem(
    id: id ?? this.id,
    workId: workId ?? this.workId,
    editionId: editionId.present ? editionId.value : this.editionId,
    desiredLanguage: desiredLanguage.present
        ? desiredLanguage.value
        : this.desiredLanguage,
    desiredFormat: desiredFormat.present
        ? desiredFormat.value
        : this.desiredFormat,
    desiredEdition: desiredEdition.present
        ? desiredEdition.value
        : this.desiredEdition,
    priority: priority ?? this.priority,
    notes: notes.present ? notes.value : this.notes,
    dateAdded: dateAdded ?? this.dateAdded,
  );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      desiredLanguage: data.desiredLanguage.present
          ? data.desiredLanguage.value
          : this.desiredLanguage,
      desiredFormat: data.desiredFormat.present
          ? data.desiredFormat.value
          : this.desiredFormat,
      desiredEdition: data.desiredEdition.present
          ? data.desiredEdition.value
          : this.desiredEdition,
      priority: data.priority.present ? data.priority.value : this.priority,
      notes: data.notes.present ? data.notes.value : this.notes,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('desiredLanguage: $desiredLanguage, ')
          ..write('desiredFormat: $desiredFormat, ')
          ..write('desiredEdition: $desiredEdition, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('dateAdded: $dateAdded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workId,
    editionId,
    desiredLanguage,
    desiredFormat,
    desiredEdition,
    priority,
    notes,
    dateAdded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.editionId == this.editionId &&
          other.desiredLanguage == this.desiredLanguage &&
          other.desiredFormat == this.desiredFormat &&
          other.desiredEdition == this.desiredEdition &&
          other.priority == this.priority &&
          other.notes == this.notes &&
          other.dateAdded == this.dateAdded);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String?> editionId;
  final Value<String?> desiredLanguage;
  final Value<String?> desiredFormat;
  final Value<String?> desiredEdition;
  final Value<String> priority;
  final Value<String?> notes;
  final Value<DateTime> dateAdded;
  final Value<int> rowid;
  const WishlistItemsCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.editionId = const Value.absent(),
    this.desiredLanguage = const Value.absent(),
    this.desiredFormat = const Value.absent(),
    this.desiredEdition = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    required String id,
    required String workId,
    this.editionId = const Value.absent(),
    this.desiredLanguage = const Value.absent(),
    this.desiredFormat = const Value.absent(),
    this.desiredEdition = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime dateAdded,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workId = Value(workId),
       dateAdded = Value(dateAdded);
  static Insertable<WishlistItem> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? editionId,
    Expression<String>? desiredLanguage,
    Expression<String>? desiredFormat,
    Expression<String>? desiredEdition,
    Expression<String>? priority,
    Expression<String>? notes,
    Expression<DateTime>? dateAdded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (editionId != null) 'edition_id': editionId,
      if (desiredLanguage != null) 'desired_language': desiredLanguage,
      if (desiredFormat != null) 'desired_format': desiredFormat,
      if (desiredEdition != null) 'desired_edition': desiredEdition,
      if (priority != null) 'priority': priority,
      if (notes != null) 'notes': notes,
      if (dateAdded != null) 'date_added': dateAdded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishlistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? workId,
    Value<String?>? editionId,
    Value<String?>? desiredLanguage,
    Value<String?>? desiredFormat,
    Value<String?>? desiredEdition,
    Value<String>? priority,
    Value<String?>? notes,
    Value<DateTime>? dateAdded,
    Value<int>? rowid,
  }) {
    return WishlistItemsCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      editionId: editionId ?? this.editionId,
      desiredLanguage: desiredLanguage ?? this.desiredLanguage,
      desiredFormat: desiredFormat ?? this.desiredFormat,
      desiredEdition: desiredEdition ?? this.desiredEdition,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      dateAdded: dateAdded ?? this.dateAdded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (desiredLanguage.present) {
      map['desired_language'] = Variable<String>(desiredLanguage.value);
    }
    if (desiredFormat.present) {
      map['desired_format'] = Variable<String>(desiredFormat.value);
    }
    if (desiredEdition.present) {
      map['desired_edition'] = Variable<String>(desiredEdition.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('desiredLanguage: $desiredLanguage, ')
          ..write('desiredFormat: $desiredFormat, ')
          ..write('desiredEdition: $desiredEdition, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingEntriesTable extends ReadingEntries
    with TableInfo<$ReadingEntriesTable, ReadingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES works (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishDateMeta = const VerificationMeta(
    'finishDate',
  );
  @override
  late final GeneratedColumn<DateTime> finishDate = GeneratedColumn<DateTime>(
    'finish_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagesReadMeta = const VerificationMeta(
    'pagesRead',
  );
  @override
  late final GeneratedColumn<int> pagesRead = GeneratedColumn<int>(
    'pages_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedMeta = const VerificationMeta(
    'finished',
  );
  @override
  late final GeneratedColumn<bool> finished = GeneratedColumn<bool>(
    'finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finished" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workId,
    editionId,
    startDate,
    finishDate,
    pagesRead,
    rating,
    notes,
    finished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('finish_date')) {
      context.handle(
        _finishDateMeta,
        finishDate.isAcceptableOrUnknown(data['finish_date']!, _finishDateMeta),
      );
    } else if (isInserting) {
      context.missing(_finishDateMeta);
    }
    if (data.containsKey('pages_read')) {
      context.handle(
        _pagesReadMeta,
        pagesRead.isAcceptableOrUnknown(data['pages_read']!, _pagesReadMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('finished')) {
      context.handle(
        _finishedMeta,
        finished.isAcceptableOrUnknown(data['finished']!, _finishedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      finishDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finish_date'],
      )!,
      pagesRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages_read'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      finished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finished'],
      )!,
    );
  }

  @override
  $ReadingEntriesTable createAlias(String alias) {
    return $ReadingEntriesTable(attachedDatabase, alias);
  }
}

class ReadingEntry extends DataClass implements Insertable<ReadingEntry> {
  final String id;
  final String workId;
  final String? editionId;
  final DateTime? startDate;
  final DateTime finishDate;
  final int pagesRead;
  final double? rating;
  final String? notes;

  /// False when the read was abandoned (DNF).
  final bool finished;
  const ReadingEntry({
    required this.id,
    required this.workId,
    this.editionId,
    this.startDate,
    required this.finishDate,
    required this.pagesRead,
    this.rating,
    this.notes,
    required this.finished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    if (!nullToAbsent || editionId != null) {
      map['edition_id'] = Variable<String>(editionId);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    map['finish_date'] = Variable<DateTime>(finishDate);
    map['pages_read'] = Variable<int>(pagesRead);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['finished'] = Variable<bool>(finished);
    return map;
  }

  ReadingEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReadingEntriesCompanion(
      id: Value(id),
      workId: Value(workId),
      editionId: editionId == null && nullToAbsent
          ? const Value.absent()
          : Value(editionId),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      finishDate: Value(finishDate),
      pagesRead: Value(pagesRead),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      finished: Value(finished),
    );
  }

  factory ReadingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingEntry(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      editionId: serializer.fromJson<String?>(json['editionId']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      finishDate: serializer.fromJson<DateTime>(json['finishDate']),
      pagesRead: serializer.fromJson<int>(json['pagesRead']),
      rating: serializer.fromJson<double?>(json['rating']),
      notes: serializer.fromJson<String?>(json['notes']),
      finished: serializer.fromJson<bool>(json['finished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'editionId': serializer.toJson<String?>(editionId),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'finishDate': serializer.toJson<DateTime>(finishDate),
      'pagesRead': serializer.toJson<int>(pagesRead),
      'rating': serializer.toJson<double?>(rating),
      'notes': serializer.toJson<String?>(notes),
      'finished': serializer.toJson<bool>(finished),
    };
  }

  ReadingEntry copyWith({
    String? id,
    String? workId,
    Value<String?> editionId = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    DateTime? finishDate,
    int? pagesRead,
    Value<double?> rating = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? finished,
  }) => ReadingEntry(
    id: id ?? this.id,
    workId: workId ?? this.workId,
    editionId: editionId.present ? editionId.value : this.editionId,
    startDate: startDate.present ? startDate.value : this.startDate,
    finishDate: finishDate ?? this.finishDate,
    pagesRead: pagesRead ?? this.pagesRead,
    rating: rating.present ? rating.value : this.rating,
    notes: notes.present ? notes.value : this.notes,
    finished: finished ?? this.finished,
  );
  ReadingEntry copyWithCompanion(ReadingEntriesCompanion data) {
    return ReadingEntry(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      finishDate: data.finishDate.present
          ? data.finishDate.value
          : this.finishDate,
      pagesRead: data.pagesRead.present ? data.pagesRead.value : this.pagesRead,
      rating: data.rating.present ? data.rating.value : this.rating,
      notes: data.notes.present ? data.notes.value : this.notes,
      finished: data.finished.present ? data.finished.value : this.finished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingEntry(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('finished: $finished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workId,
    editionId,
    startDate,
    finishDate,
    pagesRead,
    rating,
    notes,
    finished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingEntry &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.editionId == this.editionId &&
          other.startDate == this.startDate &&
          other.finishDate == this.finishDate &&
          other.pagesRead == this.pagesRead &&
          other.rating == this.rating &&
          other.notes == this.notes &&
          other.finished == this.finished);
}

class ReadingEntriesCompanion extends UpdateCompanion<ReadingEntry> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String?> editionId;
  final Value<DateTime?> startDate;
  final Value<DateTime> finishDate;
  final Value<int> pagesRead;
  final Value<double?> rating;
  final Value<String?> notes;
  final Value<bool> finished;
  final Value<int> rowid;
  const ReadingEntriesCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.editionId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.finishDate = const Value.absent(),
    this.pagesRead = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.finished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingEntriesCompanion.insert({
    required String id,
    required String workId,
    this.editionId = const Value.absent(),
    this.startDate = const Value.absent(),
    required DateTime finishDate,
    this.pagesRead = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.finished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workId = Value(workId),
       finishDate = Value(finishDate);
  static Insertable<ReadingEntry> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? editionId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? finishDate,
    Expression<int>? pagesRead,
    Expression<double>? rating,
    Expression<String>? notes,
    Expression<bool>? finished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (editionId != null) 'edition_id': editionId,
      if (startDate != null) 'start_date': startDate,
      if (finishDate != null) 'finish_date': finishDate,
      if (pagesRead != null) 'pages_read': pagesRead,
      if (rating != null) 'rating': rating,
      if (notes != null) 'notes': notes,
      if (finished != null) 'finished': finished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? workId,
    Value<String?>? editionId,
    Value<DateTime?>? startDate,
    Value<DateTime>? finishDate,
    Value<int>? pagesRead,
    Value<double?>? rating,
    Value<String?>? notes,
    Value<bool>? finished,
    Value<int>? rowid,
  }) {
    return ReadingEntriesCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      editionId: editionId ?? this.editionId,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      pagesRead: pagesRead ?? this.pagesRead,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      finished: finished ?? this.finished,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (finishDate.present) {
      map['finish_date'] = Variable<DateTime>(finishDate.value);
    }
    if (pagesRead.present) {
      map['pages_read'] = Variable<int>(pagesRead.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (finished.present) {
      map['finished'] = Variable<bool>(finished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingEntriesCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('finished: $finished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentSearchesTable extends RecentSearches
    with TableInfo<$RecentSearchesTable, RecentSearch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentSearchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchedAtMeta = const VerificationMeta(
    'searchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
    'searched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultCountMeta = const VerificationMeta(
    'resultCount',
  );
  @override
  late final GeneratedColumn<int> resultCount = GeneratedColumn<int>(
    'result_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [query, searchedAt, resultCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_searches';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentSearch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(
        _searchedAtMeta,
        searchedAt.isAcceptableOrUnknown(data['searched_at']!, _searchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    if (data.containsKey('result_count')) {
      context.handle(
        _resultCountMeta,
        resultCount.isAcceptableOrUnknown(
          data['result_count']!,
          _resultCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {query};
  @override
  RecentSearch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentSearch(
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      searchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}searched_at'],
      )!,
      resultCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}result_count'],
      )!,
    );
  }

  @override
  $RecentSearchesTable createAlias(String alias) {
    return $RecentSearchesTable(attachedDatabase, alias);
  }
}

class RecentSearch extends DataClass implements Insertable<RecentSearch> {
  final String query;
  final DateTime searchedAt;
  final int resultCount;
  const RecentSearch({
    required this.query,
    required this.searchedAt,
    required this.resultCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query'] = Variable<String>(query);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    map['result_count'] = Variable<int>(resultCount);
    return map;
  }

  RecentSearchesCompanion toCompanion(bool nullToAbsent) {
    return RecentSearchesCompanion(
      query: Value(query),
      searchedAt: Value(searchedAt),
      resultCount: Value(resultCount),
    );
  }

  factory RecentSearch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentSearch(
      query: serializer.fromJson<String>(json['query']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
      resultCount: serializer.fromJson<int>(json['resultCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'query': serializer.toJson<String>(query),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
      'resultCount': serializer.toJson<int>(resultCount),
    };
  }

  RecentSearch copyWith({
    String? query,
    DateTime? searchedAt,
    int? resultCount,
  }) => RecentSearch(
    query: query ?? this.query,
    searchedAt: searchedAt ?? this.searchedAt,
    resultCount: resultCount ?? this.resultCount,
  );
  RecentSearch copyWithCompanion(RecentSearchesCompanion data) {
    return RecentSearch(
      query: data.query.present ? data.query.value : this.query,
      searchedAt: data.searchedAt.present
          ? data.searchedAt.value
          : this.searchedAt,
      resultCount: data.resultCount.present
          ? data.resultCount.value
          : this.resultCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearch(')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt, ')
          ..write('resultCount: $resultCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(query, searchedAt, resultCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentSearch &&
          other.query == this.query &&
          other.searchedAt == this.searchedAt &&
          other.resultCount == this.resultCount);
}

class RecentSearchesCompanion extends UpdateCompanion<RecentSearch> {
  final Value<String> query;
  final Value<DateTime> searchedAt;
  final Value<int> resultCount;
  final Value<int> rowid;
  const RecentSearchesCompanion({
    this.query = const Value.absent(),
    this.searchedAt = const Value.absent(),
    this.resultCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentSearchesCompanion.insert({
    required String query,
    required DateTime searchedAt,
    this.resultCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : query = Value(query),
       searchedAt = Value(searchedAt);
  static Insertable<RecentSearch> custom({
    Expression<String>? query,
    Expression<DateTime>? searchedAt,
    Expression<int>? resultCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (query != null) 'query': query,
      if (searchedAt != null) 'searched_at': searchedAt,
      if (resultCount != null) 'result_count': resultCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentSearchesCompanion copyWith({
    Value<String>? query,
    Value<DateTime>? searchedAt,
    Value<int>? resultCount,
    Value<int>? rowid,
  }) {
    return RecentSearchesCompanion(
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
      resultCount: resultCount ?? this.resultCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    if (resultCount.present) {
      map['result_count'] = Variable<int>(resultCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchesCompanion(')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt, ')
          ..write('resultCount: $resultCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorksTable works = $WorksTable(this);
  late final $EditionsTable editions = $EditionsTable(this);
  late final $CopiesTable copies = $CopiesTable(this);
  late final $CopyPhotosTable copyPhotos = $CopyPhotosTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $CopyTagsTable copyTags = $CopyTagsTable(this);
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  late final $ReadingEntriesTable readingEntries = $ReadingEntriesTable(this);
  late final $RecentSearchesTable recentSearches = $RecentSearchesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    works,
    editions,
    copies,
    copyPhotos,
    tags,
    copyTags,
    wishlistItems,
    readingEntries,
    recentSearches,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'works',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('editions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'copies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copy_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'copies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copy_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copy_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'works',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wishlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'works',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorksTableCreateCompanionBuilder =
    WorksCompanion Function({
      required String id,
      required String title,
      required List<String> authors,
      Value<String?> originalTitle,
      Value<String?> originalLanguage,
      Value<String?> description,
      required List<String> genres,
      Value<String?> seriesName,
      Value<int?> seriesIndex,
      Value<int?> firstPublished,
      Value<String?> primaryEditionId,
      Value<String> readingStatus,
      Value<int> currentPage,
      Value<DateTime?> startDate,
      Value<DateTime?> finishDate,
      Value<double?> rating,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorksTableUpdateCompanionBuilder =
    WorksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<List<String>> authors,
      Value<String?> originalTitle,
      Value<String?> originalLanguage,
      Value<String?> description,
      Value<List<String>> genres,
      Value<String?> seriesName,
      Value<int?> seriesIndex,
      Value<int?> firstPublished,
      Value<String?> primaryEditionId,
      Value<String> readingStatus,
      Value<int> currentPage,
      Value<DateTime?> startDate,
      Value<DateTime?> finishDate,
      Value<double?> rating,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorksTableReferences
    extends BaseReferences<_$AppDatabase, $WorksTable, Work> {
  $$WorksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EditionsTable, List<Edition>> _editionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.editions,
    aliasName: 'works__id__editions__work_id',
  );

  $$EditionsTableProcessedTableManager get editionsRefs {
    final manager = $$EditionsTableTableManager(
      $_db,
      $_db.editions,
    ).filter((f) => f.workId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_editionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WishlistItemsTable, List<WishlistItem>>
  _wishlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wishlistItems,
    aliasName: 'works__id__wishlist_items__work_id',
  );

  $$WishlistItemsTableProcessedTableManager get wishlistItemsRefs {
    final manager = $$WishlistItemsTableTableManager(
      $_db,
      $_db.wishlistItems,
    ).filter((f) => f.workId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wishlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingEntriesTable, List<ReadingEntry>>
  _readingEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingEntries,
    aliasName: 'works__id__reading_entries__work_id',
  );

  $$ReadingEntriesTableProcessedTableManager get readingEntriesRefs {
    final manager = $$ReadingEntriesTableTableManager(
      $_db,
      $_db.readingEntries,
    ).filter((f) => f.workId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorksTableFilterComposer extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seriesIndex => $composableBuilder(
    column: $table.seriesIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstPublished => $composableBuilder(
    column: $table.firstPublished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryEditionId => $composableBuilder(
    column: $table.primaryEditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> editionsRefs(
    Expression<bool> Function($$EditionsTableFilterComposer f) f,
  ) {
    final $$EditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableFilterComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wishlistItemsRefs(
    Expression<bool> Function($$WishlistItemsTableFilterComposer f) f,
  ) {
    final $$WishlistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableFilterComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingEntriesRefs(
    Expression<bool> Function($$ReadingEntriesTableFilterComposer f) f,
  ) {
    final $$ReadingEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingEntries,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingEntriesTableFilterComposer(
            $db: $db,
            $table: $db.readingEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seriesIndex => $composableBuilder(
    column: $table.seriesIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstPublished => $composableBuilder(
    column: $table.firstPublished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryEditionId => $composableBuilder(
    column: $table.primaryEditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumn<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seriesIndex => $composableBuilder(
    column: $table.seriesIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstPublished => $composableBuilder(
    column: $table.firstPublished,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryEditionId => $composableBuilder(
    column: $table.primaryEditionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> editionsRefs<T extends Object>(
    Expression<T> Function($$EditionsTableAnnotationComposer a) f,
  ) {
    final $$EditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wishlistItemsRefs<T extends Object>(
    Expression<T> Function($$WishlistItemsTableAnnotationComposer a) f,
  ) {
    final $$WishlistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingEntriesRefs<T extends Object>(
    Expression<T> Function($$ReadingEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReadingEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingEntries,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.readingEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorksTable,
          Work,
          $$WorksTableFilterComposer,
          $$WorksTableOrderingComposer,
          $$WorksTableAnnotationComposer,
          $$WorksTableCreateCompanionBuilder,
          $$WorksTableUpdateCompanionBuilder,
          (Work, $$WorksTableReferences),
          Work,
          PrefetchHooks Function({
            bool editionsRefs,
            bool wishlistItemsRefs,
            bool readingEntriesRefs,
          })
        > {
  $$WorksTableTableManager(_$AppDatabase db, $WorksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<List<String>> authors = const Value.absent(),
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<List<String>> genres = const Value.absent(),
                Value<String?> seriesName = const Value.absent(),
                Value<int?> seriesIndex = const Value.absent(),
                Value<int?> firstPublished = const Value.absent(),
                Value<String?> primaryEditionId = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> finishDate = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorksCompanion(
                id: id,
                title: title,
                authors: authors,
                originalTitle: originalTitle,
                originalLanguage: originalLanguage,
                description: description,
                genres: genres,
                seriesName: seriesName,
                seriesIndex: seriesIndex,
                firstPublished: firstPublished,
                primaryEditionId: primaryEditionId,
                readingStatus: readingStatus,
                currentPage: currentPage,
                startDate: startDate,
                finishDate: finishDate,
                rating: rating,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required List<String> authors,
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required List<String> genres,
                Value<String?> seriesName = const Value.absent(),
                Value<int?> seriesIndex = const Value.absent(),
                Value<int?> firstPublished = const Value.absent(),
                Value<String?> primaryEditionId = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> finishDate = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorksCompanion.insert(
                id: id,
                title: title,
                authors: authors,
                originalTitle: originalTitle,
                originalLanguage: originalLanguage,
                description: description,
                genres: genres,
                seriesName: seriesName,
                seriesIndex: seriesIndex,
                firstPublished: firstPublished,
                primaryEditionId: primaryEditionId,
                readingStatus: readingStatus,
                currentPage: currentPage,
                startDate: startDate,
                finishDate: finishDate,
                rating: rating,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorksTable, Work>(table),
                  $$WorksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                editionsRefs = false,
                wishlistItemsRefs = false,
                readingEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (editionsRefs) db.editions,
                    if (wishlistItemsRefs) db.wishlistItems,
                    if (readingEntriesRefs) db.readingEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (editionsRefs)
                        await $_getPrefetchedData<Work, $WorksTable, Edition>(
                          currentTable: table,
                          referencedTable: $$WorksTableReferences
                              ._editionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorksTableReferences(
                                db,
                                table,
                                p0,
                              ).editionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wishlistItemsRefs)
                        await $_getPrefetchedData<
                          Work,
                          $WorksTable,
                          WishlistItem
                        >(
                          currentTable: table,
                          referencedTable: $$WorksTableReferences
                              ._wishlistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorksTableReferences(
                                db,
                                table,
                                p0,
                              ).wishlistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingEntriesRefs)
                        await $_getPrefetchedData<
                          Work,
                          $WorksTable,
                          ReadingEntry
                        >(
                          currentTable: table,
                          referencedTable: $$WorksTableReferences
                              ._readingEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorksTable,
      Work,
      $$WorksTableFilterComposer,
      $$WorksTableOrderingComposer,
      $$WorksTableAnnotationComposer,
      $$WorksTableCreateCompanionBuilder,
      $$WorksTableUpdateCompanionBuilder,
      (Work, $$WorksTableReferences),
      Work,
      PrefetchHooks Function({
        bool editionsRefs,
        bool wishlistItemsRefs,
        bool readingEntriesRefs,
      })
    >;
typedef $$EditionsTableCreateCompanionBuilder =
    EditionsCompanion Function({
      required String id,
      required String workId,
      Value<String?> isbn13,
      Value<String?> isbn10,
      Value<String?> publisher,
      Value<String?> publicationDate,
      Value<int?> publishedYear,
      Value<String?> language,
      Value<String?> format,
      Value<String?> editionName,
      Value<int?> pageCount,
      Value<String?> coverUrl,
      Value<String?> coverImagePath,
      Value<int> coverColorIndex,
      Value<String?> dimensions,
      Value<double?> weightGrams,
      Value<String?> translator,
      required List<String> illustrators,
      Value<String?> country,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EditionsTableUpdateCompanionBuilder =
    EditionsCompanion Function({
      Value<String> id,
      Value<String> workId,
      Value<String?> isbn13,
      Value<String?> isbn10,
      Value<String?> publisher,
      Value<String?> publicationDate,
      Value<int?> publishedYear,
      Value<String?> language,
      Value<String?> format,
      Value<String?> editionName,
      Value<int?> pageCount,
      Value<String?> coverUrl,
      Value<String?> coverImagePath,
      Value<int> coverColorIndex,
      Value<String?> dimensions,
      Value<double?> weightGrams,
      Value<String?> translator,
      Value<List<String>> illustrators,
      Value<String?> country,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$EditionsTableReferences
    extends BaseReferences<_$AppDatabase, $EditionsTable, Edition> {
  $$EditionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorksTable _workIdTable(_$AppDatabase db) =>
      db.works.createAlias('editions__work_id__works__id');

  $$WorksTableProcessedTableManager get workId {
    final $_column = $_itemColumn<String>('work_id')!;

    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CopiesTable, List<Copy>> _copiesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.copies,
    aliasName: 'editions__id__copies__edition_id',
  );

  $$CopiesTableProcessedTableManager get copiesRefs {
    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EditionsTableFilterComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn10 => $composableBuilder(
    column: $table.isbn10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColorIndex => $composableBuilder(
    column: $table.coverColorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get illustrators => $composableBuilder(
    column: $table.illustrators,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> copiesRefs(
    Expression<bool> Function($$CopiesTableFilterComposer f) f,
  ) {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn10 => $composableBuilder(
    column: $table.isbn10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColorIndex => $composableBuilder(
    column: $table.coverColorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illustrators => $composableBuilder(
    column: $table.illustrators,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableOrderingComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get isbn13 =>
      $composableBuilder(column: $table.isbn13, builder: (column) => column);

  GeneratedColumn<String> get isbn10 =>
      $composableBuilder(column: $table.isbn10, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coverColorIndex => $composableBuilder(
    column: $table.coverColorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get illustrators =>
      $composableBuilder(
        column: $table.illustrators,
        builder: (column) => column,
      );

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorksTableAnnotationComposer get workId {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> copiesRefs<T extends Object>(
    Expression<T> Function($$CopiesTableAnnotationComposer a) f,
  ) {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EditionsTable,
          Edition,
          $$EditionsTableFilterComposer,
          $$EditionsTableOrderingComposer,
          $$EditionsTableAnnotationComposer,
          $$EditionsTableCreateCompanionBuilder,
          $$EditionsTableUpdateCompanionBuilder,
          (Edition, $$EditionsTableReferences),
          Edition,
          PrefetchHooks Function({bool workId, bool copiesRefs})
        > {
  $$EditionsTableTableManager(_$AppDatabase db, $EditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workId = const Value.absent(),
                Value<String?> isbn13 = const Value.absent(),
                Value<String?> isbn10 = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publicationDate = const Value.absent(),
                Value<int?> publishedYear = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> format = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<int> coverColorIndex = const Value.absent(),
                Value<String?> dimensions = const Value.absent(),
                Value<double?> weightGrams = const Value.absent(),
                Value<String?> translator = const Value.absent(),
                Value<List<String>> illustrators = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion(
                id: id,
                workId: workId,
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
                illustrators: illustrators,
                country: country,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workId,
                Value<String?> isbn13 = const Value.absent(),
                Value<String?> isbn10 = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publicationDate = const Value.absent(),
                Value<int?> publishedYear = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> format = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<int> coverColorIndex = const Value.absent(),
                Value<String?> dimensions = const Value.absent(),
                Value<double?> weightGrams = const Value.absent(),
                Value<String?> translator = const Value.absent(),
                required List<String> illustrators,
                Value<String?> country = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion.insert(
                id: id,
                workId: workId,
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
                illustrators: illustrators,
                country: country,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EditionsTable, Edition>(table),
                  $$EditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workId = false, copiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (copiesRefs) db.copies],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workId,
                                referencedTable: $$EditionsTableReferences
                                    ._workIdTable(db),
                                referencedColumn: $$EditionsTableReferences
                                    ._workIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (copiesRefs)
                    await $_getPrefetchedData<Edition, $EditionsTable, Copy>(
                      currentTable: table,
                      referencedTable: $$EditionsTableReferences
                          ._copiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EditionsTableReferences(db, table, p0).copiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.editionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EditionsTable,
      Edition,
      $$EditionsTableFilterComposer,
      $$EditionsTableOrderingComposer,
      $$EditionsTableAnnotationComposer,
      $$EditionsTableCreateCompanionBuilder,
      $$EditionsTableUpdateCompanionBuilder,
      (Edition, $$EditionsTableReferences),
      Edition,
      PrefetchHooks Function({bool workId, bool copiesRefs})
    >;
typedef $$CopiesTableCreateCompanionBuilder =
    CopiesCompanion Function({
      required String id,
      required String editionId,
      Value<String> ownership,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<String?> currency,
      Value<String?> store,
      Value<bool> isGift,
      Value<String?> giftFrom,
      Value<String?> condition,
      Value<String?> location,
      Value<String?> notes,
      required DateTime addedDate,
      Value<int> rowid,
    });
typedef $$CopiesTableUpdateCompanionBuilder =
    CopiesCompanion Function({
      Value<String> id,
      Value<String> editionId,
      Value<String> ownership,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<String?> currency,
      Value<String?> store,
      Value<bool> isGift,
      Value<String?> giftFrom,
      Value<String?> condition,
      Value<String?> location,
      Value<String?> notes,
      Value<DateTime> addedDate,
      Value<int> rowid,
    });

final class $$CopiesTableReferences
    extends BaseReferences<_$AppDatabase, $CopiesTable, Copy> {
  $$CopiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EditionsTable _editionIdTable(_$AppDatabase db) =>
      db.editions.createAlias('copies__edition_id__editions__id');

  $$EditionsTableProcessedTableManager get editionId {
    final $_column = $_itemColumn<String>('edition_id')!;

    final manager = $$EditionsTableTableManager(
      $_db,
      $_db.editions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CopyPhotosTable, List<CopyPhoto>>
  _copyPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.copyPhotos,
    aliasName: 'copies__id__copy_photos__copy_id',
  );

  $$CopyPhotosTableProcessedTableManager get copyPhotosRefs {
    final manager = $$CopyPhotosTableTableManager(
      $_db,
      $_db.copyPhotos,
    ).filter((f) => f.copyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copyPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CopyTagsTable, List<CopyTag>> _copyTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.copyTags,
    aliasName: 'copies__id__copy_tags__copy_id',
  );

  $$CopyTagsTableProcessedTableManager get copyTagsRefs {
    final manager = $$CopyTagsTableTableManager(
      $_db,
      $_db.copyTags,
    ).filter((f) => f.copyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copyTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CopiesTableFilterComposer
    extends Composer<_$AppDatabase, $CopiesTable> {
  $$CopiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownership => $composableBuilder(
    column: $table.ownership,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGift => $composableBuilder(
    column: $table.isGift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get giftFrom => $composableBuilder(
    column: $table.giftFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
    column: $table.addedDate,
    builder: (column) => ColumnFilters(column),
  );

  $$EditionsTableFilterComposer get editionId {
    final $$EditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableFilterComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> copyPhotosRefs(
    Expression<bool> Function($$CopyPhotosTableFilterComposer f) f,
  ) {
    final $$CopyPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyPhotos,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyPhotosTableFilterComposer(
            $db: $db,
            $table: $db.copyPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> copyTagsRefs(
    Expression<bool> Function($$CopyTagsTableFilterComposer f) f,
  ) {
    final $$CopyTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyTags,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyTagsTableFilterComposer(
            $db: $db,
            $table: $db.copyTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CopiesTable> {
  $$CopiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownership => $composableBuilder(
    column: $table.ownership,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGift => $composableBuilder(
    column: $table.isGift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get giftFrom => $composableBuilder(
    column: $table.giftFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
    column: $table.addedDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$EditionsTableOrderingComposer get editionId {
    final $$EditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableOrderingComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CopiesTable> {
  $$CopiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownership =>
      $composableBuilder(column: $table.ownership, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<bool> get isGift =>
      $composableBuilder(column: $table.isGift, builder: (column) => column);

  GeneratedColumn<String> get giftFrom =>
      $composableBuilder(column: $table.giftFrom, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  $$EditionsTableAnnotationComposer get editionId {
    final $$EditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> copyPhotosRefs<T extends Object>(
    Expression<T> Function($$CopyPhotosTableAnnotationComposer a) f,
  ) {
    final $$CopyPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyPhotos,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.copyPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> copyTagsRefs<T extends Object>(
    Expression<T> Function($$CopyTagsTableAnnotationComposer a) f,
  ) {
    final $$CopyTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyTags,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.copyTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CopiesTable,
          Copy,
          $$CopiesTableFilterComposer,
          $$CopiesTableOrderingComposer,
          $$CopiesTableAnnotationComposer,
          $$CopiesTableCreateCompanionBuilder,
          $$CopiesTableUpdateCompanionBuilder,
          (Copy, $$CopiesTableReferences),
          Copy,
          PrefetchHooks Function({
            bool editionId,
            bool copyPhotosRefs,
            bool copyTagsRefs,
          })
        > {
  $$CopiesTableTableManager(_$AppDatabase db, $CopiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> editionId = const Value.absent(),
                Value<String> ownership = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> store = const Value.absent(),
                Value<bool> isGift = const Value.absent(),
                Value<String?> giftFrom = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> addedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopiesCompanion(
                id: id,
                editionId: editionId,
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
                addedDate: addedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String editionId,
                Value<String> ownership = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> store = const Value.absent(),
                Value<bool> isGift = const Value.absent(),
                Value<String?> giftFrom = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime addedDate,
                Value<int> rowid = const Value.absent(),
              }) => CopiesCompanion.insert(
                id: id,
                editionId: editionId,
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
                addedDate: addedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopiesTable, Copy>(table),
                  $$CopiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                editionId = false,
                copyPhotosRefs = false,
                copyTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (copyPhotosRefs) db.copyPhotos,
                    if (copyTagsRefs) db.copyTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (editionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.editionId,
                                    referencedTable: $$CopiesTableReferences
                                        ._editionIdTable(db),
                                    referencedColumn: $$CopiesTableReferences
                                        ._editionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (copyPhotosRefs)
                        await $_getPrefetchedData<
                          Copy,
                          $CopiesTable,
                          CopyPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$CopiesTableReferences
                              ._copyPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopiesTableReferences(
                                db,
                                table,
                                p0,
                              ).copyPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (copyTagsRefs)
                        await $_getPrefetchedData<Copy, $CopiesTable, CopyTag>(
                          currentTable: table,
                          referencedTable: $$CopiesTableReferences
                              ._copyTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopiesTableReferences(
                                db,
                                table,
                                p0,
                              ).copyTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CopiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CopiesTable,
      Copy,
      $$CopiesTableFilterComposer,
      $$CopiesTableOrderingComposer,
      $$CopiesTableAnnotationComposer,
      $$CopiesTableCreateCompanionBuilder,
      $$CopiesTableUpdateCompanionBuilder,
      (Copy, $$CopiesTableReferences),
      Copy,
      PrefetchHooks Function({
        bool editionId,
        bool copyPhotosRefs,
        bool copyTagsRefs,
      })
    >;
typedef $$CopyPhotosTableCreateCompanionBuilder =
    CopyPhotosCompanion Function({
      required String id,
      required String copyId,
      required String path,
      Value<String> type,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$CopyPhotosTableUpdateCompanionBuilder =
    CopyPhotosCompanion Function({
      Value<String> id,
      Value<String> copyId,
      Value<String> path,
      Value<String> type,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$CopyPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $CopyPhotosTable, CopyPhoto> {
  $$CopyPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CopiesTable _copyIdTable(_$AppDatabase db) =>
      db.copies.createAlias('copy_photos__copy_id__copies__id');

  $$CopiesTableProcessedTableManager get copyId {
    final $_column = $_itemColumn<String>('copy_id')!;

    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CopyPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $CopyPhotosTable> {
  $$CopyPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CopiesTableFilterComposer get copyId {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $CopyPhotosTable> {
  $$CopyPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CopiesTableOrderingComposer get copyId {
    final $$CopiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableOrderingComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CopyPhotosTable> {
  $$CopyPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$CopiesTableAnnotationComposer get copyId {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CopyPhotosTable,
          CopyPhoto,
          $$CopyPhotosTableFilterComposer,
          $$CopyPhotosTableOrderingComposer,
          $$CopyPhotosTableAnnotationComposer,
          $$CopyPhotosTableCreateCompanionBuilder,
          $$CopyPhotosTableUpdateCompanionBuilder,
          (CopyPhoto, $$CopyPhotosTableReferences),
          CopyPhoto,
          PrefetchHooks Function({bool copyId})
        > {
  $$CopyPhotosTableTableManager(_$AppDatabase db, $CopyPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopyPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopyPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopyPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> copyId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopyPhotosCompanion(
                id: id,
                copyId: copyId,
                path: path,
                type: type,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String copyId,
                required String path,
                Value<String> type = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => CopyPhotosCompanion.insert(
                id: id,
                copyId: copyId,
                path: path,
                type: type,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopyPhotosTable, CopyPhoto>(table),
                  $$CopyPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({copyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (copyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.copyId,
                                referencedTable: $$CopyPhotosTableReferences
                                    ._copyIdTable(db),
                                referencedColumn: $$CopyPhotosTableReferences
                                    ._copyIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CopyPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CopyPhotosTable,
      CopyPhoto,
      $$CopyPhotosTableFilterComposer,
      $$CopyPhotosTableOrderingComposer,
      $$CopyPhotosTableAnnotationComposer,
      $$CopyPhotosTableCreateCompanionBuilder,
      $$CopyPhotosTableUpdateCompanionBuilder,
      (CopyPhoto, $$CopyPhotosTableReferences),
      CopyPhoto,
      PrefetchHooks Function({bool copyId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CopyTagsTable, List<CopyTag>> _copyTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.copyTags,
    aliasName: 'tags__id__copy_tags__tag_id',
  );

  $$CopyTagsTableProcessedTableManager get copyTagsRefs {
    final manager = $$CopyTagsTableTableManager(
      $_db,
      $_db.copyTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copyTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> copyTagsRefs(
    Expression<bool> Function($$CopyTagsTableFilterComposer f) f,
  ) {
    final $$CopyTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyTagsTableFilterComposer(
            $db: $db,
            $table: $db.copyTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> copyTagsRefs<T extends Object>(
    Expression<T> Function($$CopyTagsTableAnnotationComposer a) f,
  ) {
    final $$CopyTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.copyTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool copyTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({copyTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (copyTagsRefs) db.copyTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (copyTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, CopyTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._copyTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).copyTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool copyTagsRefs})
    >;
typedef $$CopyTagsTableCreateCompanionBuilder =
    CopyTagsCompanion Function({
      required String copyId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$CopyTagsTableUpdateCompanionBuilder =
    CopyTagsCompanion Function({
      Value<String> copyId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$CopyTagsTableReferences
    extends BaseReferences<_$AppDatabase, $CopyTagsTable, CopyTag> {
  $$CopyTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CopiesTable _copyIdTable(_$AppDatabase db) =>
      db.copies.createAlias('copy_tags__copy_id__copies__id');

  $$CopiesTableProcessedTableManager get copyId {
    final $_column = $_itemColumn<String>('copy_id')!;

    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('copy_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CopyTagsTableFilterComposer
    extends Composer<_$AppDatabase, $CopyTagsTable> {
  $$CopyTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CopiesTableFilterComposer get copyId {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $CopyTagsTable> {
  $$CopyTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CopiesTableOrderingComposer get copyId {
    final $$CopiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableOrderingComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CopyTagsTable> {
  $$CopyTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CopiesTableAnnotationComposer get copyId {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CopyTagsTable,
          CopyTag,
          $$CopyTagsTableFilterComposer,
          $$CopyTagsTableOrderingComposer,
          $$CopyTagsTableAnnotationComposer,
          $$CopyTagsTableCreateCompanionBuilder,
          $$CopyTagsTableUpdateCompanionBuilder,
          (CopyTag, $$CopyTagsTableReferences),
          CopyTag,
          PrefetchHooks Function({bool copyId, bool tagId})
        > {
  $$CopyTagsTableTableManager(_$AppDatabase db, $CopyTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopyTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopyTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopyTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> copyId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  CopyTagsCompanion(copyId: copyId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required String copyId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => CopyTagsCompanion.insert(
                copyId: copyId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopyTagsTable, CopyTag>(table),
                  $$CopyTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({copyId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (copyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.copyId,
                                referencedTable: $$CopyTagsTableReferences
                                    ._copyIdTable(db),
                                referencedColumn: $$CopyTagsTableReferences
                                    ._copyIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$CopyTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$CopyTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CopyTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CopyTagsTable,
      CopyTag,
      $$CopyTagsTableFilterComposer,
      $$CopyTagsTableOrderingComposer,
      $$CopyTagsTableAnnotationComposer,
      $$CopyTagsTableCreateCompanionBuilder,
      $$CopyTagsTableUpdateCompanionBuilder,
      (CopyTag, $$CopyTagsTableReferences),
      CopyTag,
      PrefetchHooks Function({bool copyId, bool tagId})
    >;
typedef $$WishlistItemsTableCreateCompanionBuilder =
    WishlistItemsCompanion Function({
      required String id,
      required String workId,
      Value<String?> editionId,
      Value<String?> desiredLanguage,
      Value<String?> desiredFormat,
      Value<String?> desiredEdition,
      Value<String> priority,
      Value<String?> notes,
      required DateTime dateAdded,
      Value<int> rowid,
    });
typedef $$WishlistItemsTableUpdateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<String> id,
      Value<String> workId,
      Value<String?> editionId,
      Value<String?> desiredLanguage,
      Value<String?> desiredFormat,
      Value<String?> desiredEdition,
      Value<String> priority,
      Value<String?> notes,
      Value<DateTime> dateAdded,
      Value<int> rowid,
    });

final class $$WishlistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem> {
  $$WishlistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorksTable _workIdTable(_$AppDatabase db) =>
      db.works.createAlias('wishlist_items__work_id__works__id');

  $$WorksTableProcessedTableManager get workId {
    final $_column = $_itemColumn<String>('work_id')!;

    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get desiredLanguage => $composableBuilder(
    column: $table.desiredLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get desiredFormat => $composableBuilder(
    column: $table.desiredFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get desiredEdition => $composableBuilder(
    column: $table.desiredEdition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get desiredLanguage => $composableBuilder(
    column: $table.desiredLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get desiredFormat => $composableBuilder(
    column: $table.desiredFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get desiredEdition => $composableBuilder(
    column: $table.desiredEdition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableOrderingComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get editionId =>
      $composableBuilder(column: $table.editionId, builder: (column) => column);

  GeneratedColumn<String> get desiredLanguage => $composableBuilder(
    column: $table.desiredLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get desiredFormat => $composableBuilder(
    column: $table.desiredFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get desiredEdition => $composableBuilder(
    column: $table.desiredEdition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  $$WorksTableAnnotationComposer get workId {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishlistItemsTable,
          WishlistItem,
          $$WishlistItemsTableFilterComposer,
          $$WishlistItemsTableOrderingComposer,
          $$WishlistItemsTableAnnotationComposer,
          $$WishlistItemsTableCreateCompanionBuilder,
          $$WishlistItemsTableUpdateCompanionBuilder,
          (WishlistItem, $$WishlistItemsTableReferences),
          WishlistItem,
          PrefetchHooks Function({bool workId})
        > {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workId = const Value.absent(),
                Value<String?> editionId = const Value.absent(),
                Value<String?> desiredLanguage = const Value.absent(),
                Value<String?> desiredFormat = const Value.absent(),
                Value<String?> desiredEdition = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion(
                id: id,
                workId: workId,
                editionId: editionId,
                desiredLanguage: desiredLanguage,
                desiredFormat: desiredFormat,
                desiredEdition: desiredEdition,
                priority: priority,
                notes: notes,
                dateAdded: dateAdded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workId,
                Value<String?> editionId = const Value.absent(),
                Value<String?> desiredLanguage = const Value.absent(),
                Value<String?> desiredFormat = const Value.absent(),
                Value<String?> desiredEdition = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime dateAdded,
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion.insert(
                id: id,
                workId: workId,
                editionId: editionId,
                desiredLanguage: desiredLanguage,
                desiredFormat: desiredFormat,
                desiredEdition: desiredEdition,
                priority: priority,
                notes: notes,
                dateAdded: dateAdded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WishlistItemsTable, WishlistItem>(table),
                  $$WishlistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workId,
                                referencedTable: $$WishlistItemsTableReferences
                                    ._workIdTable(db),
                                referencedColumn: $$WishlistItemsTableReferences
                                    ._workIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WishlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishlistItemsTable,
      WishlistItem,
      $$WishlistItemsTableFilterComposer,
      $$WishlistItemsTableOrderingComposer,
      $$WishlistItemsTableAnnotationComposer,
      $$WishlistItemsTableCreateCompanionBuilder,
      $$WishlistItemsTableUpdateCompanionBuilder,
      (WishlistItem, $$WishlistItemsTableReferences),
      WishlistItem,
      PrefetchHooks Function({bool workId})
    >;
typedef $$ReadingEntriesTableCreateCompanionBuilder =
    ReadingEntriesCompanion Function({
      required String id,
      required String workId,
      Value<String?> editionId,
      Value<DateTime?> startDate,
      required DateTime finishDate,
      Value<int> pagesRead,
      Value<double?> rating,
      Value<String?> notes,
      Value<bool> finished,
      Value<int> rowid,
    });
typedef $$ReadingEntriesTableUpdateCompanionBuilder =
    ReadingEntriesCompanion Function({
      Value<String> id,
      Value<String> workId,
      Value<String?> editionId,
      Value<DateTime?> startDate,
      Value<DateTime> finishDate,
      Value<int> pagesRead,
      Value<double?> rating,
      Value<String?> notes,
      Value<bool> finished,
      Value<int> rowid,
    });

final class $$ReadingEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingEntriesTable, ReadingEntry> {
  $$ReadingEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorksTable _workIdTable(_$AppDatabase db) =>
      db.works.createAlias('reading_entries__work_id__works__id');

  $$WorksTableProcessedTableManager get workId {
    final $_column = $_itemColumn<String>('work_id')!;

    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingEntriesTable> {
  $$ReadingEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pagesRead => $composableBuilder(
    column: $table.pagesRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get finished => $composableBuilder(
    column: $table.finished,
    builder: (column) => ColumnFilters(column),
  );

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingEntriesTable> {
  $$ReadingEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pagesRead => $composableBuilder(
    column: $table.pagesRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get finished => $composableBuilder(
    column: $table.finished,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableOrderingComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingEntriesTable> {
  $$ReadingEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get editionId =>
      $composableBuilder(column: $table.editionId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pagesRead =>
      $composableBuilder(column: $table.pagesRead, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get finished =>
      $composableBuilder(column: $table.finished, builder: (column) => column);

  $$WorksTableAnnotationComposer get workId {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingEntriesTable,
          ReadingEntry,
          $$ReadingEntriesTableFilterComposer,
          $$ReadingEntriesTableOrderingComposer,
          $$ReadingEntriesTableAnnotationComposer,
          $$ReadingEntriesTableCreateCompanionBuilder,
          $$ReadingEntriesTableUpdateCompanionBuilder,
          (ReadingEntry, $$ReadingEntriesTableReferences),
          ReadingEntry,
          PrefetchHooks Function({bool workId})
        > {
  $$ReadingEntriesTableTableManager(
    _$AppDatabase db,
    $ReadingEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workId = const Value.absent(),
                Value<String?> editionId = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime> finishDate = const Value.absent(),
                Value<int> pagesRead = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> finished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingEntriesCompanion(
                id: id,
                workId: workId,
                editionId: editionId,
                startDate: startDate,
                finishDate: finishDate,
                pagesRead: pagesRead,
                rating: rating,
                notes: notes,
                finished: finished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workId,
                Value<String?> editionId = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                required DateTime finishDate,
                Value<int> pagesRead = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> finished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingEntriesCompanion.insert(
                id: id,
                workId: workId,
                editionId: editionId,
                startDate: startDate,
                finishDate: finishDate,
                pagesRead: pagesRead,
                rating: rating,
                notes: notes,
                finished: finished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingEntriesTable, ReadingEntry>(table),
                  $$ReadingEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workId,
                                referencedTable: $$ReadingEntriesTableReferences
                                    ._workIdTable(db),
                                referencedColumn:
                                    $$ReadingEntriesTableReferences
                                        ._workIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingEntriesTable,
      ReadingEntry,
      $$ReadingEntriesTableFilterComposer,
      $$ReadingEntriesTableOrderingComposer,
      $$ReadingEntriesTableAnnotationComposer,
      $$ReadingEntriesTableCreateCompanionBuilder,
      $$ReadingEntriesTableUpdateCompanionBuilder,
      (ReadingEntry, $$ReadingEntriesTableReferences),
      ReadingEntry,
      PrefetchHooks Function({bool workId})
    >;
typedef $$RecentSearchesTableCreateCompanionBuilder =
    RecentSearchesCompanion Function({
      required String query,
      required DateTime searchedAt,
      Value<int> resultCount,
      Value<int> rowid,
    });
typedef $$RecentSearchesTableUpdateCompanionBuilder =
    RecentSearchesCompanion Function({
      Value<String> query,
      Value<DateTime> searchedAt,
      Value<int> resultCount,
      Value<int> rowid,
    });

class $$RecentSearchesTableFilterComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resultCount => $composableBuilder(
    column: $table.resultCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentSearchesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resultCount => $composableBuilder(
    column: $table.resultCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentSearchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resultCount => $composableBuilder(
    column: $table.resultCount,
    builder: (column) => column,
  );
}

class $$RecentSearchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentSearchesTable,
          RecentSearch,
          $$RecentSearchesTableFilterComposer,
          $$RecentSearchesTableOrderingComposer,
          $$RecentSearchesTableAnnotationComposer,
          $$RecentSearchesTableCreateCompanionBuilder,
          $$RecentSearchesTableUpdateCompanionBuilder,
          (
            RecentSearch,
            BaseReferences<_$AppDatabase, $RecentSearchesTable, RecentSearch>,
          ),
          RecentSearch,
          PrefetchHooks Function()
        > {
  $$RecentSearchesTableTableManager(
    _$AppDatabase db,
    $RecentSearchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentSearchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentSearchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentSearchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> query = const Value.absent(),
                Value<DateTime> searchedAt = const Value.absent(),
                Value<int> resultCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentSearchesCompanion(
                query: query,
                searchedAt: searchedAt,
                resultCount: resultCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String query,
                required DateTime searchedAt,
                Value<int> resultCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentSearchesCompanion.insert(
                query: query,
                searchedAt: searchedAt,
                resultCount: resultCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentSearchesTable, RecentSearch>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecentSearchesTable,
                    RecentSearch
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentSearchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentSearchesTable,
      RecentSearch,
      $$RecentSearchesTableFilterComposer,
      $$RecentSearchesTableOrderingComposer,
      $$RecentSearchesTableAnnotationComposer,
      $$RecentSearchesTableCreateCompanionBuilder,
      $$RecentSearchesTableUpdateCompanionBuilder,
      (
        RecentSearch,
        BaseReferences<_$AppDatabase, $RecentSearchesTable, RecentSearch>,
      ),
      RecentSearch,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorksTableTableManager get works =>
      $$WorksTableTableManager(_db, _db.works);
  $$EditionsTableTableManager get editions =>
      $$EditionsTableTableManager(_db, _db.editions);
  $$CopiesTableTableManager get copies =>
      $$CopiesTableTableManager(_db, _db.copies);
  $$CopyPhotosTableTableManager get copyPhotos =>
      $$CopyPhotosTableTableManager(_db, _db.copyPhotos);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$CopyTagsTableTableManager get copyTags =>
      $$CopyTagsTableTableManager(_db, _db.copyTags);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
  $$ReadingEntriesTableTableManager get readingEntries =>
      $$ReadingEntriesTableTableManager(_db, _db.readingEntries);
  $$RecentSearchesTableTableManager get recentSearches =>
      $$RecentSearchesTableTableManager(_db, _db.recentSearches);
}
