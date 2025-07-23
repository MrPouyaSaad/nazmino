import 'package:flutter/material.dart';
import 'package:nazmino/model/transaction.dart';
import 'package:nazmino/common/price_extention.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _confirmDelete(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),

        margin: EdgeInsets.zero,
        child: ListTile(
          title: Text(transaction.title),
          subtitle: Text(transaction.isInCome ? 'Income' : 'Expense'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.amount.toPriceStringWithCurrency(),
                style: TextStyle(
                  fontSize: 13,
                  color: transaction.isInCome ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(transaction.id.substring(0, 10)),
            ],
          ),
        ),
      ),
    );
  }
}
