import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nazmino/data/database/transaction_cat_db.dart';
import 'package:nazmino/model/transaction.dart';

const String defaultCategoryId = 'default_category_123';
final _defaultCategory = TransactionCategory(
  id: defaultCategoryId,
  name: 'Default',
);

class CategoryProvider extends ChangeNotifier {
  final TransactionCatDb _db = TransactionCatDb();
  final List<TransactionCategory> _categories = [_defaultCategory];

  List<TransactionCategory> get categories => _categories;

  Future<void> loadCategories() async {
    final defaultCatExists = await _db.categoryExists(defaultCategoryId);

    // 2. اگر وجود نداشت، آن را ایجاد کنید
    if (!defaultCatExists) {
      await _db.insertTransactionCat(_defaultCategory);
    }

    final dbCategories = await _db.getAllTransactionCats();

    _categories.clear();
    _categories.addAll(dbCategories);
    log('Category Count: ${_categories.length}');

    notifyListeners();
  }

  // add a new category to the list
  void addCategory(String name) {
    final newCategory = TransactionCategory(
      id: DateTime.now().toString(),
      name: name,
    );
    _db.insertTransactionCat(newCategory);
    _categories.add(newCategory);
    notifyListeners();
  }

  //edit an existing category
  void editCategory(String id, String newName) {
    if (id == defaultCategoryId) return;
    final index = _categories.indexWhere((cat) => cat.id == id);
    if (index != -1) {
      _db.updateTransactionCat(TransactionCategory(id: id, name: newName));
      _categories[index] = TransactionCategory(id: id, name: newName);
      notifyListeners();
    }
  }

  // remove a category from the list
  void removeCategory(String id) {
    if (id == defaultCategoryId) return;
    _db.deleteTransactionCat(id);
    _categories.removeWhere((cat) => cat.id == id);
    notifyListeners();
  }
}
