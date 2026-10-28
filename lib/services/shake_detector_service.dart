import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../core/utils/app_logger.dart';

class ShakeDetectorService {
  double shakeThreshold;
  final VoidCallback onShake;
  final Duration debounceDuration;
  
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  late final AppLifecycleListener _lifecycleListener;
  DateTime _lastShakeTime = DateTime.now();
  bool _isListening = false;

  ShakeDetectorService({
    required this.onShake,
    this.shakeThreshold = 7.0, // Umbral de aceleración en m/s²
    this.debounceDuration = const Duration(milliseconds: 1200),
  }) {
    _initLifecycleListener();
  }

  void _initLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        AppLogger.info('SO Resumed: Reanudando sensor de aceleración');
        startListening();
      },
      onPause: () {
        AppLogger.info('SO Paused: Suspendiendo sensor para mitigar consumo de batería');
        stopListening();
      },
      onDetach: () => dispose(),
    );
  }

  void startListening() {
    if (_isListening) return;
    
    _subscription = userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        // Magnitud vectorial: sqrt(x² + y² + z²)
        final double magnitude = sqrt(
          event.x * event.x +
          event.y * event.y +
          event.z * event.z
        );
        
        if (magnitude > shakeThreshold) {
          final now = DateTime.now();
          if (now.difference(_lastShakeTime) > debounceDuration) {
            _lastShakeTime = now;
            AppLogger.info('¡Shake detectado! Magnitud: ${magnitude.toStringAsFixed(2)} m/s² (umbral: $shakeThreshold)');
            onShake();
          }
        }
      },
      onError: (error) {
        AppLogger.error('Error en el flujo del acelerómetro: $error');
      },
      cancelOnError: false,
    );
    
    _isListening = true;
    AppLogger.info('ShakeDetectorService: Escucha activa');
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _isListening = false;
    AppLogger.info('ShakeDetectorService: Escucha detenida');
  }

  void dispose() {
    stopListening();
    _lifecycleListener.dispose();
  }
}