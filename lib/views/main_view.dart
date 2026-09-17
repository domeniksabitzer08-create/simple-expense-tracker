import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/widgets/app_text_widget.dart';
import 'package:simple_expense_tracker/widgets/category_widget.dart';

class MainView extends StatefulWidget {
  const new({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final expenes = [
    Expense(
      id: 0,
      name: "Mc Donalds",
      date: DateTime(2026, 9, 11),
      expense: 7.50,
      category: Category(
        id: 0,
        name: "Food",
        color: const Color.fromARGB(255, 126, 115, 7),
      ),
    ),
    Expense(
      id: 0,
      name: "Burger King",
      date: DateTime(2026, 9, 11),
      expense: 7.50,
      category: Category(
        id: 0,
        name: "Food",
        color: const Color.fromARGB(255, 126, 115, 7),
      ),
    ),
    Expense(
      id: 0,
      name: "Noodle King",
      date: DateTime(2026, 10, 11),
      expense: 7.50,
      category: Category(
        id: 0,
        name: "Food",
        color: const Color.fromARGB(255, 126, 115, 7),
      ),
    ),
  ];

  List<DateTime> dates = [];
  @override
  Widget build(BuildContext context) {
    List<dynamic> uiList = createList();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Sort by Catagories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Expense",
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: uiList.length,
        itemBuilder: (BuildContext context, int index) {
          final element = uiList[index];
          if (element is Expense) return ExpenseLabel(expense: element);
          return DateLabel(date: element);
        },
      ),
    );
  }

  List<dynamic> createList() {
    List list = [];
    int count = 0;
    for (int i = 0; i < expenes.length; i++) {
      Expense exp = expenes[i];
      if (!dates.contains(exp.date)) {
        list.insert(i + count, exp.date);
      }
      list.insert(i + count + 1, exp);
      count++;
    }
    return list;
  }
}

class DateLabel extends StatelessWidget {
  final DateTime _date;
  const DateLabel({super.key, required this._date});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Center(
        child: AppText(
          text: "${_date.day}.${_date.month}.${_date.year}",
          color: Colors.white,
          fontSize: 40,
        ),
      ),
    );
  }
}

class ExpenseLabel extends StatelessWidget {
  final Expense _expense;
  const ExpenseLabel({super.key, required this._expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AppText(
                    text: _expense.name,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                CategoryLabel(category: _expense.category),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AppText(
                text: "-${_expense.expense}€",
                fontSize: 50,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
