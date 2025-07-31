class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isInCome;
  final String categoryId;
  final DateTime date = DateTime.now();

  Transaction({
    required this.categoryId,
    required this.id,
    required this.title,
    required this.amount,
    required this.isInCome,
  });
}

class TransactionCategory {
  final String id;
  final String name;

  TransactionCategory({required this.id, required this.name});
}
