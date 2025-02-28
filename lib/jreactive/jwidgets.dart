import 'package:flutter/material.dart';

import '../jconsole/jconsole.dart';
import '../jutils/jutils.dart';
import 'jobservables.dart';
import 'jobservers.dart';

/// Widget que observa los cambios en un `JObservableBase`.
///
/// Este widget se suscribe a un `JObservableBase` y se reconstruye automáticamente
/// cada vez que el valor del observable cambia. Es útil para crear interfaces reactivas
/// que respondan dinámicamente a cambios en los datos.
class JObserverBaseWidget<T> extends StatefulWidget {
  /// El `JObservableBase` que este widget está observando.
  ///
  /// Este observable es la fuente de datos que el widget observará y utilizará para
  /// reconstruirse cuando cambie su valor.
  final JObservableBase<T> observable;

  /// Una función que se llama para construir el widget cada vez que el valor del
  /// `JObservableBase` cambia.
  ///
  /// Esta función recibe el valor actual del observable y debe devolver un widget
  /// que represente ese valor.
  ///
  /// Ejemplo:
  /// ```dart
  /// (int value) => Text('Valor: $value'),
  /// ```
  final Widget Function(T value) builder;

  /// Constructor para el widget `JObserverBaseWidget`.
  ///
  /// Parámetros:
  /// - [observable]: El `JObservableBase` que este widget observará.
  /// - [builder]: La función que construye el widget basado en el valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
  /// JObserverBaseWidget<int>(
  ///   observable: myObservable,
  ///   builder: (value) => Text('Valor: $value'),
  /// );
  /// ```
  const JObserverBaseWidget({
    super.key,
    required this.observable,
    required this.builder,
  });

  @override
  JObserverBaseWidgetState<T> createState() => JObserverBaseWidgetState<T>();
}

/// Estado del widget `JObserverBaseWidget`.
///
/// Este estado implementa `JObserverBase`, lo que permite al widget suscribirse
/// a un `JObservableBase` y recibir notificaciones cuando el valor del observable
/// cambia.
class JObserverBaseWidgetState<T> extends State<JObserverBaseWidget<T>>
    implements JObserverBase<T> {
  /// El valor actual del `JObservableBase`.
  ///
  /// Este valor se actualiza cada vez que el observable notifica un cambio.
  late T value;

  /// Una función que se puede llamar para desuscribirse del `JObservableBase`.
  ///
  /// Esta función se utiliza para limpiar la suscripción cuando el widget se elimina.
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
  /// Este método se llama automáticamente cuando el observable notifica un cambio.
  /// Actualiza el valor y reconstruye el widget.
  @override
  void notify(T newValue) {
    setState(() {
      value = newValue;
    });
  }
}

/// Extensión para convertir un `JObservableBase` en un `JObserverBaseWidget`.
///
/// Esta extensión añade un método `observer` a los `JObservableBase`, permitiendo
/// convertir fácilmente un observable en un widget reactivo que observe sus cambios.
///
/// Ejemplo:
/// ```dart
/// var counter = 0.observable;
/// var widget = counter.observer((int value) => Text('$value'));
/// ```
extension JObserverWidgetBaseExtension<T> on JObservableBase<T> {
  /// Convierte el `JObservableBase` en un `JObserverBaseWidget`.
  ///
  /// Parámetros:
  /// - [builder]: Una función que construye el widget basado en el valor del observable.
  ///
  /// Retorna:
  /// - Un `JObserverBaseWidget` que observa este observable.
  Widget observer(Widget Function(T value) builder) {
    return JObserverBaseWidget<T>(
      observable: this,
      builder: builder,
    );
  }
}

// ...

/// Widget que observa los cambios en un `JObservable`.
///
/// Este widget se suscribe a un `JObservable` y se reconstruye automáticamente
/// cada vez que el valor del observable cambia. Es útil para crear interfaces reactivas
/// que respondan dinámicamente a cambios en los datos.
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
  /// Este observable es la fuente de datos que el widget observará y utilizará para
  /// reconstruirse cuando cambie su valor.
  final JObservable<T> observable;

  /// Una función que se llama para construir el widget cada vez que el valor del
  /// `JObservable` cambia.
  ///
  /// Esta función recibe el valor actual del observable y debe devolver un widget
  /// que represente ese valor.
  ///
  /// Ejemplo:
  /// ```dart
  /// (int value) => Text('Valor: $value'),
  /// ```
  final Widget Function(T value) onChange;

  /// Constructor para el widget `JObserverWidget`.
  ///
  /// Parámetros:
  /// - [observable]: El `JObservable` que este widget observará.
  /// - [onChange]: La función que construye el widget basado en el valor del observable.
  ///
  /// Ejemplo:
  /// ```dart
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

/// Estado del widget `JObserverWidget`.
///
/// Este estado implementa `JObserver`, lo que permite al widget suscribirse
/// a un `JObservable` y recibir notificaciones cuando el valor del observable
/// cambia.
class JObserverWidgetState<T> extends State<JObserverWidget<T>>
    implements JObserver<T> {
  /// Identificador único del observador.
  ///
  /// Este ID se genera automáticamente al crear el estado del widget y se utiliza
  /// para depurar y registrar eventos relacionados con el observador.
  @override
  final String id;

  /// El valor actual del `JObservable`.
  ///
  /// Este valor se actualiza cada vez que el observable notifica un cambio.
  late T value;

  /// Una función que se puede llamar para desuscribirse del `JObservable`.
  ///
  /// Esta función se utiliza para limpiar la suscripción cuando el widget se elimina.
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
  /// Este método se llama automáticamente cuando el observable notifica un cambio.
  /// Actualiza el valor y reconstruye el widget.
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
/// Esta extensión añade un método `observer` a los `JObservable`, permitiendo
/// convertir fácilmente un observable en un widget reactivo que observe sus cambios.
///
/// Ejemplo:
/// ```dart
/// var counter = 0.observable;
/// var widget = counter.observer((int value) => Text('$value'));
/// ```
extension JObserverWidgetExtension<T> on JObservable<T> {
  /// Convierte el `JObservable` en un `JObserverWidget`.
  ///
  /// Parámetros:
  /// - [builder]: Una función que construye el widget basado en el valor del observable.
  ///
  /// Retorna:
  /// - Un `JObserverWidget` que observa este observable.
  Widget observer(Widget Function(T value) builder) {
    return JObserverWidget<T>(
      observable: this,
      onChange: builder,
    );
  }
}
