import '../jconsole/jconsole.dart';
import 'jinstance.dart';

/// Gestor centralizado de dependencias en el sistema.
///
/// Esta clase proporciona una interfaz para gestionar dependencias de manera eficiente.
/// Utiliza un mapa interno para almacenar las dependencias, donde cada dependencia
/// se identifica mediante una clave única generada a partir de su tipo y un nombre
/// de instancia opcional.
///
/// Características principales:
/// - Soporte para dependencias permanentes y no permanentes.
/// - Métodos para agregar, encontrar, eliminar y limpiar dependencias.
/// - Generación automática de claves únicas para evitar colisiones.
class JDependency {
  /// Mapa interno que almacena todas las dependencias registradas.
  ///
  /// Las claves son cadenas únicas generadas a partir del tipo de la dependencia
  /// y un nombre de instancia opcional. Los valores son instancias de [JInstance].
  static final Map<String, JInstance> _dependencies = {};

  /// Genera una clave única para una dependencia.
  ///
  /// La clave se genera combinando el tipo de la dependencia (`T`) y un nombre
  /// de instancia opcional (`instanceName`). Esto garantiza que cada dependencia
  /// tenga una identificación única en el sistema.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final key1 = _getKey<MyDependency>();
  /// final key2 = _getKey<MyDependency>(instanceName: 'D1');
  /// ```
  static String _getKey<T>({String? instanceName}) {
    return '${T.toString()}${instanceName ?? ''}';
  }

  /// Añade una dependencia al sistema.
  ///
  /// La dependencia se almacena con una clave única generada a partir de su tipo
  /// y un nombre de instancia opcional. Si ya existe una dependencia con la misma
  /// clave, no se sobrescribe.
  ///
  /// Parámetros:
  /// - [instance]: La instancia de la dependencia a añadir. Es obligatorio.
  /// - [permanent]: Indica si la dependencia es permanente (por defecto: `false`).
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// JDependency.put<MyDependency>(MyDependency());
  /// JDependency.put<MyDependency>(MyDependency(), instanceName: 'D1', permanent: true);
  /// ```
  static void put<T>(
    T instance, {
    bool permanent = false,
    String? instanceName,
  }) {
    final key = _getKey<T>(instanceName: instanceName);
    if (!_dependencies.containsKey(key)) {
      JConsole.info('$T created');
      _dependencies[key] = JInstance(
        instance: instance,
        permanent: permanent,
      );
    }
  }

  /// Encuentra y devuelve una dependencia del sistema.
  ///
  /// Lanza una excepción si la dependencia no se encuentra en el sistema.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final dependency = JDependency.find<MyDependency>();
  /// final namedDependency = JDependency.find<MyDependency>(instanceName: 'D1');
  /// ```
  static T find<T>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    if (_dependencies.containsKey(key)) {
      return _dependencies[key]!.instance as T;
    } else {
      throw Exception(
          'Dependency of type $key not found. Please make sure the dependency is added before trying to access it.');
    }
  }

  /// Verifica si una dependencia existe en el sistema.
  ///
  /// Devuelve `true` si la dependencia existe, `false` en caso contrario.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final exists = JDependency.exists<MyDependency>();
  /// final namedExists = JDependency.exists<MyDependency>(instanceName: 'D1');
  /// ```
  static bool exists<T>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    return _dependencies.containsKey(key);
  }

  /// Elimina una dependencia del sistema.
  ///
  /// Solo las dependencias no permanentes pueden ser eliminadas. Si la dependencia
  /// es permanente, se registra un mensaje de advertencia en la consola.
  ///
  /// Parámetros:
  /// - [instanceName]: Nombre opcional para diferenciar múltiples instancias del mismo tipo.
  ///
  /// Ejemplo:
  /// ```dart
  /// JDependency.delete<MyDependency>();
  /// JDependency.delete<MyDependency>(instanceName: 'D1');
  /// ```
  static void delete<T>({String? instanceName}) {
    final key = _getKey<T>(instanceName: instanceName);
    if (_dependencies.containsKey(key)) {
      final instance = _dependencies[key]!;
      if (!instance.permanent) {
        JConsole.info('$T deleted');
        _dependencies.remove(key);
      } else {
        JConsole.error('$T is permanent and cannot be deleted');
      }
    } else {
      JConsole.error('$T does not exist');
    }
  }

  /// Limpia todas las dependencias del sistema.
  ///
  /// Este método elimina todas las dependencias, independientemente de si son
  /// permanentes o no. Se utiliza principalmente para reiniciar el sistema o
  /// liberar recursos.
  ///
  /// Ejemplo:
  /// ```dart
  /// JDependency.clear();
  /// ```
  static void clear() {
    JConsole.info('Delete all dependencies');
    _dependencies.clear();
  }

  /// Devuelve una lista de todas las dependencias registradas.
  ///
  /// Este método devuelve un mapa que contiene todas las dependencias registradas,
  /// donde las claves son las claves únicas y los valores son las instancias de
  /// las dependencias.
  ///
  /// Ejemplo:
  /// ```dart
  /// final allDependencies = JDependency.listAll();
  /// ```
  static Map<String, dynamic> listAll() {
    return Map.fromEntries(
      _dependencies.entries
          .map((entry) => MapEntry(entry.key, entry.value.instance)),
    );
  }
}
