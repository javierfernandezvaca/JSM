import '../jconsole/jconsole.dart';
import '../jcontroller/jlifecycle.dart';

/// Clase JService
///
/// Una clase abstracta para gestionar los servicios de manera eficiente.
///
/// Esta clase utiliza un mapa para almacenar los servicios y proporciona
/// métodos para iniciar, detener, obtener y verificar si un servicio
/// está en ejecución.
///
/// Cada servicio se almacena con una clave única que se genera a partir
/// del tipo del servicio y un nombre de instancia opcional.
abstract class JService extends JDisposableInterface {
  /// Mapa para almacenar los servicios.
  static final Map<String, dynamic> _services = {};

  /// Genera una clave única para cada tipo de servicio.
  static String _getKey<T>({String? instanceName}) {
    return '${T.toString()}${instanceName ?? ''}';
  }

  /// Método para iniciar el servicio.
  ///
  /// Este método debe ser implementado por cada servicio.
  @override
  Future<void> onInit();

  /// Método para detener el servicio.
  ///
  /// Este método debe ser implementado por cada servicio.
  @override
  Future<void> onClose();

  /// Inicia un servicio y lo añade al mapa de servicios.
  ///
  /// Parámetros:
  /// - `instance`: La instancia del servicio a iniciar.
  /// - `instanceName`: Un nombre opcional para la instancia del servicio.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// await JService.start<MyService>(MyService());
  /// await JService.start<MyService>(MyService(), instanceName: 'S1');
  /// ```
  static Future<void> start<T extends JService>(T instance,
      {String? instanceName}) async {
    final key = _getKey<T>(instanceName: instanceName);
    if (!_services.containsKey(key)) {
      T service = instance;
      _services[key] = service;
      await service.onInit();
      JConsole.info('$T started');
    } else {
      JConsole.info(
          'The service $T already exists. Please make sure the service is not already started before trying to start it.');
    }
  }

  /// Detiene un servicio y lo elimina del mapa de servicios.
  ///
  /// Parámetros:
  /// - `instanceName`: Un nombre opcional para la instancia del servicio.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// await JService.stop<MyService>();
  /// await JService.stop<MyService>(instanceName: 'S1');
  /// ```
  static Future<void> stop<T extends JService>({String? instanceName}) async {
    final key = _getKey<T>(instanceName: instanceName);
    if (_services.containsKey(key)) {
      await (_services[key] as JService).onClose();
      _services.remove(key);
      JConsole.info('$T stoped');
    } else {
      JConsole.info(
          'The service $T was not found. Please make sure the service is started before trying to stop it.');
    }
  }

  /// Encuentra y devuelve un servicio del mapa de servicios.
  ///
  /// Parámetros:
  /// - `instanceName`: Un nombre opcional para la instancia del servicio.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// var myService1 = JService.find<MyService>();
  /// var myService2 = JService.find<MyService>(instanceName: 'S2');
  /// ```
  static T find<T extends JService>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    if (_services.containsKey(key)) {
      final service = _services[key];
      if (service is T) {
        return service;
      } else {
        throw Exception(
            'The service $T was found but its type does not match the expected type.');
      }
    } else {
      throw Exception(
          'The service $T was not found. Please make sure the service is started before trying to access it.');
    }
  }

  /// Verifica si un servicio está en ejecución en el mapa de servicios.
  ///
  /// Devuelve `true` si el servicio está en ejecución, `false` en caso
  /// contrario.
  ///
  /// Parámetros:
  /// - `instanceName`: Un nombre opcional para la instancia del servicio.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// var isRunning1 = JService.isRunning<MyService>();
  /// var isRunning2 = JService.isRunning<MyService>(instanceName: 'S1');
  /// ```
  static bool isRunning<T extends JService>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    return _services.containsKey(key);
  }

  /// Detiene todos los servicios y limpia el mapa de servicios.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// JService.stopAll();
  /// ```
  static void stopAll() {
    _services.forEach((key, service) {
      try {
        (service as JService).onClose();
        JConsole.info('$key stopped');
      } catch (e) {
        JConsole.error('Failed to stop $key: ${e.toString()}');
      }
    });
    _services.clear();
  }

  /// Devuelve una lista de todos los servicios registrados.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// var allServices = JService.listAll();
  /// ```
  static Map<String, dynamic> listAll() {
    return Map.fromEntries(
      _services.entries.map((entry) => MapEntry(entry.key, entry.value)),
    );
  }
}
