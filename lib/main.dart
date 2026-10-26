import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'ui/screens/peg_solitare_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/history_screen.dart';
import 'viewmodels/peg_solitaire_view_model.dart';
import '../services/preferences_services.dart';


final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsService = await PreferencesService.create();
  
  logger.i('--- INICIO PRUEBA DE PREFERENCIAS ---');
  logger.i('1. Valor inicial de sonido: ${prefsService.isSoundEnabled}');
  
  await prefsService.setSoundEnabled(false);
  logger.i('2. Valor tras setSoundEnabled(false): ${prefsService.isSoundEnabled}');
  
  await prefsService.setSoundEnabled(true);
  logger.i('3. Valor reestablecido: ${prefsService.isSoundEnabled}');
  logger.i('--- FIN PRUEBA DE PREFERENCIAS ---');

  runApp(const MyApp());
}

/*
void main() {
  logger.i("Logger funcionando");
  runApp(const MyApp());
}
*/
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
       '/about': (context) => const RulesScreen(),
       '/game': (context) => ChangeNotifierProvider<PegSolitaireViewModel>(
        create: (_) => PegSolitaireViewModel(),
        child: const PegSolitaireScreen(),
       ), 
       '/history': (context) => const HistoryScreen(),
       '/rules': (context) => const RulesScreen(), 
     },
    );
  }
}