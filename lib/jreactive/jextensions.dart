import 'jobservables.dart';

/// Extensión para convertir una cadena en un observable.
///
/// Esta extensión añade una propiedad `observable` a las cadenas que
/// devuelve un `JObservable<String>` con la cadena como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableString = 'miCadena'.observable;
/// ```
extension JObservableString on String {
  JObservable<String> get observable => JObservable<String>(this);
}

/// Extensión para convertir un entero en un observable.
///
/// Esta extensión añade una propiedad `observable` a los enteros que
/// devuelve un `JObservable<int>` con el entero como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableInt = 123.observable;
/// ```
extension JObservableInt on int {
  JObservable<int> get observable => JObservable<int>(this);
}

/// Extensión para convertir un número de coma flotante en un observable.
///
/// Esta extensión añade una propiedad `observable` a los números de
/// coma flotante que devuelve un `JObservable<double>` con el número
/// de coma flotante como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableDouble = 123.456.observable;
/// ```
extension JObservableDouble on double {
  JObservable<double> get observable => JObservable<double>(this);
}

/// Extensión para convertir un booleano en un observable.
///
/// Esta extensión añade una propiedad `observable` a los booleanos que
/// devuelve un `JObservable<bool>` con el booleano como valor inicial.
///
/// Ejemplo:
/// ```dart
/// var observableBool = true.observable;
/// ```
extension JObservableBool on bool {
  JObservable<bool> get observable => JObservable<bool>(this);
}

/// Extensión genérica para convertir cualquier tipo de dato en
/// un observable.
///
/// Esta extensión añade una propiedad `observable` a cualquier tipo de
/// dato que devuelve un `JObservable<T>` con el dato como valor inicial.
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
  // Devuelve una instancia de un Observable con [this] de tipo T como
  // el valor inicial y actual del objeto que está llamando al método
  JObservable<T> get observable => JObservable<T>(this);
}
