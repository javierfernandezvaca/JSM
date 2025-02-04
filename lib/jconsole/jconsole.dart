import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'ansi_color.dart';

/// Nombre por defecto utilizado para identificar los mensajes de la consola.
const String _defaultName = 'JSM';

/// Consola de depuración con soporte para logs coloreados, medición de tiempos,
/// y trazas de pila.
///
/// Esta clase no debe ser instanciada. Todos los métodos son estáticos.
class JConsole {
  /// Habilita/deshabilita los logs reactivos en la consola.
  ///
  /// Cuando está activado, muestra logs detallados de los observables y sus
  /// observadores.
  static bool debugShowReactiveLogs = false;

  static final _colorGreen = AnsiColor.fg(34);
  static final _colorYellow = AnsiColor.fg(220);
  static final _colorRed = AnsiColor.fg(196);

  /// Registra un mensaje de log en color verde.
  ///
  /// Útil para mensajes generales de depuración.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.log('Usuario autenticado: $user');
  /// ```
  static void log(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      _printColored(_colorGreen, obj, name);
    }
  }

  /// Registra un mensaje de error en color rojo.
  ///
  /// Ideal para capturar excepciones o estados no recuperables.
  ///
  /// Ejemplo:
  /// ```dart
  /// try {
  ///   // Código riesgoso
  /// } catch (e) {
  ///   JConsole.error('Fallo en la operación: $e');
  /// }
  /// ```
  static void error(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      _printColored(_colorRed, obj, name);
    }
  }

  /// Registra un mensaje informativo en color amarillo.
  ///
  /// Útil para advertencias o eventos que no son errores críticos.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.info('Conexión inestable: reintentando...');
  /// ```
  static void info(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      _printColored(_colorYellow, obj, name);
    }
  }

  static void _printColored(AnsiColor color, dynamic obj, String name) {
    final message = color('$obj');
    if (kDebugMode) {
      print('[$name] $message');
    }
  }

  /// Formatea y registra un objeto JSON con indentación personalizada o en
  /// formato compacto.
  ///
  /// Lanza un error si el objeto no es serializable.
  ///
  /// Ejemplo (con indentación):
  /// ```dart
  /// JConsole.logJson({'id': 1, 'name': 'Alice'}, indent: 4);
  /// ```
  ///
  /// Ejemplo (sin indentación):
  /// ```dart
  /// JConsole.logJson({'id': 1, 'name': 'Alice'}, prettyPrint: false);
  /// ```
  static void logJson(
    dynamic data, {
    String name = _defaultName,
    int indent = 2,
    bool prettyPrint = true,
  }) {
    if (data == null) {
      log('null', name: name);
    } else {
      try {
        String jsonString;
        if (prettyPrint) {
          // Formato legible con indentación
          final encoder = JsonEncoder.withIndent(' ' * indent);
          jsonString = encoder.convert(data);
        } else {
          // Formato compacto
          jsonString = json.encode(data);
        }
        log(jsonString, name: name);
      } catch (e) {
        error('Failed to encode JSON: $e', name: name);
      }
    }
  }

  // ...

  static final _stopwatches = <String, Stopwatch>{};

  /// Inicia un temporizador asociado a un [id] único.
  ///
  /// Utiliza [timeEnd] con el mismo [id] para medir la duración.
  ///
  /// Precisión: Microsegundos (usando `Stopwatch`).
  static void timeStart(String id) {
    _stopwatches[id] = Stopwatch()..start();
  }

  /// Detiene el temporizador asociado a [id] y registra la duración.
  ///
  /// Si el [id] no existe, registra un error.
  static void timeEnd(String id) {
    final sw = _stopwatches.remove(id);
    if (sw != null) {
      sw.stop();
      log('Time $id: ${sw.elapsedMicroseconds} μs');
    } else {
      error('Timer "$id" was never started');
    }
  }

  /// Registra el tiempo transcurrido para el temporizador asociado a [id].
  ///
  /// No detiene el temporizador, lo que permite medir puntos intermedios.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeStart('fetchData');
  /// // Código que tarda un tiempo...
  /// JConsole.timeLog('fetchData'); // Registra el tiempo transcurrido hasta aquí
  /// // Más código...
  /// JConsole.timeEnd('fetchData'); // Registra el tiempo total
  /// ```
  static void timeLog(String id) {
    final sw = _stopwatches[id];
    if (sw != null && sw.isRunning) {
      log('Intermediate time for $id: ${sw.elapsedMicroseconds} μs');
    } else {
      error('Timer "$id" is not running or was never started');
    }
  }

  /// Captura y registra la pila de llamadas actual.
  ///
  /// Útil para depurar flujos complejos o identificar el origen de un error.
  static void trace() {
    if (kDebugMode) {
      developer.log('\n${StackTrace.current}', name: 'Stack Trace');
    }
  }
}
