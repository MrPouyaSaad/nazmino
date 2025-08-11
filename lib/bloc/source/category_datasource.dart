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
    final res = await httpClient.post('/categories', data: {'name': name});
    validateResponse(res);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final res = await httpClient.delete('/categories/$id');
    validateResponse(res);
  }

  @override
  Future<List<TransactionCategory>> getCategories() async {
    try {
      log('🌐 Sending GET request to /categories');
      log('📋 Request headers:');
      log(httpClient.options.headers.toString()); // نمایش هدرهای پایه

      final res = await httpClient.get('/categories');

      log('🔄 Response received:');
      log('Status: ${res.statusCode}');
      log('Headers: ${res.headers}');

      validateResponse(res);

      final List<TransactionCategory> categories = [];
      for (var item in res.data) {
        categories.add(TransactionCategory.fromJson(item));
      }

      return categories;
    } catch (e) {
      log('❌ Error in getCategories: $e');
      rethrow;
    }
  }
}
