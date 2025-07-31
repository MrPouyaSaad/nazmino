import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/controller/theme_controller.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/model/transaction.dart';
import 'package:nazmino/provider/category_provider.dart';
import 'package:nazmino/provider/transaction_history_provider.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/service/lang_load_service.dart';
import 'package:nazmino/view/about_app_screen.dart';
import 'package:nazmino/widgets/drawer.dart';
import 'package:nazmino/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';
import 'package:nazmino/widgets/total_report.dart';
import 'package:nazmino/view/add_transaction_screen.dart';
import 'package:nazmino/view/transaction_history_screen.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  bool _isLoading = true;
  TransactionCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);

    await provider.loadTransactions();
    await catProvider.loadCategories();

    if (mounted) {
      setState(() {
        _isLoading = false;

        if (catProvider.categories.isNotEmpty) {
          _selectedCategory = catProvider.categories.first;
        }
      });
    }
  }

  void _showAddTransaction([Transaction? transaction]) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddTransactionScreen(
        transaction: transaction,
        categories: provider.categories,
        category: _selectedCategory,
      ),
    );
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
              for (var transaction in transactions) {
                Provider.of<TransactionHistoryProvider>(
                  context,
                  listen: false,
                ).addTransaction(transaction: transaction);
              }
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
    final historyProvider = Provider.of<TransactionHistoryProvider>(context);

    // filter transactions based on selected category
    final filteredTransactions =
        _selectedCategory == null || _selectedCategory?.id == defaultCategoryId
        ? provider.transactions
        : provider.transactions
              .where((t) => t.categoryId == _selectedCategory?.id)
              .toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     AppMessages.appName.tr,
      //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      drawer: AppDrawer(),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _showAddTransaction,
              child: const Icon(Icons.add),
            ),
      body: _isLoading
          ? const Center(child: CupertinoActivityIndicator(radius: 12))
          : NestedScrollView(
              physics: filteredTransactions.isEmpty
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.525,

                  title: Text(
                    AppMessages.appName.tr,
                    style: TextStyle(
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
                          TotalReport(transactions: filteredTransactions),
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
                  SliverToBoxAdapter(child: _buildCategorySelector(context)),
                  if (filteredTransactions.isEmpty)
                    SliverFillRemaining(
                      child: Center(child: Text(AppMessages.noTransactions.tr)),
                    )
                  else ...[
                    SliverToBoxAdapter(
                      child: _buildHeader(context, filteredTransactions),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final t = filteredTransactions.reversed.toList()[index];
                        return TransactionTile(
                          transaction: t,
                          onTap: () => _showAddTransaction(t),
                          onDelete: () {
                            historyProvider.addTransaction(transaction: t);
                            provider.removeTransaction(t);
                          },
                        );
                      }, childCount: filteredTransactions.length),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 88), // فضای زیر FAB
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _buildAddCategoryButton(context);
              }
              final category = categories[index];
              return InkWell(
                onLongPress: () => index != 0 && index != categories.length
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppMessages.deleteCategory.tr),
                            content: Text(
                              AppMessages.confirmDeleteCategory.trParams({
                                'category': category.name,
                              }),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppMessages.cancel.tr),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _selectedCategory = categories.first;
                                  final transactions =
                                      Provider.of<TransactionProvider>(
                                        context,
                                        listen: false,
                                      ).transactions;
                                  Provider.of<TransactionHistoryProvider>(
                                    context,
                                    listen: false,
                                  ).addTransactionFromCategory(
                                    category.id,
                                    transactions,
                                  );
                                  Provider.of<CategoryProvider>(
                                    context,
                                    listen: false,
                                  ).removeCategory(category.id);
                                  Provider.of<TransactionProvider>(
                                    context,
                                    listen: false,
                                  ).deleteTransactionsByCategory(category.id);
                                  Navigator.pop(context);
                                },
                                child: Text(AppMessages.delete.tr),
                              ),
                            ],
                          );
                        },
                      )
                    : null,
                child: ChoiceChip(
                  chipAnimationStyle: ChipAnimationStyle(
                    enableAnimation: const AnimationStyle(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 250),
                    ),
                    selectAnimation: const AnimationStyle(
                      curve: Curves.easeOutBack,
                      duration: Duration(milliseconds: 300),
                    ),
                  ),

                  showCheckmark: false,
                  label: Text(index == 0 ? AppMessages.all.tr : category.name),
                  selected: _selectedCategory?.id == category.id,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: _selectedCategory?.id == category.id
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return InputChip(
      avatar: const Icon(Icons.add, size: 18),
      label: Text(AppMessages.addCategory.tr),
      onPressed: () => _showAddCategoryDialog(context),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppMessages.newCategory.tr),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: AppMessages.categoryName.tr,
              border: OutlineInputBorder(),
            ),
            maxLength: 30,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppMessages.cancel.tr),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  categoryProvider.addCategory(textController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text(AppMessages.add.tr),
            ),
          ],
        );
      },
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
