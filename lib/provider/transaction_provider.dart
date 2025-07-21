import 'package:flutter/material.dart';
import 'package:nazmino/model/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  /// The list of transactions.
  /// This is a private field that holds the transactions.
  final List<Transaction> _transactions = [];

  /// Get the list of transactions.
  /// This is a getter that returns the transactions.
  /// @return The list of transactions.
  List<Transaction> get transactions => _transactions;

  /// Add a transaction to the list.
  /// This method adds a transaction to the list and notifies listeners.
  /// @param transaction The transaction to add.
  /// @return void
  void addTransaction({required Transaction transaction}) {
    _transactions.add(transaction);
    notifyListeners();
  }

  /// Remove a transaction from the list.
  /// This method removes a transaction from the list and notifies listeners.
  /// @param transaction The transaction to remove.
  /// @return void
  void removeTransaction(Transaction transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }

  /// Clear all transactions from the list.
  /// This method clears all transactions from the list and notifies listeners.
  /// @return void
  void clearTransactions() {
    _transactions.clear();
    notifyListeners();
  }

  /// Get the total amount of all transactions.
  /// This method calculates the total amount of all transactions.
  /// @return The total amount of all transactions.
  double get totalAmount {
    return _transactions.fold(0.0, (sum, transaction) {
      return sum +
          (transaction.isInCome ? transaction.amount : -transaction.amount);
    });
  }

  /// Get the total income from all transactions.
  /// This method calculates the total income from all transactions.
  /// @return The total income from all transactions.
  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.isInCome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get the total expense from all transactions.
  /// This method calculates the total expense from all transactions.
  /// @return The total expense from all transactions.
  double get totalExpense {
    return _transactions
        .where((transaction) => !transaction.isInCome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Edit a transaction in the list.
  /// This method edits a transaction in the list and notifies listeners.
  /// @param oldTransaction The transaction to edit.
  /// @param newTransaction The new transaction to replace the old one.
  /// @return void
  void editTransaction(Transaction oldTransaction, Transaction newTransaction) {
    final index = _transactions.indexOf(oldTransaction);
    if (index != -1) {
      _transactions[index] = newTransaction;
      notifyListeners();
    }
  }
}
