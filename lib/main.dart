import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'ui/screens/peg_solitare_screen.dart';
import 'ui/theme/app_theme.dart';

final logger = Logger();

void main() {
  logger.i("Logger funcionando");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Ingles',
      theme: app_theme.lightTheme,
      home: const PegSolitaireScreen(), // Apuntamos a nuestra nueva pantalla
    );
  }
}