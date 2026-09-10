import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

@immutable
class GameRecord {
  final String id;
  final DateTime date;
  final int remainingPegs;
  final int totalMoves;
  final int durationSeconds;
  final bool isVictory;

  const GameRecord({
    required this.id,
    required this.date,
    required this.remainingPegs,
    required this.totalMoves,
    required this.durationSeconds,
    required this.isVictory,
  });
}

// Función auxiliar para cumplir con la validación de la guía
void testGameRecordModel() {
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
}