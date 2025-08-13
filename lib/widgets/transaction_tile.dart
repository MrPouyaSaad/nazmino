import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/translate/messages.dart' show AppMessages;
import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/core/extensions/price_extensions.dart';
import 'package:nazmino/widgets/loading_widget.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isFromHistory;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
    this.isFromHistory = false,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppMessages.deleteTransaction.tr),
        content: Text(AppMessages.confirmDelete.tr),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(AppMessages.cancel.tr),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: Text(
              AppMessages.delete.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: transaction.isDeleting ? null : onTap,
      onLongPress: transaction.isDeleting
          ? null
          : () => _confirmDelete(context),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        color: theme.cardColor,
        elevation: 0,
        child: Stack(
          children: [
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              title: Text(
                transaction.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: transaction.isDeleting
                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                transaction.isInCome
                    ? AppMessages.income.tr
                    : AppMessages.expense.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: transaction.isDeleting
                      ? theme.colorScheme.onSurface.withOpacity(0.3)
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction.amount.toPriceStringWithCurrency(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: transaction.isDeleting
                              ? theme.colorScheme.onSurface.withOpacity(0.5)
                              : transaction.isInCome
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.date.toString().substring(0, 10),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: transaction.isDeleting
                              ? theme.colorScheme.onSurface.withOpacity(0.2)
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  if (isFromHistory) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: transaction.isDeleting
                          ? null
                          : () => _restoreFromHistory(context),
                      icon: Icon(
                        CupertinoIcons.arrow_counterclockwise,
                        color: transaction.isDeleting
                            ? theme.colorScheme.onSurface.withOpacity(0.3)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (transaction.isDeleting)
              Positioned.fill(
                child: Container(
                  color: theme.cardColor.withOpacity(0.7),
                  child: AppLoading(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _restoreFromHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppMessages.restoreTransaction.tr),
        content: Text(AppMessages.confirmRestore.tr),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(AppMessages.cancel.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onTap();
            },
            child: Text(
              AppMessages.restore.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
