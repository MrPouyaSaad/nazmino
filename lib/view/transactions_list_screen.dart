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
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final catProvider = Provider.of<CategoryProvider>(context);

    final themeController = Get.find<ThemeController>();

    // فیلتر کردن تراکنش‌ها بر اساس دسته‌بندی انتخاب شده
    final filteredTransactions =
        _selectedCategory == null || _selectedCategory?.id == defaultCategoryId
        ? provider
              .transactions // نمایش همه اگر پیش‌فرض انتخاب شده یا هیچکدام
        : provider.transactions
              .where((t) => t.categoryId == _selectedCategory?.id)
              .toList();

    return Scaffold(
      appBar: AppBar(title: Text(AppMessages.appName.tr), centerTitle: true),
      drawer: _buildAppDrawer(context, themeController),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _showAddTransaction,
              child: const Icon(Icons.add),
            ),
      body: _isLoading
          ? const Center(child: CupertinoActivityIndicator(radius: 12))
          : Column(
              children: [
                TotalReport(transactions: filteredTransactions),
                _buildCategorySelector(context),
                if (filteredTransactions.isEmpty)
                  Expanded(
                    child: Center(child: Text(AppMessages.noTransactions.tr)),
                  )
                else ...[
                  _buildHeader(context, filteredTransactions),
                  Expanded(
                    child: ListView(
                      children: filteredTransactions.reversed
                          .map(
                            (t) => TransactionTile(
                              transaction: t,
                              onTap: () => _showAddTransaction(t),
                              onDelete: () => provider.removeTransaction(t),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '${AppMessages.selectedCategory.tr}: ${_selectedCategory?.name ?? AppMessages.all.tr}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _buildAddCategoryButton(context);
              }
              final category = categories[index];
              return ChoiceChip(
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
                label: Text(category.name),
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

  Widget _buildAppDrawer(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.appName.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   AppMessages.appSlogan.tr,
                      //   style: TextStyle(
                      //     color: Colors.white70,
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.history,
                    text: AppMessages.history.tr,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const TransactionsHistoryListScreen());
                    },
                  ),
                  Obx(
                    () => SwitchListTile(
                      secondary: Icon(
                        themeController.isDarkMode.value
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: Text(AppMessages.darkMode.tr),
                      value: themeController.isDarkMode.value,
                      onChanged: (_) => themeController.toggleTheme(),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(AppMessages.language.tr),
                    trailing: DropdownButton<String>(
                      value: Get.locale?.languageCode ?? 'en',
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'fa', child: Text('فارسی')),
                      ],
                      onChanged: (String? languageCode) {
                        if (languageCode == null) return;
                        final localeService = Get.find<LocaleService>();
                        if (languageCode == 'fa') {
                          localeService.changeLocale('fa');
                        } else {
                          localeService.changeLocale('en');
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    text: AppMessages.aboutApp.tr,
                    onTap: () {
                      // Navigate to about screen
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Nazmino v1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
