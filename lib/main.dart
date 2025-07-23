import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Nazmino',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.indigo,

        // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        // blendLevel: 20,
        // appBarStyle: FlexAppBarStyle.background,
        // useMaterial3: true,
        // visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),

      theme: FlexThemeData.light(
        scheme: FlexScheme.aquaBlue,
        // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        // blendLevel: 20,
        // appBarStyle: FlexAppBarStyle.background,
        // useMaterial3: true,
        // visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      home: TransactionsListScreen(),
    );
  }
}
