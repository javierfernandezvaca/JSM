import 'dart:async';

import 'jobservables.dart';
import 'jobservers.dart';

/// Una clase para gestionar la suscripción a un observable.
///
/// Esta clase proporciona un método para desuscribirse del observable.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = JWorker(miFuncionParaDesuscribir);
/// ```
class JWorker {
  /// La función para desuscribirse del observable.
  ///
  /// Esta es una función que se puede llamar para desuscribirse
  /// del observable.
  final void Function() unsubscribe;

  /// Crea un trabajador con una función para desuscribirse.
  ///
  /// Este constructor toma una función para desuscribirse y crea una
  /// instancia de `JWorker`.
  ///
  /// Parámetros:
  ///   `unsubscribe`: La función para desuscribirse del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// var miTrabajador = JWorker(miFuncionParaDesuscribir);
  /// ```
  JWorker(this.unsubscribe);

  /// Desuscribe al trabajador del observable.
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

/// Crea un trabajador que se suscribe a un observable y llama a una función
/// cada vez que el valor del observable cambia.
///
/// Devuelve un trabajador que puede ser usado para desuscribirse
/// del observable.
///
/// Parámetros:
///   `observable`: El observable al que se va a suscribir el trabajador.
///   `onChange`: La función que se llama cada vez que el valor del
///               observable cambia.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = ever<int>(
///   observable: miObservable,
///   onChange: (value) => print('$value'),
/// );
/// ```
JWorker ever<T>({
  required JObservable<T> observable,
  required Function(T) onChange,
}) {
  var unsubscribe = observable.subscribe(_EverObserver(onChange));
  return JWorker(unsubscribe);
}

/// Un observador que llama a una función cada vez que se le notifica
/// un nuevo valor.
class _EverObserver<T> extends JObserverBase<T> {
  /// La función a llamar cuando se notifica un nuevo valor.
  final Function(T) onChange;

  /// Crea un observador con una función a llamar cuando se notifica
  /// un nuevo valor.
  _EverObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Crea un trabajador que se suscribe a un observable y llama a una función
/// solo la primera vez que el valor del observable cambia.
///
/// Devuelve un trabajador que puede ser usado para desuscribirse
/// del observable.
///
/// Parámetros:
///   `observable`: El observable al que se va a suscribir el trabajador.
///   `onChange`: La función que se llama solo la primera vez que el
///               valor del observable cambia.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = once<int>(
///   observable: miObservable,
///   onChange: (value) => print('$value'),
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

/// Un observador que llama a una función solo la primera vez que se
/// le notifica un nuevo valor.
class _OnceObserver<T> extends JObserverBase<T> {
  /// La función a llamar cuando se notifica un nuevo valor por
  /// primera vez.
  final Function(T) onChange;

  /// Crea un observador con una función a llamar cuando se notifica
  /// un nuevo valor por primera vez.
  _OnceObserver(this.onChange);

  /// Llama a la función con el nuevo valor.
  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Crea un trabajador que se suscribe a un observable y llama a una
/// función solo después de que ha pasado un cierto período de tiempo
/// desde el último cambio en el valor del observable.
///
/// Parámetros:
///   `observable`: El observable al que se va a suscribir el trabajador.
///   `onChange`: La función que se llama después de que ha pasado un cierto
///               período de tiempo desde el último cambio en el valor del
///               observable.
///   `duration`: La duración del período de tiempo que debe pasar antes de
///               llamar a la función.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = interval<int>(
///   observable: miObservable,
///   onChange: (value) => print('$value'),
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

/// Un observador que llama a una función solo después de que ha pasado
/// un cierto período de tiempo desde el último cambio en el valor del
/// observable.
class _IntervalObserver<T> extends JObserverBase<T> {
  final Function(T) onChange;

  _IntervalObserver(this.onChange);

  @override
  void notify(T value) {
    onChange(value);
  }
}

// ...

/// Implementación de 'debounce'
///
/// Crea un trabajador que se suscribe a un observable y llama a una función
/// solo después de que el valor del observable ha dejado de cambiar durante
/// un cierto período de tiempo.
///
/// Parámetros:
///   `observable`: El observable al que se va a suscribir el trabajador.
///   `onChange`: La función que se llama solo después de que el valor del
///               observable ha dejado de cambiar durante un cierto período
///               de tiempo.
///   `duration`: La duración de la pausa requerida antes de llamar a
///               la función.
///
/// Ejemplo:
/// ```dart
/// var miTrabajador = debounce<int>(
///   observable: miObservable,
///   onChange: (value) => print('$value'),
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

/// Un observador que llama a una función solo después de que el valor del
/// observable ha dejado de cambiar durante un cierto período de tiempo.
class _DebounceObserver<T> extends JObserverBase<T> {
  final Function(T) onChange;

  _DebounceObserver(this.onChange);

  @override
  void notify(T value) {
    onChange(value);
  }
}
