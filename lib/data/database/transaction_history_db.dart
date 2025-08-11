// import 'dart:io';
// import 'package:nazmino/data/database/tables/transaction_history_table.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:nazmino/bloc/model/transaction.dart';

// part 'transaction_history_db.g.dart';

// @DriftDatabase(tables: [TransactionHistoryTable])
// class TransactionHistoryDatabase extends _$TransactionHistoryDatabase {
//   TransactionHistoryDatabase() : super(_openConnection());

//   static LazyDatabase _openConnection() {
//     return LazyDatabase(() async {
//       final dbFolder = await getApplicationDocumentsDirectory();
//       final file = File(p.join(dbFolder.path, 'history.db'));
//       // final db = await openDatabase(
//       //   'nazmino.db',
//       //   version: 1,
//       //   onCreate: (db, version) {
//       //     return db.execute('''
//       //       CREATE TABLE transactions (
//       //         id TEXT PRIMARY KEY,
//       //         title TEXT NOT NULL,
//       //         amount REAL NOT NULL,
//       //         isInCome INTEGER NOT NULL
//       //       )
//       //     ''');
//       //   },
//       // );
//       return NativeDatabase.createInBackground(file);
//     });
//   }

//   @override
//   int get schemaVersion => 1;

//   Future<List<Transaction>> getAllTransactions() =>
//       select(transactionHistoryTable).get().then(
//         (rows) => rows.map((row) {
//           return Transaction(
//             id: row.id,
//             title: row.title,
//             amount: row.amount,
//             isInCome: row.isInCome,
//             categoryId: row.categoryId,
//           );
//         }).toList(),
//       );

//   // Insert a new transaction
//   Future<int> insertTransaction(Transaction transaction) {
//     return into(transactionHistoryTable).insert(
//       TransactionHistoryTableData(
//         id: transaction.id,
//         title: transaction.title,
//         amount: transaction.amount,
//         isInCome: transaction.isInCome,
//         date: transaction.date,
//         categoryId: transaction.categoryId,
//       ),
//     );
//   }

//   // Insert a transaction from category
//   insertTransactionFromCategory(
//     String categoryId,
//     List<Transaction> transactions,
//   ) {
//     for (var transaction in transactions) {
//       if (transaction.categoryId == categoryId) {
//         return into(transactionHistoryTable).insert(
//           TransactionHistoryTableData(
//             id: transaction.id,
//             title: transaction.title,
//             amount: transaction.amount,
//             isInCome: transaction.isInCome,
//             date: transaction.date,
//             categoryId: transaction.categoryId,
//           ),
//         );
//       }
//     }
//   }

//   //remove a transaction
//   Future<int> deleteTransaction(String id) {
//     return (delete(
//       transactionHistoryTable,
//     )..where((t) => t.id.equals(id))).go();
//   }

//   //remove all transactions
//   Future<int> deleteAllTransactions() {
//     return delete(transactionHistoryTable).go();
//   }
// }
