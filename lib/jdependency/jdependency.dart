import '../jconsole/jconsole.dart';
import 'jinstance.dart';

/// Clase JDependency
///
/// Una clase para gestionar las dependencias de manera eficiente.
///
/// Esta clase utiliza un mapa para almacenar las dependencias y proporciona
/// métodos para agregar, encontrar, eliminar y limpiar las dependencias.
///
/// Cada dependencia se almacena con una clave única que se genera a partir
/// del tipo de la dependencia y un nombre de instancia opcional.
///
/// Las dependencias pueden ser permanentes o no permanentes. Las
/// dependencias no permanentes pueden ser eliminadas, mientras que
/// las dependencias permanentes no pueden ser eliminadas.
class JDependency {
  static final Map<String, JInstance> _dependencies = {};
  static String _getKey<T>() {
    return T.toString();
  }

  /// Añade una dependencia al mapa de dependencias.
  ///
  /// La dependencia se almacena con una clave única generada a partir
  /// de su tipo y un nombre de instancia opcional.
  ///
  /// Parámetros:
  ///
  /// - `instance`: La instancia de la dependencia a añadir.
  /// - `permanent`: Indica si la dependencia es permanente.
  /// - `instanceName`: El nombre de la instancia (opcional).
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// JDependency.put<MyDependency>(MyDependency());
  /// JDependency.put<MyDependency>(MyDependency(), instanceName: 'D1');
  /// ```
  static void put<T>(
    T instance, {
    bool permanent = false,
    String? instanceName,
  }) {
    final key = _getKey<T>() + (instanceName ?? '');
    if (!_dependencies.containsKey(key)) {
      JConsole.info('$T created');
      _dependencies[key] = JInstance(
        instance: instance,
        permanent: permanent,
      );
    }
  }

  /// Encuentra y devuelve una dependencia del mapa de dependencias.
  ///
  /// Lanza una excepción si la dependencia no se encuentra en el mapa.
  ///
  /// Parámetros:
  ///
  /// - `instanceName`: El nombre de la instancia (opcional).
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// var myDependency1 = JDependency.find<MyDependency>();
  /// var myDependency2 = JDependency.find<MyDependency>(instanceName: 'D2');
  /// ```
  static T find<T>({String? instanceName}) {
    final key = _getKey<T>() + (instanceName ?? '');
    if (_dependencies.containsKey(key)) {
      return _dependencies[key]!.instance;
    } else {
      throw Exception(
          'Dependency of type $key not found. Please make sure the dependency is added before trying to access it.');
    }
  }

  /// Verifica si una dependencia existe en el mapa de dependencias.
  ///
  /// Devuelve `true` si la dependencia existe, `false` en caso contrario.
  ///
  /// Parámetros:
  ///
  /// - `instanceName`: El nombre de la instancia (opcional).
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// var exist1 = JDependency.exists<MyDependency>();
  /// var exist2 = JDependency.exists<MyDependency>(instanceName: 'D1');
  /// ```
  static bool exists<T>({String? instanceName}) {
    final key = _getKey<T>() + (instanceName ?? '');
    return _dependencies.containsKey(key);
  }

  /// Elimina una dependencia del mapa de dependencias.
  ///
  /// Solo las dependencias no permanentes pueden ser eliminadas.
  ///
  /// Parámetros:
  ///
  /// - `instanceName`: El nombre de la instancia (opcional).
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// JDependency.delete<MyDependency>();
  /// JDependency.delete<MyDependency>(instanceName: 'D1');
  /// ```
  static void delete<T>({String? instanceName}) {
    final key = _getKey<T>() + (instanceName ?? '');
    if (_dependencies.containsKey(key) && !_dependencies[key]!.permanent) {
      JConsole.info('$T deleted');
      _dependencies.remove(key);
    } else if (_dependencies.containsKey(key) &&
        _dependencies[key]!.permanent) {
      JConsole.info('$T is permanent and cannot be deleted');
    } else {
      JConsole.info('$T does not exist');
    }
  }

  /// Limpia todas las dependencias del mapa de dependencias.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// JDependency.clear();
  /// ```
  static void clear() {
    JConsole.info('Delete all dependencies');
    _dependencies.clear();
  }
}
