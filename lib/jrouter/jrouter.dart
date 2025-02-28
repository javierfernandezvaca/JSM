import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

/// Clase centralizada para gestionar la navegación entre rutas en la aplicación.
///
/// Esta clase proporciona métodos para navegar entre rutas, validar guardas,
/// y gestionar la pila de navegación. También incluye una lista de rutas registradas
/// y una clave global para acceder al estado del navegador desde cualquier parte
/// de la aplicación.
class JRouter {
  /// Una clave global para el estado del navegador.
  ///
  /// Esta clave se utiliza para acceder al estado del navegador (`NavigatorState`)
  /// desde cualquier parte de la aplicación. Es esencial para realizar operaciones
  /// de navegación programática.
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  /// Devuelve los argumentos de la ruta actual como un mapa.
  ///
  /// Este método toma un contexto y extrae los argumentos pasados a la ruta actual.
  /// Si no se proporcionan argumentos, devuelve un mapa vacío.
  ///
  /// Parámetros:
  /// - [context]: El contexto del widget desde donde se accede a los argumentos.
  ///
  /// Ejemplo:
  /// ```dart
  /// final args = JRouter.arguments(context);
  /// final userId = args['userId'];
  /// ```
  static Map<dynamic, dynamic> arguments(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? {};
    return args as Map;
  }

  /// La ruta inicial por defecto de la aplicación.
  ///
  /// Esta propiedad define la ruta inicial de la aplicación. Por defecto, se establece
  /// como `'/'`, pero puede ser personalizada según las necesidades de la aplicación.
  static String initialRoute = '/';

  /// Una lista de todas las rutas registradas en la aplicación.
  ///
  /// Esta lista contiene todas las rutas definidas mediante instancias de `JRoute`.
  /// Cada ruta incluye su nombre, el widget asociado y una lista opcional de guardas.
  static List<JRoute> get routes => _routes;
  static final List<JRoute> _routes = <JRoute>[];

  /// Convierte la lista de rutas en un mapa de rutas.
  ///
  /// Este método transforma la lista de rutas en un mapa donde las claves son los nombres
  /// de las rutas y los valores son funciones que construyen los widgets asociados.
  /// Esto es útil para configurar el `MaterialApp.routes` o `MaterialApp.onGenerateRoute`.
  ///
  /// Parámetros:
  /// - [ctx]: El contexto del widget (no utilizado directamente, pero necesario para compatibilidad).
  ///
  /// Ejemplo:
  /// ```dart
  /// final appRoutes = JRouter.routesToMap(context);
  /// MaterialApp(
  ///   routes: appRoutes,
  /// );
  /// ```
  static Map<String, Widget Function(BuildContext)> routesToMap(
      BuildContext ctx) {
    final appRoutes = <String, WidgetBuilder>{};
    for (var route in _routes) {
      appRoutes[route.route] = (ctx) => route.page;
    }
    return appRoutes;
  }

  /// Navega hacia atrás en la pila de navegación.
  ///
  /// Este método permite regresar a la ruta anterior en la pila de navegación.
  /// Opcionalmente, puede devolver un resultado a la ruta anterior.
  ///
  /// Parámetros:
  /// - [result]: El resultado a devolver al navegar hacia atrás (opcional).
  ///
  /// Ejemplo:
  /// ```dart
  /// JRouter.back(result: 'Operación completada');
  /// ```
  static void back<T>({
    T? result,
  }) {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop<T>(result);
    } else {
      throw Exception('No previous route in the Navigator stack');
    }
  }

  /// Navega a una ruta por su nombre.
  ///
  /// Este método navega a una ruta específica utilizando su nombre. Antes de navegar,
  /// valida las guardas asociadas con la ruta. Si alguna guarda falla, la navegación
  /// se cancela.
  ///
  /// Parámetros:
  /// - [page]: El nombre de la ruta a la que se desea navegar.
  /// - [arguments]: Argumentos opcionales que se pasan a la ruta.
  /// - [parameters]: Parámetros opcionales que se adjuntan como query parameters.
  ///
  /// Ejemplo:
  /// ```dart
  /// await JRouter.toNamed(
  ///   page: '/profile',
  ///   arguments: {'userId': 123},
  ///   parameters: {'tab': 'settings'},
  /// );
  /// ```
  static Future<T?>? toNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (!await _validateGuards(navigatorKey.currentState!.context, page)) {
      return null;
    }
    if (parameters != null) {
      final uri = Uri(
        path: page,
        queryParameters: parameters,
      );
      page = uri.toString();
    }
    return _navigatorKey.currentState!.pushNamed<T>(
      page,
      arguments: arguments,
    );
  }

  /// Reemplaza la ruta actual con una nueva ruta por su nombre.
  ///
  /// Este método reemplaza la ruta actual en la pila de navegación con una nueva ruta.
  /// Antes de navegar, valida las guardas asociadas con la ruta. Si alguna guarda falla,
  /// la navegación se cancela.
  ///
  /// Parámetros:
  /// - [page]: El nombre de la nueva ruta.
  /// - [arguments]: Argumentos opcionales que se pasan a la nueva ruta.
  /// - [parameters]: Parámetros opcionales que se adjuntan como query parameters.
  ///
  /// Ejemplo:
  /// ```dart
  /// await JRouter.offNamed(
  ///   page: '/dashboard',
  ///   arguments: {'projectId': 456},
  /// );
  /// ```
  static Future<T?>? offNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (!await _validateGuards(navigatorKey.currentState!.context, page)) {
      return null;
    }
    if (parameters != null) {
      final uri = Uri(
        path: page,
        queryParameters: parameters,
      );
      page = uri.toString();
    }
    return _navigatorKey.currentState!.pushReplacementNamed(
      page,
      arguments: arguments,
    );
  }

  /// Navega hacia atrás en la pila de navegación y luego a una nueva ruta por su nombre.
  ///
  /// Este método combina dos acciones: primero navega hacia atrás en la pila de navegación
  /// (devolviendo un resultado opcional), y luego navega a una nueva ruta.
  ///
  /// Parámetros:
  /// - [page]: El nombre de la nueva ruta.
  /// - [arguments]: Argumentos opcionales que se pasan a la nueva ruta.
  /// - [parameters]: Parámetros opcionales que se adjuntan como query parameters.
  /// - [result]: Resultado opcional que se devuelve al navegar hacia atrás.
  ///
  /// Ejemplo:
  /// ```dart
  /// await JRouter.offAndToNamed(
  ///   page: '/home',
  ///   result: 'Logout successful',
  /// );
  /// ```
  static Future<T?>? offAndToNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
    dynamic result,
  }) async {
    if (!await _validateGuards(navigatorKey.currentState!.context, page)) {
      return null;
    }
    if (parameters != null) {
      final uri = Uri(
        path: page,
        queryParameters: parameters,
      );
      page = uri.toString();
    }
    return _navigatorKey.currentState!.popAndPushNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  /// Elimina todas las rutas de la pila de navegación y navega a una nueva ruta por su nombre.
  ///
  /// Este método limpia completamente la pila de navegación y navega a una nueva ruta.
  /// Antes de navegar, valida las guardas asociadas con la ruta. Si alguna guarda falla,
  /// la navegación se cancela.
  ///
  /// Parámetros:
  /// - [newRouteName]: El nombre de la nueva ruta.
  /// - [arguments]: Argumentos opcionales que se pasan a la nueva ruta.
  /// - [parameters]: Parámetros opcionales que se adjuntan como query parameters.
  ///
  /// Ejemplo:
  /// ```dart
  /// await JRouter.offAllNamed(
  ///   newRouteName: '/login',
  /// );
  /// ```
  static Future<T?>? offAllNamed<T>({
    required String newRouteName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (!await _validateGuards(
        navigatorKey.currentState!.context, newRouteName)) {
      return null;
    }
    if (parameters != null) {
      final uri = Uri(
        path: newRouteName,
        queryParameters: parameters,
      );
      newRouteName = uri.toString();
    }
    return _navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      newRouteName,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Valida las guardas asociadas con una ruta.
  ///
  /// Este método privado verifica si todas las guardas asociadas con una ruta permiten
  /// la navegación. Si alguna guarda falla, registra un mensaje de error en la consola
  /// y cancela la navegación.
  ///
  /// Parámetros:
  /// - [context]: El contexto del widget desde donde se intenta navegar.
  /// - [page]: El nombre de la ruta a validar.
  ///
  /// Retorna:
  /// - `true` si todas las guardas pasan, `false` si alguna falla.
  static Future<bool> _validateGuards(BuildContext context, String page) async {
    final route = _routes.firstWhere((r) => r.route == page,
        orElse: () => JRoute(route: 'undefined', page: Container()));
    if (route.route == 'undefined') {
      throw Exception('No route found with the specified name');
    }
    for (final guard in route.guards) {
      final canNavigate = await guard.canActivate(context, page);
      if (!canNavigate) {
        JConsole.info('Guard "${guard.guardName}" failed for route "$page"');
        JConsole.error('Reason: ${guard.failureMessage}');
        // Cancelar la navegación
        return false;
      }
    }
    return true;
  }
}
