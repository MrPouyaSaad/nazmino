import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/model/category.dart';
import 'package:nazmino/widgets/loading_widget.dart';
import '../../core/translate/messages.dart';
import '../transaction_list/bloc/transaction_bloc.dart';
import 'bloc/category_bloc.dart';

class TransactionCategoryWidget extends StatefulWidget {
  const TransactionCategoryWidget({super.key});

  @override
  State<TransactionCategoryWidget> createState() =>
      _TransactionCategoryWidgetState();
}

class _TransactionCategoryWidgetState extends State<TransactionCategoryWidget> {
  TransactionCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return AppLoading().marginOnly(top: 8);
        }
        if (state is CategorySuccess) {
          final categories = state.categories;

          if (state.isLoading) {
            return AppLoading().marginOnly(top: 8);
          }
          selectedCategory = selectedCategory ?? categories.categoryList.last;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  itemCount: categories.count + 1,
                  itemBuilder: (context, index) {
                    if (index == categories.count) {
                      return _buildAddCategoryButton(context);
                    }
                    final category = state.categories.categoryList.reversed
                        .toList()[index];
                    return Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onLongPress: () => index != 0
                            ? _showDeleteCategoryDialog(context, category)
                            : null,
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            category.name == 'All' || category.name == 'همه'
                                ? AppMessages.all.tr
                                : category.name,
                          ),
                          selected: selectedCategory!.id == category.id,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });

                            context.read<TransactionBloc>().add(
                              FilterByCategory(selectedCategory!),
                            );
                          },
                          selectedColor: theme.colorScheme.primary.withOpacity(
                            0.2,
                          ),
                          labelStyle: TextStyle(
                            color: selectedCategory?.id == category.id
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ],
          ).marginSymmetric(vertical: 4);
        } else {
          throw 'Error';
        }
      },
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InputChip(
        avatar: const Icon(Icons.add, size: 18),
        label: Text(AppMessages.addCategory.tr),
        onPressed: () => _showAddCategoryDialog(context),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppMessages.newCategory.tr),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: AppMessages.categoryName.tr,
              border: const OutlineInputBorder(),
            ),
            maxLength: 30,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppMessages.cancel.tr),
            ),
            ElevatedButton(
              onPressed: () {
                final name = textController.text.trim();
                if (name.isNotEmpty) {
                  BlocProvider.of<CategoryBloc>(context).add(AddCategory(name));
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(AppMessages.add.tr),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    TransactionCategory category,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppMessages.deleteCategory.tr),
          content: Text(
            AppMessages.confirmDeleteCategory.trParams({
              'category': category.name,
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppMessages.cancel.tr),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.read<CategoryBloc>().add(
                  DeleteCategory(category.id),
                );
                Navigator.pop(dialogContext);
              },
              child: Text(AppMessages.delete.tr),
            ),
          ],
        );
      },
    );
  }
}
