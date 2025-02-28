import 'package:flutter/material.dart';

/// Clase que representa un idioma y sus traducciones asociadas.
///
/// Esta clase encapsula el código del idioma, el código del país y una lista
/// de traducciones específicas para ese idioma.
class JLanguage {
  /// Código del idioma y código del país.
  ///
  /// Representa el idioma y la región específicos (por ejemplo, `es_ES` para español de España).
  final Locale locale;

  /// Lista de traducciones para este idioma.
  ///
  /// Contiene todas las traducciones disponibles para el idioma especificado.
  final List<JTranslation> translations;

  /// Constructor para la clase `JLanguage`.
  ///
  /// Parámetros:
  /// - [locale]: El código del idioma y código del país.
  /// - [translations]: La lista de traducciones para este idioma.
  ///
  /// Ejemplo:
  /// ```dart
  /// final spanish = JLanguage(
  ///   locale: const Locale('es', 'ES'),
  ///   translations: [
  ///     JTranslation(key: 'hello', value: 'Hola'),
  ///     JTranslation(key: 'goodbye', value: 'Adiós'),
  ///   ],
  /// );
  /// ```
  JLanguage({
    required this.locale,
    required this.translations,
  });
}

/// Clase que representa una traducción individual.
///
/// Esta clase encapsula una clave y su correspondiente valor traducido.
class JTranslation {
  /// Clave de la traducción.
  ///
  /// Es el identificador único de la traducción (por ejemplo, `'hello'`).
  final String key;

  /// Valor de la traducción.
  ///
  /// Es la cadena traducida asociada a la clave (por ejemplo, `'Hola'`).
  final String value;

  /// Constructor para la clase `JTranslation`.
  ///
  /// Parámetros:
  /// - [key]: La clave de la traducción.
  /// - [value]: El valor de la traducción.
  ///
  /// Ejemplo:
  /// ```dart
  /// final translation = JTranslation(key: 'hello', value: 'Hola');
  /// ```
  JTranslation({
    required this.key,
    required this.value,
  });
}
