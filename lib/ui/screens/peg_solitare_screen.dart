import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/enums/cell_type.dart';
import '../../models/board_position.dart';
import '../../viewmodels/peg_solitaire_view_model.dart'; 
import '../../services/shake_detector_service.dart';
import 'rules_screen.dart';
import '../widgets/peg_cell.dart';

class PegSolitaireScreen extends StatefulWidget {
  const PegSolitaireScreen({super.key});

  @override
  State<PegSolitaireScreen> createState() => _PegSolitaireScreenState();
}

class _PegSolitaireScreenState extends State<PegSolitaireScreen>{
  
  static final Logger _logger = Logger();
  ShakeDetectorService? _shakeDetector;
  double _currentSensitivity = 7.0;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetectorService(
      onShake: _handleShakeEvent,
      shakeThreshold: _currentSensitivity,
    );
    _shakeDetector?.startListening();
  }

  void _handleShakeEvent(){
    final vm = context.read<PegSolitaireViewModel>();
    if (vm.isGameOver){
      
    _logger.i("Se sacudió el dispositivo: Reiniciando tablero");
    vm.initializeBoard();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tablero reiniciado'),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 0, 17, 130),
      ),
    );
    }
    else{
      _logger.d("Se sacudió el dispositivo: Juego en curso - No se puede reiniciar el tablero");
    }
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  Widget _gameBoard(BuildContext context, PegSolitaireViewModel vm) { 
    _logger.i("Construyendo el tablero de juego"); 
    return Center( 
      child: Padding( 
        padding: const EdgeInsets.all(8.0), 
        child: AspectRatio( 
          aspectRatio: 1.0, 
          child: GridView.builder( 
            physics: const NeverScrollableScrollPhysics(), 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
              crossAxisCount: PegSolitaireViewModel.gridSize, 
              crossAxisSpacing: 2.0, 
              mainAxisSpacing: 2.0, 
            ), 
            itemCount: PegSolitaireViewModel.gridSize * PegSolitaireViewModel.gridSize, 
            itemBuilder: (context, index) { 
              final int row = index ~/ PegSolitaireViewModel.gridSize; 
              final int col = index % PegSolitaireViewModel.gridSize; 
              final position = BoardPosition(row, col); 
              final CellType type = vm.getCellType(row, col); 
              
              final validDestinations = vm.getValidDestinations();
              final isValidDestination = validDestinations.any((p) => p.row == row && p.col == col);

              return PegCell( 
                position: position, 
                type: type, 
                isSelected: vm.selectedPosition == position, 
                isValidDestination: isValidDestination, 
                onTap: () => context.read<PegSolitaireViewModel>().onCellTapped(position),
              ); 
            }, 
          ), 
        ), 
      ), 
    ); 
  } 

  Widget _buildGameOverBanner(BuildContext context, PegSolitaireViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: vm.isVictory ? const Color.fromARGB(255, 0, 17, 130) : const Color.fromARGB(255, 23, 0, 74),
      child: Column(
        children: [
          Text(
            vm.isVictory ? '¡VICTORIA!' : '¡FIN DEL JUEGO!',
            style: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              color: Color.fromARGB(255, 188, 228, 244),
              fontFamily: 'MatchaCih',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vm.isVictory 
              ? 'Partida finalizada con ${vm.moveCount} movimientos.' 
              : 'No quedán saltos válidos.',
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 188, 228, 244)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 17, 130),
              foregroundColor: const Color.fromARGB(255, 188, 228, 244),
            ),
            icon: const Icon(Icons.share),
            label: const Text(
              'Compartir resultado',
              style: TextStyle(fontFamily: 'MatchaCih', color: Color.fromARGB(255, 188, 228, 244)),
            ),
            onPressed: () async {
              final String message = "Termine una partida de Peg Solitaire en ${vm.moveCount} movimientos dejando ${vm.remainingPegs} piezas en el tablero";
              await SharePlus.instance.share( ShareParams(text:message));
            },
          )
        ],
      ),
    );
  }

  @override 
  Widget build(BuildContext context) { 
    final vm = context.watch<PegSolitaireViewModel>(); 

    return Scaffold( 
      appBar: AppBar(
        title: const Text('Solitario'),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 188, 228, 244)),
        actions: [
          PopupMenuButton<double>(
            icon: const Icon(Icons.vibration, color: Color.fromARGB(255, 188, 228, 244)),
            tooltip: 'Sensibilidad de agitación',
            onSelected: (double newTreshold){
              setState((){
                _currentSensitivity = newTreshold;
                _shakeDetector?.shakeThreshold = newTreshold;
              });
              String label = newTreshold == 3.0
                ?'Suave (3.0)'
                :(newTreshold == 7.0 ? 'Media (7.0)' : 'Fuerte (13.0)');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sensibilidad ajustada a: $label'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color.fromARGB(255, 0, 17, 130),
                ),
              );
            },
            itemBuilder: (context) => <PopupMenuEntry<double>>[
              const PopupMenuItem<double>(
                value: 3.0,
                child: Text('Suave (3.0)'),
              ),
              const PopupMenuItem<double>(
                value: 7.0,
                child: Text('Media (7.0)'),
              ),
              const PopupMenuItem<double>(
                value: 13.0,
                child: Text('Fuerte (13.0)'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.undo, color: vm.canUndo ? Color.fromARGB(255, 188, 228, 244) : Color.fromARGB(255, 119, 123, 182)),
            tooltip: 'Deshacer movimiento',
            onPressed: vm.canUndo ? () => context.read<PegSolitaireViewModel>().undoMove() : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color.fromARGB(255, 188, 228, 244)),
            tooltip: 'Reiniciar Tablero',
            onPressed: () => context.read<PegSolitaireViewModel>().initializeBoard(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color.fromARGB(255, 188, 228, 244)),
            tooltip: 'Reglas del juego',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RulesScreen()),
              );
            },
          ),
        ],
      ), 
      body: SafeArea( 
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Fondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [ 
              Container( 
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                color: const Color.fromARGB(134, 11, 0, 20), 
                child: Center( 
                  child: Text('STATUS: En juego | Movimientos: ${vm.moveCount} | Piezas restantes: ${vm.remainingPegs}', 
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'MatchaCih',
                      color: Color.fromARGB(255, 188, 228, 244),
                    ), 
                  ), 
                ), 
              ), 
              const Divider(height: 1), 
              Expanded( 
                child: _gameBoard(context, vm), 
              ), 
              if (vm.isGameOver) _buildGameOverBanner(context, vm),
            ], 
          ),
        ), 
      ), 
    ); 
  } 
}