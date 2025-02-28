import 'package:flutter/material.dart';

/// Interfaz base para implementar guardas de rutas en la aplicación.
///
/// Esta interfaz define métodos y propiedades que deben ser implementados
/// por cualquier clase que actúe como guarda de rutas. Los guardas se utilizan
/// para controlar el acceso a ciertas rutas en función de condiciones específicas,
/// como autenticación o permisos.
abstract class JRouteGuard {
  /// Determina si se permite la navegación a una ruta específica.
  ///
  /// Este método debe ser implementado por cada guarda para definir su lógica
  /// de validación. Retorna `true` si se permite la navegación, o `false` si no.
  ///
  /// Parámetros:
  /// - [context]: El contexto del widget desde donde se intenta navegar.
  /// - [route]: El nombre de la ruta a la que se intenta navegar.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// Future<bool> canActivate(BuildContext context, String route) async {
  ///   final isAuthenticated = await AuthService.isAuthenticated();
  ///   return isAuthenticated;
  /// }
  /// ```
  Future<bool> canActivate(BuildContext context, String route);

  /// Mensaje que se muestra cuando el guarda falla.
  ///
  /// Este mensaje se utiliza para informar al usuario sobre el motivo por el cual
  /// no se le permite acceder a la ruta. Debe ser claro y descriptivo.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// String get failureMessage => 'Debes iniciar sesión para acceder a esta página.';
  /// ```
  String get failureMessage;

  /// Nombre único de la guarda para identificación.
  ///
  /// Este nombre se utiliza para identificar la guarda en el sistema. Debe ser único
  /// entre todas las guardas registradas.
  ///
  /// Ejemplo:
  /// ```dart
  /// @override
  /// String get guardName => 'AuthGuard';
  /// ```
  String get guardName;
}

/// Clase que representa una ruta en la aplicación.
///
/// Esta clase encapsula el nombre de una ruta y el widget asociado que se debe
/// mostrar cuando se navega a dicha ruta. También permite asociar una lista de
/// guardas (`JRouteGuard`) para controlar el acceso a la ruta.
class JRoute {
  /// El nombre de la ruta.
  ///
  /// Este es el identificador único de la ruta dentro de la aplicación. Se utiliza
  /// para navegar hacia esta ruta.
  final String route;

  /// El widget que se debe mostrar cuando se navega a la ruta.
  ///
  /// Este es el contenido principal de la ruta. Generalmente, es un widget de página
  /// (por ejemplo, `Scaffold` o `StatefulWidget`).
  final Widget page;

  /// Lista de guardas asociadas a esta ruta.
  ///
  /// Estas guardas se utilizan para controlar el acceso a la ruta. Antes de navegar
  /// a la ruta, se evalúan todas las guardas en orden. Si alguna guarda falla, la
  /// navegación se cancela y se muestra el mensaje de error correspondiente.
  final List<JRouteGuard> guards;

  /// Crea una nueva instancia de una ruta nombrada.
  ///
  /// Parámetros:
  /// - [route]: El nombre de la ruta. Debe ser único dentro de la aplicación.
  /// - [page]: El widget que se debe mostrar cuando se navega a la ruta.
  /// - [guards]: Lista opcional de guardas para controlar el acceso a la ruta.
  ///
  /// Ejemplo:
  /// ```dart
  /// JRoute(
  ///   route: '/home',
  ///   page: const HomePage(),
  ///   guards: [AuthGuard()],
  /// );
  /// ```
  JRoute({
    required this.route,
    required this.page,
    this.guards = const [],
  });
}
