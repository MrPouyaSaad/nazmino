class TransactionCategory {
  final String id;
  final String name;

  TransactionCategory({required this.id, required this.name});

  TransactionCategory.fromJson(Map<String, dynamic> json)
    : id = json['category_id'].toString(),
      name = json['name'];
}
