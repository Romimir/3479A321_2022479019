import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../core/utils/app_logger.dart';

/// Servicio para extraer buffers visuales del Render Tree y convertirlos en archivos de imagen.
class ScreenshotService {
  static Future<String?> captureWidgetToImage(GlobalKey boundaryKey) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        AppLogger.warning(
            'No se encontró RenderRepaintBoundary asociado a la GlobalKey');
        return null;
      }

      // Renderizado a imagen con escala de alta definición (pixelRatio: 2.0)
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/peg_solitaire_record_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(buffer, flush: true);

      AppLogger.info('Evidencia gráfica capturada con éxito en: $filePath');
      return filePath;
    } catch (e) {
      AppLogger.error('Error al capturar evidencia gráfica del tablero: $e');
      return null;
    }
  }
}