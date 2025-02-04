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
  static ThemeData _lightTheme = ThemeData.light();

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
    _lightTheme = theme;
    if (currentTheme.value == _lightTheme) {
      currentTheme.value = theme;
    }
  }

  /// Obtiene el tema oscuro actual.
  ///
  /// Ejemplo:
  /// ```dart
  /// var temaOscuro = JTheme.darkTheme;
  /// ```
  static ThemeData get darkTheme => _darkTheme;
  static ThemeData _darkTheme = ThemeData.dark();

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
    _darkTheme = theme;
    if (currentTheme.value == _darkTheme) {
      currentTheme.value = theme;
    }
  }

  /// Restablece los temas claro y oscuro a sus valores predeterminados.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.resetThemes();
  /// ```
  static void resetThemes() {
    _lightTheme = ThemeData.light();
    _darkTheme = ThemeData.dark();
    if (currentTheme.value == _lightTheme || currentTheme.value == _darkTheme) {
      // Restablece al tema claro por defecto
      currentTheme.value = _lightTheme;
    }
  }
}
