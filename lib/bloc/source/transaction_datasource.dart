import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:nazmino/core/api/validator.dart';
import '../model/transaction.dart';

abstract class ITransactionDataSource {
  Future<List<Transaction>> getTransactions();
  Future<Transaction> addTransactions(Transaction transaction);
  Future<Transaction> editTransactions(Transaction transaction, String id);
  Future<void> remove(String id);
  Future<void> removeAll();
}

class TransactionDatasource implements ITransactionDataSource {
  final Dio httpClient;
  TransactionDatasource(this.httpClient);

  @override
  Future<List<Transaction>> getTransactions() async {
    log('[TransactionDatasource] getTransactions() called');
    final response = await httpClient.get('/transactions');
    log('[TransactionDatasource] GET /transactions => ${response.statusCode}');
    validateResponse(response);

    final List<Transaction> transactions = [];
    for (var transaction in response.data['data']) {
      transactions.add(Transaction.fromJson(transaction));
    }
    log(
      '[TransactionDatasource] Retrieved ${transactions.length} transactions',
    );
    return transactions;
  }

  @override
  Future<void> remove(String id) async {
    log('[TransactionDatasource] remove() called with id: $id');
    final response = await httpClient.delete('/transactions/$id');
    log(
      '[TransactionDatasource] DELETE /transactions/$id => ${response.statusCode}',
    );
    validateResponse(response);
    log('[TransactionDatasource] Transaction $id removed');
  }

  @override
  Future<void> removeAll() async {
    log('[TransactionDatasource] removeAll() called');
    final response = await httpClient.delete('/transactions');
    log(
      '[TransactionDatasource] DELETE /transactions => ${response.statusCode}',
    );
    validateResponse(response);
    log('[TransactionDatasource] All transactions removed');
  }

  @override
  Future<Transaction> addTransactions(Transaction transaction) async {
    log(
      '[TransactionDatasource] addTransactions() called with title: ${transaction.title}, amount: ${transaction.amount}',
    );
    final type = transaction.isInCome ? 'income' : 'expense';
    final response = await httpClient.post(
      '/transactions',
      data: {
        "title": transaction.title,
        "amount": transaction.amount,
        "type": type,
        "category_id": transaction.categoryId,
        "date": transaction.date.toString(),
      },
    );
    log(
      '[TransactionDatasource] POST /transactions => ${response.statusCode}, data: ${response.data}',
    );
    validateResponse(response);

    final newTransaction = Transaction.fromJson(response.data['data']);
    log(
      '[TransactionDatasource] Transaction added with id: ${newTransaction.id}',
    );
    return newTransaction;
  }

  @override
  Future<Transaction> editTransactions(
    Transaction transaction,
    String id,
  ) async {
    final type = transaction.isInCome ? 'income' : 'expense';
    final res = await httpClient.put(
      '/transactions/$id',
      data: {
        "title": transaction.title,
        "amount": transaction.amount,
        "type": type,
        "category_id": transaction.categoryId,
        "date": transaction.date,
      },
    );
    validateResponse(res);
    return Transaction.fromJson(res.data);
  }
}
