import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/core/translate/translate.dart';

class FaKeys extends AppTranslationKeys {
  @override
  Map<String, String> get keys => {
    AppMessages.appName: 'نظمینو',
    AppMessages.addTransaction: 'افزودن تراکنش',
    AppMessages.editTransaction: 'ویرایش تراکنش',
    AppMessages.deleteTransaction: 'حذف تراکنش',
    AppMessages.confirmDelete:
        'آیا مطمئن هستید که می‌خواهید این تراکنش را حذف کنید؟',
    AppMessages.transactionAdded: 'تراکنش با موفقیت اضافه شد!',
    AppMessages.transactionUpdated: 'تراکنش با موفقیت به‌روزرسانی شد!',
    AppMessages.transactionDeleted: 'تراکنش با موفقیت حذف شد!',
    AppMessages.noTransactions: 'هنوز تراکنشی اضافه نکردید!',
    AppMessages.deleteAllTransactions: 'حذف همه',
    AppMessages.confirmDeleteAll:
        'آیا مطمئن هستید که می‌خواهید همه تراکنش‌ها را حذف کنید؟',
    AppMessages.transactionsCleared: 'همه تراکنش‌ها با موفقیت پاک شدند!',
    AppMessages.income: 'درآمد',
    AppMessages.expense: 'هزینه',
    AppMessages.amount: 'مبلغ',
    AppMessages.title: 'عنوان',

    AppMessages.date: 'تاریخ',
    AppMessages.totalAmount: 'مجموع مبلغ',
    AppMessages.totalIncome: 'مجموع درآمد',
    AppMessages.totalExpense: 'مجموع هزینه',
    AppMessages.cancel: 'لغو',
    AppMessages.delete: 'حذف',
    AppMessages.deleteAll: 'حذف همه',
    AppMessages.confirm: 'تایید',

    AppMessages.ok: 'باشه',
    AppMessages.error: 'خطا',
    AppMessages.success: 'موفق',
    AppMessages.loading: 'در حال بارگذاری',
    AppMessages.noData: 'داده‌ای موجود نیست',
    AppMessages.somethingWentWrong: 'مشکلی پیش آمد!',
    AppMessages.transaction: 'تراکنش',
    AppMessages.transactions: 'تراکنش‌ها',
    AppMessages.save: 'ذخیره',
    AppMessages.enterAmount: 'لطفاً یک "مبلغ" وارد کنید',
    AppMessages.enterTitle: 'لطفاً یک "عنوان" وارد کنید',
    AppMessages.enterValidAmount: 'لطفاً یک "مبلغ" معتبر وارد کنید',
    AppMessages.enterPositiveAmount: 'لطفاً یک "مبلغ" مثبت وارد کنید',
    AppMessages.enterValidTitle: 'لطفاً یک "عنوان" معتبر وارد کنید',
    AppMessages.history: 'تاریخچه',
    AppMessages.aboutApp: 'درباره اپ',
    AppMessages.language: "زبان",
    AppMessages.darkMode: 'حالت تاریک',
    AppMessages.defaultt: 'پیش‌فرض',
    AppMessages.selectCategory: 'انتخاب دسته‌بندی',
    AppMessages.category: 'دسته‌بندی',
    AppMessages.addCategory: 'افزودن دسته‌بندی',
    AppMessages.newCategory: 'دسته‌بندی جدید',
    AppMessages.categoryName: 'نام دسته‌بندی',
    AppMessages.add: 'افزودن',
    AppMessages.selectedCategory: 'دسته‌بندی انتخاب شده',
    AppMessages.all: 'همه',
  };
}
