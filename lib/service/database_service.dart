import 'dart:developer' show log;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:simple_expense_tracker/constants/pre_defined_categories.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/models/expense_model.dart';
import 'package:simple_expense_tracker/service/database_exceptions.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

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
    //deleteDatabase(databasePath);
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
CREATE TABLE $_expenseTableName(
      $_expenseIdColoumnName INTEGER PRIMARY KEY AUTOINCREMENT,
      $_expenseColoumnName REAL NOT NULL,
      $_expenseNameColoumnName TEXT NOT NULL,
      $_dateColoumnName TEXT NOT NULL,
      $_expenseCategoryIdColoumnName INT);''');
        db.execute('''CREATE TABLE $_categoryTableName(
      $_categoryIdColoumnName INTEGER PRIMARY KEY AUTOINCREMENT,
      $_categoryNameColoumnName TEXT NOT NULL,
      $_alphaColoumnName INTEGER NOT NULL,
      $_redColoumnName INTEGER NOT NULL,
      $_greenColoumnName INTEGER NOT NULL,
      $_blueColoumnName INTEGER NOT NULL);
      ''');

        insertPreDefinedCategories(db);
      },
    );

    return database;
  }

  void insertPreDefinedCategories(Database db) async {
    for (Category category in preDefinedCategories) {
      int newId = await db.insert(_categoryTableName, {
        _categoryNameColoumnName: category.name,
        _alphaColoumnName: category.color.alpha,
        _redColoumnName: category.color.red,
        _greenColoumnName: category.color.green,
        _blueColoumnName: category.color.blue,
      });
      category.id = newId;
    }
  }

  Future<int> addNewExpense(Expense expense) async {
    final Database db = await database;
    int? newId = await db.insert(_expenseTableName, {
      _expenseColoumnName: expense.expense,
      _expenseNameColoumnName: expense.name,
      _dateColoumnName: expense.date.toString(),
      _expenseCategoryIdColoumnName: expense.categoryId,
    });
    return newId;
  }

  Future<int> addNewCategory(Category category) async {
    Database db = await database;

    int? newId = await db.insert(_categoryTableName, {
      _categoryNameColoumnName: category.name,
      _alphaColoumnName: category.color.alpha,
      _redColoumnName: category.color.red,
      _greenColoumnName: category.color.green,
      _blueColoumnName: category.color.blue,
    });
    return newId;
  }

  Future<Expense> getExpense(int id) async {
    final Database db = await database;
    final data = await db.query(
      _expenseTableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    if (data.isEmpty) throw IdNotFoundDatabaseException();

    Expense expense = data
        .map(
          (e) => Expense(
            id: e["id"] as int,
            name: e["name"] as String,
            date: DateTime.parse(e["date"] as String),
            expense: e["expense"] as double,
            categoryId: e[_expenseCategoryIdColoumnName] as int,
          ),
        )
        .first;

    return expense;
  }

  Future<Category> getCategory(int id) async {
    final Database db = await database;
    final data = await db.query(
      _categoryTableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    if (data.isNotEmpty) {
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

  Future<List<Category>> getAllCategories() async {
    final Database db = await database;
    final data = await db.query(
      _categoryTableName,
    );
    if (data.isNotEmpty) {
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
      return category.toList();
    } else {
      throw IdNotFoundDatabaseException();
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    final Database db = await database;
    final data = await db.rawQuery('''
      SELECT * FROM $_expenseTableName
      ''');
    if (data.isEmpty) throw IdNotFoundDatabaseException();

    final expenses = data.map(
      (e) => Expense(
        id: e["id"] as int,
        name: e["name"] as String,
        date: DateTime.parse(e["date"] as String),
        expense: e["expense"] as double,
        categoryId: e[_expenseCategoryIdColoumnName] as int,
      ),
    );

    return expenses.toList();
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
