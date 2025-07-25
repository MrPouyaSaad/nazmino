import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/input_formatter.dart';
import 'package:nazmino/core/translate/messages.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for the text fields
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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.transaction == null
                  ? AppMessages.addTransaction.tr
                  : AppMessages.editTransaction.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _amountController,
                    inputFormatters: [PriceInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppMessages.enterAmount.tr;
                      }

                      final cleaned = value.replaceAll(',', '');

                      final parsed = double.tryParse(cleaned);

                      if (parsed == null) {
                        return AppMessages.enterValidAmount.tr;
                      } else if (parsed <= 0) {
                        return AppMessages.enterPositiveAmount.tr;
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: AppMessages.amount.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppMessages.enterTitle.tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppMessages.title.tr,
                      isDense: true,

                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppMessages.expense.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !_isIncome
                        ? Theme.of(context).colorScheme.error
                        : Colors.black,
                  ),
                ),
                Switch(
                  value: _isIncome,
                  onChanged: (value) {
                    setState(() => _isIncome = value);
                  },
                ),
                Text(
                  AppMessages.income.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isIncome ? Color(0xff2E7D32) : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final amount = _amountController.text.replaceAll(',', '');
                  final transaction = Transaction(
                    id:
                        widget.transaction?.id ??
                        DateTime.now().toIso8601String(),
                    title: _titleController.text,
                    amount: double.tryParse(amount) ?? 0.0,
                    isInCome: _isIncome,
                  );

                  if (widget.transaction == null) {
                    transactionProvider.addTransaction(
                      transaction: transaction,
                    );
                  } else {
                    transactionProvider.editTransaction(
                      widget.transaction!,
                      transaction,
                    );
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(
                '${AppMessages.save.tr} ${AppMessages.transaction.tr}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
