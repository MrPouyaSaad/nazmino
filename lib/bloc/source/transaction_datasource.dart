import 'package:dio/dio.dart';
import 'package:nazmino/core/api/validator.dart';

import '../model/transaction.dart';

abstract class ITransactionDataSource {
  Future<List<Transaction>> getTransactions();
  Future<Transaction> addTransactions(Transaction transaction);
  Future<void> remove(String id);
  Future<void> removeAll();
}

class TransactionDatasource implements ITransactionDataSource {
  final Dio httpClient;
  TransactionDatasource(this.httpClient);
  @override
  Future<List<Transaction>> getTransactions() async {
    final response = await httpClient.get('/transactions');
    validateResponse(response);
    final List<Transaction> transactions = [];

    for (var transaction in response.data) {
      transactions.add(Transaction.fromJson(transaction));
    }

    return transactions;
  }

  @override
  Future<void> remove(String id) async {
    final response = await httpClient.delete('/transactions/$id');
    validateResponse(response);
  }

  @override
  Future<void> removeAll() async {
    final response = await httpClient.delete('/transactions');
    validateResponse(response);
  }

  @override
  Future<Transaction> addTransactions(Transaction transaction) async {
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
    validateResponse(response);
    return Transaction.fromJson(response.data);
  }
}
