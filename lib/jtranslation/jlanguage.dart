import 'package:flutter/material.dart';

/// Una clase que representa un idioma.
///
/// Esta clase contiene el código del idioma y el código del país y una
/// lista de traducciones para este idioma.
class JLanguage {
  /// Código del idioma y código del país.
  final Locale locale;

  /// Lista de traducciones para este idioma.
  final List<JTranslation> translations;

  /// Constructor para la clase `JLanguage`.
  ///
  /// Parámetros:
  ///   `locale`: El código del idioma y código del país.
  ///   `translations`: La lista de traducciones para este idioma.
  JLanguage({
    required this.locale,
    required this.translations,
  });
}

/// Una clase que representa una traducción.
///
/// Esta clase contiene la clave de la traducción y el valor de la
/// traducción, que es la traducción de la clave al idioma especificado.
class JTranslation {
  /// Clave de la traducción.
  final String key;

  /// Valor de la traducción; cadena que es la traducción de la clave al
  /// idioma especificado.
  final String value;

  /// Constructor para la clase `JTranslation`.
  ///
  /// Parámetros:
  ///   `key`: La clave de la traducción.
  ///   `value`: El valor de la traducción.
  JTranslation({
    required this.key,
    required this.value,
  });
}
