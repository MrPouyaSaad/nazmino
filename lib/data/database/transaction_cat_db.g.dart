// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_cat_db.dart';

// ignore_for_file: type=lint
class $TransactionCatTableTable extends TransactionCatTable
    with TableInfo<$TransactionCatTableTable, TransactionCatTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionCatTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_cat_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionCatTableData> instance, {
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
  TransactionCatTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionCatTableData(
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
  $TransactionCatTableTable createAlias(String alias) {
    return $TransactionCatTableTable(attachedDatabase, alias);
  }
}

class TransactionCatTableData extends DataClass
    implements Insertable<TransactionCatTableData> {
  final String id;
  final String name;
  const TransactionCatTableData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TransactionCatTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionCatTableCompanion(id: Value(id), name: Value(name));
  }

  factory TransactionCatTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionCatTableData(
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

  TransactionCatTableData copyWith({String? id, String? name}) =>
      TransactionCatTableData(id: id ?? this.id, name: name ?? this.name);
  TransactionCatTableData copyWithCompanion(TransactionCatTableCompanion data) {
    return TransactionCatTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionCatTableData(')
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
      (other is TransactionCatTableData &&
          other.id == this.id &&
          other.name == this.name);
}

class TransactionCatTableCompanion
    extends UpdateCompanion<TransactionCatTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const TransactionCatTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionCatTableCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<TransactionCatTableData> custom({
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

  TransactionCatTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TransactionCatTableCompanion(
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
    return (StringBuffer('TransactionCatTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TransactionCatDb extends GeneratedDatabase {
  _$TransactionCatDb(QueryExecutor e) : super(e);
  $TransactionCatDbManager get managers => $TransactionCatDbManager(this);
  late final $TransactionCatTableTable transactionCatTable =
      $TransactionCatTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactionCatTable];
}

typedef $$TransactionCatTableTableCreateCompanionBuilder =
    TransactionCatTableCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$TransactionCatTableTableUpdateCompanionBuilder =
    TransactionCatTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$TransactionCatTableTableFilterComposer
    extends Composer<_$TransactionCatDb, $TransactionCatTableTable> {
  $$TransactionCatTableTableFilterComposer({
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
}

class $$TransactionCatTableTableOrderingComposer
    extends Composer<_$TransactionCatDb, $TransactionCatTableTable> {
  $$TransactionCatTableTableOrderingComposer({
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

class $$TransactionCatTableTableAnnotationComposer
    extends Composer<_$TransactionCatDb, $TransactionCatTableTable> {
  $$TransactionCatTableTableAnnotationComposer({
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
}

class $$TransactionCatTableTableTableManager
    extends
        RootTableManager<
          _$TransactionCatDb,
          $TransactionCatTableTable,
          TransactionCatTableData,
          $$TransactionCatTableTableFilterComposer,
          $$TransactionCatTableTableOrderingComposer,
          $$TransactionCatTableTableAnnotationComposer,
          $$TransactionCatTableTableCreateCompanionBuilder,
          $$TransactionCatTableTableUpdateCompanionBuilder,
          (
            TransactionCatTableData,
            BaseReferences<
              _$TransactionCatDb,
              $TransactionCatTableTable,
              TransactionCatTableData
            >,
          ),
          TransactionCatTableData,
          PrefetchHooks Function()
        > {
  $$TransactionCatTableTableTableManager(
    _$TransactionCatDb db,
    $TransactionCatTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionCatTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionCatTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionCatTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionCatTableCompanion(
                id: id,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => TransactionCatTableCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionCatTableTableProcessedTableManager =
    ProcessedTableManager<
      _$TransactionCatDb,
      $TransactionCatTableTable,
      TransactionCatTableData,
      $$TransactionCatTableTableFilterComposer,
      $$TransactionCatTableTableOrderingComposer,
      $$TransactionCatTableTableAnnotationComposer,
      $$TransactionCatTableTableCreateCompanionBuilder,
      $$TransactionCatTableTableUpdateCompanionBuilder,
      (
        TransactionCatTableData,
        BaseReferences<
          _$TransactionCatDb,
          $TransactionCatTableTable,
          TransactionCatTableData
        >,
      ),
      TransactionCatTableData,
      PrefetchHooks Function()
    >;

class $TransactionCatDbManager {
  final _$TransactionCatDb _db;
  $TransactionCatDbManager(this._db);
  $$TransactionCatTableTableTableManager get transactionCatTable =>
      $$TransactionCatTableTableTableManager(_db, _db.transactionCatTable);
}
