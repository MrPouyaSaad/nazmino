// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nazmino/core/translate/messages.dart';
// import 'package:nazmino/data/database/transaction_cat_db.dart';
// import 'package:nazmino/bloc/model/transaction.dart';

// const String defaultCategoryId = 'default_category_123';
// // final _defaultCategory = TransactionCategory(
// //   id: defaultCategoryId,
// //   name: AppMessages.all.tr,
// // );

// class CategoryProvider extends ChangeNotifier {
//   final TransactionCatDb _db = TransactionCatDb();
//   final List<TransactionCategory> _categories = [];

//   List<TransactionCategory> get categories => _categories;

//   TransactionCategory get _defaultCategory =>
//       TransactionCategory(id: defaultCategoryId, name: AppMessages.all.tr);

//   Future<void> loadCategories() async {
//     final defaultCatExists = await _db.categoryExists(defaultCategoryId);

//     if (!defaultCatExists) {
//       await _db.insertTransactionCat(_defaultCategory);
//     }

//     final dbCategories = await _db.getAllTransactionCats();

//     _categories.clear();
//     _categories.addAll(dbCategories);
//     if (!_categories.any((c) => c.id == defaultCategoryId)) {
//       _categories.insert(0, _defaultCategory);
//     }
//     log('Category Count: ${_categories.length}');

//     notifyListeners();
//   }

//   // add a new category to the list
//   void addCategory(String name) {
//     final newCategory = TransactionCategory(
//       id: DateTime.now().toString(),
//       name: name,
//     );
//     _db.insertTransactionCat(newCategory);
//     _categories.add(newCategory);
//     notifyListeners();
//   }

//   //edit an existing category
//   void editCategory(String id, String newName) {
//     if (id == defaultCategoryId) return;
//     final index = _categories.indexWhere((cat) => cat.id == id);
//     if (index != -1) {
//       _db.updateTransactionCat(TransactionCategory(id: id, name: newName));
//       _categories[index] = TransactionCategory(id: id, name: newName);
//       notifyListeners();
//     }
//   }

//   // remove a category from the list
//   void removeCategory(String id) {
//     if (id == defaultCategoryId) return;
//     _db.deleteTransactionCat(id);
//     _categories.removeWhere((cat) => cat.id == id);
//     notifyListeners();
//   }
// }
