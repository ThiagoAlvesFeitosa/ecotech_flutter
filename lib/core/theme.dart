// theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
// Cores personalizadas para reutilizar em vários lugares
class AppColors {
  static const Color primaryGreen = Color(0xFF4CAF50); // verde principal
  static const Color lightGreen = Color(0xFFC8E6C9);   // verde claro
  static const Color darkGreen = Color(0xFF388E3C);    // verde escuro
}