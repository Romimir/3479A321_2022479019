import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keyBestScore = 'best_score';

  PreferencesService(this._prefs);

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  bool get isSoundEnabled => _prefs.getBool(_keySoundEnabled) ?? true;
  bool get isVibrationEnabled => _prefs.getBool(_keyVibrationEnabled) ?? true;
  int get bestRemainingPegs => _prefs.getInt(_keyBestScore) ?? 32; // <-- Corregido (sin la 'a')

  Future<bool> setSoundEnabled(bool enabled) async {
    _logger.i('PreferencesService: Sonido configurado en $enabled');
    return await _prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<bool> setVibrationEnabled(bool enabled) async {
    _logger.i('PreferencesService: Vibración configurada en $enabled');
    return await _prefs.setBool(_keyVibrationEnabled, enabled);
  }

  Future<bool> checkAndSaveRecord(int remainingPegs) async {
    if (remainingPegs < bestRemainingPegs) {
      _logger.i('PreferencesService: ¡Nuevo récord registrado! $remainingPegs piezas restantes.');
      return await _prefs.setInt(_keyBestScore, remainingPegs);
    }
    return false;
  }

  Future<bool> resetBestScore() async {
    _logger.i('PreferencesService: Récord restablecido a 32');
    return await _prefs.setInt(_keyBestScore, 32);
  }
}