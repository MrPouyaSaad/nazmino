import 'dart:io';
import 'package:nazmino/data/database/tables/transaction_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:nazmino/model/transaction.dart';

part 'transaction_db.g.dart';

@DriftDatabase(tables: [TransactionTable])
class TransactionDatabase extends _$TransactionDatabase {
  TransactionDatabase() : super(_openConnection());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'nazmino.db'));
      // final db = await openDatabase(
      //   'nazmino.db',
      //   version: 1,
      //   onCreate: (db, version) {
      //     return db.execute('''
      //       CREATE TABLE transactions (
      //         id TEXT PRIMARY KEY,
      //         title TEXT NOT NULL,
      //         amount REAL NOT NULL,
      //         isInCome INTEGER NOT NULL
      //       )
      //     ''');
      //   },
      // );
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getAllTransactions() =>
      select(transactionTable).get().then(
        (rows) => rows.map((row) {
          return Transaction(
            id: row.id,
            title: row.title,
            amount: row.amount,
            isInCome: row.isInCome,
          );
        }).toList(),
      );

  // Insert a new transaction
  Future<int> insertTransaction(Transaction transaction) {
    return into(transactionTable).insert(
      TransactionTableCompanion(
        id: Value(transaction.id),
        title: Value(transaction.title),
        amount: Value(transaction.amount),
        isInCome: Value(transaction.isInCome),
        date: Value(transaction.date),
      ),
    );
  }

  //remove a transaction
  Future<int> deleteTransaction(String id) {
    return (delete(transactionTable)..where((t) => t.id.equals(id))).go();
  }

  // Update a transaction
  Future<int> updateTransaction(Transaction transaction) {
    return (update(
      transactionTable,
    )..where((t) => t.id.equals(transaction.id))).write(
      TransactionTableCompanion(
        id: Value(transaction.id),
        title: Value(transaction.title),
        amount: Value(transaction.amount),
        isInCome: Value(transaction.isInCome),
      ),
    );
  }

  //remove all transactions
  Future<int> deleteAllTransactions() {
    return delete(transactionTable).go();
  }
}
