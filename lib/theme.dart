import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0A1A35),
      colorScheme: const ColorScheme.dark(background: Color(0xFF0A1A35)),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A1A35)));
}
