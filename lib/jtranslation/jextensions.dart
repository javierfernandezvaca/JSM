import 'jtranslation.dart';

/// Extensión de la clase String para proporcionar una función
/// de traducción.
///
/// Esta extensión añade el getter `tr` a la clase `String`, que
/// devuelve la traducción de la cadena al idioma actual.
extension TranslateExtensionString on String {
  /// Devuelve la traducción de la cadena al idioma actual.
  ///
  /// Si no se encuentra una traducción para la cadena en el idioma
  /// actual, se devuelve la cadena original.
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
