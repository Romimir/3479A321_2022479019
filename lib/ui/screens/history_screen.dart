import 'package:flutter/material.dart';
import '../../models/game_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  List<GameRecord> _getMockRecords() {
    return [
      GameRecord(
        id: '101',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 145,
        isVictory: true,
      ),
      GameRecord(
        id: '102',
        date: DateTime.now().subtract(const Duration(minutes: 15)),
        remainingPegs: 3,
        totalMoves: 29,
        durationSeconds: 215,
        isVictory: false,
      ),
      GameRecord(
        id: '103',
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        remainingPegs: 2,
        totalMoves: 27,
        durationSeconds: 190,
        isVictory: false,
      ),
      GameRecord(
        id: '104',
        date: DateTime.now().subtract(const Duration(minutes: 45)),
        remainingPegs: 1,
        totalMoves: 32,
        durationSeconds: 130,
        isVictory: true,
      ),
      GameRecord(
        id: '105',
        date: DateTime.now().subtract(const Duration(minutes: 60)),
        remainingPegs: 4,
        totalMoves: 25,
        durationSeconds: 240,
        isVictory: false,
      ),
      GameRecord(
        id: '106',
        date: DateTime.now().subtract(const Duration(minutes: 75)),
        remainingPegs: 1,
        totalMoves: 30,
        durationSeconds: 155,
        isVictory: true,
      ),
      GameRecord(
        id: '107',
        date: DateTime.now().subtract(const Duration(minutes: 90)),
        remainingPegs: 5,
        totalMoves: 22,
        durationSeconds: 280,
        isVictory: false,
      ),
      GameRecord(
        id: '108',
        date: DateTime.now().subtract(const Duration(minutes: 105)),
        remainingPegs: 1,
        totalMoves: 33,
        durationSeconds: 140,
        isVictory: true,
      ),
      GameRecord(
        id: '109',
        date: DateTime.now().subtract(const Duration(minutes: 120)),
        remainingPegs: 2,
        totalMoves: 28,
        durationSeconds: 200,
        isVictory: false,
      ),
      GameRecord(
        id: '110',
        date: DateTime.now().subtract(const Duration(minutes: 777)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 150,
        isVictory: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final records = _getMockRecords();
    
    const Color boxBackgroundColor = Color.fromARGB(134, 11, 0, 20);
    const Color textColor = Color.fromARGB(255, 188, 228, 244);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Partidas'),
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            color: boxBackgroundColor,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            elevation: 4,
            child: ListTile(
              leading: Icon(
                record.isVictory ? Icons.emoji_events : Icons.flag,
                color: record.isVictory ? const Color.fromARGB(255, 136, 233, 255) : const Color.fromARGB(179, 131, 117, 194),
              ),
              title: Text(
                'Partida: ${record.id}',
                style: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Movimientos: ${record.totalMoves} | Fichas restantes: ${record.remainingPegs}',
                style: const TextStyle(color: textColor),
              ),
              trailing: Text(
                record.isVictory ? 'Victoria' : 'Derrota',
                style: TextStyle(
                  color: record.isVictory ? const Color.fromARGB(255, 136, 233, 255) : const Color.fromARGB(179, 131, 117, 194),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}