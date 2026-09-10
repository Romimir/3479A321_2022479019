import 'package:flutter/material.dart';
import '../../core/enums/cell_type.dart';
import '../widgets/peg_cell.dart';
import 'rules_screen.dart';
import 'package:logger/logger.dart';
import '../../models/game_record.dart';

class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({Key? key}) : super(key: key);

  static const int gridSize = 7;
  static const int totalCells = gridSize * gridSize; //49 casillas

  // Determina el tipo de celda según sus coordenadas matriciales (row, col) 
  CellType _getCellType(int row, int col) { 
    // Esquinas 2x2 no jugables en el tablero inglés estándar 
    final bool isCorner = (row < 2 || row > 4) && (col < 2 || col > 4); 
    if (isCorner) { 
      return CellType.voidCell; 
    } 
    return CellType.occupiedPeg; // El resto de posiciones inician ocupadas
  }

  Widget _gameBoard() { 
   return Center( 
      child: Padding( 
        padding: const EdgeInsets.all(8.0), 
        child: AspectRatio( 
          aspectRatio: 1.0, // Cuadrado perfecto 
          child: GridView.builder( 
            physics: const NeverScrollableScrollPhysics(), // Bloquea el scroll 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
              crossAxisCount: 7, // 7 columnas 
              crossAxisSpacing: 2.0, 
              mainAxisSpacing: 2.0, 
            ), 
           itemCount: 49, // 7x7 = 49 celdas 
            
           itemBuilder: (context, index) { 
            // Convertir el índice en coordenadas matriciales 
            final int row = index ~/ gridSize; 
            final int col = index % gridSize; 
            final CellType cellType = _getCellType(row, col); 
            
            return PegCell(
              row: row, 
              col: col, 
              type: cellType,
              isSelected: false,
              onTap: () {
              },
            );
          },  
         ), 
        ), 
      ), 
   ); 
  } 

  @override 
  Widget build(BuildContext context) { 

  final Logger logger = Logger();
  final GameRecord lastGameRecord = GameRecord(
    id: 'REC-001',
    date: DateTime.now(),
    remainingPegs: 2,
    totalMoves: 25,
    durationSeconds: 120,
    isVictory: true,
  );

  logger.i("Último registro de juego: Piezas restantes ${lastGameRecord.remainingPegs} | ${lastGameRecord.durationSeconds} segundos jugados");

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
      body: SafeArea( // Protege la UI de los bordes del dispositivo 
         child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Fondo.jpg'),
              fit: BoxFit.cover,
              ),
          ),
          child: Column(
            children: [ 
             // Área de Status 
             Container( 
               height: 60, 
               color: const Color.fromARGB(255, 38, 10, 62), 
               child: const Center( 
                 child: Text('STATUS: 349 segundos | Piezas restantes: 33', 
                   style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize:14,
                    fontFamily: 'MatchaCih',
                    color: Color.fromARGB(255, 227, 218, 242),
                   ), 
                 ), 
               ), 
             ), 
             const Divider(height: 1), 
             // Área de Juego 
             Expanded( // Expande el tablero para llenar la pantalla 
               child: _gameBoard(), 
             ), 
           ], 
          ),
        ), 
      ), 
    ); 
  } 
}