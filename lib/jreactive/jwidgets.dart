import 'package:flutter/material.dart';

import '../jconsole/jconsole.dart';
import '../jutils/jutils.dart';
import 'jobservables.dart';
import 'jobservers.dart';

/// Un widget que observa los cambios en un `JObservableBase`.
///
/// Este widget se suscribe a un `JObservableBase` y se reconstruye cada
/// vez que el valor del `JObservableBase` cambia.
class JObserverBaseWidget<T> extends StatefulWidget {
  /// El `JObservableBase` que este widget está observando.
  final JObservableBase<T> observable;

  /// Una función que se llama para construir el widget cada vez que el
  /// valor del `JObservableBase` cambia.
  final Widget Function(T value) builder;

  const JObserverBaseWidget({
    super.key,
    required this.observable,
    required this.builder,
  });

  @override
  JObserverBaseWidgetState<T> createState() => JObserverBaseWidgetState<T>();
}

/// El estado de un `JObserverBaseWidget`.
///
/// Este estado implementa `JObserverBase`, lo que significa que puede
/// suscribirse a un `JObservableBase` y ser notificado cuando el valor
/// del `JObservableBase` cambia.
class JObserverBaseWidgetState<T> extends State<JObserverBaseWidget<T>>
    implements JObserverBase<T> {
  /// El valor actual del `JObservableBase`.
  late T value;

  /// Una función que se puede llamar para desuscribirse del `JObservableBase`.
  late void Function() unsubscribe;

  @override
  void initState() {
    super.initState();
    value = widget.observable.value;
    unsubscribe = widget.observable.subscribe(this);
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(value);
  }

  /// Notifica al observador con un nuevo valor.
  ///
  /// Cuando se notifica un nuevo valor, este se guarda y se
  /// reconstruye el widget.
  @override
  void notify(T newValue) {
    setState(() {
      value = newValue;
    });
  }
}

/// Extensión para convertir un `JObservableBase` en un `JObserverBaseWidget`.
///
/// Esta extensión añade un método `observer` a los `JObservableBase` que
/// devuelve un `JObserverBaseWidget` que observa el `JObservableBase`.
extension JObserverWidgetBaseExtension<T> on JObservableBase<T> {
  Widget observer(Widget Function(T value) builder) {
    return JObserverBaseWidget<T>(
      observable: this,
      builder: builder,
    );
  }
}

// ...

/// Un widget que observa los cambios en un `JObservable`.
///
/// Este widget se suscribe a un `JObservable` y se reconstruye cada vez
/// que el valor del `JObservable` cambia.
///
/// Ejemplo:
/// ```dart
/// var counter = 0.observable;
///
/// JObserverWidget<int>(
///   observable: counter,
///   onChange: (int value) => Text('$value'),
/// );
/// ```
class JObserverWidget<T> extends StatefulWidget {
  /// El `JObservable` que este widget está observando.
  ///
  /// Este es un `JObservable<T>` que representa el observable que este
  /// widget está observando.
  final JObservable<T> observable;

  /// Una función que se llama para construir el widget cada vez que el
  /// valor del `JObservable` cambia.
  ///
  /// Esta es una función que toma un valor de tipo `T` y devuelve
  /// un `Widget`.
  final Widget Function(T value) onChange;

  /// Crea un `JObserverWidget` con un `JObservable` y una
  /// función de cambio.
  ///
  /// Este constructor toma un `JObservable` y una función de cambio y
  /// crea una instancia de `JObserverWidget`.
  ///
  /// Parámetros:
  ///   `observable`: El `JObservable` que este widget está observando.
  ///   `onChange`: La función que se llama para construir el widget cada vez
  ///               que el valor del `JObservable` cambia.
  ///
  /// Ejemplo:
  /// ```dart
  /// var counter = 0.observable;
  ///
  /// JObserverWidget<int>(
  ///   observable: counter,
  ///   onChange: (int value) => Text('$value'),
  /// );
  /// ```
  JObserverWidget({
    Key? key,
    required this.observable,
    required this.onChange,
  }) : super(key: key ?? ValueKey(JUtils.generateUniqueID()));

  @override
  JObserverWidgetState<T> createState() => JObserverWidgetState<T>();
}

/// El estado de un `JObserverWidget`.
///
/// Este estado implementa `JObserver`, lo que significa que puede
/// suscribirse a un `JObservable` y ser notificado cuando el valor
/// del `JObservable` cambia.
class JObserverWidgetState<T> extends State<JObserverWidget<T>>
    implements JObserver<T> {
  /// El identificador único del observador.
  @override
  final String id;

  /// El valor actual del `JObservable`.
  late T value;

  /// Una función que se puede llamar para desuscribirse del
  /// `JObservable`.
  late void Function() unsubscribe;

  JObserverWidgetState() : id = JUtils.generateUniqueID();

  @override
  void initState() {
    super.initState();
    value = widget.observable.value;
    // Después de suscribirse al Observable; se proporciona una referencia
    // para cancelar esa suscripción en el futuro `dispose()` del widget
    unsubscribe = widget.observable.subscribe(this);
    if (JConsole.debugShowReactiveLogs) {
      JConsole.info('Observer $id initState');
    }
  }

  @override
  void dispose() {
    if (JConsole.debugShowReactiveLogs) {
      JConsole.info('Observer $id dispose and unsubscribed');
    }
    unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (JConsole.debugShowReactiveLogs) {
      JConsole.info('Observer $id build');
    }
    return widget.onChange(value);
  }

  /// Notifica al observador con un nuevo valor.
  ///
  /// Cuando se notifica un nuevo valor, este se guarda y se
  /// reconstruye el widget.
  @override
  void notify(T newValue) {
    value = newValue;
    if (mounted) {
      setState(() {});
    }
  }
}

/// Extensión para convertir un `JObservable` en un `JObserverWidget`.
///
/// Esta extensión añade un método `observer` a los `JObservable` que
/// devuelve un `JObserverWidget` que observa el `JObservable`.
///
/// Ejemplo:
/// ```dart
/// var counter = 0.observable;
///
/// counter.observer((int value) => Text('$value'));
/// ```
extension JObserverWidgetExtension<T> on JObservable<T> {
  /// Extensión `observer` para los `JObservable` que devuelve un
  /// `JObserverWidget` que observa el `JObservable`.
  ///
  /// Ejemplo:
  /// ```dart
  /// var counter = 0.observable;
  ///
  /// counter.observer((int value) => Text('$value'));
  /// ```
  Widget observer(Widget Function(T value) builder) {
    return JObserverWidget<T>(
      observable: this,
      onChange: builder,
    );
  }
}
