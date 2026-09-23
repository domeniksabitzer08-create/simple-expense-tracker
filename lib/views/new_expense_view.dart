import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/service/database_service.dart';
import 'package:simple_expense_tracker/widgets/app_text_widget.dart';

class NewExpenseView extends StatefulWidget {
  const new({super.key});

  @override
  State<NewExpenseView> createState() => _NewExpenseViewState();
}

class _NewExpenseViewState extends State<NewExpenseView> {
  @override
  Widget build(BuildContext context) {
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
    final Category category = Category(
      id: -1,
      name: "Food",
      color: const Color.fromARGB(255, 126, 115, 7),
    );

    final expense = Expense(
      id: -1,
      name: "Mc Donalds",
      date: DateTime(2026, 9, 11),
      expense: 7.50,
      categoryId: 0,
    );
    final DatabaseService databaseService = DatabaseService();
    print("making query");
    int newCatId = await databaseService.addNewCategory(category);
    category.id = newCatId;
    int newExpId = await databaseService.addNewExpense(expense);
    expense.id = newExpId;
    final expense2 = await databaseService.getExpense(newExpId);

    print("result:");
    print(expense2.toString());
  }
}

class InputField extends StatefulWidget {
  final double height;
  final double? width;
  final Color? containerColor;
  final Color? fontColor;
  final double? fontSize;
  final bool? multiLine;
  final EdgeInsetsGeometry textFieldPadding;

  const InputField({
    super.key,
    required this.height,
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
