import 'package:flutter/material.dart'; 
 
class AppTheme { 
  static const Color primarySeed = Color.fromARGB(255, 12, 31, 77); // Un color de ejemplo. 
  static const Color boardBaseColor = Color.fromARGB(255, 42, 13, 56); 
  static const Color emptyHoleColor = Color.fromARGB(255, 77, 42, 112); 
 
  static ThemeData get lightTheme { 
    return ThemeData( 
      useMaterial3: true, 
      colorScheme: ColorScheme.fromSeed( 
        seedColor: primarySeed, 
        brightness: Brightness.light, 
        surfaceContainerHighest: const Color(0xFF160824), 
      ), 
      scaffoldBackgroundColor: const Color.fromARGB(255, 5, 7, 13), 
      appBarTheme: const AppBarTheme( 
        centerTitle: true, 
        elevation: 0,         backgroundColor: primarySeed, 
        foregroundColor: Color.fromARGB(255, 3, 10, 34), 
        titleTextStyle: TextStyle( 
          fontSize: 20, 
          fontWeight: FontWeight.bold, //SUMAREMOS nuestra fuente en la siguiente línea. 
          letterSpacing: 1.1, 
        ), 
      ), 
    ); 
  } 
} 