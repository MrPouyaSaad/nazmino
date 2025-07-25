import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/price_extention.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import '../core/translate/messages.dart' show AppMessages;

class TotalReport extends StatelessWidget {
  const TotalReport({super.key, required this.transactionProvider});

  final TransactionProvider transactionProvider;

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
        color: theme.cardColor,
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
            value: transactionProvider.totalAmount.toPriceStringWithCurrency(),
            color: theme.colorScheme.primary,
            style: titleStyle,
          ),
          const Divider(height: 24),
          _buildReportItem(
            context,
            title: '${AppMessages.totalIncome.tr} :',
            value: transactionProvider.totalIncome.toPriceStringWithCurrency(),
            color: theme.colorScheme.tertiary,
            style: titleStyle,
          ),
          const Divider(height: 24),
          _buildReportItem(
            context,
            title: '${AppMessages.totalExpense.tr} :',
            value: transactionProvider.totalExpense.toPriceStringWithCurrency(),
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
