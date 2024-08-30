import 'package:flutter/material.dart';

import '../jreactive/jobservables.dart';

/// Una clase para gestionar el tema de la aplicación.
///
/// Esta clase proporciona métodos y propiedades para cambiar y obtener el
/// tema actual de la aplicación. Los temas se pueden cambiar en tiempo de
/// ejecución.
///
/// Los temas predeterminados son el tema claro y el tema oscuro
/// proporcionados por Flutter.
class JTheme {
  /// El tema actual de la aplicación.
  ///
  /// Este es un `JObservable` que permite a los widgets escuchar los
  /// cambios en el tema.
  static final currentTheme = JObservable<ThemeData>(_lightTheme);

  /// Cambia el tema actual de la aplicación.
  ///
  /// Este método cambia el valor del `JObservable` `currentTheme`.
  ///
  /// Parámetros:
  ///   `theme`: El nuevo tema a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.changeTheme(ThemeData.dark());
  /// ```
  static void changeTheme(ThemeData theme) {
    currentTheme.value = theme;
  }

  /// Alterna entre el tema claro y oscuro.
  ///
  /// Este método cambia el valor del `JObservable` `currentTheme` al
  /// tema opuesto.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.toggleTheme();
  /// ```
  static void toggleTheme() {
    if (currentTheme.value == _lightTheme) {
      currentTheme.value = _darkTheme;
    } else {
      currentTheme.value = _lightTheme;
    }
  }

  /// Obtiene el tema claro actual.
  ///
  /// Ejemplo:
  /// ```dart
  /// var temaClaro = JTheme.lightTheme;
  /// ```
  static ThemeData get lightTheme => _lightTheme;
  static final _lightTheme = ThemeData.light();

  /// Establece un nuevo tema claro.
  ///
  /// Parámetros:
  ///   `theme`: El nuevo tema claro a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.lightTheme = ThemeData.light();
  /// ```
  static set lightTheme(ThemeData theme) {
    lightTheme = theme;
  }

  /// Obtiene el tema oscuro actual.
  ///
  /// Ejemplo:
  /// ```dart
  /// var temaOscuro = JTheme.darkTheme;
  /// ```
  static ThemeData get darkTheme => _darkTheme;
  static final _darkTheme = ThemeData.dark();

  /// Establece un nuevo tema oscuro.
  ///
  /// Parámetros:
  ///   `theme`: El nuevo tema oscuro a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.darkTheme = ThemeData.dark();
  /// ```
  static set darkTheme(ThemeData theme) {
    darkTheme = theme;
  }
}
