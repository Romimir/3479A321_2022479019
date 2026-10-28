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
import 'repositories/game_history_repository.dart';
import 'repositories/json_file_history_repository.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesService = await PreferencesService.create();
  final historyRepository = JsonFileHistoryRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<IGameHistoryRepository>.value(value:historyRepository),
        Provider<PreferencesService>.value(value: preferencesService),
      ],
      child: const MyApp(),
      ),
  );
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
       '/about': (context) => const RulesScreen(),
       '/game': (context) => ChangeNotifierProvider<PegSolitaireViewModel>(
        create: (_) => PegSolitaireViewModel(
          historyRepository: context.read<IGameHistoryRepository>(),
          preferencesService: context.read<PreferencesService>(),  
        ),
        child: const PegSolitaireScreen(),
       ), 
       '/history': (context) => const HistoryScreen(),
       '/rules': (context) => const RulesScreen(), 
     },
    );
  }
}