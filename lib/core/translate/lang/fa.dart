import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/core/translate/translate.dart';

class FaKeys extends AppTranslationKeys {
  @override
  Map<String, String> get keys => {
    AppMessages.appName: 'نظمینو',
    AppMessages.addTransaction: 'افزودن تراکنش',
    AppMessages.editTransaction: 'ویرایش تراکنش',
    AppMessages.deleteTransaction: 'حذف تراکنش',
    AppMessages.all: 'همه',
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
    AppMessages.aboutApp: 'درباره اپلیکیشن',
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
    AppMessages.restore: 'بازیابی',
    AppMessages.restoreTransaction: 'بازیابی تراکنش',
    AppMessages.confirmRestore:
        'آیا مطمئن هستید که می‌خواهید این تراکنش را بازیابی کنید؟',
    AppMessages.deleteCategory: 'حذف دسته‌بندی',
    AppMessages.confirmDeleteCategory:
        'آیا مطمئن هستید که می‌خواهید این دسته‌بندی را حذف کنید؟ همه تراکنش‌های این دسته‌بندی نیز حذف خواهند شد.',
    AppMessages.aboutDescription:
        'نظمینو یک اپلیکیشن مدیریت مالی ساده و کاربرپسند است که به شما کمک می‌کند تا درآمدها و هزینه‌های خود را به راحتی مدیریت کنید. با نظمینو می‌توانید تراکنش‌های مالی خود را ثبت کنید، دسته‌بندی‌های مختلف ایجاد کنید و گزارش‌های مالی دقیق دریافت کنید. این اپلیکیشن اکنون آنلاین شده و تمامی داده‌های شما به‌صورت امن ذخیره می‌شوند.',

    AppMessages.feature1: 'پیگیری تمام تراکنش‌های مالی',
    AppMessages.feature2: 'دسته‌بندی و سازماندهی هزینه‌ها',
    AppMessages.feature3: 'تاریخچه کامل تراکنش‌ها',
    AppMessages.feature4: 'ذخیره‌سازی داده‌ها به صورت آنلاین',

    AppMessages.developedBy: 'توسعه داده شده توسط',
    AppMessages.pouyaDev: 'پویا صادقزاده',

    AppMessages.login: 'ورود',
    AppMessages.signup: 'ثبت‌نام',
    AppMessages.username: 'شماره موبایل',
    AppMessages.password: 'رمز عبور',
    AppMessages.loginSuccess: 'با موفقیت وارد شدید',
    AppMessages.signupSuccess: 'حساب با موفقیت ایجاد شد',
    AppMessages.passwordTooShort: 'رمز عبور باید حداقل ۶ کاراکتر باشد',
    AppMessages.usernameRequired: 'نام کاربری الزامی است',
    AppMessages.dontHaveAccount: 'حساب ندارید؟',
    AppMessages.alreadyHaveAccount: 'حساب دارید؟',
    AppMessages.loginToYourAccount: 'ورود به حساب کاربری',
    AppMessages.createAccount: ' ایجاد حساب کاربری',
    AppMessages.code: 'کد تایید',
    AppMessages.verifyYourNumber: 'شماره موبایل خود را تایید کنید',
    AppMessages.resendCode: 'ارسال مجدد',
    AppMessages.resendIn: 'ارسال مجدد تا',
    AppMessages.seconds: 'ثانیه',
    AppMessages.emptyHistoryList: 'تاریخچه خالی است!',
    AppMessages.logOut: 'خروج از حساب',
    AppMessages.updateRequired: 'آپدیت ضروری',
    AppMessages.newVersionAvailable: 'نسخه جدید موجود است!',
    AppMessages.betterExperience: 'تجربه بهتری در انتظار شماست',
    AppMessages.tryAgain: 'تلاش مجدد',

    AppMessages.currentVersion: 'نسخه فعلی',
    AppMessages.newVersion: 'نسخه جدید',
    AppMessages.changelogTitle: 'تغییرات نسخه جدید:',
    AppMessages.changelogItem1: 'بهینه‌سازی عملکرد و سرعت برنامه',
    AppMessages.changelogItem2: 'رفع مشکلات گزارش شده توسط کاربران',
    AppMessages.downloadAndInstallUpdate: 'دانلود و نصب آپدیت',
    AppMessages.maybeLater: 'فعلاً نه، ممنون',
    AppMessages.errorTitle: 'خطا',
    AppMessages.cannotOpenUpdateLink: 'امکان باز کردن لینک آپدیت وجود ندارد',
    AppMessages.errorLaunchingUpdateLink: 'خطا در اجرای لینک آپدیت',
    AppMessages.termsPrefix: 'با ادامه، شما ',
    AppMessages.termsOfUse: 'شرایط استفاده',
    AppMessages.and: ' و ',
    AppMessages.privacyPolicy: 'سیاست حفظ حریم خصوصی',
    AppMessages.termsSuffix: ' ما را می‌پذیرید.',
    AppMessages.termsOfUseContent: '''
با استفاده از اپلیکیشن Nazmino شما موافقت می‌کنید که:

1. این اپلیکیشن تنها برای مدیریت مالی شخصی شما طراحی شده است و مسئولیتی در قبال تصمیمات مالی شما ندارد.  
2. ورود به اپلیکیشن از طریق شماره موبایل و کد یکبار مصرف (OTP) انجام می‌شود و شما مسئول حفظ امنیت شماره موبایل خود هستید.  
3. هرگونه سوءاستفاده از اپلیکیشن (از جمله دسترسی غیرمجاز یا انتشار داده‌های دیگران) ممنوع است.  
4. توسعه‌دهندگان حق دارند در هر زمان نسبت به تغییر یا توقف خدمات اقدام کنند.  
5. استفاده شما از اپ به منزله پذیرش تمامی تغییرات بعدی در شرایط استفاده خواهد بود.  
''',

    AppMessages.privacyPolicyContent: '''
ما در "نظمینو" به حریم خصوصی شما اهمیت می‌دهیم:

1. اطلاعات شخصی شما (مانند شماره موبایل، تراکنش‌ها) فقط برای ارائه خدمات اپ استفاده می‌شود.  
2. ما هیچ‌گاه اطلاعات شما را بدون رضایت‌تان به اشخاص ثالث نمی‌فروشیم یا منتقل نمی‌کنیم.  
3. داده‌های شما از طریق ارتباط امن (HTTPS) به سرور منتقل می‌شوند.  
4. شما می‌توانید در هر زمان درخواست حذف حساب کاربری خود را ثبت کنید.  
5. با استفاده از اپ، شما با ذخیره‌سازی و پردازش داده‌ها بر اساس این سیاست موافقت می‌کنید.  
''',
  };
}
