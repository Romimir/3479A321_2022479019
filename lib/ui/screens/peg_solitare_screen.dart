import 'package:flutter/material.dart';
import '../../core/enums/cell_type.dart';
import '../widgets/peg_cell.dart';
import 'rules_screen.dart';
import 'package:logger/logger.dart';
import '../../models/game_record.dart';

class PegSolitaireScreen extends StatefulWidget {
  const PegSolitaireScreen({super.key});

  @override
  State<PegSolitaireScreen> createState() => _PegSolitaireScreenState();
}

class _PegSolitaireScreenState extends State<PegSolitaireScreen> {
  final Logger _logger = Logger();
  
  int? rowSelected;
  int? colSelected;

  static const int gridSize = 7;
  static const int totalCells = gridSize * gridSize;

  CellType _getCellType(int row, int col) { 
    final bool isCorner = (row < 2 || row > 4) && (col < 2 || col > 4); 
    if (isCorner) { 
      return CellType.voidCell; 
    } 
    return CellType.occupiedPeg; 
  }

void _handleCellTapped(int row, int col, CellType type) {
  if (type == CellType.voidCell) return;

  setState(() {
    if (rowSelected == null) {
      if (type == CellType.occupiedPeg) {
        rowSelected = row;
        colSelected = col;
        _logger.d('Se selecciono la celda: $row, $col');
      }
    } else {
      if (rowSelected == row && colSelected == col) {
        _logger.d('Se desselecciono la celda: $rowSelected, $colSelected');
        rowSelected = null;
        colSelected = null;
      } else {
        _logger.d('Moviendo ($rowSelected, $colSelected) hacia ($row, $col)');
        rowSelected = null;
        colSelected = null;
      }
    }
  });
}

  Widget _gameBoard() { 
    return Center( 
      child: Padding( 
        padding: const EdgeInsets.all(8.0), 
        child: AspectRatio( 
          aspectRatio: 1.0, 
          child: GridView.builder( 
            physics: const NeverScrollableScrollPhysics(), 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
              crossAxisCount: 7, 
              crossAxisSpacing: 2.0, 
              mainAxisSpacing: 2.0, 
            ), 
            itemCount: totalCells, 
            itemBuilder: (context, index) { 
              final int row = index ~/ gridSize; 
              final int col = index % gridSize; 
              final CellType cellType = _getCellType(row, col); 
              
              final bool isSelected = (rowSelected == row && colSelected == col);

              return PegCell(
                row: row, 
                col: col, 
                type: cellType,
                isSelected: isSelected, 
                onTap: () => _handleCellTapped(row, col, cellType), 
              );
            },  
          ), 
        ), 
      ), 
    ); 
  } 

  @override 
  Widget build(BuildContext context) { 
    final GameRecord lastGameRecord = GameRecord(
      id: 'REC-001',
      date: DateTime.now(),
      remainingPegs: 2,
      totalMoves: 25,
      durationSeconds: 120,
      isVictory: true,
    );

    _logger.i("Último registro de juego: Piezas restantes ${lastGameRecord.remainingPegs} | ${lastGameRecord.durationSeconds} segundos jugados");

    return Scaffold( 
      appBar: AppBar(
        title: const Text('Solitario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
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
                height: 60, 
                color: const Color.fromARGB(255, 38, 10, 62), 
                child: const Center( 
                  child: Text('STATUS: 349 segundos | Piezas restantes: 33', 
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      fontFamily: 'MatchaCih',
                      color: Color.fromARGB(255, 227, 218, 242),
                    ), 
                  ), 
                ), 
              ), 
              const Divider(height: 1), 
              Expanded( 
                child: _gameBoard(), 
              ), 
            ], 
          ),
        ), 
      ), 
    ); 
  } 
}