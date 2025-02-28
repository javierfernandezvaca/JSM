/// Una clase para almacenar una instancia de una dependencia junto con su estado de permanencia.
///
/// Esta clase encapsula una instancia de una dependencia y su estado de permanencia.
/// Las instancias pueden ser marcadas como permanentes o no permanentes:
/// - Las instancias permanentes no pueden ser eliminadas del sistema.
/// - Las instancias no permanentes pueden ser eliminadas cuando ya no son necesarias.
class JInstance<T> {
  /// La instancia de la dependencia almacenada.
  ///
  /// Este es el objeto real que se almacena y gestiona dentro del sistema de dependencias.
  final T instance;

  /// El estado de permanencia de la instancia.
  ///
  /// Si es `true`, la instancia es permanente y no puede ser eliminada.
  /// Si es `false`, la instancia es temporal y puede ser eliminada.
  bool get permanent => _permanent;

  /// Estado interno de permanencia de la instancia.
  final bool _permanent;

  /// Crea una nueva instancia de [JInstance].
  ///
  /// Parámetros:
  /// - [instance]: La instancia de la dependencia a almacenar. Es obligatorio.
  /// - [permanent]: Indica si la instancia es permanente (por defecto: `false`).
  ///
  /// Ejemplo:
  /// ```dart
  /// final myInstance = JInstance<MyDependency>(
  ///   instance: MyDependency(),
  ///   permanent: true,
  /// );
  /// ```
  JInstance({
    required this.instance,
    bool permanent = false,
  }) : _permanent = permanent;
}
