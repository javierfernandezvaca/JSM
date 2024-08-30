// ...

import 'package:flutter/material.dart';

import '../jcontroller/jcontroller.dart';
import '../jdependency/jdependency.dart';
import '../jutils/jutils.dart';
import '../jreactive/jwidgets.dart';

/// Un widget que se reconstruye a partir de un controlador y su estado.
///
/// Este widget toma un controlador y una función de construcción, y
/// se reconstruye cada vez que el estado del controlador cambia.
///
/// Ejemplo:
/// ```dart
/// class MyController extends JController {
///   int counter = 0;
///
///   void increase() {
///     counter++;
///     update(['counter-widget']);
///   }
/// }
///
/// JBuilderWidget<MyController>(
///   id: 'counter-widget',
///   onChange: (context, controller) => Text('${controller.counter}'),
/// );
/// ```
class JBuilderWidget<T extends JController> extends StatefulWidget {
  /// Una función que construye el widget.
  ///
  /// Esta función se llama con el contexto y el controlador
  /// como argumentos.
  final Widget Function(BuildContext context, T controller) onChange;

  /// Identificador opcional para este widget.
  ///
  /// Si se proporciona un identificador, este widget se reconstruirá solo
  /// cuando el estado del controlador cambie y el identificador de este
  /// widget esté contenido en la lista de identificadores que se van a
  /// actualizar. Si no se proporciona un identificador, este widget se
  /// reconstruirá cada vez que cambie el estado del controlador.
  final String? id;

  /// Un widget que se reconstruye a partir de un controlador y su estado.
  ///
  /// Este widget toma un controlador y una función de construcción, y
  /// se reconstruye cada vez que el estado del controlador cambia.
  ///
  /// Ejemplo:
  /// ```dart
  /// class MyController extends JController {
  ///   int counter = 0;
  ///
  ///   void increase() {
  ///     counter++;
  ///     update(['counter-widget']);
  ///   }
  /// }
  ///
  /// JBuilderWidget<MyController>(
  ///   id: 'counter-widget',
  ///   onChange: (context, controller) => Text('${controller.counter}'),
  /// );
  /// ```
  JBuilderWidget({
    Key? key,
    required this.onChange,
    this.id,
  }) : super(key: key ?? ValueKey(JUtils.generateUniqueID()));

  @override
  JBuilderWidgetState createState() => JBuilderWidgetState<T>();
}

class JBuilderWidgetState<T extends JController>
    extends State<JBuilderWidget<T>> {
  late final T controller;
  Widget? builtWidget;

  @override
  void initState() {
    super.initState();
    controller = JDependency.find<T>();
    builtWidget = widget.onChange(context, controller);
  }

  @override
  Widget build(BuildContext context) {
    return controller.state.observer((state) {
      // Solo se reconstruye si no se proporcionaron ids o si el id de
      // este builder está contenido en la lista de ids que se van a
      // actualizar a petición del usuario.
      if ((state.ids == null) ||
          (state.ids!.isEmpty ||
              ((widget.id != null) && state.ids!.contains(widget.id)))) {
        builtWidget = widget.onChange(context, controller);
      }
      // Si no, se devuelve el widget actual sin cambios ya que no
      // clasificó en la actualización solicitada por el usuario.
      return builtWidget ?? Container();
    });
  }
}

/// Extensión para convertir un `JController` en un `JBuilderWidget`.
///
/// Esta extensión añade un método `builder` a los `JController` que
/// devuelve un `JBuilderWidget` que se reconstruye a partir del
/// controlador y su estado.
///
/// Ejemplo:
/// ```dart
/// class MyController extends JController {
///   int counter = 0;
///
///   void increase() {
///     counter++;
///     update(['counter-widget']);
///   }
/// }
///
/// var ctrl = JDependency.find<MyController>();
///
/// ctrl.builder(
///   id: 'counter-widget',
///   onChange: (context, controller) => Text('${controller.counter}'),
/// );
/// ```
extension JBuilderWidgetExtension<T extends JController> on T {
  /// Extensión para convertir un `JController` en un `JBuilderWidget`.
  ///
  /// Extensión `builder` para los `JController` que devuelve un
  /// `JBuilderWidget` que se reconstruye a partir del controlador
  /// y su estado.
  ///
  /// Ejemplo:
  /// ```dart
  /// class MyController extends JController {
  ///   int counter = 0;
  ///
  ///   void increase() {
  ///     counter++;
  ///     update(['counter-widget']);
  ///   }
  /// }
  ///
  /// var ctrl = JDependency.find<MyController>();
  ///
  /// ctrl.builder(
  ///   id: 'counter-widget',
  ///   onChange: (context, controller) => Text('${controller.counter}'),
  /// );
  /// ```
  Widget builder({
    required Widget Function(BuildContext context, T controller) onChange,
    String? id,
  }) {
    return JBuilderWidget<T>(
      onChange: onChange,
      id: id,
    );
  }
}
