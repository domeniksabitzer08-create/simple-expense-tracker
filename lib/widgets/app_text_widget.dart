import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String _text;
  final double? _fontSize;
  final Color? _color;
  final FontWeight? _fontWeight;
  final TextAlign? _textAlign;

  const AppText({
    super.key,
    required this._text,
    this._fontSize,
    this._color,
    this._fontWeight,
    this._textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      textAlign: _textAlign,
      style: TextStyle(
        fontSize: _fontSize,
        color: _color,
        fontWeight: _fontWeight,
      ),
    );
  }
}
