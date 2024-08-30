import 'package:flutter/material.dart';

import '../jconsole/jconsole.dart';
import '../jcontroller/jcontroller.dart';
import '../jcontroller/jstate.dart';
import '../jdependency/jdependency.dart';
import '../jreactive/jobservers.dart';

/// Un widget que crea y proporciona un controlador a su widget hijo.
///
/// Este widget se suscribe a un `JObservable` y se reconstruye cada vez
/// que el valor del `JObservable` cambia.
///
/// Ejemplo:
/// ```dart
/// // Se crea la clase controladora
/// class MiController extends JController {
///   String message = "Hola mundo";
/// }
///
/// // Se añade la dependencia de la clase controladora
/// JDependency.put<MiController>(MiController());
/// // Se crea una referencia a la clase controladora
/// var miControlador = JDependency.find<MiController>();
///
/// // Se construye el widget y su controlador asociado
/// var miWidget = JView<MiController>(
///   createController: () => miControlador,
///   builder: (context, controller) => Text(controller.message),
/// );
/// ```
class JView<T extends JController> extends StatefulWidget {
  /// Una función que crea el controlador.
  ///
  /// Esta es una función que crea un controlador de tipo `T`.
  final T Function() createController;

  /// Una función que construye el widget hijo.
  ///
  /// Esta es una función que toma un contexto y un controlador
  /// y devuelve un `Widget`.
  final Widget Function(BuildContext context, T controller) builder;

  /// Un callback que se llama cuando se inicializa el estado del widget.
  ///
  /// Este es un callback opcional que se llama cuando se inicializa
  /// el estado del widget.
  final VoidCallback? fnOnInit;

  /// Un callback que se llama cuando cambian las dependencias del widget.
  ///
  /// Este es un callback opcional que se llama cuando cambian las
  /// dependencias del widget.
  final VoidCallback? fnOnDidChangeDependencies;

  /// Un callback que se llama cuando se construye el widget.
  ///
  /// Este es un callback opcional que se llama cuando se construye
  /// el widget.
  final VoidCallback? fnOnBuild;

  /// Un callback que se llama cuando se actualiza el widget.
  ///
  /// Este es un callback opcional que se llama cuando se actualiza
  /// el widget.
  final VoidCallback? fnOnDidUpdateWidget;

  /// Un callback que se llama cuando se destruye el widget.
  ///
  /// Este es un callback opcional que se llama cuando se destruye
  /// el widget.
  final VoidCallback? fnOnDispose;

  /// Un callback que se llama cuando se actualiza el estado del widget.
  ///
  /// Este es un callback opcional que se llama cuando se actualiza
  /// el estado del widget.
  final VoidCallback? fnOnUpdate;

  /// Crea un `JView` con un controlador y una función de construcción.
  ///
  /// Este constructor toma una función que crea un controlador y una
  /// función de construcción y crea una instancia de `JView`.
  ///
  /// Parámetros:
  ///   `createController`: La función que crea el controlador.
  ///   `builder`: La función que construye el widget hijo.
  ///
  /// Ejemplo:
  /// ```dart
  /// // Se crea la clase controladora
  /// class MiController extends JController {
  ///   String message = "Hola mundo";
  /// }
  ///
  /// // Se añade la dependencia de la clase controladora
  /// JDependency.put<MiController>(MiController());
  /// // Se crea una referencia a la clase controladora
  /// var miControlador = JDependency.find<MiController>();
  ///
  /// // Se construye el widget y su controlador asociado
  /// var miWidget = JView<MiController>(
  ///   createController: () => miControlador,
  ///   builder: (context, controller) => Text(controller.message),
  /// );
  /// ```
  const JView({
    super.key,
    required this.createController,
    required this.builder,
    this.fnOnInit,
    this.fnOnDidChangeDependencies,
    this.fnOnBuild,
    this.fnOnDidUpdateWidget,
    this.fnOnDispose,
    this.fnOnUpdate,
  });

  @override
  JViewState<T> createState() => JViewState<T>();
}

/// El estado de un `JView`.
///
/// Este estado implementa `JObserverBase<JState>`, lo que significa que
/// puede suscribirse a un `JObservableBase<JState>` y ser notificado
/// cuando el valor del `JObservableBase<JState>` cambia.
class JViewState<T extends JController> extends State<JView<T>>
    implements JObserverBase<JState> {
  /// El controlador que este estado está observando.
  late final T controller;

  /// Una función que se puede llamar para desuscribirse del
  /// `JObservableBase<JState>`.
  late void Function() _unsubscribe;

  /// Un booleano que indica si el estado se ha inicializado.
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    controller = widget.createController();
    controller.context = context;
    _unsubscribe = controller.state.subscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      JConsole.log('$T onInit');
      controller.onInit();
      _initialized = true;
      // Callback fnOnInit
      if (widget.fnOnInit != null) {
        widget.fnOnInit!();
      }
    }
    // JConsole.log('$T didChangeDependencies');
    // Función de callback fnOnDidChangeDependencies
    if (widget.fnOnDidChangeDependencies != null) {
      widget.fnOnDidChangeDependencies!();
    }
    // ...
    WidgetsBinding.instance.addPostFrameCallback((_) {
      JConsole.log('$T onReady');
      controller.onReady();
    });
    // ...
  }

  @override
  Widget build(BuildContext context) {
    // JConsole.log('$T build');
    // Función de callback fnOnBuild
    if (widget.fnOnBuild != null) {
      widget.fnOnBuild!();
    }
    return widget.builder(context, controller);
  }

  @override
  void didUpdateWidget(covariant JView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // JConsole.log('$T didUpdateWidget');
    // Función de callback fnOnDidUpdateWidget
    if (widget.fnOnDidUpdateWidget != null) {
      widget.fnOnDidUpdateWidget!();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    JConsole.log('$T onClose');
    controller.onClose();
    JDependency.delete<T>();
    // Función de callback fnOnDispose
    if (widget.fnOnDispose != null) {
      widget.fnOnDispose!();
    }
    super.dispose();
  }

  /// Actualiza el estado del widget.
  ///
  /// Este método llama a `setState` para reconstruir el widget y llama
  /// al callback `fnOnUpdate` si se proporciona.
  void update() {
    if (mounted) {
      JConsole.log('$T onUpdate');
      setState(() {});
      // Función de callback fnOnUpdate
      if (widget.fnOnUpdate != null) {
        widget.fnOnUpdate!();
      }
    }
  }

  /// Notifica al estado con un nuevo estado.
  ///
  /// Este método está obsoleto y es solo para uso interno. En su lugar,
  /// debes usar el método `update`.
  @Deprecated(
      'This function is deprecated and it is for internal use only, please use the `update()` function instead')
  @override
  void notify(JState state) {
    // Por optimización justo aquí exclusivamente se debe reconstruir todo
    // si no se proporcionaron ids en el estado. Estos ids corresponden a
    // los JBuilderWidgets que son exclusivamente los que el usuario ha enviado
    // a actualizar de manera manual y no el estado completo.
    if ((state.ids == null) || (state.ids!.isEmpty)) {
      update();
    }
  }
}

/// Extensión para facilitar la creación de un `JView` a partir de
/// un controlador.
///
/// Esta extensión añade un método `render` a los controladores que devuelve
/// un `JView` que utiliza el controlador.
extension JViewExtension<T extends JController> on T {
  /// Crea un `JView` que utiliza este controlador.
  ///
  /// Este método toma una función de construcción y varios callbacks
  /// opcionales que se llaman en diferentes puntos del ciclo de vida
  /// del widget.
  Widget render(
    Widget Function(BuildContext context, T controller) builder, {
    VoidCallback? fnOnInit,
    VoidCallback? fnOnDidChangeDependencies,
    VoidCallback? fnOnBuild,
    VoidCallback? fnOnDidUpdateWidget,
    VoidCallback? fnOnDispose,
    VoidCallback? fnOnUpdate,
  }) {
    return JView<T>(
      createController: () => this,
      builder: builder,
      // ...
      fnOnInit: fnOnInit,
      fnOnDidChangeDependencies: fnOnDidChangeDependencies,
      fnOnBuild: fnOnBuild,
      fnOnDidUpdateWidget: fnOnDidUpdateWidget,
      fnOnDispose: fnOnDispose,
      fnOnUpdate: fnOnUpdate,
    );
  }
}
