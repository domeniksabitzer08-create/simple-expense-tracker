import 'dart:ui';

import 'package:path/path.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/service/database_exceptions.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE $_categoryTableName
      $_categoryIdColoumnName INT PRIMARY KEY,
      $_categoryNameColoumnName TEXT NOT NULL,
      $_alphaColoumnName INT NOT NULL
      $_redColoumnName INT NOT NULL
      $_greenColoumnName INT NOT NULL
      $_blueColoumnName INT NOT NULL

      CREATE TABLE $_expenseTableName
      $_expenseIdColoumnName INT PRIMARY KEY,
      $_expenseColoumnName REAL NOT NULL,
      $_expenseNameColoumnName TEXT NOT NULL,
      $_dateColoumnName TEXT NOT NULL,
      $_expenseCategoryIdColoumnName INT
      ''');
      },
    );

    return database;
  }

  Future<int> addNewExpense(Expense expense) async {
    final Database db = await database;
    int? newId = await db.insert(_expenseTableName, {
      _expenseColoumnName: expense.expense,
      _expenseNameColoumnName: expense.name,
      _dateColoumnName: expense.name,
      _expenseCategoryIdColoumnName: expense.category.id,
    });
    return newId;
  }

  Future<int> addNewCategory(Category category) async {
    final Database db = await database;
    int? newId = await db.insert(_categoryTableName, {
      _categoryNameColoumnName: category.name,
      _colorColoumnName: category.color,
    });
    return newId;
  }

  Future<Expense> getExpense(int id) async {
    final Database db = await database;
    final data = await db.query(
      _expenseTableName,
      where: "id = ?",
      whereArgs: [id],
    );

    final Category category = 

    Expense expense = data.map(
      (e) async{
        return Expense(
        id: e["id"] as int,
        name: e["name"] as String,
        date:  DateTime.parse(e["date"] as String),
        expense: e["expense"] as double,
        category: await getCategory(e[_expenseCategoryIdColoumnName] as int),
      );
      }
    );
  }

  Future<Category> getCategory(int id) async {
    final Database db = await database;
    final data = await db.query(
      _categoryTableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    if (data.isEmpty) {
      Iterable<Category> category = data.map(
        (e) => Category(
          id: e["id"] as int,
          name: e["name"] as String,
          color: Color.fromARGB(
            e["alpha"] as int,
            e["red"] as int,
            e["green"] as int,
            e["blue"] as int,
          ),
        ),
      );
      return category.first;
    } else {
      throw IdNotFoundDatabaseException();
    }
  }

  final String _categoryTableName = "categories";
  final String _categoryIdColoumnName = "id";
  final String _categoryNameColoumnName = "name";
  final String _alphaColoumnName = "alpha";
  final String _redColoumnName = "red";
  final String _greenColoumnName = "green";
  final String _blueColoumnName = "blue";

  final String _expenseTableName = "expenses";
  final String _expenseIdColoumnName = "id";
  final String _expenseColoumnName = "expense";
  final String _expenseNameColoumnName = "name";
  final String _dateColoumnName = "date";
  final String _expenseCategoryIdColoumnName = "catId";
}
