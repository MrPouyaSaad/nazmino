import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:nazmino/model/transaction.dart';
import 'package:path/path.dart' as p;
import 'package:nazmino/data/database/tables/transaction_cat_table.dart';
import 'package:path_provider/path_provider.dart';
part 'transaction_cat_db.g.dart';

@DriftDatabase(tables: [TransactionCatTable])
class TransactionCatDb extends _$TransactionCatDb {
  TransactionCatDb() : super(_openConnection());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'transaction_cat.db'));

      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;

  Future<bool> categoryExists(String categoryId) async {
    final result = await (select(
      transactionCatTable,
    )..where((tbl) => tbl.id.equals(categoryId))).get();

    return result.isNotEmpty;
  }

  Future<List<TransactionCategory>> getAllTransactionCats() =>
      select(transactionCatTable).get().then(
        (rows) => rows.map((row) {
          return TransactionCategory(id: row.id, name: row.name);
        }).toList(),
      );

  // Insert a new transaction category
  Future<int> insertTransactionCat(TransactionCategory transactionCat) {
    return into(transactionCatTable).insert(
      TransactionCatTableData(id: transactionCat.id, name: transactionCat.name),
    );
  }

  // Update an existing transaction category
  Future<int> updateTransactionCat(TransactionCategory transactionCat) {
    return (update(
      transactionCatTable,
    )..where((tbl) => tbl.id.equals(transactionCat.id))).write(
      TransactionCatTableData(id: transactionCat.id, name: transactionCat.name),
    );
  }

  // Remove a transaction category
  Future<int> deleteTransactionCat(String id) {
    return (delete(
      transactionCatTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
