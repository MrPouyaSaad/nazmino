import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/model/category.dart';
import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/view/transaction_list/bloc/transaction_bloc.dart';
import 'package:nazmino/widgets/drawer.dart';
import 'package:nazmino/widgets/error_widget.dart';
import 'package:nazmino/widgets/loading_widget.dart';
import 'package:nazmino/widgets/transaction_tile.dart';
import 'package:nazmino/widgets/total_report.dart';
import 'package:nazmino/view/add_transaction_screen.dart';
import '../category/category_list.dart';
import '../category/bloc/category_bloc.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransactionsListView();
  }
}

class _TransactionsListView extends StatefulWidget {
  const _TransactionsListView();

  @override
  State<_TransactionsListView> createState() => _TransactionsListViewState();
}

class _TransactionsListViewState extends State<_TransactionsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          final lastEvent = BlocProvider.of<CategoryBloc>(context).lastEvent;
          if (lastEvent is DeleteCategory) {
            context.read<TransactionBloc>().add(
              TransactionsListScreenStarted(),
            );
          }

          if (state is TransactionDeleteError) {
            setState(() {});
          }

          if (state is TransactionLoaded) {
            log('set State');
            setState(() {});
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            log('Currently State is: $state', name: 'State', level: 1);

            Widget? fab;
            Widget body;

            if (state is TransactionLoading) {
              body = const AppLoading();
            } else if (state is TransactionLoaded) {
              body = _buildSuccessState(context, state);
              fab = FloatingActionButton(
                onPressed: () => _showAddTransaction(),
                child: const Icon(Icons.add),
              );
            } else if (state is TransactionError) {
              body = AppErrorScreen(
                onRetry: () => BlocProvider.of<TransactionBloc>(
                  context,
                ).add(TransactionsListScreenStarted()),
              );
            } else {
              body = const SizedBox.shrink();
            }

            return Scaffold(
              drawer: const AppDrawer(),
              body: body,
              floatingActionButton: fab,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, TransactionLoaded state) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.width * 0.525,
          title: Text(
            AppMessages.appName.tr,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  TotalReport(transactions: state.transactions),
                ],
              ),
            ),
          ),
          floating: true,
          pinned: true,
          snap: true,
          centerTitle: true,
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: TransactionCategoryWidget()),
          if (state.transactions.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text(AppMessages.noTransactions.tr)),
            )
          else ...[
            SliverToBoxAdapter(
              child: _buildHeader(context, state.transactions),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final t = state.transactions.toList()[index];
                return TransactionTile(
                  transaction: t,
                  onTap: () => _showEditTransaction(context, t),
                  onDelete: () => _deleteTransaction(context, t.id!),
                );
              }, childCount: state.transactions.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 88)),
          ],
        ],
      ),
    );
  }

  void _showAddTransaction() {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    final categories = categoryBloc.state is CategorySuccess
        ? (categoryBloc.state as CategorySuccess).categories
        : TransactionCategoryListModel(categoryList: [], count: 0);

    Get.bottomSheet(
      AddTransactionScreen(categories: categories),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 10,
      enableDrag: true,

      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }

  void _showEditTransaction(BuildContext context, Transaction transaction) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    final categories = (categoryBloc.state is CategorySuccess)
        ? (categoryBloc.state as CategorySuccess).categories
        : TransactionCategoryListModel(categoryList: [], count: 0);

    final category = categories.categoryList.firstWhere(
      (c) => c.id == transaction.categoryId.toString(),
    );
    Get.bottomSheet(
      AddTransactionScreen(
        transaction: transaction,
        categories: categories,
        category: category,
      ),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 10,
      enableDrag: true,

      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
    // showModalBottomSheet(
    //   context: context,
    //   enableDrag: true,
    //   isDismissible: true,
    //   isScrollControlled: true,
    //   showDragHandle: true,
    //   builder: (bottomSheetContext) {
    //     final categories =
    //         bottomSheetContext.read<CategoryBloc>().state is CategorySuccess
    //         ? (bottomSheetContext.read<CategoryBloc>().state as CategorySuccess)
    //               .categories
    //         : <TransactionCategory>[];
    //     return AddTransactionScreen(
    //       transaction: transaction,
    //       categories: categories,
    //       category: selectedCategory,
    //     );
    //   },
    // );
  }

  void _deleteTransaction(BuildContext context, String transactionId) {
    context.read<TransactionBloc>().add(DeleteTransaction(transactionId));
  }

  void _showDeleteAllConfirmation(
    BuildContext context,
    List<Transaction> transactions,
  ) {
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

              BlocProvider.of<TransactionBloc>(
                context,
              ).add(DeleteAllTransactions());
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

  Widget _buildHeader(BuildContext context, List<Transaction> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppMessages.transactions.tr,
            style: const TextStyle(fontSize: 16),
          ),
          TextButton.icon(
            onPressed: () => _showDeleteAllConfirmation(context, transactions),
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
