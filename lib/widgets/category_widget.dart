import 'package:flutter/material.dart';
import 'package:simple_expense_tracker/models/category_model.dart';
import 'package:simple_expense_tracker/widgets/app_text_widget.dart';

class CategoryLabel extends StatelessWidget {
  final Category _category;
  const CategoryLabel({super.key, required this._category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _category.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 12),
        child: AppText(
          text: _category.name,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
