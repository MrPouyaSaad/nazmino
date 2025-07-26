import 'package:nazmino/model/transaction.dart';

extension TransactionListExtensions on List<Transaction> {
  double get totalAmount => fold(0.0, (sum, t) {
    return t.isInCome ? sum + t.amount : sum - t.amount;
  });

  double get totalIncome =>
      where((t) => t.isInCome).fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense =>
      where((t) => !t.isInCome).fold(0.0, (sum, t) => sum + t.amount);
}
