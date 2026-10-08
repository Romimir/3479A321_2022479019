import 'package:flutter/material.dart'; 
 
class AppTheme { 
  static const Color primarySeed = Color.fromARGB(255, 12, 31, 77);
  static const Color boardBaseColor = Color.fromARGB(255, 69, 0, 103); 
  static const Color emptyHoleColor = Color.fromARGB(255, 77, 42, 112); 
  static const Color globalTextColor = Color.fromARGB(255, 188, 228, 244);

  static ThemeData get lightTheme { 
    return ThemeData( 
      useMaterial3: true, 
      fontFamily: 'MatchaCih',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: globalTextColor),
        bodyLarge: TextStyle(color: globalTextColor),
        titleLarge: TextStyle(color: globalTextColor),
      ),
      colorScheme: ColorScheme.fromSeed( 
        seedColor: primarySeed, 
        brightness: Brightness.light, 
        surfaceContainerHighest: const Color.fromARGB(255, 30, 4, 62), 
      ), 
      scaffoldBackgroundColor: const Color.fromARGB(255, 30, 4, 62), 
      appBarTheme: const AppBarTheme( 
        centerTitle: true, 
        elevation: 0,         backgroundColor: primarySeed, 
        foregroundColor:  Color.fromARGB(255, 30, 4, 62), 
        titleTextStyle: TextStyle( 
          fontSize: 20, 
          fontWeight: FontWeight.normal,
          fontFamily: 'MatchaCih',
          letterSpacing: 1.1, 
        ), 
      ), 
    ); 
  } 
} 