/// Una clase para almacenar una instancia de una dependencia.
///
/// Esta clase se utiliza para almacenar una instancia de una dependencia
/// junto con su estado de permanencia.
///
/// La instancia de la dependencia es almacenada en `instance` y el estado
/// de permanencia en `permanent`.
///
/// Las instancias pueden ser permanentes o no. Las instancias no permanentes
/// pueden ser eliminadas, mientras que las instancias permanentes no pueden
/// ser eliminadas.
class JInstance<T> {
  /// La instancia de la dependencia.
  final T instance;

  /// El estado de permanencia de la instancia.
  bool permanent;

  /// Crea una instancia de JInstance.
  ///
  /// Requiere una instancia de una dependencia y opcionalmente un estado
  /// de permanencia.
  JInstance({
    required this.instance,
    this.permanent = false,
  });
}
