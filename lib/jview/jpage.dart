import 'package:flutter/material.dart';

import '../jcontroller/jcontroller.dart';
import '../jdependency/jdependency.dart';
import 'jview.dart';

/// Un widget sin estado que crea y proporciona un controlador
/// a su widget hijo.
///
/// Este widget crea un controlador de tipo `T` y lo pasa a su widget
/// hijo a través de una función de construcción. También proporciona
/// callbacks opcionales que se llaman en diferentes puntos del ciclo
/// de vida del widget.
///
/// Ejemplo:
/// ```dart
/// class HomeController extends JController {
///   String message = "Hola mundo";
/// }
///
/// class HomePage extends StatelessWidget {
///   const HomePage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return JPage(
///       create: () => HomeController(),
///       builder: (context, controller) {
///         return Scaffold(
///           body: Text(controller.message),
///         );
///       },
///     );
///   }
/// }
/// ```
class JPage<T extends JController> extends StatelessWidget {
  /// Una función que construye el widget hijo.
  ///
  /// Esta es una función que toma un contexto y un controlador
  /// y devuelve un `Widget`.
  final Widget Function(BuildContext, T) builder;

  /// Una función que crea el controlador.
  ///
  /// Esta es una función que crea un controlador de tipo `T`.
  final T Function() create;

  /// Un callback que se llama cuando se inicializa el estado del widget.
  ///
  /// Este es un callback opcional que se llama cuando se inicializa
  /// el estado del widget.
  final VoidCallback? onInit;

  /// Un callback que se llama cuando cambian las dependencias del widget.
  ///
  /// Este es un callback opcional que se llama cuando cambian las
  /// dependencias del widget.
  final VoidCallback? onDidChangeDependencies;

  /// Un callback que se llama cuando se construye el widget.
  ///
  /// Este es un callback opcional que se llama cuando se construye
  /// el widget.
  final VoidCallback? onBuild;

  /// Un callback que se llama cuando se actualiza el widget.
  ///
  /// Este es un callback opcional que se llama cuando se actualiza
  /// el widget.
  final VoidCallback? onDidUpdateWidget;

  /// Un callback que se llama cuando se destruye el widget.
  ///
  /// Este es un callback opcional que se llama cuando se destruye
  /// el widget.
  final VoidCallback? onDispose;

  /// Un callback que se llama cuando se actualiza el estado del widget.
  ///
  /// Este es un callback opcional que se llama cuando se actualiza
  /// el estado del widget.
  final VoidCallback? onUpdate;

  /// Crea un `JPage` con un controlador y una función de construcción.
  ///
  /// Este constructor toma una función que crea un controlador y una
  /// función de construcción y crea una instancia de `JPage`.
  ///
  /// Parámetros:
  ///   `create`: La función que crea el controlador.
  ///   `builder`: La función que construye el widget hijo.
  ///
  /// Ejemplo:
  /// ```dart
  /// class HomeController extends JController {
  ///   String message = "Hola mundo";
  /// }
  ///
  /// class HomePage extends StatelessWidget {
  ///   const HomePage({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return JPage(
  ///       create: () => HomeController(),
  ///       builder: (context, controller) {
  ///         return Scaffold(
  ///           body: Text(controller.message),
  ///         );
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  const JPage({
    super.key,
    required this.builder,
    required this.create,
    this.onInit,
    this.onDidChangeDependencies,
    this.onBuild,
    this.onDidUpdateWidget,
    this.onDispose,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Crea el controlador y lo añade a las dependencias.
    JDependency.put<T>(create());
    // Obtiene el controlador de las dependencias.
    final page = JDependency.find<T>();
    // Devuelve el widget construido por el controlador.
    return page.render(
      (context, controller) => builder(context, controller),
      fnOnInit: onInit,
      fnOnDidChangeDependencies: onDidChangeDependencies,
      fnOnBuild: onBuild,
      fnOnDidUpdateWidget: onDidUpdateWidget,
      fnOnDispose: onDispose,
      fnOnUpdate: onUpdate,
    );
  }
}
