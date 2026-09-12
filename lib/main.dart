import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'ui/screens/peg_solitare_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';

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
      theme: AppTheme.lightTheme,
      initialRoute: '/', 
     routes: { 
       '/': (context) => const MenuScreen(), 
       '/game': (context) => PegSolitaireScreen(), 
       '/rules': (context) => const RulesScreen(), 
     },
    );
  }
}