import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String _text;
  final double? _fontSize;
  final Color? _color;
  final FontWeight? _fontWeight;

  const AppText({
    super.key,
    required this._text,
    this._fontSize,
    this._color,
    this._fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: _fontSize,
        color: _color,
        fontWeight: _fontWeight,
      ),
    );
  }
}
