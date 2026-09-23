import 'package:simple_expense_tracker/models/category_model.dart';

class Expense {
  int id;
  final String name;
  final DateTime date;
  final double expense;
  final int categoryId;

  new({
    required this.id,
    required this.name,
    required this.date,
    required this.expense,
    required this.categoryId,
  });

  @override
  String toString() {
    return "id: $id | name: $name | date: $date | exepense: $expense | category: $categoryId";
  }
}
