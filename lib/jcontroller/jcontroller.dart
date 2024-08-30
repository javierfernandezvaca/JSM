import 'package:flutter/material.dart';

import '../jreactive/jobservables.dart';
import '../jreactive/jobservers.dart';
import '../jrouter/jrouter.dart';
import 'jlifecycle.dart';
import 'jstate.dart';

/// Clase abstracta que define a un controlador.
///
/// Esta clase proporciona métodos para obtener el contexto, los argumentos, y
/// para actualizar y notificar el estado.
abstract class JController extends JDisposableInterface
    implements JObserverBase<JState> {
  /// Contexto del widget del controlador.
  late BuildContext context;

  /// Argumentos pasados al widget del controlador.
  Map<dynamic, dynamic> get arguments => JRouter.arguments(context);

  /// Estado del controlador.
  JObservableBase<JState> get state => _state;

  /// Método que se llama cuando se inicializa el controlador.
  ///
  /// Este método se puede sobrescribir en las subclases para proporcionar un
  /// comportamiento personalizado durante la inicialización del controlador.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// void onInit() {
  ///   // Código personalizado aquí
  /// }
  /// ```
  @override
  void onInit() {}

  /// Método que se llama cuando el controlador está listo para ser usado.
  ///
  /// Este método se puede sobrescribir en las subclases para proporcionar un
  /// comportamiento personalizado después de que el controlador se haya
  /// inicializado y esté listo para ser usado.
  ///
  /// Es el lugar perfecto para realizar acciones que dependen del estado de
  /// renderizado de los widgets, como mostrar un diálogo, navegar a una nueva
  /// ruta, o realizar una solicitud asíncrona.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// void onReady() {
  ///   // Código personalizado aquí
  /// }
  /// ```
  @override
  void onReady() {}

  /// Método que se llama cuando se cierra el controlador.
  ///
  /// Este método se puede sobrescribir en las subclases para proporcionar un
  /// comportamiento personalizado durante el cierre del controlador.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// void onClose() {
  ///   // Código personalizado aquí
  /// }
  /// ```
  @override
  void onClose() {}

  /// Actualiza el estado del controlador.
  ///
  /// Este método cambia el valor del estado a un nuevo estado con la
  /// fecha y hora actuales y el evento `update`.
  ///
  /// Ejemplo:
  /// ```dart
  /// update();
  /// ```
  void update([List<String>? ids]) {
    _state.value = JState(
      datetime: DateTime.now().millisecondsSinceEpoch,
      event: JEvent.update,
      ids: ids,
    );
  }

  // ...

  // Estado interno del controlador
  final _state = JObservableBase<JState>(JState(
    datetime: DateTime.now().microsecondsSinceEpoch,
    event: JEvent.init,
  ));

  /// Notifica a los observadores con un nuevo estado.
  ///
  /// Este método está obsoleto y es solo para uso interno. En su lugar, debes
  /// hacer uso de los métodos `update`.
  @Deprecated(
      'This function is deprecated and it is for internal use only, please use the `update()` function instead.')
  @override
  void notify(JState state) {}
}
