import 'package:flutter/material.dart';
import '../../models/game_record.dart';
import '../../repositories/game_history_repository.dart';
import '../../repositories/json_file_history_repository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final IGameHistoryRepository _repository = JsonFileHistoryRepository();
  late Future<List<GameRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _repository.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color boxBackgroundColor = Color.fromARGB(134, 11, 0, 20);
    const Color textColor = Color.fromARGB(255, 188, 228, 244);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Partidas'),
        iconTheme: const IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Borrar historial',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 23, 0, 74),
                  title: const Text('Borrar historial', style: TextStyle(color: textColor)),
                  content: const Text(
                    '¿Desea eliminar el historial por completo?',
                    style: TextStyle(color: textColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar', style: TextStyle(color: textColor)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _repository.clearHistory();
                _loadHistory();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<GameRecord>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: textColor));
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error al cargar el historial',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              );
            }

            final records = snapshot.data ?? [];
            if (records.isEmpty) {
              return const Center(
                child: Text(
                  'No hay partidas registradas aún.',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  color: boxBackgroundColor,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      record.isVictory ? Icons.emoji_events : Icons.flag,
                      color: record.isVictory
                          ? const Color.fromARGB(255, 136, 233, 255)
                          : const Color.fromARGB(179, 131, 117, 194),
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
                        color: record.isVictory
                            ? const Color.fromARGB(255, 136, 233, 255)
                            : const Color.fromARGB(179, 131, 117, 194),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}