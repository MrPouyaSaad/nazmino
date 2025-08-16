import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/bloc/source/transaction_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final ITransactionRepository transactionRepository = TransactionRepository(
  TransactionDatasource(ApiBaseData.httpClient),
);

abstract class ITransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<List<Transaction>> addTransactions(Transaction transaction);
  Future<List<Transaction>> editTransactions(
    Transaction transaction,
    String id,
  );

  Future<void> remove(String id);
  Future<void> removeAll();
}

class TransactionRepository implements ITransactionRepository {
  final ITransactionDataSource dataSource;

  TransactionRepository(this.dataSource);
  @override
  Future<List<Transaction>> addTransactions(Transaction transaction) async {
    await dataSource.addTransactions(transaction);
    final tList = await dataSource.getTransactions();
    return tList;
  }

  @override
  Future<List<Transaction>> getTransactions() => dataSource.getTransactions();

  @override
  Future<void> remove(String id) => dataSource.remove(id);

  @override
  Future<void> removeAll() => dataSource.removeAll();

  @override
  Future<List<Transaction>> editTransactions(
    Transaction transaction,
    String id,
  ) async {
    await dataSource.editTransactions(transaction, id);
    final tList = await dataSource.getTransactions();
    return tList;
  }
}
