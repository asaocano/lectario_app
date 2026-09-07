// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BookshelfTable extends Bookshelf
    with TableInfo<$BookshelfTable, BookshelfData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookshelfTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionsMeta = const VerificationMeta(
    'editions',
  );
  @override
  late final GeneratedColumn<int> editions = GeneratedColumn<int>(
    'editions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _publishYearMeta = const VerificationMeta(
    'publishYear',
  );
  @override
  late final GeneratedColumn<int> publishYear = GeneratedColumn<int>(
    'publish_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    authorId,
    editions,
    coverUrl,
    publishYear,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookshelf';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookshelfData> instance, {
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
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('editions')) {
      context.handle(
        _editionsMeta,
        editions.isAcceptableOrUnknown(data['editions']!, _editionsMeta),
      );
    } else if (isInserting) {
      context.missing(_editionsMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('publish_year')) {
      context.handle(
        _publishYearMeta,
        publishYear.isAcceptableOrUnknown(
          data['publish_year']!,
          _publishYearMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  BookshelfData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookshelfData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      editions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}editions'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      publishYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}publish_year'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $BookshelfTable createAlias(String alias) {
    return $BookshelfTable(attachedDatabase, alias);
  }
}

class BookshelfData extends DataClass implements Insertable<BookshelfData> {
  final String id;
  final String title;
  final String author;
  final String authorId;
  final int editions;
  final String? coverUrl;
  final int? publishYear;
  final int status;
  const BookshelfData({
    required this.id,
    required this.title,
    required this.author,
    required this.authorId,
    required this.editions,
    this.coverUrl,
    this.publishYear,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['author_id'] = Variable<String>(authorId);
    map['editions'] = Variable<int>(editions);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || publishYear != null) {
      map['publish_year'] = Variable<int>(publishYear);
    }
    map['status'] = Variable<int>(status);
    return map;
  }

  BookshelfCompanion toCompanion(bool nullToAbsent) {
    return BookshelfCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      authorId: Value(authorId),
      editions: Value(editions),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      publishYear: publishYear == null && nullToAbsent
          ? const Value.absent()
          : Value(publishYear),
      status: Value(status),
    );
  }

  factory BookshelfData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookshelfData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      authorId: serializer.fromJson<String>(json['authorId']),
      editions: serializer.fromJson<int>(json['editions']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      publishYear: serializer.fromJson<int?>(json['publishYear']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'authorId': serializer.toJson<String>(authorId),
      'editions': serializer.toJson<int>(editions),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'publishYear': serializer.toJson<int?>(publishYear),
      'status': serializer.toJson<int>(status),
    };
  }

  BookshelfData copyWith({
    String? id,
    String? title,
    String? author,
    String? authorId,
    int? editions,
    Value<String?> coverUrl = const Value.absent(),
    Value<int?> publishYear = const Value.absent(),
    int? status,
  }) => BookshelfData(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    authorId: authorId ?? this.authorId,
    editions: editions ?? this.editions,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    publishYear: publishYear.present ? publishYear.value : this.publishYear,
    status: status ?? this.status,
  );
  BookshelfData copyWithCompanion(BookshelfCompanion data) {
    return BookshelfData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      editions: data.editions.present ? data.editions.value : this.editions,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      publishYear: data.publishYear.present
          ? data.publishYear.value
          : this.publishYear,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookshelfData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('authorId: $authorId, ')
          ..write('editions: $editions, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('publishYear: $publishYear, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    authorId,
    editions,
    coverUrl,
    publishYear,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookshelfData &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.authorId == this.authorId &&
          other.editions == this.editions &&
          other.coverUrl == this.coverUrl &&
          other.publishYear == this.publishYear &&
          other.status == this.status);
}

class BookshelfCompanion extends UpdateCompanion<BookshelfData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> author;
  final Value<String> authorId;
  final Value<int> editions;
  final Value<String?> coverUrl;
  final Value<int?> publishYear;
  final Value<int> status;
  final Value<int> rowid;
  const BookshelfCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.authorId = const Value.absent(),
    this.editions = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.publishYear = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookshelfCompanion.insert({
    required String id,
    required String title,
    required String author,
    required String authorId,
    required int editions,
    this.coverUrl = const Value.absent(),
    this.publishYear = const Value.absent(),
    required int status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       author = Value(author),
       authorId = Value(authorId),
       editions = Value(editions),
       status = Value(status);
  static Insertable<BookshelfData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? authorId,
    Expression<int>? editions,
    Expression<String>? coverUrl,
    Expression<int>? publishYear,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (authorId != null) 'author_id': authorId,
      if (editions != null) 'editions': editions,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (publishYear != null) 'publish_year': publishYear,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookshelfCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? author,
    Value<String>? authorId,
    Value<int>? editions,
    Value<String?>? coverUrl,
    Value<int?>? publishYear,
    Value<int>? status,
    Value<int>? rowid,
  }) {
    return BookshelfCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      editions: editions ?? this.editions,
      coverUrl: coverUrl ?? this.coverUrl,
      publishYear: publishYear ?? this.publishYear,
      status: status ?? this.status,
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
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (editions.present) {
      map['editions'] = Variable<int>(editions.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (publishYear.present) {
      map['publish_year'] = Variable<int>(publishYear.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookshelfCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('authorId: $authorId, ')
          ..write('editions: $editions, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('publishYear: $publishYear, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookshelfTable bookshelf = $BookshelfTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bookshelf];
}

typedef $$BookshelfTableCreateCompanionBuilder =
    BookshelfCompanion Function({
      required String id,
      required String title,
      required String author,
      required String authorId,
      required int editions,
      Value<String?> coverUrl,
      Value<int?> publishYear,
      required int status,
      Value<int> rowid,
    });
typedef $$BookshelfTableUpdateCompanionBuilder =
    BookshelfCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> author,
      Value<String> authorId,
      Value<int> editions,
      Value<String?> coverUrl,
      Value<int?> publishYear,
      Value<int> status,
      Value<int> rowid,
    });

class $$BookshelfTableFilterComposer
    extends Composer<_$AppDatabase, $BookshelfTable> {
  $$BookshelfTableFilterComposer({
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

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get editions => $composableBuilder(
    column: $table.editions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publishYear => $composableBuilder(
    column: $table.publishYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookshelfTableOrderingComposer
    extends Composer<_$AppDatabase, $BookshelfTable> {
  $$BookshelfTableOrderingComposer({
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

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get editions => $composableBuilder(
    column: $table.editions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publishYear => $composableBuilder(
    column: $table.publishYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookshelfTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookshelfTable> {
  $$BookshelfTableAnnotationComposer({
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

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<int> get editions =>
      $composableBuilder(column: $table.editions, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<int> get publishYear => $composableBuilder(
    column: $table.publishYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$BookshelfTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookshelfTable,
          BookshelfData,
          $$BookshelfTableFilterComposer,
          $$BookshelfTableOrderingComposer,
          $$BookshelfTableAnnotationComposer,
          $$BookshelfTableCreateCompanionBuilder,
          $$BookshelfTableUpdateCompanionBuilder,
          (
            BookshelfData,
            BaseReferences<_$AppDatabase, $BookshelfTable, BookshelfData>,
          ),
          BookshelfData,
          PrefetchHooks Function()
        > {
  $$BookshelfTableTableManager(_$AppDatabase db, $BookshelfTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookshelfTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookshelfTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookshelfTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<int> editions = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<int?> publishYear = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookshelfCompanion(
                id: id,
                title: title,
                author: author,
                authorId: authorId,
                editions: editions,
                coverUrl: coverUrl,
                publishYear: publishYear,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String author,
                required String authorId,
                required int editions,
                Value<String?> coverUrl = const Value.absent(),
                Value<int?> publishYear = const Value.absent(),
                required int status,
                Value<int> rowid = const Value.absent(),
              }) => BookshelfCompanion.insert(
                id: id,
                title: title,
                author: author,
                authorId: authorId,
                editions: editions,
                coverUrl: coverUrl,
                publishYear: publishYear,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookshelfTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookshelfTable,
      BookshelfData,
      $$BookshelfTableFilterComposer,
      $$BookshelfTableOrderingComposer,
      $$BookshelfTableAnnotationComposer,
      $$BookshelfTableCreateCompanionBuilder,
      $$BookshelfTableUpdateCompanionBuilder,
      (
        BookshelfData,
        BaseReferences<_$AppDatabase, $BookshelfTable, BookshelfData>,
      ),
      BookshelfData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookshelfTableTableManager get bookshelf =>
      $$BookshelfTableTableManager(_db, _db.bookshelf);
}
