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
    final themeData = Theme.of(context);
    final titleStyle = TextStyle(
      color: Color(0xff607D8B),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('${AppMessages.totalAmount.tr} :', style: titleStyle),
            trailing: Text(
              transactionProvider.totalAmount.toPriceStringWithCurrency(),
              style: TextStyle(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('${AppMessages.totalIncome.tr} :', style: titleStyle),
            trailing: Text(
              transactionProvider.totalIncome.toPriceStringWithCurrency(),
              style: TextStyle(
                color: Color(0xff2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('${AppMessages.totalExpense.tr} :', style: titleStyle),
            trailing: Text(
              transactionProvider.totalExpense.toPriceStringWithCurrency(),
              style: TextStyle(
                color: themeData.colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
