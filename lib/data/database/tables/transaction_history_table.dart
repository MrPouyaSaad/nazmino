import 'package:drift/drift.dart';

class TransactionHistoryTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 50)();

  RealColumn get amount => real()();

  BoolColumn get isInCome => boolean()();

  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();

  TextColumn get categoryId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
