import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/bloc/source/transaction_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final ITransactionRepository transactionRepository = TransactionRepository(
  TransactionDatasource(ApiBaseData.httpClient),
);

abstract class ITransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<List<Transaction>> addTransactions(Transaction transaction);
  Future<void> remove(String id);
  Future<void> removeAll();
}

class TransactionRepository implements ITransactionRepository {
  final ITransactionDataSource dataSource;

  TransactionRepository(this.dataSource);
  @override
  Future<List<Transaction>> addTransactions(Transaction transaction) async {
    dataSource.addTransactions(transaction);
    return dataSource.getTransactions();
  }

  @override
  Future<List<Transaction>> getTransactions() => dataSource.getTransactions();

  @override
  Future<void> remove(String id) => dataSource.remove(id);

  @override
  Future<void> removeAll() => dataSource.removeAll();
}
