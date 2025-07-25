import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/core/translate/translate.dart';

class EnKeys extends AppTranslationKeys {
  @override
  Map<String, String> get keys => {
    AppMessages.appName: 'Nazmino',
    AppMessages.addTransaction: 'Add Transaction',
    AppMessages.editTransaction: 'Edit Transaction',
    AppMessages.deleteTransaction: 'Delete Transaction',
    AppMessages.confirmDelete:
        'Are you sure you want to delete this transaction?',
    AppMessages.transactionAdded: 'Transaction added successfully!',
    AppMessages.transactionUpdated: 'Transaction updated successfully!',
    AppMessages.transactionDeleted: 'Transaction deleted successfully!',
    AppMessages.noTransactions: 'No transactions available.',
    AppMessages.deleteAllTransactions: 'Delete All Transactions',
    AppMessages.confirmDeleteAll:
        'Are you sure you want to delete all transactions?',
    AppMessages.transactionsCleared: 'All transactions cleared successfully!',
    AppMessages.income: 'Income',
    AppMessages.expense: 'Expense',
    AppMessages.amount: 'Amount',
    AppMessages.title: 'Title',
    AppMessages.date: 'Date',
    AppMessages.totalAmount: 'Total Amount',
    AppMessages.totalIncome: 'Total Income',
    AppMessages.totalExpense: 'Total Expense',
    AppMessages.cancel: 'Cancel',
    AppMessages.delete: 'Delete',
    AppMessages.deleteAll: 'Delete All',
    AppMessages.confirm: 'Confirm',
    AppMessages.ok: 'OK',
    AppMessages.error: 'Error',
    AppMessages.success: 'Success',
    AppMessages.loading: 'Loading',
    AppMessages.noData: 'No Data Available',
    AppMessages.somethingWentWrong: 'Something went wrong!',
    AppMessages.transaction: 'Transaction',
    AppMessages.transactions: 'Transactions',
    AppMessages.save: 'Save',
    AppMessages.enterAmount: 'Please enter an "Amount"',
    AppMessages.enterTitle: 'Please enter a "Title"',
    AppMessages.enterValidAmount: 'Please enter a valid "Amount"',
    AppMessages.enterPositiveAmount: 'Please enter a positive "Amount"',
    AppMessages.enterValidTitle: 'Please enter a valid "Title"',
  };
}
