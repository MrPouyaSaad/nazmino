import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/repository/history_repo.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/view/history/bloc/history_bloc.dart';
import 'package:nazmino/widgets/error_widget.dart';
import 'package:nazmino/widgets/loading_widget.dart';
import 'package:nazmino/widgets/transaction_tile.dart';

import '../transaction_list/bloc/transaction_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';

class TransactionsHistoryListScreen extends StatefulWidget {
  const TransactionsHistoryListScreen({super.key});

  @override
  State<TransactionsHistoryListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends State<TransactionsHistoryListScreen> {
  late HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc(historyRepository)..add(LoadHistory());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
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
              Navigator.of(context).pop();

              _bloc.add(DeleteAllHistory());
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

  void _showGetSnackBar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطا' : 'موفقیت',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  void _showLoadingDialog() {
    Get.dialog(const AppLoading(), barrierDismissible: false);
  }

  void _hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // بستن دیالوگ
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppMessages.history.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: BlocListener<HistoryBloc, HistoryState>(
          listenWhen: (prev, curr) => curr is HistoryActionState,
          listener: (context, state) {
            if (state is DeleteAllHistoryLoading) {
              _showLoadingDialog();
            } else {
              _hideLoadingDialog();
            }

            if (state is DeleteHistorySuccess) {
              _showGetSnackBar('تراکنش با موفقیت حذف شد');
            } else if (state is DeleteHistoryError) {
              _showGetSnackBar('خطا در حذف تراکنش', isError: true);
            } else if (state is DeleteAllHistorySuccess) {
              _showGetSnackBar('تمام تراکنش‌ها حذف شدند');
            } else if (state is DeleteAllHistoryError) {
              _showGetSnackBar('خطا در حذف همه تراکنش‌ها', isError: true);
            } else if (state is RestoreHistorySuccess) {
              _showGetSnackBar('تراکنش با موفقیت بازگردانده شد');
              context.read<TransactionBloc>().add(
                TransactionsListScreenStarted(),
              );
            } else if (state is RestoreHistoryError) {
              _showGetSnackBar('خطا در بازگردانی تراکنش', isError: true);
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoading) {
                return const AppLoading();
              } else if (state is HistoryLoaded) {
                final transactions = state.transactions;
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      AppMessages.emptyHistoryList.tr,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView(
                  children: [
                    _buildHeader(context),
                    ...transactions.reversed.map(
                      (t) => TransactionTile(
                        isFromHistory: true,
                        transaction: t,
                        onTap: () => _bloc.add(RestoreHistoryItem(t.id!)),
                        onDelete: () => _bloc.add(DeleteHistoryItem(t.id!)),
                      ),
                    ),
                  ],
                );
              } else if (state is HistoryLoadError) {
                return AppErrorWidget(onRetry: () => _bloc.add(LoadHistory()));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            '${AppMessages.history.tr} ${AppMessages.transactions.tr}',
            style: TextStyle(fontSize: 14),
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
