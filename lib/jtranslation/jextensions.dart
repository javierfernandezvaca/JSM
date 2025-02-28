import 'jtranslation.dart';

/// Extensión de la clase `String` para proporcionar una función de traducción.
///
/// Esta extensión añade el getter `tr` a la clase `String`, que permite obtener
/// la traducción de una cadena al idioma actual. Si no se encuentra una traducción,
/// se devuelve la cadena original.
extension TranslateExtensionString on String {
  /// Devuelve la traducción de la cadena al idioma actual.
  ///
  /// Este método busca la traducción en el mapa de traducciones utilizando el
  /// idioma y el país actuales. Si no se encuentra una traducción específica para
  /// el idioma y país, se intenta buscar solo por el idioma. Si tampoco se encuentra,
  /// se devuelve la cadena original.
  ///
  /// Ejemplo:
  /// ```dart
  /// final greeting = 'hello'.tr; // Retorna "Hola" si el idioma es español.
  /// ```
  String get tr {
    String languageCode = JTranslations.locale.value.languageCode;
    String? countryCode = JTranslations.locale.value.countryCode;
    final key = '${languageCode}_$countryCode';
    if (JTranslations.keys.containsKey(key) &&
        JTranslations.keys[key]!.containsKey(this)) {
      return JTranslations.keys[key]![this]!;
    }
    if (JTranslations.keys.containsKey(languageCode) &&
        JTranslations.keys[languageCode]!.containsKey(this)) {
      return JTranslations.keys[languageCode]![this]!;
    }
    return this;
  }
}
