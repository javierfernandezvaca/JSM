import 'package:flutter/material.dart';

/// Una clase que representa una ruta en la aplicación.
///
/// Esta clase contiene el nombre de la ruta y el widget que se debe
/// mostrar cuando se navega a la ruta.
class JRoute {
  /// El nombre de la ruta.
  final String route;

  /// El widget que se debe mostrar cuando se navega a la ruta.
  final Widget page;

  /// Crea una ruta nombrada.
  ///
  /// Crea una ruta que se compone por el nombre de la ruta y el widget
  /// asociado que se debe mostrar cuando se navega a la ruta.
  ///
  /// Parámetros:
  /// - `route`: El nombre de la ruta.
  /// - `page`: El widget que se debe mostrar cuando se navega a la ruta.
  ///
  /// Ejemplo:
  /// ```dart
  /// JRoute(route: '/', page: const HomePage()),
  /// JRoute(route: '/login', page: const LoginPage()),
  /// ```
  JRoute({
    required this.route,
    required this.page,
  });
}
