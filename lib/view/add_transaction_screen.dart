import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/input_formatter.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/model/transaction.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    this.transaction,
    this.category,
    required this.categories,
  });

  final Transaction? transaction;
  final TransactionCategory? category;
  final List<TransactionCategory> categories;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = true;
  TransactionCategory? _selectedCategory;

  @override
  void initState() {
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _isIncome = widget.transaction!.isInCome;

      // Set initial category from transaction or passed category
      _selectedCategory = widget.categories.firstWhere(
        (c) => c.id == (widget.transaction?.categoryId ?? widget.category?.id),
        orElse: () => widget.categories.first,
      );
    } else if (widget.category != null) {
      _selectedCategory = widget.category;
    } else {
      _selectedCategory = widget.categories.isNotEmpty
          ? widget.categories.first
          : null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
        ),
        child: Material(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.transaction == null
                      ? AppMessages.addTransaction.tr
                      : AppMessages.editTransaction.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category Dropdown

                      // Amount Field
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
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: AppMessages.amount.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Title Field
                      TextFormField(
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppMessages.enterTitle.tr;
                          }
                          return null;
                        },
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          labelText: AppMessages.title.tr,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface.withOpacity(0.5),
                        ),
                      ),
                      if (widget.categories.isNotEmpty)
                        const SizedBox(height: 16.0),
                      if (widget.categories.isNotEmpty)
                        DropdownButtonFormField<TransactionCategory>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: AppMessages.category.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surface.withOpacity(0.5),
                          ),
                          items: widget.categories.map((category) {
                            return DropdownMenuItem<TransactionCategory>(
                              value: category,
                              child: Text(
                                category.name == 'All'
                                    ? AppMessages.all.tr
                                    : category.name,
                              ),
                            );
                          }).toList(),
                          onChanged: (category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return AppMessages.selectCategory.tr;
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Income/Expense Toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppMessages.expense.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: !_isIncome
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      Switch(
                        value: _isIncome,
                        onChanged: (value) => setState(() => _isIncome = value),
                        activeColor: theme.colorScheme.tertiary,
                        inactiveThumbColor: theme.colorScheme.error,
                      ),
                      Text(
                        AppMessages.income.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isIncome
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedCategory != null) {
                        final amount = _amountController.text.replaceAll(
                          ',',
                          '',
                        );
                        final transaction = Transaction(
                          categoryId: _selectedCategory!.id,
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
