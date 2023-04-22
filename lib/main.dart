import 'package:expense_tracker/pages/tabs_page.dart';
import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TransactionsProvider(),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer
          ),
          textTheme: ThemeData().textTheme.copyWith(
            displayLarge: ThemeData().textTheme.displayLarge!.copyWith(),
            displayMedium: ThemeData().textTheme.displayMedium!.copyWith(),
            displaySmall: ThemeData().textTheme.displaySmall!.copyWith(),
            headlineLarge: ThemeData().textTheme.headlineLarge!.copyWith(),
            headlineMedium: ThemeData().textTheme.headlineMedium!.copyWith(),
            headlineSmall: ThemeData().textTheme.headlineSmall!.copyWith(),
            titleLarge: ThemeData().textTheme.titleLarge!.copyWith(),
            titleMedium: ThemeData().textTheme.titleMedium!.copyWith(),
            titleSmall: ThemeData().textTheme.titleSmall!.copyWith(),
            labelLarge: ThemeData().textTheme.labelLarge!.copyWith(),
            labelMedium: ThemeData().textTheme.labelMedium!.copyWith(),
            labelSmall: ThemeData().textTheme.labelSmall!.copyWith(),
            bodyLarge: ThemeData().textTheme.bodyLarge!.copyWith(),
            bodyMedium: ThemeData().textTheme.bodyMedium!.copyWith(),
            bodySmall: ThemeData().textTheme.bodySmall!.copyWith(),
          )
        ),
        home: const TabsPage(),
      ),
    );
  }
}