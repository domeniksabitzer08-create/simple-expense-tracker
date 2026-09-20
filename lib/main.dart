import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/constants/routes.dart';
import 'package:simple_expense_tracker/views/main_view.dart';
import 'package:simple_expense_tracker/views/new_expense_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 16, 163, 255),
        ),
      ),
      home: const MainView(),
      routes: {
        mainViewRoute: (context) => MainView(),
        newExpenseViewRoute: (context) => NewExpenseView(),
      },
    );
  }
}
