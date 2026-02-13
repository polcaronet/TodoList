import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  Color get primaryColor =>
      Theme.of(this).primaryColor;
  Color get primaryColorLight =>
      Theme.of(this).primaryColorLight;
  Color get buttonColor =>
      Theme.of(this).colorScheme.primary;

  TextStyle get titleStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}
