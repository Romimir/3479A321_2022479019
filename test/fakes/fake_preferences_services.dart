import 'package:lab1/services/preferences_services.dart';

class FakePreferencesService implements PreferencesService {
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  int bestScore = 32;

  @override
  bool get isSoundEnabled => soundEnabled;

  @override
  bool get isVibrationEnabled => vibrationEnabled;

  @override
  int get bestRemainingPegs => bestScore;

  @override
  Future<bool> setSoundEnabled(bool enabled) async {
    soundEnabled = enabled;
    return true;
  }

  @override
  Future<bool> setVibrationEnabled(bool enabled) async {
    vibrationEnabled = enabled;
    return true;
  }

  @override
  Future<bool> checkAndSaveRecord(int remainingPegs) async {
    if (remainingPegs < bestScore) {
      bestScore = remainingPegs;
      return true;
    }
    return false;
  }

  @override
  Future<bool> resetBestScore() async {
    bestScore = 32;
    return true;
  }
}