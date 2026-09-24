import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/service/database_service.dart';
import 'package:simple_expense_tracker/widgets/app_text_widget.dart';
import 'package:sqflite/sqflite.dart';

class NewExpenseView extends StatefulWidget {
  const new({super.key});

  @override
  State<NewExpenseView> createState() => _NewExpenseViewState();
}

class _NewExpenseViewState extends State<NewExpenseView> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Category>? _categories;

  String? _name;
  double? _expense;
  String? _stringDate;

  bool _isSynced = false;

  int _selectedIndex = -1;
  final double _labelDefaultPadding = 2;
  final double _labelSelectedPadding = 4;

  void callBackName(String? newName) => _name = newName;
  void callBackExpense(String? newExpense) =>
      _expense = double.tryParse(newExpense!);
  void callBackdate(String? newdate) => _stringDate = newdate;

  Future<void> syncAllCategoriesWithDb() async {
    List<Category> cats = await _databaseService.getAllCategories();
    if (_categories == null || cats != _categories) {
      setState(() {
        _categories = cats;
        _isSynced = true;
      });
    }
  }

  @override
  void initState() {
    syncAllCategoriesWithDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSynced) return CircularProgressIndicator();
    syncAllCategoriesWithDb();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.directional(top: 20, start: 0),
              child: AppText(
                text: "Name",
                fontSize: 30,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: scheme.primaryContainer,
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Center(
                    child: TextField(
                      onChanged: (value) => callBackName(value),
                      minLines: 1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AppText(
              text: "Expense",
              fontSize: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputField(
                  callBack: callBackExpense,
                  height: 110,
                  width: 180,
                  textFieldPadding: EdgeInsetsGeometry.all(10),
                  containerColor: scheme.onSecondaryContainer,
                  fontColor: scheme.onSecondary,
                  fontSize: 50,
                ),
                Icon(
                  Icons.euro,
                  size: 100,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.directional(top: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Date:",
                    fontSize: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputField(
                      callBack: callBackdate,
                      height: 50,
                      width: 180,
                      textFieldPadding: EdgeInsetsGeometry.all(6),
                      containerColor: scheme.onPrimaryContainer,
                      fontColor: scheme.onTertiary,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            AppText(
              text: "Category:",
              fontSize: 40,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categories!.map((Category category) {
                final isSelected = (_selectedIndex == category.id);
                return ChoiceChip(
                  showCheckmark: false,
                  backgroundColor: category.color,
                  selectedColor: category.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  label: AnimatedPadding(
                    padding: EdgeInsets.all(
                      isSelected ? _labelSelectedPadding : _labelDefaultPadding,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: AppText(
                      text: category.name,
                      color: Colors.white,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool isSelected) {
                    setState(() {
                      _selectedIndex = category.id;
                    });
                  },
                );
              }).toList(),
            ),

            ElevatedButton(
              onPressed: addElement,
              style: ButtonStyle(),
              child: AppText(text: "ADD"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addElement() async {
    final expense = await parseToExpense();
    if (expense != null) {
      int newId = await _databaseService.addNewExpense(expense);
      log("expnese info from database: ");
      final newExpense = await _databaseService.getExpense(newId);
      log(newExpense.toString());
    }
  }

  Future<Expense?> parseToExpense() async {
    DateTime? date = convertStringToDate(_stringDate!);
    String errorText = "";
    if (date == null) {
      errorText = "The date is not in the right format or is empty";
    }
    if (_selectedIndex == -1) errorText = "No category was selected";
    if (_name == "") errorText = "No name was given";
    if (_expense == null) errorText = "No expnese was given";

    if (errorText != "") {
      showErrorDialog(errorText);
      return null;
    } else {
      return Expense(
        id: -1,
        name: _name!,
        date: date!,
        expense: _expense!,
        categoryId: _categories![_selectedIndex].id,
      );
    }
  }

  Future<dynamic> showErrorDialog(String data) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: AppText(text: "Error")),
        content: AppText(text: data),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(text: "OK"),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? convertStringToDate(String stringDate) {
    DateTime? date;
    date = DateTime.tryParse(stringDate);
    return date;
  }
}

class InputField extends StatefulWidget {
  final double height;
  final Function callBack;
  final double? width;
  final Color? containerColor;
  final Color? fontColor;
  final double? fontSize;
  final bool? multiLine;
  final EdgeInsetsGeometry textFieldPadding;

  const InputField({
    super.key,
    required this.height,
    required this.callBack,
    this.width,
    this.containerColor,
    required this.textFieldPadding,
    this.fontColor,
    this.fontSize,
    this.multiLine,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: widget.containerColor,
      ),
      child: Padding(
        padding: widget.textFieldPadding,
        child: Center(
          child: TextField(
            onChanged: (value) => widget.callBack(value),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.fontColor,
              fontSize: widget.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
