import '../jconsole/jconsole.dart';
import '../jutils/jutils.dart';
import 'jobservers.dart';

/// Clase base para implementar observables.
///
/// Esta clase proporciona una estructura básica para gestionar observables,
/// incluyendo métodos para obtener y cambiar el valor del observable, así como
/// para suscribir y desuscribir observadores.
class JObservableBase<T> {
  /// El valor actual del observable.
  ///
  /// Este es el valor que se puede observar y modificar. Los cambios en este valor
  /// notifican automáticamente a todos los observadores suscritos.
  T _value;

  /// El tipo del observable.
  ///
  /// Representa el tipo de datos que maneja el observable (por ejemplo, `int`, `String`, etc.).
  final Type _type;

  /// La lista de observadores suscritos al observable.
  ///
  /// Cada vez que el valor del observable cambia, se notifica a todos los observadores
  /// en esta lista.
  final List<JObserverBase<T>> _observers = [];

  /// Crea un observable con un valor inicial.
  ///
  /// Parámetros:
  /// - [value]: El valor inicial del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// final observable = JObservableBase<int>(42);
  /// ```
  JObservableBase(this._value) : _type = T;

  /// Obtiene el tipo del observable.
  ///
  /// Este método devuelve el tipo de datos que maneja el observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// print(observable.type); // Imprime: int
  /// ```
  Type get type => _type;

  /// Obtiene el valor actual del observable.
  ///
  /// Este getter permite acceder al valor actual del observable sin modificarlo.
  ///
  /// Ejemplo:
  /// ```dart
  /// print(observable.value); // Imprime: 42
  /// ```
  T get value => _value;

  /// Cambia el valor del observable y notifica a todos los observadores.
  ///
  /// Este setter actualiza el valor del observable y notifica a todos los observadores
  /// suscritos con el nuevo valor.
  ///
  /// Parámetros:
  /// - [newValue]: El nuevo valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// observable.value = 100;
  /// ```
  set value(T newValue) {
    _value = newValue;
    for (var observer in _observers) {
      observer.notify(_value);
    }
  }

  /// Suscribe un observador al observable.
  ///
  /// Este método añade un observador a la lista de observadores del observable.
  /// Devuelve una función que puede ser utilizada para desuscribir el observador.
  ///
  /// Parámetros:
  /// - [observer]: El observador a suscribir al observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// final unsubscribe = observable.subscribe(myObserver);
  /// unsubscribe(); // Desuscribe el observador.
  /// ```
  void Function() subscribe(JObserverBase<T> observer) {
    _observers.add(observer);
    return () => _observers.remove(observer);
  }

  /// Verifica si un observador está suscrito al observable.
  ///
  /// Este método comprueba si un observador específico está en la lista de observadores.
  ///
  /// Parámetros:
  /// - [observer]: El observador a verificar.
  ///
  /// Retorna:
  /// - `true` si el observador está suscrito, `false` en caso contrario.
  ///
  /// Ejemplo:
  /// ```dart
  /// if (observable.isSubscribed(myObserver)) {
  ///   print('El observador está suscrito.');
  /// }
  /// ```
  bool isSubscribed(JObserverBase<T> observer) {
    return _observers.contains(observer);
  }
}

/// Clase para gestionar observables con identificador único.
///
/// Esta clase extiende `JObservableBase` y añade un identificador único (`id`) para
/// facilitar la identificación y seguimiento de los observables en el sistema.
class JObservable<T> extends JObservableBase<T> {
  /// Identificador único del observable.
  ///
  /// Este identificador se genera automáticamente al crear una instancia del observable.
  /// Es útil para depurar y registrar eventos relacionados con el observable.
  final String id;

  /// Crea un observable con un valor inicial y un identificador único.
  ///
  /// Parámetros:
  /// - [value]: El valor inicial del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// final observable = JObservable<int>(42);
  /// print(observable.id); // Imprime: Un ID único generado.
  /// ```
  JObservable(super.value) : id = JUtils.generateUniqueID();

  /// Cambia el valor del observable y actualiza el valor si el nuevo valor
  /// es diferente al valor actual.
  ///
  /// Este setter verifica si el nuevo valor es diferente del valor actual utilizando
  /// el método `_isEqual`. Si son diferentes, actualiza el valor y notifica a los observadores.
  ///
  /// Parámetros:
  /// - [newValue]: El nuevo valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// observable.value = 100; // Notifica a los observadores si el valor cambia.
  /// ```
  @override
  set value(T newValue) {
    if (!_isEqual(_value, newValue)) {
      _value = newValue;
      refresh();
    }
  }

  /// Comprueba si dos valores se consideran "iguales" para determinar si se debe
  /// notificar a los observadores sobre un cambio.
  ///
  /// Este método utiliza el operador `==` para comparar valores primitivos (`int`, `double`,
  /// `String`, `bool`). Para tipos complejos (listas, mapas, objetos personalizados),
  /// siempre devuelve `false`, lo que significa que cualquier modificación en estos tipos
  /// se considera un cambio y requiere notificación manual mediante `refresh`.
  ///
  /// Parámetros:
  /// - [x]: El primer valor a comparar.
  /// - [y]: El segundo valor a comparar.
  ///
  /// Retorna:
  /// - `true` si los valores son iguales, `false` en caso contrario.
  ///
  /// Ejemplo:
  /// ```dart
  /// final isEqual = observable._isEqual(42, 42); // Retorna: true
  /// ```
  bool _isEqual(T x, T y) {
    if (x is int || x is double || x is String || x is bool) {
      return x == y;
    } else {
      return false;
    }
  }

  /// Notifica a todos los observadores con el valor actual del observable.
  ///
  /// Este método recorre la lista de observadores y llama al método `notify` de cada uno
  /// con el valor actual del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// observable.refresh(); // Notifica a todos los observadores.
  /// ```
  void refresh() {
    for (var observer in _observers) {
      observer.notify(_value);
    }
  }

  /// Suscribe un observador al observable y registra la suscripción en la consola
  /// si `debugShowReactiveLogs` de `JConsole` está activado.
  ///
  /// Este método extiende el comportamiento de `subscribe` de la clase base para incluir
  /// registros de depuración cuando un observador se suscribe.
  ///
  /// Parámetros:
  /// - [observer]: El observador a suscribir al observable.
  ///
  /// Retorna:
  /// - Una función que puede ser usada para desuscribir el observador.
  ///
  /// Ejemplo:
  /// ```dart
  /// final unsubscribe = observable.subscribe(myObserver);
  /// unsubscribe(); // Desuscribe el observador.
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

  /// Desuscribe un observador del observable y registra la desuscripción en la consola
  /// si `debugShowReactiveLogs` de `JConsole` está activado.
  ///
  /// Este método elimina un observador de la lista de observadores y registra la acción
  /// en la consola si los registros de depuración están habilitados.
  ///
  /// Parámetros:
  /// - [observer]: El observador a desuscribir del observable.
  ///
  /// Retorna:
  /// - Una función que puede ser usada para desuscribir el observador.
  ///
  /// Ejemplo:
  /// ```dart
  /// final unsubscribe = observable.subscribe(myObserver);
  /// unsubscribe(); // Desuscribe el observador y registra la acción.
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
