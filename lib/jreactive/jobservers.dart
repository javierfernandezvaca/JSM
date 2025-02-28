import '../jutils/jutils.dart';

/// Clase base abstracta para implementar observadores.
///
/// Esta clase define la interfaz básica para todos los observadores. Cada
/// observador debe implementar el método `notify`, que se utiliza para recibir
/// actualizaciones de los observables a los que está suscrito.
abstract class JObserverBase<T> {
  /// Notifica al observador con un nuevo valor.
  ///
  /// Este método debe ser implementado por todas las subclases. Se llama cada vez
  /// que el observable al que está suscrito el observador cambia su valor.
  ///
  /// Parámetros:
  /// - [value]: El nuevo valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// void notify(int value) {
  ///   print('El valor ha cambiado a: $value');
  /// }
  /// ```
  void notify(T value);
}

/// Clase abstracta para observadores con identificador único.
///
/// Esta clase extiende `JObserverBase` y añade un identificador único (`id`) para
/// facilitar la identificación y seguimiento de los observadores en el sistema.
abstract class JObserver<T> extends JObserverBase<T> {
  /// Identificador único del observador.
  ///
  /// Este identificador se genera automáticamente al crear una instancia del
  /// observador. Es útil para depurar y registrar eventos relacionados con el
  /// observador.
  final String id;

  /// Crea un observador con un identificador único.
  ///
  /// El identificador se genera utilizando el método `generateUniqueID` de la
  /// clase `JUtils`.
  ///
  /// Ejemplo:
  /// ```dart
  /// class MiObserver extends JObserver<int> {
  ///   @override
  ///   void notify(int value) {
  ///     print('Observador $id recibió el valor: $value');
  ///   }
  /// }
  /// ```
  JObserver() : id = JUtils.generateUniqueID();
}
