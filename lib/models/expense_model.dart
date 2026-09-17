import 'package:simple_expense_tracker/models/category_model.dart';

class Expense {
  final int id;
  final String name;
  final DateTime date;
  final double expense;
  final Category category;

  new({
    required this.id,
    required this.name,
    required this.date,
    required this.expense,
    required this.category,
  });
}
