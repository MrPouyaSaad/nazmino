import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:nazmino/core/api/validator.dart';
import '../model/category.dart';

abstract class ICategoryDataSource {
  Future<List<TransactionCategory>> getCategories();
  Future<void> addCategory(String name);
  Future<void> deleteCategory(String id);
}

class CategoryDataSource implements ICategoryDataSource {
  final Dio httpClient;

  CategoryDataSource({required this.httpClient});

  @override
  Future<void> addCategory(String name) async {
    log('[CategoryDataSource] addCategory() called with name: $name');
    try {
      final res = await httpClient.post('/categories', data: {'name': name});
      log('[CategoryDataSource] POST /categories => ${res.statusCode}');
      validateResponse(res);
      log('[CategoryDataSource] Category "$name" added successfully');
    } catch (e, stack) {
      log('[CategoryDataSource] ❌ Error in addCategory: $e', stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    log('[CategoryDataSource] deleteCategory() called with id: $id');
    try {
      final res = await httpClient.delete('/categories/$id');
      log('[CategoryDataSource] DELETE /categories/$id => ${res.statusCode}');
      validateResponse(res);
      log('[CategoryDataSource] Category $id deleted successfully');
    } catch (e, stack) {
      log(
        '[CategoryDataSource] ❌ Error in deleteCategory: $e',
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<List<TransactionCategory>> getCategories() async {
    log('[CategoryDataSource] getCategories() called');
    log('[CategoryDataSource] Request headers: ${httpClient.options.headers}');
    try {
      final res = await httpClient.get('/categories');
      log('[CategoryDataSource] GET /categories => ${res.statusCode}');
      log('[CategoryDataSource] Response headers: ${res.headers}');
      validateResponse(res);

      final List<TransactionCategory> categories = [];
      for (var item in res.data) {
        categories.add(TransactionCategory.fromJson(item));
      }
      log('[CategoryDataSource] Retrieved ${categories.length} categories');
      return categories;
    } catch (e, stack) {
      log(
        '[CategoryDataSource] ❌ Error in getCategories: $e',
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
