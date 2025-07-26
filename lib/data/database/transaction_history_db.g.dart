// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_db.dart';

// ignore_for_file: type=lint
class $TransactionHistoryTableTable extends TransactionHistoryTable
    with TableInfo<$TransactionHistoryTableTable, TransactionHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionHistoryTableTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInComeMeta = const VerificationMeta(
    'isInCome',
  );
  @override
  late final GeneratedColumn<bool> isInCome = GeneratedColumn<bool>(
    'is_in_come',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_in_come" IN (0, 1))',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    isInCome,
    date,
    categoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionHistoryTableData> instance, {
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
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_in_come')) {
      context.handle(
        _isInComeMeta,
        isInCome.isAcceptableOrUnknown(data['is_in_come']!, _isInComeMeta),
      );
    } else if (isInserting) {
      context.missing(_isInComeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionHistoryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      isInCome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_in_come'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $TransactionHistoryTableTable createAlias(String alias) {
    return $TransactionHistoryTableTable(attachedDatabase, alias);
  }
}

class TransactionHistoryTableData extends DataClass
    implements Insertable<TransactionHistoryTableData> {
  final String id;
  final String title;
  final double amount;
  final bool isInCome;
  final DateTime date;
  final String categoryId;
  const TransactionHistoryTableData({
    required this.id,
    required this.title,
    required this.amount,
    required this.isInCome,
    required this.date,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['is_in_come'] = Variable<bool>(isInCome);
    map['date'] = Variable<DateTime>(date);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  TransactionHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionHistoryTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      isInCome: Value(isInCome),
      date: Value(date),
      categoryId: Value(categoryId),
    );
  }

  factory TransactionHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      isInCome: serializer.fromJson<bool>(json['isInCome']),
      date: serializer.fromJson<DateTime>(json['date']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'isInCome': serializer.toJson<bool>(isInCome),
      'date': serializer.toJson<DateTime>(date),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  TransactionHistoryTableData copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isInCome,
    DateTime? date,
    String? categoryId,
  }) => TransactionHistoryTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    isInCome: isInCome ?? this.isInCome,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
  );
  TransactionHistoryTableData copyWithCompanion(
    TransactionHistoryTableCompanion data,
  ) {
    return TransactionHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      isInCome: data.isInCome.present ? data.isInCome.value : this.isInCome,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionHistoryTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('isInCome: $isInCome, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, amount, isInCome, date, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionHistoryTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.isInCome == this.isInCome &&
          other.date == this.date &&
          other.categoryId == this.categoryId);
}

class TransactionHistoryTableCompanion
    extends UpdateCompanion<TransactionHistoryTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<bool> isInCome;
  final Value<DateTime> date;
  final Value<String> categoryId;
  final Value<int> rowid;
  const TransactionHistoryTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.isInCome = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionHistoryTableCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required bool isInCome,
    this.date = const Value.absent(),
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       amount = Value(amount),
       isInCome = Value(isInCome),
       categoryId = Value(categoryId);
  static Insertable<TransactionHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<bool>? isInCome,
    Expression<DateTime>? date,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (isInCome != null) 'is_in_come': isInCome,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<double>? amount,
    Value<bool>? isInCome,
    Value<DateTime>? date,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return TransactionHistoryTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isInCome: isInCome ?? this.isInCome,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
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
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isInCome.present) {
      map['is_in_come'] = Variable<bool>(isInCome.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('isInCome: $isInCome, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TransactionHistoryDatabase extends GeneratedDatabase {
  _$TransactionHistoryDatabase(QueryExecutor e) : super(e);
  $TransactionHistoryDatabaseManager get managers =>
      $TransactionHistoryDatabaseManager(this);
  late final $TransactionHistoryTableTable transactionHistoryTable =
      $TransactionHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactionHistoryTable];
}

typedef $$TransactionHistoryTableTableCreateCompanionBuilder =
    TransactionHistoryTableCompanion Function({
      required String id,
      required String title,
      required double amount,
      required bool isInCome,
      Value<DateTime> date,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$TransactionHistoryTableTableUpdateCompanionBuilder =
    TransactionHistoryTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<double> amount,
      Value<bool> isInCome,
      Value<DateTime> date,
      Value<String> categoryId,
      Value<int> rowid,
    });

class $$TransactionHistoryTableTableFilterComposer
    extends
        Composer<_$TransactionHistoryDatabase, $TransactionHistoryTableTable> {
  $$TransactionHistoryTableTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInCome => $composableBuilder(
    column: $table.isInCome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionHistoryTableTableOrderingComposer
    extends
        Composer<_$TransactionHistoryDatabase, $TransactionHistoryTableTable> {
  $$TransactionHistoryTableTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInCome => $composableBuilder(
    column: $table.isInCome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionHistoryTableTableAnnotationComposer
    extends
        Composer<_$TransactionHistoryDatabase, $TransactionHistoryTableTable> {
  $$TransactionHistoryTableTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isInCome =>
      $composableBuilder(column: $table.isInCome, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );
}

class $$TransactionHistoryTableTableTableManager
    extends
        RootTableManager<
          _$TransactionHistoryDatabase,
          $TransactionHistoryTableTable,
          TransactionHistoryTableData,
          $$TransactionHistoryTableTableFilterComposer,
          $$TransactionHistoryTableTableOrderingComposer,
          $$TransactionHistoryTableTableAnnotationComposer,
          $$TransactionHistoryTableTableCreateCompanionBuilder,
          $$TransactionHistoryTableTableUpdateCompanionBuilder,
          (
            TransactionHistoryTableData,
            BaseReferences<
              _$TransactionHistoryDatabase,
              $TransactionHistoryTableTable,
              TransactionHistoryTableData
            >,
          ),
          TransactionHistoryTableData,
          PrefetchHooks Function()
        > {
  $$TransactionHistoryTableTableTableManager(
    _$TransactionHistoryDatabase db,
    $TransactionHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<bool> isInCome = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionHistoryTableCompanion(
                id: id,
                title: title,
                amount: amount,
                isInCome: isInCome,
                date: date,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required double amount,
                required bool isInCome,
                Value<DateTime> date = const Value.absent(),
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => TransactionHistoryTableCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                isInCome: isInCome,
                date: date,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$TransactionHistoryDatabase,
      $TransactionHistoryTableTable,
      TransactionHistoryTableData,
      $$TransactionHistoryTableTableFilterComposer,
      $$TransactionHistoryTableTableOrderingComposer,
      $$TransactionHistoryTableTableAnnotationComposer,
      $$TransactionHistoryTableTableCreateCompanionBuilder,
      $$TransactionHistoryTableTableUpdateCompanionBuilder,
      (
        TransactionHistoryTableData,
        BaseReferences<
          _$TransactionHistoryDatabase,
          $TransactionHistoryTableTable,
          TransactionHistoryTableData
        >,
      ),
      TransactionHistoryTableData,
      PrefetchHooks Function()
    >;

class $TransactionHistoryDatabaseManager {
  final _$TransactionHistoryDatabase _db;
  $TransactionHistoryDatabaseManager(this._db);
  $$TransactionHistoryTableTableTableManager get transactionHistoryTable =>
      $$TransactionHistoryTableTableTableManager(
        _db,
        _db.transactionHistoryTable,
      );
}
