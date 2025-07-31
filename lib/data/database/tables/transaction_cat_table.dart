import 'package:drift/drift.dart';

class TransactionCatTable extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  @override
  Set<Column> get primaryKey => {id};
}
