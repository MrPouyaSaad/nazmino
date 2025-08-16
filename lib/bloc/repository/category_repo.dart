import 'package:nazmino/bloc/model/category.dart';
import 'package:nazmino/core/api/options.dart';

import '../source/category_datasource.dart';

final ICategoryRepository categoryRepository = CategoryRepository(
  dataSource: CategoryDataSource(httpClient: ApiBaseData.httpClient),
);

abstract class ICategoryRepository {
  Future<TransactionCategoryListModel> getCategories();
  Future<void> addCategory(String name);
  Future<void> deleteCategory(String id);
}

class CategoryRepository implements ICategoryRepository {
  final ICategoryDataSource dataSource;

  CategoryRepository({required this.dataSource});

  @override
  Future<TransactionCategoryListModel> getCategories() =>
      dataSource.getCategories();

  @override
  Future<void> addCategory(String name) async {
    await dataSource.addCategory(name);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await dataSource.deleteCategory(id);
  }
}
