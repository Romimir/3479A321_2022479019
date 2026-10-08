import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../core/enums/cell_type.dart';
import '../widgets/peg_cell.dart';
import 'rules_screen.dart';
import '../../models/board_position.dart';
import '../../viewmodels/peg_solitaire_view_model.dart'; 

class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({super.key});

  static final Logger _logger = Logger();

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
              
              return PegCell( 
                position: position, 
                type: type, 
                isSelected: vm.selectedPosition == position, 
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
            vm.isVictory ? '¡VICTORIA TÁCTICA!' : '¡FIN DEL JUEGO!',
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
              ? '¡Excelente! Lo lograste en ${vm.moveCount} movimientos.' 
              : 'Te quedaste sin saltos válidos.',
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 188, 228, 244)),
          ),
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