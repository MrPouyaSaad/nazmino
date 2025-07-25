import 'package:flutter/material.dart';
import 'package:nazmino/model/transaction.dart';
import 'package:nazmino/core/price_extention.dart';

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
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
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
          title: Text(
            transaction.title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
              wordSpacing: -2,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            transaction.isInCome ? 'Income' : 'Expense',
            style: TextStyle(
              color: Color(0xff607D8B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.amount.toPriceStringWithCurrency(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: transaction.isInCome
                      ? Color(0xff2E7D32)
                      : Theme.of(context).colorScheme.error,
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
