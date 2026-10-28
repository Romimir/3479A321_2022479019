import 'package:audioplayers/audioplayers.dart'; 
import '../core/utils/app_logger.dart'; 
 
class AudioService { 
  static final AudioService instance = AudioService._internal(); 
  late final AudioPlayer _player; 
  bool _isInitialized = false; 
 
  AudioService._internal() { 
    _player = AudioPlayer(); 
    _configurePlayer(); 
  } 
 
  Future<void> _configurePlayer() async { 
    try { 
      await _player.setReleaseMode(ReleaseMode.stop); 
      await _player.setPlayerMode(PlayerMode.lowLatency); 
      _isInitialized = true; 
      AppLogger.info('AudioService inicializado en modo Low Latency'); 
    } catch (e) { 
      AppLogger.error('Fallo en la inicialización del AudioService: $e'); 
    } 
  } 
 
  Future<void> playSelect() async { 
    if (!_isInitialized) return; 
    try { 
      await _player.play(AssetSource('audio/selection.mp3'));
      AppLogger.info('Reproduciendo selection.mp3 con éxito');
    } catch (e) { 
      AppLogger.error('No se pudo reproducir selection.mp3: $e'); 
    } 
  } 
 
  Future<void> playJump() async { 
    if (!_isInitialized) return; 
    try { 
      await _player.play(AssetSource('audio/jump.mp3')); 
      AppLogger.info('Reproduciendo jump.mp3 con éxito');
    } catch (e) { 
      AppLogger.error('No se pudo reproducir jump.mp3: $e'); 
    } 
  } 
 
  Future<void> playGameOver() async { 
    if (!_isInitialized) return; 
    try { 
      await _player.play(AssetSource('audio/final.mp3')); 
      AppLogger.info('Reproduciendo final.mp3 con éxito');
    } catch (e) { 
      AppLogger.error('No se pudo reproducir final.mp3: $e'); 
    } 
  } 

  void dispose() { 
    _player.dispose(); 
  } 
}