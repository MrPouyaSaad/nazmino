import 'package:flutter/material.dart';
import 'package:nazmino/common/price_extention.dart';
import 'package:nazmino/provider/transaction_provider.dart';

class TotalReport extends StatelessWidget {
  const TotalReport({super.key, required this.transactionProvider});

  final TransactionProvider transactionProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Report',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xff1E6091),
            ),
          ),
          const SizedBox(height: 8.0),
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('Total Amount: '),
            trailing: Text(
              transactionProvider.totalAmount.toPriceStringWithCurrency(),
            ),
          ),
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('Total Income: '),
            trailing: Text(
              transactionProvider.totalIncome.toPriceStringWithCurrency(),
              style: TextStyle(color: Colors.green),
            ),
          ),
          ListTile(
            minVerticalPadding: 0,
            minTileHeight: 28,
            contentPadding: EdgeInsets.zero,
            title: Text('Total Expense: '),
            trailing: Text(
              transactionProvider.totalExpense.toPriceStringWithCurrency(),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
