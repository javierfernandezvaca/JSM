import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

// Colores utilizados en la consola de depuración.
enum _JConsoleColor { green, yellow, red, reset }

// Nombre predeterminado para los mensajes de la consola.
const String _defaultName = 'JSM';

// Códigos de los color para cada mensaje de la consola.
final Map<_JConsoleColor, String> _colorCodes = {
  _JConsoleColor.green: '\x1B[32m',
  _JConsoleColor.yellow: '\x1B[33m',
  _JConsoleColor.red: '\x1B[31m',
  _JConsoleColor.reset: '\x1B[0m',
};

/// Consola de depuración.
///
/// Esta clase proporciona métodos para registrar mensajes, información y
/// errores en la consola de depuración; asi como de utilidades para el
/// registro de tiempos y de las aciones en la pila de llamadas de las
/// aplicaciones.
class JConsole {
  /// Mostrar en la consola la información de los registros reactivos.
  ///
  /// Mostrar en la consola la información (los registros reactivos) de
  /// los observables y sus observadores.
  static bool debugShowReactiveLogs = false;

  /// Este método registra un mensaje en la consola de depuración de
  /// color verde.
  ///
  /// Parámetros:
  /// - `obj`: El objeto a registrar.
  /// - `name`: El nombre del registro en consola.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.log('Hello...!!');
  /// ```
  static void log(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      developer.log(
          '${_colorCodes[_JConsoleColor.green]}$obj${_colorCodes[_JConsoleColor.reset]}',
          name: name);
    }
  }

  /// Este método registra un mensaje en la consola de depuración de
  /// color rojo.
  ///
  /// Parámetros:
  /// - `obj`: El objeto a registrar.
  /// - `name`: El nombre del registro en consola.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.error('Error...');
  /// ```
  static void error(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      developer.log(
          '${_colorCodes[_JConsoleColor.red]}$obj${_colorCodes[_JConsoleColor.reset]}',
          name: name);
    }
  }

  /// Este método registra un mensaje en la consola de depuración de
  /// color amarillo.
  ///
  /// Parámetros:
  /// - `obj`: El objeto a registrar.
  /// - `name`: El nombre del registro en consola.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.info('Information...');
  /// ```
  static void info(
    dynamic obj, {
    String name = _defaultName,
  }) {
    if (kDebugMode) {
      developer.log(
          '${_colorCodes[_JConsoleColor.yellow]}$obj${_colorCodes[_JConsoleColor.reset]}',
          name: name);
    }
  }

  /// Este método registra un objeto JSON en la consola de depuración con un
  /// formato de indentación personalizada.
  ///
  /// Parámetros:
  /// - `json`: El objeto JSON a registrar.
  /// - `name`: El nombre del registro en consola.
  /// - `indent`: La cantidad de espacios para la indentación. Por defecto es 2.
  ///
  /// Ejemplo:
  /// ```dart
  /// var json = {
  ///   'clave': 'valor'
  /// };
  ///
  /// JConsole.logJson(json, indent: 4);
  /// ```
  static void logJson(
    dynamic data, {
    String name = _defaultName,
    int indent = 2,
  }) {
    var encoder = JsonEncoder.withIndent(' ' * indent);
    var formattedJson = encoder.convert(data);
    log(formattedJson, name: name);
  }

  // ...

  static final _timestamps = <String, DateTime>{};

  /// Registro de tiempo (Inicio).
  ///
  /// Métodos para registrar el inicio de ciertas operaciones, y calcular
  /// cuánto tiempo tardan. Esto es útil para la depuración de rendimiento
  /// en las aplicaciones.
  ///
  /// Parámetros:
  /// - `id`: El identificador del registro de tiempo.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeStart('Bubble Sort');
  /// ```
  static void timeStart(String id) {
    _timestamps[id] = DateTime.now();
  }

  /// Registro de tiempo (Final).
  ///
  /// Métodos para registrar el fin de ciertas operaciones, y calcular
  /// cuánto tiempo tardan. Esto es útil para la depuración de rendimiento
  /// en las aplicaciones.
  ///
  /// Parámetros:
  /// - `id`: El identificador del registro de tiempo.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeEnd('Bubble Sort');
  /// ```
  static void timeEnd(String id) {
    final start = _timestamps[id];
    if (start != null) {
      final duration = DateTime.now().difference(start);
      log('Time $id: ${duration.inMilliseconds} ms');
    }
  }

  // Registro de pila de llamadas.
  //
  // Método para registrar la pila de llamadas actual. Útil para depurar
  // problemas complejos en las aplicaciones.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.trace();
  /// ```
  static void trace() {
    if (kDebugMode) {
      developer.log('\n${StackTrace.current}', name: 'Stack Trace');
    }
  }
}
