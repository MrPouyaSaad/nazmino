import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nazmino/data/database/transaction_history_db.dart';
import 'package:nazmino/model/transaction.dart';

class TransactionHistoryProvider extends ChangeNotifier {
  final TransactionHistoryDatabase _db = TransactionHistoryDatabase();

  final List<Transaction> _transactionsHistory = [];

  List<Transaction> get transactionsHistory => _transactionsHistory;

  /// Load transactions from the database.
  Future<void> loadTransactions() async {
    final dbTransactions = await _db.getAllTransactions();
    log('Transaction History Count: ${dbTransactions.length}');

    _transactionsHistory.clear();
    _transactionsHistory.addAll(dbTransactions);
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
    _transactionsHistory.add(transaction);
    notifyListeners();
  }

  /// Remove a transaction from the list.
  /// This method removes a transaction from the list and notifies listeners.
  /// @param transaction The transaction to remove.
  /// @return void
  void removeTransaction(Transaction transaction) async {
    await _db.deleteTransaction(transaction.id);
    log('Transaction removed: ${transaction.title}');
    _transactionsHistory.remove(transaction);
    notifyListeners();
  }

  /// Clear all transactions from the list.
  /// This method clears all transactions from the list and notifies listeners.
  /// @return void
  void clearTransactions() async {
    await _db.deleteAllTransactions();
    log('All transactions cleared');
    _transactionsHistory.clear();
    notifyListeners();
  }

  // add transaction from category
  void addTransactionFromCategory(
    String categoryId,
    List<Transaction> transactions,
  ) async {
    await _db.insertTransactionFromCategory(categoryId, transactions);
    final dbTransactions = await _db.getAllTransactions();
    log('Transaction added from category: ${dbTransactions.last.title}');
    log('Transaction Count: ${dbTransactions.length}');
    _transactionsHistory.add(dbTransactions.last);
    notifyListeners();
  }

  /// Get the total amount of all transactions.
  /// This method calculates the total amount of all transactions.
  /// @return The total amount of all transactions.
  double get totalAmount {
    return _transactionsHistory.fold(0.0, (sum, transaction) {
      return sum +
          (transaction.isInCome ? transaction.amount : -transaction.amount);
    });
  }

  /// Get the total income from all transactions.
  /// This method calculates the total income from all transactions.
  /// @return The total income from all transactions.
  double get totalIncome {
    return _transactionsHistory
        .where((transaction) => transaction.isInCome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get the total expense from all transactions.
  /// This method calculates the total expense from all transactions.
  /// @return The total expense from all transactions.
  double get totalExpense {
    return _transactionsHistory
        .where((transaction) => !transaction.isInCome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}
