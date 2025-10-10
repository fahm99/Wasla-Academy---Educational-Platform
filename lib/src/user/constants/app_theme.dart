import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الأساسية
  static const Color darkBlue = Color(0xFF0C1445);
  static const Color yellow = Color(0xFFF9D71C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF757575);
  static const Color green = Color(0xFF4CAF50);
  static const Color red = Color(0xFFF44336);
  static const Color blue = Color(0xFF2196F3);

  // Backward compatibility aliases
  static const Color primaryColor = darkBlue;
  static const Color accentColor = yellow;
  static const Color goldColor = yellow;
  static const Color successColor = green;
  static const Color warningColor = yellow;
  static const Color errorColor = red;
  static const Color backgroundColor = white;
  static const Color surfaceColor = white;
  static const Color cardColor = lightGray;
  static const Color textPrimaryColor = darkBlue;
  static const Color textSecondaryColor = darkGray;

  static ThemeData get theme {
    return ThemeData(
      primaryColor: darkBlue,
      scaffoldBackgroundColor: white,
      fontFamily: 'Segoe UI',
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: darkBlue,
        elevation: 2,
        shadowColor: Colors.black12,
        titleTextStyle: TextStyle(
          color: darkBlue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      // البطاقات
      cardTheme: CardTheme(
        color: white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: darkBlue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBlue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        labelStyle: const TextStyle(
          color: darkGray,
          fontWeight: FontWeight.w600,
        ),
      ),

      // النصوص
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkBlue,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkBlue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: darkBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: darkGray,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: darkGray,
          fontSize: 12,
        ),
      ),

      // الشريط السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: yellow,
        unselectedItemColor: darkGray,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: darkBlue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'Segoe UI',
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: yellow,
        elevation: 2,
        shadowColor: Colors.black12,
        titleTextStyle: TextStyle(
          color: yellow,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      // البطاقات
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: darkBlue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: yellow, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
        fillColor: const Color(0xFF2D2D2D),
        filled: true,
      ),

      // النصوص
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: yellow,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: yellow,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: yellow,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white60,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),

      // الشريط السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: yellow,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      // الأيقونات
      iconTheme: const IconThemeData(
        color: yellow,
      ),
    );
  }

  // أنماط مخصصة للبطاقات الإحصائية
  static BoxDecoration statCardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // أنماط الحالات
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
      case 'approved':
        return green;
      case 'draft':
        return Colors.orange;
      case 'pending':
        return blue;
      case 'rejected':
        return red;
      default:
        return darkGray;
    }
  }

  static Color getStatusBackgroundColor(String status) {
    return getStatusColor(status).withOpacity(0.1);
  }
}
