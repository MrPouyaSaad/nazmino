class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isInCome;
  final DateTime date = DateTime.now();

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isInCome,
  });
}
