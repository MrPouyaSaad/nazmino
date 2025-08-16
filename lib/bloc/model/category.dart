class TransactionCategory {
  final String id;
  final String name;

  TransactionCategory({required this.id, required this.name});

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}

class TransactionCategoryListModel {
  final List<TransactionCategory> categoryList;
  final int count;

  TransactionCategoryListModel({
    required this.categoryList,
    required this.count,
  });

  factory TransactionCategoryListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return TransactionCategoryListModel(
      count: json['count'] ?? data.length,
      categoryList: data
          .map((item) => TransactionCategory.fromJson(item))
          .toList(),
    );
  }
}
