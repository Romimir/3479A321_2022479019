import 'package:flutter/foundation.dart'; 
import 'package:flutter/services.dart';
import '../models/board_position.dart'; 
import '../core/enums/cell_type.dart'; 
import '../services/audio_service.dart';
import '../models/move_record.dart';
import '../models/game_record.dart';
import '../repositories/game_history_repository.dart';
import '../services/preferences_services.dart';
import '../../core/utils/app_logger.dart';

class PegSolitaireViewModel extends ChangeNotifier { 
  static const int gridSize = 7; 
  
  final IGameHistoryRepository? historyRepository;
  final PreferencesService? preferencesService;
  final AudioService? audioService;

  final List<MoveRecord> _movesHistory = [];

  final List<List<List<CellType>>> _undoStack = [];
  bool get canUndo => _undoStack.isNotEmpty;

  late List<List<CellType>> _board; 
  BoardPosition? _selectedPosition; 
  int _remainingPegs = 0; 
  int _moveCount = 0; 
  bool _isGameOver = false; 
  bool _isVictory = false; 

  List<List<CellType>> get board => _board; 
  BoardPosition? get selectedPosition => _selectedPosition; 
  int get remainingPegs => _remainingPegs; 
  int get moveCount => _moveCount; 
  bool get isGameOver => _isGameOver; 
  bool get isVictory => _isVictory; 

  PegSolitaireViewModel({
    this.historyRepository,
    this.preferencesService,
    this.audioService,
  }) { 
    initializeBoard(); 
  } 

  List<List<CellType>> _copyGrid(List<List<CellType>> source) {
    return source.map((row) => List<CellType>.from(row)).toList();
  }

  void undoMove() {
    if (_undoStack.isEmpty) return;
    _board = _undoStack.removeLast();
    _selectedPosition = null;
    _moveCount--;
    _remainingPegs++;
    _isGameOver = false;
    
    if (_movesHistory.isNotEmpty) {
      _movesHistory.removeLast();
    }
    
    notifyListeners();
  }

  List<BoardPosition> getValidDestinations() {
    if (_selectedPosition == null) return [];
    List<BoardPosition> destinations = [];
    final directions = [[-2, 0], [2, 0], [0, -2], [0, 2]];
    
    for (var dir in directions) {
      int newRow = _selectedPosition!.row + dir[0];
      int newCol = _selectedPosition!.col + dir[1]; 
      
      if (newRow >= 0 && newRow < gridSize && newCol >= 0 && newCol < gridSize) {
        BoardPosition dest = BoardPosition(newRow, newCol);
        if (_isValidMove(_selectedPosition!, dest)) {
          destinations.add(dest);
        }
      }
    }
    return destinations;
  }

  void initializeBoard() { 
    _board = List.generate(gridSize, (row) { 
      return List.generate(gridSize, (col) { 
        if ((row < 2 || row > 4) && (col < 2 || col > 4)) { 
          return CellType.voidCell; 
        } 
        if (row == 3 && col == 3) { 
          return CellType.emptyHole; 
        } 
        return CellType.occupiedPeg; 
      }); 
    }); 
    _selectedPosition = null; 
    _remainingPegs = 32; 
    _moveCount = 0; 
    _isGameOver = false; 
    _isVictory = false; 
    
    _undoStack.clear();
    _movesHistory.clear();

    notifyListeners(); 
  } 

  CellType getCellType(int row, int col) { 
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) { 
      return CellType.voidCell; 
    } 
    return _board[row][col]; 
  } 

  void onCellTapped(BoardPosition pos) { 
    if (_isGameOver) { 
      return; 
    } 

    final CellType tappedType = _board[pos.row][pos.col]; 
    if (tappedType == CellType.voidCell) return; 

    if (_selectedPosition == null) { 
      if (tappedType == CellType.occupiedPeg) { 
        _selectedPosition = pos; 
        audioService?.playSelect();
        notifyListeners(); 
      } 
      return; 
    } 

    final BoardPosition origin = _selectedPosition!; 

    if (origin == pos) { 
      _selectedPosition = null; 
      notifyListeners(); 
      return; 
    } 

    if (tappedType == CellType.occupiedPeg) { 
      _selectedPosition = pos; 
      audioService?.playSelect();
      notifyListeners(); 
      return; 
    } 

    if (tappedType == CellType.emptyHole) { 
      if (_isValidMove(origin, pos)) { 
        _undoStack.add(_copyGrid(_board));

        _executeMove(origin, pos); 
        _selectedPosition = null; 
        _evaluateGameTermination(); 
        notifyListeners(); 
      } else {  
        AppLogger.warning('Reglas: Intento de salto inválido rechazado desde $origin hacia $pos'); 
      } 
    } 
  }

  bool _isValidMove(BoardPosition from, BoardPosition to) { 
    final int rowDelta = (from.row - to.row).abs(); 
    final int colDelta = (from.col - to.col).abs(); 

    final bool isOrthogonalTwoStep = 
        (rowDelta == 2 && colDelta == 0) || (rowDelta == 0 && colDelta == 2); 
    if (!isOrthogonalTwoStep) return false; 

    if (_board[to.row][to.col] != CellType.emptyHole) return false; 

    final int midRow = (from.row + to.row) ~/ 2; 
    final int midCol = (from.col + to.col) ~/ 2; 
    if (_board[midRow][midCol] != CellType.occupiedPeg) return false; 
    
    return true; 
  } 

  void _executeMove(BoardPosition from, BoardPosition to) { 
    final int midRow = (from.row + to.row) ~/ 2; 
    final int midCol = (from.col + to.col) ~/ 2; 

    _board[from.row][from.col] = CellType.emptyHole;     
    _board[midRow][midCol] = CellType.emptyHole;        
    _board[to.row][to.col] = CellType.occupiedPeg;      

    _remainingPegs--; 
    _moveCount++; 

    _movesHistory.add(MoveRecord(
      from: from,
      to: to,
      timestamp: DateTime.now(),
    ));

    HapticFeedback.mediumImpact();
    audioService?.playJump();
    AppLogger.info('Salto ejecutado con éxito: $from -> $to | Clavijas restantes: $_remainingPegs'); 
  } 

  void _evaluateGameTermination() { 
    if (_remainingPegs == 1) { 
      _isGameOver = true; 
      _isVictory = true; 
      audioService?.playGameOver();
      HapticFeedback.heavyImpact();
      AppLogger.info('¡VICTORIA! Partida completada en $_moveCount movimientos.'); 
      _persistCompletedGame();
      return; 
    } 

    if (!_hasValidMovesRemaining()) { 
      _isGameOver = true; 
      _isVictory = false; 
      HapticFeedback.heavyImpact();
      audioService?.playGameOver();
      AppLogger.warning('Fin de juego por bloqueo. No existen movimientos válidos.'); 
      _persistCompletedGame();
    } 
  } 

  bool _hasValidMovesRemaining() { 
    const List<List<int>> directions = [ 
      [-2, 0], 
      [2, 0],  
      [0, -2], 
      [0, 2],  
    ]; 

    for (int r = 0; r < gridSize; r++) { 
      for (int c = 0; c < gridSize; c++) { 
        if (_board[r][c] == CellType.occupiedPeg) { 
          final from = BoardPosition(r, c); 

          for (final dir in directions) { 
            final int targetRow = r + dir[0]; 
            final int targetCol = c + dir[1]; 

            if (targetRow >= 0 && targetRow < gridSize && 
                targetCol >= 0 && targetCol < gridSize) { 
              final to = BoardPosition(targetRow, targetCol); 
              if (_board[targetRow][targetCol] != CellType.voidCell && 
                  _isValidMove(from, to)) { 
                return true; 
              } 
            } 
          } 
        } 
      } 
    } 
    return false; 
  } 

  Future<void> _persistCompletedGame() async {
    final record = GameRecord(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      remainingPegs: _remainingPegs,
      totalMoves: _moveCount,
      durationSeconds: 0,
      isVictory: _isVictory,
      moves: List.unmodifiable(_movesHistory),
    );

    try {
      await historyRepository?.saveGame(record);
      await preferencesService?.checkAndSaveRecord(_remainingPegs);
      AppLogger.info('Resumen de la partida guardado en disco correctamente.');
    } catch (e) {
      AppLogger.error('Error al guardar el resumen en el repositorio: $e');
    }
  }
}