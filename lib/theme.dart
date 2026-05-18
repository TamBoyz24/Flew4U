import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF0072FF);

  static ThemeData light = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        minimumSize: const Size(double.infinity, 55),
      ),
    ),
  );
}