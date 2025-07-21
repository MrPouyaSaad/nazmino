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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0c2a43)),
      ),
      home: TransactionsListScreen(),
    );
  }
}
