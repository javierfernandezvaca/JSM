import 'package:flutter/material.dart';

import 'jroute.dart';

/// Una clase que proporciona métodos para la navegación entre rutas.
///
/// Esta clase contiene una lista de rutas y proporciona métodos para
/// navegar entre ellas.
class JRouter {
  /// Una clave global para el estado del navegador.
  ///
  /// Esta clave se utiliza para acceder al estado del navegador desde
  /// cualquier parte de la aplicación.
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  /// Devuelve los argumentos de la ruta actual.
  ///
  /// Este método toma un contexto y devuelve los argumentos de la ruta
  /// actual como un mapa.
  static Map<dynamic, dynamic> arguments(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? {};
    return args as Map;
  }

  /// La ruta inicial por defecto de la aplicación.
  static String initialRoute = '/';

  /// Una lista de todas las rutas de la aplicación.
  static List<JRoute> get routes => _routes;
  static final List<JRoute> _routes = <JRoute>[];

  /// Convierte la lista de rutas en un mapa de rutas.
  ///
  /// Este método toma un contexto y devuelve un mapa donde las claves
  /// son los nombres de las rutas y los valores son las funciones de
  /// construcción de los widgets de las rutas.
  ///
  /// Parámetros:
  ///   `ctx`: El contexto del widget.
  ///
  /// Ejemplo:
  /// ```dart
  /// var mapRutas = routesToMap(context);
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
  /// Este método toma un resultado opcional y navega hacia atrás en la
  /// pila de navegación, devolviendo el resultado si se proporciona.
  ///
  /// Parámetros:
  ///   `result`: El resultado a devolver al navegar hacia atrás. Es opcional.
  ///
  /// Ejemplo:
  /// ```dart
  /// back<String>(result: 'resultado');
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
  /// Este método toma el nombre de la ruta, los argumentos opcionales
  /// y los parámetros opcionales, y navega a la ruta.
  ///
  /// Parámetros:
  ///   `page`: El nombre de la ruta a la que se va a navegar.
  ///   `arguments`: Los argumentos a pasar a la ruta. Es opcional.
  ///   `parameters`: Los parámetros a pasar a la ruta. Es opcional.
  ///
  /// Ejemplo:
  /// ```dart
  /// toNamed<String>(
  ///   page: '/ruta',
  ///   arguments: 'argumentos',
  ///   parameters: {'clave': 'valor'}
  /// );
  /// ```
  static Future<T?>? toNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    if (_routes.any((route) => route.route == page)) {
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
    } else {
      throw Exception('No route found with the specified name');
    }
  }

  /// Reemplaza la ruta actual con una nueva ruta por su nombre.
  ///
  /// Este método toma el nombre de la nueva ruta, los argumentos
  /// opcionales y los parámetros opcionales, y reemplaza la ruta
  /// actual con la nueva ruta.
  ///
  /// Parámetros:
  ///   `page`: El nombre de la nueva ruta.
  ///   `arguments`: Los argumentos a pasar a la nueva ruta. Es opcional.
  ///   `parameters`: Los parámetros a pasar a la nueva ruta. Es opcional.
  ///
  /// Ejemplo:
  /// ```dart
  /// offNamed<String>(
  ///   page: '/nuevaRuta',
  ///   arguments: 'argumentos',
  ///   parameters: {'clave': 'valor'}
  /// );
  /// ```
  static Future<T?>? offNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    if (_routes.any((route) => route.route == page)) {
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
    } else {
      throw Exception('No route found with the specified name');
    }
  }

  /// Navega hacia atrás en la pila de navegación y luego a una
  /// nueva ruta por su nombre.
  ///
  /// Este método toma el nombre de la nueva ruta, los argumentos
  /// opcionales, los parámetros opcionales y un resultado opcional,
  /// navega hacia atrás en la pila de navegación, devolviendo el
  /// resultado si se proporciona, y luego navega a la nueva ruta.
  ///
  /// Parámetros:
  ///   `page`: El nombre de la nueva ruta.
  ///   `arguments`: Los argumentos a pasar a la nueva ruta. Es opcional.
  ///   `parameters`: Los parámetros a pasar a la nueva ruta. Es opcional.
  ///   `result`: El resultado a devolver al navegar hacia atrás. Es opcional.
  ///
  /// Ejemplo:
  /// ```dart
  /// offAndToNamed<String>(
  ///   page: '/nuevaRuta',
  ///   arguments: 'argumentos',
  ///   parameters: {'clave': 'valor'},
  ///   result: 'resultado'
  /// );
  /// ```
  static Future<T?>? offAndToNamed<T>({
    required String page,
    dynamic arguments,
    Map<String, String>? parameters,
    dynamic result,
  }) {
    if (_routes.any((route) => route.route == page)) {
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
    } else {
      throw Exception('No route found with the specified name');
    }
  }

  /// Elimina todas las rutas de la pila de navegación y navega a
  /// una nueva ruta por su nombre.
  ///
  /// Este método toma el nombre de la nueva ruta, los argumentos
  /// opcionales y los parámetros opcionales, elimina todas las rutas
  /// de la pila de navegación y luego navega a la nueva ruta.
  ///
  /// Parámetros:
  ///   `newRouteName`: El nombre de la nueva ruta.
  ///   `arguments`: Los argumentos a pasar a la nueva ruta. Es opcional.
  ///   `parameters`: Los parámetros a pasar a la nueva ruta. Es opcional.
  ///
  /// Ejemplo:
  /// ```dart
  /// offAllNamed<String>(
  ///   newRouteName: '/nuevaRuta',
  ///   arguments: 'argumentos',
  ///   parameters: {'clave': 'valor'}
  /// );
  /// ```
  static Future<T?>? offAllNamed<T>({
    required String newRouteName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    if (_routes.any((route) => route.route == newRouteName)) {
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
    } else {
      throw Exception('No route found with the specified name');
    }
  }
}
