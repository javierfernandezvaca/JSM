import 'package:flutter/material.dart';

import '../jconsole/jconsole.dart';

/// Clase que extiende `RouteSettings` para configuraciones de rutas nombradas.
///
/// Esta clase garantiza que todas las configuraciones de ruta tengan un nombre
/// obligatorio. Es útil para evitar errores al trabajar con rutas nombradas en
/// aplicaciones Flutter.
class NamedRouteSettings extends RouteSettings {
  /// Crea una configuración de ruta con un nombre requerido.
  ///
  /// Parámetros:
  /// - [name]: El nombre de la ruta. Es obligatorio y no puede ser nulo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final settings = NamedRouteSettings(name: '/home');
  /// ```
  const NamedRouteSettings({
    required String name,
  }) : super(name: name);
}

/// Observador de rutas que registra eventos de navegación en la consola.
///
/// Este observador se utiliza para monitorear y registrar eventos relacionados
/// con la navegación en la aplicación, como el empuje, eliminación o reemplazo
/// de rutas. Los registros son útiles para depurar problemas relacionados con
/// la navegación.
class JRouterObserver extends NavigatorObserver {
  /// Valor predeterminado utilizado cuando el nombre de una ruta es desconocido.
  final String _unknow = 'Unknown Route';

  /// Registra que se ha navegado a una nueva ruta.
  ///
  /// Este método se llama cuando se empuja una nueva ruta a la pila de navegación.
  ///
  /// Parámetros:
  /// - [route]: La ruta a la que se ha navegado.
  /// - [previousRoute]: La ruta anterior en la pila (opcional).
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    JConsole.log('Navigated to "${route.settings.name ?? _unknow}"');
  }

  /// Registra que se ha regresado desde una ruta.
  ///
  /// Este método se llama cuando se elimina una ruta de la pila de navegación,
  /// generalmente al navegar hacia atrás.
  ///
  /// Parámetros:
  /// - [route]: La ruta desde la que se ha regresado.
  /// - [previousRoute]: La ruta anterior en la pila (opcional).
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    JConsole.log('Returned from "${route.settings.name ?? _unknow}"');
  }

  /// Registra que se ha eliminado una ruta de la pila de navegación.
  ///
  /// Este método se llama cuando una ruta es explícitamente eliminada de la pila.
  ///
  /// Parámetros:
  /// - [route]: La ruta que se ha eliminado.
  /// - [previousRoute]: La ruta anterior en la pila (opcional).
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    JConsole.log('Removed route "${route.settings.name ?? _unknow}"');
  }

  /// Registra que una ruta ha sido reemplazada por otra.
  ///
  /// Este método se llama cuando una ruta es reemplazada por otra en la pila
  /// de navegación.
  ///
  /// Parámetros:
  /// - [newRoute]: La nueva ruta que reemplaza a la anterior.
  /// - [oldRoute]: La ruta que ha sido reemplazada.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    JConsole.log(
        'Replaced "${oldRoute?.settings.name ?? _unknow}" with "${newRoute?.settings.name ?? _unknow}"');
  }

  /// Registra que un gesto del usuario ha iniciado una acción de navegación.
  ///
  /// Este método se llama cuando el usuario inicia un gesto (como deslizar)
  /// para navegar entre rutas.
  ///
  /// Parámetros:
  /// - [route]: La ruta afectada por el gesto.
  /// - [previousRoute]: La ruta anterior en la pila (opcional).
  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    JConsole.log('User gesture on "${route.settings.name ?? _unknow}"');
  }

  /// Registra que un gesto del usuario ha finalizado.
  ///
  /// Este método se llama cuando el usuario finaliza un gesto de navegación.
  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    JConsole.log('User gesture ended');
  }
}
