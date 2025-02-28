import 'package:flutter/material.dart';

import '../jreactive/jobservables.dart';

/// Clase para gestionar el tema de la aplicación.
///
/// Esta clase proporciona una interfaz centralizada para cambiar, obtener y
/// restablecer el tema de la aplicación en tiempo de ejecución. Utiliza un
/// `JObservable` para permitir que los widgets reaccionen automáticamente a
/// los cambios de tema.
///
/// Los temas predeterminados son el tema claro (`ThemeData.light`) y el tema
/// oscuro (`ThemeData.dark`) proporcionados por Flutter.
class JTheme {
  /// El tema actual de la aplicación.
  ///
  /// Este es un `JObservable` que permite a los widgets escuchar los cambios
  /// en el tema. Cuando el valor de `currentTheme` cambia, todos los widgets
  /// que dependen de él se actualizan automáticamente.
  static final currentTheme = JObservable<ThemeData>(_lightTheme);

  /// Cambia el tema actual de la aplicación.
  ///
  /// Este método actualiza el valor del `JObservable` `currentTheme` al nuevo
  /// tema proporcionado. Todos los widgets que dependen de `currentTheme`
  /// se actualizarán automáticamente.
  ///
  /// Parámetros:
  /// - [theme]: El nuevo tema a establecer.
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
  /// Este método cambia el valor del `JObservable` `currentTheme` al tema
  /// opuesto (claro ↔ oscuro). Si el tema actual es claro, se cambia a oscuro,
  /// y viceversa.
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
  /// Este getter devuelve el tema claro configurado actualmente. Por defecto,
  /// es `ThemeData.light()`, pero puede ser personalizado mediante el setter
  /// `lightTheme`.
  ///
  /// Ejemplo:
  /// ```dart
  /// var lightTheme = JTheme.lightTheme;
  /// ```
  static ThemeData get lightTheme => _lightTheme;

  /// Tema claro predeterminado.
  ///
  /// Este es el tema claro inicial de la aplicación. Puede ser modificado
  /// mediante el setter `lightTheme`.
  static ThemeData _lightTheme = ThemeData.light();

  /// Establece un nuevo tema claro.
  ///
  /// Este setter permite personalizar el tema claro de la aplicación. Si el
  /// tema actual es el tema claro, también se actualizará automáticamente.
  ///
  /// Parámetros:
  /// - [theme]: El nuevo tema claro a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.lightTheme = ThemeData(
  ///   primarySwatch: Colors.blue,
  /// );
  /// ```
  static set lightTheme(ThemeData theme) {
    _lightTheme = theme;
    if (currentTheme.value == _lightTheme) {
      currentTheme.value = theme;
    }
  }

  /// Obtiene el tema oscuro actual.
  ///
  /// Este getter devuelve el tema oscuro configurado actualmente. Por defecto,
  /// es `ThemeData.dark()`, pero puede ser personalizado mediante el setter
  /// `darkTheme`.
  ///
  /// Ejemplo:
  /// ```dart
  /// var darkTheme = JTheme.darkTheme;
  /// ```
  static ThemeData get darkTheme => _darkTheme;

  /// Tema oscuro predeterminado.
  ///
  /// Este es el tema oscuro inicial de la aplicación. Puede ser modificado
  /// mediante el setter `darkTheme`.
  static ThemeData _darkTheme = ThemeData.dark();

  /// Establece un nuevo tema oscuro.
  ///
  /// Este setter permite personalizar el tema oscuro de la aplicación. Si el
  /// tema actual es el tema oscuro, también se actualizará automáticamente.
  ///
  /// Parámetros:
  /// - [theme]: El nuevo tema oscuro a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTheme.darkTheme = ThemeData(
  ///   brightness: Brightness.dark,
  ///   primaryColor: Colors.teal,
  /// );
  /// ```
  static set darkTheme(ThemeData theme) {
    _darkTheme = theme;
    if (currentTheme.value == _darkTheme) {
      currentTheme.value = theme;
    }
  }

  /// Restablece los temas claro y oscuro a sus valores predeterminados.
  ///
  /// Este método restablece los temas claro y oscuro a `ThemeData.light()` y
  /// `ThemeData.dark()`, respectivamente. También actualiza el tema actual
  /// al tema claro predeterminado.
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
