import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nazmino/data/database/transaction_db.dart';
import 'package:nazmino/model/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  /// The database instance.
  final TransactionDatabase _db = TransactionDatabase();

  /// The list of transactions.
  /// This is a private field that holds the transactions.
  final List<Transaction> _transactions = [];

  /// Get the list of transactions.
  /// This is a getter that returns the transactions.
  /// @return The list of transactions.
  List<Transaction> get transactions => _transactions;

  /// Load transactions from the database.
  Future<void> loadTransactions() async {
    final dbTransactions = await _db.getAllTransactions();
    log('Transaction Count: ${dbTransactions.length}');

    _transactions.clear();
    _transactions.addAll(dbTransactions);
    notifyListeners();
  }

  /// Add a transaction to the list.
  /// This method adds a transaction to the list and notifies listeners.
  /// @param transaction The transaction to add.
  /// @return void

  void addTransaction({required Transaction transaction}) async {
    await _db.insertTransaction(transaction);
    final dbTransactions = await _db.getAllTransactions();
    log('Transaction added: ${dbTransactions.last.title}');
    log('Transaction Count: ${dbTransactions.length}');
    _transactions.add(transaction);
    notifyListeners();
  }

  /// Remove a transaction from the list.
  /// This method removes a transaction from the list and notifies listeners.
  /// @param transaction The transaction to remove.
  /// @return void
  void removeTransaction(Transaction transaction) async {
    await _db.deleteTransaction(transaction.id);
    log('Transaction removed: ${transaction.title}');
    _transactions.remove(transaction);
    notifyListeners();
  }

  /// Clear all transactions from the list.
  /// This method clears all transactions from the list and notifies listeners.
  /// @return void
  void clearTransactions() async {
    await _db.deleteAllTransactions();
    log('All transactions cleared');
    _transactions.clear();
    notifyListeners();
  }

  /// Delete transactions by category.
  void deleteTransactionsByCategory(String categoryId) async {
    await _db.deleteTransactionsByCategory(categoryId);
    log('Transactions deleted for category: $categoryId');
    _transactions.removeWhere(
      (transaction) => transaction.categoryId == categoryId,
    );
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
  void editTransaction(
    Transaction oldTransaction,
    Transaction newTransaction,
  ) async {
    await _db.updateTransaction(newTransaction);
    log('Transaction edited: ${newTransaction.title}');
    final index = _transactions.indexOf(oldTransaction);
    if (index != -1) {
      _transactions[index] = newTransaction;
      notifyListeners();
    }
  }
}
