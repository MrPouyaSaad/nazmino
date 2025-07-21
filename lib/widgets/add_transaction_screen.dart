import 'package:flutter/material.dart';
import 'package:nazmino/model/transaction.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.transaction});
  final Transaction? transaction;
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = true; // Default to income

  @override
  void initState() {
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _isIncome = widget.transaction!.isInCome;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add Transaction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16.0),
          // Add your form fields here
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !_isIncome ? Colors.red : Colors.black,
                ),
              ),
              // Use a Switch widget to toggle between income and expense
              Switch(
                value: _isIncome, // Replace with actual state management
                onChanged: (value) {
                  setState(() {
                    _isIncome =
                        value; // Update the state when the switch is toggled
                  });
                },
              ),
              Text(
                'Income',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isIncome ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),

          ElevatedButton(
            onPressed: () {
              transactionProvider.addTransaction(
                transaction: Transaction(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  amount: double.tryParse(_amountController.text) ?? 0.0,
                  isInCome: _isIncome,
                ),
              );

              Navigator.of(context).pop(); // Close the bottom sheet
              _titleController.clear(); // Clear the title field
              _amountController.clear(); // Clear the amount field
            },

            child: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }
}
