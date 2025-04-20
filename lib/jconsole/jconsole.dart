import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'ansi_color.dart';

/// Nombre por defecto utilizado para identificar los mensajes de la consola.
const String _defaultName = 'JSM';

/// Enumeración para especificar la unidad de tiempo.
enum TimeUnit {
  microseconds,
  milliseconds,
  seconds,
}

/// Consola de depuración personalizada con soporte para logs coloreados, medición de tiempos,
/// trazas de pila y formateo JSON.
///
/// Esta clase está diseñada para ser utilizada exclusivamente mediante métodos estáticos.
/// No debe ser instanciada, ya que todos sus métodos son estáticos y no dependen de un estado interno.
///
/// Nota: Los colores ANSI utilizados en esta clase pueden no funcionar en todas las plataformas
/// o terminales (por ejemplo, ciertos IDEs o dispositivos móviles). Se recomienda probar
/// en terminales compatibles con ANSI para obtener la mejor experiencia.
class JConsole {
  /// Habilita/deshabilita los logs reactivos en la consola.
  ///
  /// Cuando está activado, muestra logs detallados de los observables y sus
  /// observadores. Esto es útil para depurar flujos de datos reactivos.
  static bool debugShowReactiveLogs = false;

  // Colores ANSI predefinidos para mejorar la legibilidad de los logs:

  // Verde: Mensajes generales.
  static final _colorGreen = AnsiColor.fg(34);
  // Amarillo: Advertencias.
  static final _colorYellow = AnsiColor.fg(220);
  // Rojo: Errores.
  static final _colorRed = AnsiColor.fg(196);

  /// Registra un mensaje sin aplicar ningún estilo ANSI.
  ///
  /// Este método es útil para imprimir texto plano sin colores ni estilos.
  ///
  /// Parámetros:
  /// - [obj]: El objeto a imprimir (se convierte a String automáticamente).
  /// - [name]: Nombre opcional para identificar el origen del mensaje (por defecto: 'JSM').
  static void printl(
    dynamic obj, {
    String name = _defaultName,
  }) {
    _printColored(AnsiColor.none, obj, name);
  }

  /// Registra un mensaje de log en color verde.
  ///
  /// Este método es ideal para mensajes informativos generales que no requieren atención inmediata.
  ///
  /// Parámetros:
  /// - [obj]: El objeto a registrar (se convierte a String automáticamente).
  /// - [name]: Nombre opcional para identificar el origen del mensaje (por defecto: 'JSM').
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.log('Usuario autenticado: $user');
  /// ```
  static void log(
    dynamic obj, {
    String name = _defaultName,
  }) {
    _printColored(_colorGreen, obj, name);
  }

  /// Registra un mensaje de error en color rojo.
  ///
  /// Este método es ideal para capturar excepciones o estados no recuperables.
  /// Los errores registrados aquí deben ser investigados para garantizar la estabilidad de la aplicación.
  ///
  /// Parámetros:
  /// - [obj]: El objeto a registrar (se convierte a String automáticamente).
  /// - [name]: Nombre opcional para identificar el origen del mensaje (por defecto: 'JSM').
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
    _printColored(_colorRed, obj, name);
  }

  /// Registra un mensaje informativo en color amarillo.
  ///
  /// Este método es útil para advertencias o eventos que no son críticos pero merecen atención.
  ///
  /// Parámetros:
  /// - [obj]: El objeto a registrar (se convierte a String automáticamente).
  /// - [name]: Nombre opcional para identificar el origen del mensaje (por defecto: 'JSM').
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.info('Conexión inestable: reintentando...');
  /// ```
  static void info(
    dynamic obj, {
    String name = _defaultName,
  }) {
    _printColored(_colorYellow, obj, name);
  }

  /// Método privado para imprimir mensajes con colores ANSI.
  ///
  /// Este método centraliza la lógica de impresión para evitar duplicación de código.
  ///
  /// Parámetros:
  /// - [color]: El color ANSI a aplicar al mensaje.
  /// - [obj]: El objeto a registrar (se convierte a String automáticamente).
  /// - [name]: Nombre opcional para identificar el origen del mensaje.
  static void _printColored(AnsiColor color, dynamic obj, String name) {
    final message = color('$obj');
    if (kDebugMode) {
      print('[$name] $message');
    }
  }

  /// Formatea y registra un objeto JSON con indentación personalizada o en formato compacto.
  ///
  /// Este método es útil para depurar datos estructurados. Si el objeto no es serializable,
  /// se registrará un error detallado en la consola.
  ///
  /// Parámetros:
  /// - [data]: El objeto JSON a registrar.
  /// - [name]: Nombre opcional para identificar el origen del mensaje (por defecto: 'JSM').
  /// - [indent]: Número de espacios para la indentación (por defecto: 2).
  /// - [prettyPrint]: Indica si el JSON debe ser formateado legiblemente (por defecto: true).
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
        error(
          'Failed to encode JSON: $e\n'
          'Invalid object structure: ${data.runtimeType}',
          name: name,
        );
      }
    }
  }

  // ...

  // Mapa interno para almacenar temporizadores asociados a IDs únicos.
  static final _stopwatches = <String, Stopwatch>{};

  /// Inicia un temporizador asociado a un [id] único.
  ///
  /// Este método utiliza la clase `Stopwatch` para medir intervalos de tiempo con precisión
  /// de microsegundos. Para detener el temporizador, utiliza [timeEnd] con el mismo [id].
  ///
  /// Parámetros:
  /// - [id]: Identificador único para el temporizador.
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeStart('fetchData');
  /// ```
  static void timeStart(String id) {
    _stopwatches[id] = Stopwatch()..start();
  }

  /// Detiene el temporizador asociado a [id] y registra la duración.
  ///
  /// Si el [id] no existe, se registrará un error en la consola.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del temporizador.
  /// - [unit]: Unidad de tiempo para mostrar la duración (por defecto: microsegundos).
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeEnd('fetchData', unit: TimeUnit.milliseconds);
  /// ```
  static void timeEnd(String id, {TimeUnit unit = TimeUnit.microseconds}) {
    final sw = _stopwatches.remove(id);
    if (sw != null) {
      sw.stop();
      final duration = _formatDuration(sw.elapsedMicroseconds, unit);
      log('Time $id: $duration');
    } else {
      error('Timer "$id" was never started');
    }
  }

  /// Registra el tiempo transcurrido para el temporizador asociado a [id].
  ///
  /// Este método no detiene el temporizador, lo que permite medir puntos intermedios.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del temporizador.
  /// - [unit]: Unidad de tiempo para mostrar la duración (por defecto: microsegundos).
  ///
  /// Ejemplo:
  /// ```dart
  /// JConsole.timeLog('fetchData', unit: TimeUnit.seconds);
  /// ```
  static void timeLog(String id, {TimeUnit unit = TimeUnit.microseconds}) {
    final sw = _stopwatches[id];
    if (sw != null && sw.isRunning) {
      final duration = _formatDuration(sw.elapsedMicroseconds, unit);
      log('Intermediate time for $id: $duration');
    } else {
      error('Timer "$id" is not running or was never started');
    }
  }

  /// Método privado para formatear la duración según la unidad especificada.
  ///
  /// Este método convierte los microsegundos en la unidad deseada (milisegundos o segundos).
  ///
  /// Parámetros:
  /// - [microseconds]: Duración en microsegundos.
  /// - [unit]: Unidad de tiempo para mostrar la duración.
  static String _formatDuration(int microseconds, TimeUnit unit) {
    switch (unit) {
      case TimeUnit.microseconds:
        return '$microseconds μs';
      case TimeUnit.milliseconds:
        return '${(microseconds / 1000).toStringAsFixed(2)} ms';
      case TimeUnit.seconds:
        return '${(microseconds / 1000000).toStringAsFixed(2)} s';
    }
  }

  /// Captura y registra la pila de llamadas actual.
  ///
  /// Este método es útil para depurar flujos complejos o identificar el origen de un error.
  /// Utiliza el paquete `developer` de Dart para obtener la traza de pila.
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
