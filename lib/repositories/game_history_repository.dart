import '../models/game_record.dart';

abstract class IGameHistoryRepository {
  Future<List<GameRecord>> getHistory();
  Future<void> saveGame (GameRecord record);
  Future<void> clearHistory();
}