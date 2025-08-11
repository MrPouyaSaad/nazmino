import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/repository/history_repo.dart';
import 'package:nazmino/bloc/repository/transaction_repo.dart';
import 'package:nazmino/controller/theme_controller.dart';
import 'package:nazmino/core/extensions/app_version.dart';
import 'package:nazmino/core/theme/theme.dart';
import 'package:nazmino/core/translate/translate.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:nazmino/service/lang_load_service.dart';
import 'package:nazmino/view/history/bloc/history_bloc.dart';
import 'package:nazmino/view/history/bloc/history_event.dart';
import 'package:nazmino/view/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'bloc/repository/category_repo.dart';
import 'core/api/options.dart';
import 'view/category/bloc/category_bloc.dart';
import 'view/transaction_list/bloc/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => LocaleService().init());
  await ApiBaseData.init();
  Get.put(ThemeController());
  await AppVersion.init();
  runApp(
    // Use MultiProvider to provide the TransactionProvider to the widget tree
    // This allows us to access the TransactionProvider in any widget below it
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // ChangeNotifierProvider(create: (context) => TransactionProvider()),
        // ChangeNotifierProvider(create: (context) => CategoryProvider()),
        // ChangeNotifierProvider(
        //   create: (context) => TransactionHistoryProvider(),
        // ),
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CategoryBloc(categoryRepository)..add(CategoryStarted()),
        ),
        BlocProvider(
          create: (context) =>
              TransactionBloc(transactionRepository)
                ..add(TransactionsListScreenStarted()),
        ),
        BlocProvider(
          create: (context) =>
              HistoryBloc(historyRepository)..add(LoadHistory()),
        ),
      ],
      child: Obx(
        () => GetMaterialApp(
          title: 'Nazmino',
          translations: AppTranslate(),
          locale: localeService.currentLocale.value,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme(localeService.currentLocale.value),
          darkTheme: AppThemes.darkTheme(localeService.currentLocale.value),
          themeMode: ThemeMode.system,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
