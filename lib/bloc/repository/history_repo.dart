import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/bloc/source/history_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final httpClient = ApiBaseData.httpClient;
final IHistoryRepository historyRepository = HistoryRepository(
  HistoryDataSource(httpClient),
);

abstract class IHistoryRepository extends IHistoryDataSource {}

class HistoryRepository implements IHistoryRepository {
  final IHistoryDataSource dataSource;

  HistoryRepository(this.dataSource);
  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<void> deleteAll() => dataSource.deleteAll();
  @override
  Future<List<Transaction>> getAllHistory() => dataSource.getAllHistory();

  @override
  Future<void> restore(String id) => dataSource.restore(id);
}
