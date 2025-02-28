import 'package:flutter/material.dart';

import '../jreactive/jextensions.dart';
import '../jreactive/jobservables.dart';

/// Clase centralizada para gestionar las traducciones en la aplicación.
///
/// Esta clase proporciona un mapa de traducciones, una localización predeterminada
/// y una localización observable. También incluye métodos para cambiar la localización
/// actual y acceder a las traducciones.
class JTranslations {
  /// Localización predeterminada de la aplicación.
  ///
  /// Por defecto, se utiliza el idioma inglés (`en_US`).
  static const Locale _defaultLocale = Locale('en', 'US');

  /// Obtiene la localización predeterminada.
  static Locale get defaultLocale => _defaultLocale;

  /// Localización observable que permite reaccionar a cambios en el idioma.
  static final _locale = defaultLocale.observable;

  /// Obtiene la localización observable actual.
  static JObservable<Locale> get locale => _locale;

  /// Obtiene la localización actual.
  static Locale get currentLocale => _locale.value;

  /// Mapa de traducciones organizado por idioma y clave.
  ///
  /// Las claves son combinaciones de idioma y país (por ejemplo, `'es_ES'`), y los valores
  /// son mapas que asocian claves de traducción con sus valores traducidos.
  static Map<String, Map<String, String>> keys = {};

  /// Cambia la localización actual a la proporcionada.
  ///
  /// Este método actualiza la localización observable, lo que desencadena una actualización
  /// en todos los widgets que dependen de la traducción.
  ///
  /// Parámetros:
  /// - [language]: La nueva localización a establecer.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTranslations.changeLocale(const Locale('es', 'ES'));
  /// ```
  static void changeLocale(Locale language) {
    _locale.value = language;
  }
}
