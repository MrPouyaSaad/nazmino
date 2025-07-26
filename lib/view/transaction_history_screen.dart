import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/provider/category_provider.dart';
import 'package:nazmino/provider/transaction_history_provider.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';
import 'package:nazmino/view/add_transaction_screen.dart';

class TransactionsHistoryListScreen extends StatefulWidget {
  const TransactionsHistoryListScreen({super.key});

  @override
  State<TransactionsHistoryListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends State<TransactionsHistoryListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = Provider.of<TransactionHistoryProvider>(
      context,
      listen: false,
    );
    await provider.loadTransactions();
    if (mounted) setState(() => _isLoading = false);
  }

  void _restoreTransaction([transaction]) {
    if (transaction == null) return;

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final historyProvider = Provider.of<TransactionHistoryProvider>(
      context,
      listen: false,
    );

    provider.addTransaction(transaction: transaction);
    historyProvider.removeTransaction(transaction);
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
    final provider = Provider.of<TransactionHistoryProvider>(context);
    final transactions = provider.transactionsHistory;

    return Scaffold(
      appBar: AppBar(title: Text(AppMessages.history.tr), centerTitle: true),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator(radius: 12))
          : transactions.isEmpty
          ? Center(child: Text(AppMessages.noTransactions.tr))
          : ListView(
              children: [
                _buildHeader(context),
                ...transactions.reversed.map(
                  (t) => TransactionTile(
                    isFromHistory: true,
                    transaction: t,
                    onTap: () => _restoreTransaction(t),
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
          Text(
            '${AppMessages.transactions.tr} ${AppMessages.history.tr}',
            style: TextStyle(fontSize: 16),
          ),
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
