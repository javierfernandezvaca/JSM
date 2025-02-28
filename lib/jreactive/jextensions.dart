import 'jobservables.dart';

/// Extensión para convertir una cadena en un observable.
///
/// Esta extensión añade la propiedad `observable` a las cadenas, permitiendo
/// convertirlas fácilmente en un `JObservable<String>` con la cadena como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableString = 'miCadena'.observable;
/// print(observableString.value); // Imprime: miCadena
/// ```
extension JObservableString on String {
  /// Convierte la cadena en un `JObservable<String>`.
  ///
  /// Retorna un `JObservable<String>` con la cadena actual como valor inicial.
  JObservable<String> get observable => JObservable<String>(this);
}

/// Extensión para convertir un entero en un observable.
///
/// Esta extensión añade la propiedad `observable` a los enteros, permitiendo
/// convertirlos fácilmente en un `JObservable<int>` con el entero como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableInt = 123.observable;
/// print(observableInt.value); // Imprime: 123
/// ```
extension JObservableInt on int {
  /// Convierte el entero en un `JObservable<int>`.
  ///
  /// Retorna un `JObservable<int>` con el entero actual como valor inicial.
  JObservable<int> get observable => JObservable<int>(this);
}

/// Extensión para convertir un número de coma flotante en un observable.
///
/// Esta extensión añade la propiedad `observable` a los números de coma flotante,
/// permitiendo convertirlos fácilmente en un `JObservable<double>` con el número
/// como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableDouble = 123.456.observable;
/// print(observableDouble.value); // Imprime: 123.456
/// ```
extension JObservableDouble on double {
  /// Convierte el número de coma flotante en un `JObservable<double>`.
  ///
  /// Retorna un `JObservable<double>` con el número actual como valor inicial.
  JObservable<double> get observable => JObservable<double>(this);
}

/// Extensión para convertir un booleano en un observable.
///
/// Esta extensión añade la propiedad `observable` a los booleanos, permitiendo
/// convertirlos fácilmente en un `JObservable<bool>` con el booleano como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableBool = true.observable;
/// print(observableBool.value); // Imprime: true
/// ```
extension JObservableBool on bool {
  /// Convierte el booleano en un `JObservable<bool>`.
  ///
  /// Retorna un `JObservable<bool>` con el booleano actual como valor inicial.
  JObservable<bool> get observable => JObservable<bool>(this);
}

/// Extensión genérica para convertir cualquier tipo de dato en un observable.
///
/// Esta extensión añade la propiedad `observable` a cualquier tipo de dato,
/// permitiendo convertirlo fácilmente en un `JObservable<T>` con el dato como valor inicial.
///
/// Ejemplo:
/// ```dart
/// class MyClass {}
/// MyClass myClass = MyClass();
/// var observableMyClass = myClass.observable;
///
/// File? myFile;
/// var observableFile = myFile.observable;
/// ```
extension JObservableGeneric<T> on T {
  /// Convierte el dato en un `JObservable<T>`.
  ///
  /// Retorna un `JObservable<T>` con el dato actual como valor inicial.
  JObservable<T> get observable => JObservable<T>(this);
}
