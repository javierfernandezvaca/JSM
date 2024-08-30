import 'package:flutter/material.dart';

import '../jconsole/jconsole.dart';

/// Una clase que extiende `RouteSettings` y proporciona un constructor
/// que requiere un nombre.
///
/// Esta clase se utiliza para crear configuraciones para las rutas
/// nombradas (con un nombre requerido).
class NamedRouteSettings extends RouteSettings {
  /// Crea una configuración de ruta con un nombre requerido.
  const NamedRouteSettings({
    required String name,
  }) : super(name: name);
}

/// Un observador de rutas que registra los eventos de navegación.
///
/// Este observador registra los eventos de navegación en la consola.
class JRouterObserver extends NavigatorObserver {
  final String _unknow = 'Unknown Route';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    JConsole.log('Navigated to "${route.settings.name ?? _unknow}"');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    JConsole.log('Returned from "${route.settings.name ?? _unknow}"');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    JConsole.log('Removed route "${route.settings.name ?? _unknow}"');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    JConsole.log(
        'Replaced "${oldRoute?.settings.name ?? _unknow}" with "${newRoute?.settings.name ?? _unknow}"');
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    JConsole.log('User gesture on "${route.settings.name ?? _unknow}"');
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    JConsole.log('User gesture ended');
  }
}
