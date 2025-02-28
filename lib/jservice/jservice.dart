import '../jconsole/jconsole.dart';
import '../jcontroller/jlifecycle.dart';

/// Clase abstracta para gestionar servicios de manera eficiente.
///
/// Esta clase proporciona una interfaz centralizada para iniciar, detener,
/// encontrar y verificar el estado de los servicios en el sistema.
///
/// Cada servicio se almacena en un mapa interno con una clave única generada
/// a partir del tipo del servicio y un nombre de instancia opcional. Esto permite
/// manejar múltiples instancias del mismo tipo de servicio sin conflictos.
///
/// Características principales:
/// - Soporte para iniciar y detener servicios de forma controlada.
/// - Métodos para encontrar servicios y verificar su estado.
/// - Gestión centralizada de todos los servicios registrados.
abstract class JService extends JDisposableInterface {
  /// Mapa interno que almacena todos los servicios registrados.
  ///
  /// Las claves son cadenas únicas generadas a partir del tipo del servicio
  /// y un nombre de instancia opcional. Los valores son las instancias de los servicios.
  static final Map<String, dynamic> _services = {};

  /// Genera una clave única para cada tipo de servicio.
  ///
  /// La clave se genera combinando el tipo del servicio (`T`) y un nombre
  /// de instancia opcional (`instanceName`). Esto garantiza que cada servicio
  /// tenga una identificación única en el sistema.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final key1 = _getKey<MyService>();
  /// final key2 = _getKey<MyService>(instanceName: 'S1');
  /// ```
  static String _getKey<T>({String? instanceName}) {
    return '${T.toString()}${instanceName ?? ''}';
  }

  /// Método abstracto para iniciar el servicio.
  ///
  /// Este método debe ser implementado por cada servicio para definir su lógica
  /// de inicialización. Se ejecuta automáticamente cuando se inicia un servicio
  /// mediante el método `start`.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// Future<void> onInit() async {
  ///   // Lógica de inicialización del servicio
  /// }
  /// ```
  @override
  Future<void> onInit();

  /// Método abstracto para detener el servicio.
  ///
  /// Este método debe ser implementado por cada servicio para definir su lógica
  /// de cierre. Se ejecuta automáticamente cuando se detiene un servicio
  /// mediante el método `stop`.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// Future<void> onClose() async {
  ///   // Lógica de cierre del servicio
  /// }
  /// ```
  @override
  Future<void> onClose();

  /// Inicia un servicio y lo añade al sistema.
  ///
  /// Este método registra el servicio en el sistema, lo inicializa llamando a
  /// su método `onInit` y lo almacena en el mapa de servicios.
  ///
  /// Si ya existe un servicio con la misma clave, no se sobrescribe y se registra
  /// un mensaje de advertencia en la consola.
  ///
  /// Parámetros:
  /// - [instance]: La instancia del servicio a iniciar. Es obligatorio.
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
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

  /// Detiene un servicio y lo elimina del sistema.
  ///
  /// Este método detiene el servicio llamando a su método `onClose`, lo elimina
  /// del mapa de servicios y registra un mensaje en la consola.
  ///
  /// Si el servicio no existe, se registra un mensaje de advertencia en la consola.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
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

  /// Encuentra y devuelve un servicio registrado.
  ///
  /// Este método busca un servicio en el mapa de servicios y lo devuelve si existe.
  /// Si el servicio no existe o su tipo no coincide con el esperado, se lanza una excepción.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final myService = JService.find<MyService>();
  /// final namedService = JService.find<MyService>(instanceName: 'S1');
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

  /// Verifica si un servicio está en ejecución.
  ///
  /// Devuelve `true` si el servicio está registrado en el sistema, `false` en caso contrario.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final isRunning = JService.isRunning<MyService>();
  /// final isNamedRunning = JService.isRunning<MyService>(instanceName: 'S1');
  /// ```
  static bool isRunning<T extends JService>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    return _services.containsKey(key);
  }

  /// Detiene todos los servicios y limpia el sistema.
  ///
  /// Este método detiene todos los servicios registrados llamando a su método `onClose`,
  /// limpia el mapa de servicios y registra mensajes en la consola.
  ///
  /// Ejemplo:
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
  /// Este método devuelve un mapa que contiene todas las dependencias registradas,
  /// donde las claves son las claves únicas y los valores son las instancias de
  /// los servicios.
  ///
  /// Ejemplo:
  /// ```dart
  /// final allServices = JService.listAll();
  /// ```
  static Map<String, dynamic> listAll() {
    return Map.fromEntries(
      _services.entries.map((entry) => MapEntry(entry.key, entry.value)),
    );
  }
}
