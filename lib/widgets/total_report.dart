import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/extensions/price_extensions.dart';
import 'package:nazmino/core/extensions/transaction_extensions.dart';
import 'package:nazmino/bloc/model/transaction.dart';
import '../core/translate/messages.dart' show AppMessages;

class TotalReport extends StatelessWidget {
  const TotalReport({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.7),
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF121212) : theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportItem(
            context,
            title: '${AppMessages.totalAmount.tr} :',
            value: transactions.totalAmount.toPriceStringWithCurrency(),
            color: theme.colorScheme.primary,
            style: titleStyle,
          ),
          const Divider(height: 24),
          _buildReportItem(
            context,
            title: '${AppMessages.totalIncome.tr} :',
            value: transactions.totalIncome.toPriceStringWithCurrency(),
            color: theme.colorScheme.tertiary,
            style: titleStyle,
          ),
          const Divider(height: 24),
          _buildReportItem(
            context,
            title: '${AppMessages.totalExpense.tr} :',
            value: transactions.totalExpense.toPriceStringWithCurrency(),
            color: theme.colorScheme.error,
            style: titleStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required TextStyle? style,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style?.copyWith(color: color)),
      ],
    );
  }
}
