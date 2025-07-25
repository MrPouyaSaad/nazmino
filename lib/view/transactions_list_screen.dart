import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/controller/theme_controller.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';
import 'package:nazmino/widgets/total_report.dart';
import 'package:nazmino/view/add_transaction_screen.dart';

import '../widgets/language_switcher.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.loadTransactions();
    if (mounted) setState(() => _isLoading = false);
  }

  void _showAddTransaction([transaction]) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddTransactionScreen(transaction: transaction),
    );
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppMessages.deleteAllTransactions.tr),
        content: Text(AppMessages.confirmDeleteAll.tr),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(AppMessages.cancel.tr),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TransactionProvider>(
                context,
                listen: false,
              ).clearTransactions();
              Navigator.of(context).pop();
            },
            child: Text(
              AppMessages.deleteAll.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppMessages.appName.tr),
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Toggle Theme'.tr,
          icon: Obx(() {
            final isDark = Get.find<ThemeController>().isDarkMode.value;
            return Icon(isDark ? Icons.dark_mode : Icons.light_mode);
          }),
          onPressed: () {
            Get.find<ThemeController>().toggleTheme();
          },
        ),
        actions: [
          // popup menu for language selection
          const LanguageSwitcher(),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _showAddTransaction,
              child: const Icon(Icons.add),
            ),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator(radius: 12))
          : transactions.isEmpty
          ? Center(child: Text(AppMessages.noTransactions.tr))
          : ListView(
              children: [
                TotalReport(transactionProvider: provider),
                _buildHeader(context),
                ...transactions.reversed.map(
                  (t) => TransactionTile(
                    transaction: t,
                    onTap: () => _showAddTransaction(t),
                    onDelete: () => provider.removeTransaction(t),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppMessages.transactions.tr, style: TextStyle(fontSize: 16)),
          TextButton.icon(
            onPressed: () => _showDeleteAllConfirmation(context),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              AppMessages.deleteAll.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
