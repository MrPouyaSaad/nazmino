import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nazmino/core/translate/translate.dart';
import 'package:nazmino/provider/transaction_provider.dart';
import 'package:nazmino/view/transactions_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nazmino',
      translations: AppTranslate(),
      locale: const Locale('fa', 'IR'), // Set the default locale to Persian
      debugShowCheckedModeBanner: false,

      // themeMode: ThemeMode.light,
      // darkTheme: FlexThemeData.dark(
      //   scheme: FlexScheme.indigo,

      //   // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //   // blendLevel: 20,
      //   // appBarStyle: FlexAppBarStyle.background,
      //   // useMaterial3: true,
      //   // visualDensity: FlexColorScheme.comfortablePlatformDensity,
      // ),
      theme: ThemeData(
        fontFamily: 'YekanBakh',
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0C2A43),
          onPrimary: Colors.white,

          secondary: Color(0xFF1E6091),
          onSecondary: Colors.white,
          error: Color(0xFFC62828),
          onError: Colors.white,
          background: Color(0xFFF5F7FA),
          onBackground: Color(0xFF0C2A43),
          surface: Colors.white,
          onSurface: Color(0xFF0C2A43),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0C2A43),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1E6091),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E6091),
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width, 54),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'YekanBakh',
            ),
          ),
        ),
        cardColor: Colors.white,
        dividerColor: Color(0xFFE0E0E0),
      ),

      home: TransactionsListScreen(),
    );
  }
}
