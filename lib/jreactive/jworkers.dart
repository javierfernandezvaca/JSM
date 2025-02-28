import 'dart:async';

import 'jobservables.dart';
import 'jobservers.dart';

/// Clase para gestionar la suscripción a un observable.
///
/// Esta clase encapsula una función de desuscripción (`unsubscribe`) que permite
/// liberar recursos cuando ya no se necesita observar un observable.
class JWorker {
  /// Función para desuscribirse del observable.
  ///
  /// Esta función debe ser llamada para cancelar la suscripción al observable
  /// y evitar fugas de memoria o comportamientos inesperados.
  final void Function() unsubscribe;

  /// Crea una instancia de `JWorker` con una función de desuscripción.
  ///
  /// Parámetros:
  /// - [unsubscribe]: La función que se ejecutará para cancelar la suscripción.
  ///
  /// Ejemplo:
  /// ```dart
  /// var miTrabajador = JWorker(() {
  ///   print('Desuscribiendo...');
  /// });
  /// ```
  JWorker(this.unsubscribe);

  /// Desuscribe al trabajador del observable.
  ///
  /// Este método llama a la función `unsubscribe` proporcionada en el constructor.
  ///
  /// Ejemplo:
  /// ```dart
  /// miTrabajador.dispose();
  /// ```
  void dispose() {
    unsubscribe();
  }
}

// ...

/// Crea un trabajador que se suscribe a un observable y reacciona a cada cambio.
///
/// Este método crea un observador que llama a una función cada vez que el valor
/// del observable cambia. Devuelve un `JWorker` que puede ser utilizado para
/// cancelar la suscripción.
///
/// Parámetros:
/// - [observable]: El observable al que se desea suscribir.
/// - [onChange]: La función que se ejecuta cada vez que el valor del observable cambia.
///
/// Retorna:
/// - Un `JWorker` que permite cancelar la suscripción.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = ever<int>(
///   observable: miObservable,
///   onChange: (value) => print('Valor actual: $value'),
/// );
/// ```
JWorker ever<T>({
  required JObservable<T> observable,
  required Function(T) onChange,
}) {
  var unsubscribe = observable.subscribe(_EverObserver(onChange));
  return JWorker(unsubscribe);
}

/// Observador interno que llama a una función cada vez que se notifica un nuevo valor.
class _EverObserver<T> extends JObserverBase<T> {
  /// La función a llamar cuando se notifica un nuevo valor.
  final Function(T) onChange;

  /// Función que se ejecuta cuando se notifica un nuevo valor.
  _EverObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Crea un trabajador que reacciona solo al primer cambio en un observable.
///
/// Este método crea un observador que llama a una función solo la primera vez
/// que el valor del observable cambia. Devuelve un `JWorker` que puede ser
/// utilizado para cancelar la suscripción.
///
/// Parámetros:
/// - [observable]: El observable al que se desea suscribir.
/// - [onChange]: La función que se ejecuta solo la primera vez que el valor cambia.
///
/// Retorna:
/// - Un `JWorker` que permite cancelar la suscripción.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = once<int>(
///   observable: miObservable,
///   onChange: (value) => print('Primer cambio: $value'),
/// );
/// ```
JWorker once<T>({
  required JObservable<T> observable,
  required Function(T) onChange,
}) {
  var hasChanged = false;
  var unsubscribe = observable.subscribe(_OnceObserver((value) {
    if (!hasChanged) {
      hasChanged = true;
      onChange(value);
    }
  }));
  return JWorker(unsubscribe);
}

/// Observador interno que reacciona solo al primer cambio en un observable.
class _OnceObserver<T> extends JObserverBase<T> {
  /// Función que se ejecuta cuando se notifica un nuevo valor por primera vez.
  final Function(T) onChange;

  /// Crea un observador con una función para manejar el primer cambio.
  _OnceObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Crea un trabajador que reacciona solo después de un período de tiempo desde el último cambio.
///
/// Este método crea un observador que llama a una función solo si ha pasado un cierto período
/// de tiempo desde el último cambio en el observable. Devuelve un `JWorker` que puede ser
/// utilizado para cancelar la suscripción.
///
/// Parámetros:
/// - [observable]: El observable al que se desea suscribir.
/// - [onChange]: La función que se ejecuta después del período de tiempo.
/// - [duration]: El período de tiempo que debe transcurrir antes de llamar a la función.
///
/// Retorna:
/// - Un `JWorker` que permite cancelar la suscripción.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = interval<int>(
///   observable: miObservable,
///   onChange: (value) => print('Valor después de 1 segundo: $value'),
///   duration: Duration(seconds: 1),
/// );
/// ```
JWorker interval<T>({
  required JObservable<T> observable,
  required Function(T) onChange,
  required Duration duration,
}) {
  Timer? timer;
  var unsubscribe = observable.subscribe(_IntervalObserver((value) {
    // ignore: prefer_conditional_assignment
    if (timer == null) {
      timer = Timer(duration, () {
        onChange(value);
        timer = null;
      });
    }
  }));
  return JWorker(() {
    timer?.cancel();
    unsubscribe();
  });
}

/// Observador interno que reacciona solo después de un período de tiempo desde el último cambio.
class _IntervalObserver<T> extends JObserverBase<T> {
  final Function(T) onChange;

  _IntervalObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Crea un trabajador que reacciona solo después de que el observable deja de cambiar durante un período.
///
/// Este método crea un observador que llama a una función solo si el valor del observable no ha cambiado
/// durante un cierto período de tiempo. Devuelve un `JWorker` que puede ser utilizado para cancelar la
/// suscripción.
///
/// Parámetros:
/// - [observable]: El observable al que se desea suscribir.
/// - [onChange]: La función que se ejecuta después de la pausa.
/// - [duration]: El período de tiempo que debe transcurrir sin cambios antes de llamar a la función.
///
/// Retorna:
/// - Un `JWorker` que permite cancelar la suscripción.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = debounce<int>(
///   observable: miObservable,
///   onChange: (value) => print('Valor estable: $value'),
///   duration: Duration(seconds: 1),
/// );
/// ```
JWorker debounce<T>({
  required JObservable<T> observable,
  required Function(T) onChange,
  required Duration duration,
}) {
  Timer? timer;
  var unsubscribe = observable.subscribe(_DebounceObserver((value) {
    timer?.cancel();
    timer = Timer(duration, () => onChange(value));
  }));
  return JWorker(() {
    timer?.cancel();
    unsubscribe();
  });
}

/// Observador interno que reacciona solo después de que el observable deja de cambiar durante un período.
class _DebounceObserver<T> extends JObserverBase<T> {
  final Function(T) onChange;

  _DebounceObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}
