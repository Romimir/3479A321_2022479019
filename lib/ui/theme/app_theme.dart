import 'package:flutter/material.dart'; 
 
class app_theme { 
  static const Color primarySeed = Color.fromARGB(255, 100, 14, 96); // Un color de ejemplo. 
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
      scaffoldBackgroundColor: const Color(0xFFF5F2EB), 
      appBarTheme: const AppBarTheme( 
        centerTitle: true, 
        elevation: 0,         backgroundColor: primarySeed, 
        foregroundColor: Colors.white, 
        titleTextStyle: TextStyle( 
          fontSize: 20, 
          fontWeight: FontWeight.bold, //SUMAREMOS nuestra fuente en la siguiente línea. 
          letterSpacing: 1.1, 
        ), 
      ), 
    ); 
  } 
} 