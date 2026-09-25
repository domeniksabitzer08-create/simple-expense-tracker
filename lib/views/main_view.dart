import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/service/database_service.dart';
import 'package:simple_expense_tracker/views/loading_view.dart';
import 'package:simple_expense_tracker/views/new_expense_view.dart';
import 'package:simple_expense_tracker/views/sort_by_category_view.dart';
import 'package:simple_expense_tracker/widgets/app_text_widget.dart';

class MainView extends StatefulWidget {
  const new({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final _databaseService = DatabaseService.instance;
  List<Expense>? _expenses;
  @override
  Widget build(BuildContext context) {
    final pages = [
      MainListView(expenses: _expenses),
      SortByCategoryView(),
      NewExpenseView(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: pages[_selectedIndex],
    );
  }

  @override
  void initState() {
    setExpenses();
    super.initState();
  }

  void setExpenses() async {
    _expenses = await _databaseService.getAllExpenses();
    log("got expneses: ${_expenses!.first}");
  }
}

class MainListView extends StatefulWidget {
  const new({
    super.key,
    required this.expenses,
  });

  final List<Expense>? expenses;

  @override
  State<MainListView> createState() => _MainListViewState();
}

class _MainListViewState extends State<MainListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.expenses == null) return LoadingView();
    List<dynamic> uiList = createList(widget.expenses!);
    return ListView.builder(
      itemCount: uiList.length,
      itemBuilder: (BuildContext context, int index) {
        final element = uiList[index];
        if (element is Expense) return ExpenseLabel(expense: element);
        return DateLabel(date: element);
      },
    );
  }

  List<dynamic> createList(List<dynamic> expenes) {
    List<DateTime> dates = [];
    List list = [];

    for (int i = 0; i < expenes.length; i++) {
      Expense exp = expenes[i];
      if (!dates.contains(exp.date)) {
        list.insert(list.length, exp.date);
        dates.add(exp.date);
      }
      list.insert(list.length, exp);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                      fontSize: 26,
                    ),
                  ),
                  //CategoryLabel(category: _expense.categoryId!),
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
      ),
    );
  }
}
