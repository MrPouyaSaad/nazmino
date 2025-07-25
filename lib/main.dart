import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/controller/theme_controller.dart';
import 'package:nazmino/core/theme/theme.dart';
import 'package:nazmino/core/translate/translate.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/service/lang_load_service.dart';
import 'package:nazmino/view/transactions_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => LocaleService().init());
  Get.put(ThemeController());
  runApp(
    // Use MultiProvider to provide the TransactionProvider to the widget tree
    // This allows us to access the TransactionProvider in any widget below it
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return Obx(
      () => GetMaterialApp(
        title: 'Nazmino',
        translations: AppTranslate(),
        locale: localeService.currentLocale.value,
        debugShowCheckedModeBanner: false,

        theme: AppThemes.lightTheme(localeService.currentLocale.value),
        darkTheme: AppThemes.darkTheme(localeService.currentLocale.value),
        themeMode: ThemeMode.system,
        home: TransactionsListScreen(),
      ),
    );
  }
}
