import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nazmino/common/price_extention.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/widgets/add_transaction_screen.dart';
import 'package:nazmino/widgets/total_report.dart';
import 'package:provider/provider.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nazmino',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xff1E6091),
        // foregroundColor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Color(0xff1E6091),
        // foregroundColor: Colors.white,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => AddTransactionScreen(),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: transactionProvider.transactions.length + 2,
          itemBuilder: (context, index) {
            int transactionIndex = index - 2;
            switch (index) {
              case 0:
                return TotalReport(transactionProvider: transactionProvider);
              case 1:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Transactions', style: TextStyle()),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear All Transactions'),
                            content: const Text(
                              'Are you sure you want to clear all transactions?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  transactionProvider.clearTransactions();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Clear All',
                                  style: TextStyle(
                                    color: Colors.redAccent.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      iconAlignment: IconAlignment.end,
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: Colors.redAccent.shade700,
                      ),
                      label: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.redAccent.shade700),
                      ),
                    ),
                  ],
                );
            }
            return GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => AddTransactionScreen(
                  transaction:
                      transactionProvider.transactions[transactionIndex],
                ),
              ),
              onLongPress: () {
                // Confirm removal of the transaction
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Transaction'),
                    content: const Text(
                      'Are you sure you want to delete this transaction?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          transactionProvider.removeTransaction(
                            transactionProvider.transactions[transactionIndex],
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    transactionProvider.transactions[transactionIndex].title,
                  ),
                  subtitle: Text(
                    transactionProvider.transactions[transactionIndex].isInCome
                        ? 'Income'
                        : 'Expense',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        transactionProvider
                            .transactions[transactionIndex]
                            .amount
                            .toPriceStringWithCurrency(),
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              transactionProvider
                                  .transactions[transactionIndex]
                                  .isInCome
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        transactionProvider.transactions[transactionIndex].id
                            .substring(0, 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
