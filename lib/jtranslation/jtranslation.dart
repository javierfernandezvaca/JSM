import 'package:flutter/material.dart';

import '../jreactive/jextensions.dart';
import '../jreactive/jobservables.dart';

/// Una clase que proporciona funciones para la gestión de
/// las traducciones.
///
/// Esta clase contiene un mapa de traducciones, una localización por
/// defecto y una localización observable. También proporciona una
/// función para cambiar la localización.
class JTranslations {
  static const Locale _defaultLocale = Locale('en', 'US');
  static Locale get defaultLocale => _defaultLocale;

  static final _locale = defaultLocale.observable;
  static JObservable<Locale> get locale => _locale;
  static Locale get currentLocale => _locale.value;

  static Map<String, Map<String, String>> keys = {};

  /// Cambia el lenguaje actual al proporcionado.
  ///
  /// Parámetros:
  ///   `language`: El nuevo lenguaje.
  static void changeLocale(Locale language) {
    _locale.value = language;
  }
}
