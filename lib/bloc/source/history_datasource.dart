import 'package:dio/dio.dart';
import 'package:nazmino/core/api/validator.dart';

import '../model/transaction.dart';

abstract class IHistoryDataSource {
  Future<List<Transaction>> getAllHistory();
  Future<void> deleteAll();
  Future<void> delete(String id);
  Future<void> restore(String id);
}

class HistoryDataSource implements IHistoryDataSource {
  final Dio httpClient;

  HistoryDataSource(this.httpClient);
  @override
  Future<void> delete(String id) async {
    final response = await httpClient.delete('/history/$id');
    validateResponse(response);
  }

  @override
  Future<void> deleteAll() async {
    final response = await httpClient.delete('/history');
    validateResponse(response);
  }

  @override
  Future<List<Transaction>> getAllHistory() async {
    final response = await httpClient.get('/history');
    validateResponse(response);
    final List<Transaction> transactions = [];
    for (var transaction in response.data['data']) {
      transactions.add(Transaction.fromJson(transaction));
    }
    return transactions;
  }

  @override
  Future<void> restore(String id) async {
    final response = await httpClient.post('/history/restore/$id');
    validateResponse(response);
  }
}
