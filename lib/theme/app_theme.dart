import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF141b2d),
    scaffoldBackgroundColor: const Color(0xFF141b2d),
    cardColor: const Color(0xFF1F2A40),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F2A40),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFe0e0e0),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: Color(0xFFe0e0e0)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFc2c2c2)),
      bodyMedium: TextStyle(color: Color(0xFF858585)),
      titleLarge: TextStyle(
          color: Color(0xFFe0e0e0), fontWeight: FontWeight.bold, fontSize: 20),
      titleMedium: TextStyle(
          color: Color(0xFFe0e0e0), fontWeight: FontWeight.w600, fontSize: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF4cceac),
      foregroundColor: Color(0xFF141b2d),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFe0e0e0),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFF4cceac),
      secondary: const Color(0xFF868dfb),
      surface: const Color(0xFF141b2d), // Was 'background'
    ),
  );
}
