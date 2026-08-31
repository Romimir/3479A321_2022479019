import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  logger.i("Logger funcionando");
  runApp(const MyApp());
}

enum CellType {
  voidCell,   //Fuera de limites jugables (esquinas 2x2)
  emptyHole,  //Casilla jugable desocupada
  occupiedPeg, //Casilla jugable con clavija presente
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Ingles',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PegSolitaireScreen(), // Apuntamos a nuestra nueva pantalla
    );
  }
}

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

  @override 

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

  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text('Solitario')), 
      body: SafeArea( // Protege la UI de los bordes del dispositivo 
         child: Column( // Apila el marcador arriba y el tablero abajo 
           children: [ 
             // Área de Status 
             Container( 
               height: 60, 
               color: Colors.grey[300], 
               child: const Center( 
                 child: Text('STATUS: 349 segundos | Piezas restantes: 33', 
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
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
    ); 
  } 
}

class PegCell extends StatelessWidget {
  final int row; 
  final int col; 
  final CellType type; 
  final bool isSelected; 
  final VoidCallback? onTap; 
 
  const PegCell({ 
    super.key, 
    required this.row, 
    required this.col, 
    required this.type, 
    this.isSelected = false, 
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Container( 
      decoration: BoxDecoration( 
        color: Colors.grey[400], 
        border: Border.all(color: Colors.grey[600]!, width: 1.5), 
      ), 
      child: Center( 
        child: type == CellType.occupiedPeg 
            ? Container( 
                width: 30, 
                height: 30, 
                decoration: const BoxDecoration( 
                  color: Colors.blue, 
                  shape: BoxShape.circle, 
                ), 
              ) 
            : type == CellType.emptyHole 
                ? Container( 
                    width: 30, 
                    height: 30, 
                    decoration: const BoxDecoration( 
                      color: Colors.white, 
                      shape: BoxShape.circle, 
                    ), 
                  ) 
                : null, // No dibuja nada para voidCell 
      ), 
    );
  }
}


