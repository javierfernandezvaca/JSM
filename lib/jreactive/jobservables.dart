import 'package:collection/collection.dart';

import '../jconsole/jconsole.dart';
import '../jutils/jutils.dart';
import 'jobservers.dart';

/// Una clase base para los observables.
///
/// Esta clase proporciona métodos para obtener y cambiar el valor del
/// observable, y para suscribir y desuscribir observadores.
class JObservableBase<T> {
  /// El valor actual del observable.
  T _value;

  // El tipo del observable.
  final Type _type;

  /// La lista de observadores suscritos al observable.
  final List<JObserverBase<T>> _observers = [];

  /// Crea un observable con un valor inicial.
  JObservableBase(this._value) : _type = T;

  /// Obtiene el tipo del observable.
  Type get type => _type;

  /// Obtiene el valor actual del observable.
  T get value => _value;

  /// Cambia el valor del observable y notifica a todos los observadores.
  set value(T newValue) {
    _value = newValue;
    for (var observer in _observers) {
      observer.notify(_value);
    }
  }

  /// Suscribe un observador al observable.
  ///
  /// Devuelve una función que puede ser usada para desuscribir
  /// el observador.
  void Function() subscribe(JObserverBase<T> observer) {
    _observers.add(observer);
    return () => _observers.remove(observer);
  }

  /// Verifica si un observador está suscrito al observable.
  ///
  /// Devuelve `true` si el observador está suscrito, `false` en
  /// caso contrario.
  bool isSubscribed(JObserverBase<T> observer) {
    return _observers.contains(observer);
  }
}

/// Una clase para gestionar observables.
///
/// Esta clase proporciona métodos y propiedades para cambiar y obtener el
/// valor actual del observable. El valor de los observables cambia en
/// tiempo de ejecución.
///
/// ```
class JObservable<T> extends JObservableBase<T> {
  /// El identificador único del observable.
  ///
  /// Este es un `String` que representa el identificador único del
  /// observable.
  final String id;

  /// Crea un observable con un valor inicial y un identificador único.
  ///
  /// Este constructor toma un valor inicial y crea una instancia de `JObservable`.
  ///
  /// Parámetros:
  ///   `value`: El valor inicial del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// var miObservable = JObservable<int>(10);
  /// ```
  JObservable(super.value) : id = JUtils.generateUniqueID();

  /// Cambia el valor del observable y actualiza el valor si el nuevo valor
  /// es diferente al valor actual.
  ///
  /// Parámetros:
  ///   `newValue`: El nuevo valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// miObservable.value = 20;
  /// ```
  @override
  set value(T newValue) {
    if (!_isEqual(_value, newValue)) {
      _value = newValue;
      refresh();
    }
  }

  // Compara dos valores y devuelve `true` si los valores son iguales,
  // `false` en caso contrario.
  bool _isEqual(T x, T y) {
    if (x is int || x is double || x is String || x is bool) {
      return x == y;
    } else {
      return const DeepCollectionEquality().equals(x, y);
    }
  }

  /// Notifica a todos los observadores con el valor actual del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// miObservable.refresh();
  /// ```
  void refresh() {
    for (var observer in _observers) {
      observer.notify(_value);
    }
  }

  /// Suscribe un observador al observable y registra la suscripción en
  /// la consola si `debugShowReactiveLogs` de `JConsole` está activado.
  ///
  /// Devuelve una función que puede ser usada para desuscribir
  /// el observador.
  ///
  /// Parámetros:
  ///   `observer`: El observador a suscribir al observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// var desuscribir = miObservable.subscribe(miObserver);
  /// ```
  @override
  void Function() subscribe(JObserverBase<T> observer) {
    _observers.add(observer);
    if (observer is JObserver<T>) {
      if (JConsole.debugShowReactiveLogs) {
        JConsole.info('Observer ${observer.id} subscribed to Observable $id');
      }
    }
    return () => unsubscribe(observer);
  }

  /// Desuscribe un observador del observable y registra la desuscripción
  /// en la consola si `debugShowReactiveLogs` de `JConsole` está activado.
  ///
  /// Devuelve una función que puede ser usada para desuscribir
  /// el observador.
  ///
  /// Parámetros:
  ///   `observer`: El observador a desuscribir del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// var desuscribir = miObservable.subscribe(miObserver);
  /// desuscribir();
  /// ```
  void Function() unsubscribe(JObserverBase<T> observer) {
    return () {
      _observers.remove(observer);
      if (observer is JObserver<T>) {
        if (JConsole.debugShowReactiveLogs) {
          JConsole.info(
              'Observer ${observer.id} unsubscribed to Observable $id');
        }
      }
    };
  }
}
