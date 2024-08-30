import '../jutils/jutils.dart';

/// Una clase base abstracta para los observadores.
///
/// Esta clase define un método `notify` que se debe implementar en todas
/// las subclases.
abstract class JObserverBase<T> {
  /// Notifica al observador con un nuevo valor.
  void notify(T value);
}

/// Una clase abstracta para los observadores que extiende de
/// `JObserverBase`.
///
/// Esta clase proporciona un identificador único para cada observador.
abstract class JObserver<T> extends JObserverBase<T> {
  /// El identificador único del observador.
  final String id;

  /// Crea un observador con un identificador único.
  JObserver() : id = JUtils.generateUniqueID();
}
