import 'package:flutter/material.dart';

import '../jreactive/jwidgets.dart';
import 'jextensions.dart';
import 'jtranslation.dart';

/// Widget que muestra la traducción de una cadena.
///
/// Este widget observa la localización actual y muestra la traducción de una cadena
/// al idioma actual. Utiliza la extensión `tr` de la clase `String` para obtener la traducción.
class JTranslateWidget extends StatelessWidget {
  /// La cadena que se va a traducir.
  final String text;

  /// Una función que se llama cuando cambia la traducción.
  ///
  /// Esta función recibe la traducción actualizada como parámetro.
  final Widget Function(String value) onChange;

  /// Constructor para la clase `JTranslateWidget`.
  ///
  /// Parámetros:
  /// - [text]: La cadena que se va a traducir.
  /// - [onChange]: La función que se llama cuando cambia la traducción.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTranslateWidget(
  ///   text: 'hello',
  ///   onChange: (translatedText) => Text(translatedText),
  /// );
  /// ```
  const JTranslateWidget({
    super.key,
    required this.text,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return JObserverWidget<Locale>(
      observable: JTranslations.locale,
      onChange: (locale) {
        String translation = text.tr;
        return onChange(translation);
      },
    );
  }
}

/// Extensión de la clase `String` para proporcionar una función de traducción en un widget.
///
/// Esta extensión añade el método `translate` a la clase `String`, que devuelve un
/// `JTranslateWidget` para la cadena.
extension JTranslateWidgetExtension on String {
  /// Devuelve un `JTranslateWidget` para la cadena.
  ///
  /// Parámetros:
  /// - [builder]: Una función que se llama cuando cambia la traducción.
  ///
  /// Ejemplo:
  /// ```dart
  /// 'hello'.translate((translatedText) => Text(translatedText));
  /// ```
  Widget translate(Widget Function(String value) builder) {
    return JTranslateWidget(
      text: this,
      onChange: builder,
    );
  }
}

// ...

/// Widget que muestra las traducciones de una lista de cadenas.
///
/// Este widget observa la localización actual y muestra las traducciones de una lista
/// de cadenas al idioma actual. Utiliza la extensión `tr` de la clase `String` para
/// obtener las traducciones.
class JTranslateMultipleWidget extends StatelessWidget {
  /// La lista de cadenas que se van a traducir.
  final List<String> texts;

  /// Una función que se llama cuando cambian las traducciones.
  ///
  /// Esta función recibe la lista de traducciones actualizadas como parámetro.
  final Widget Function(List<String> values) onChange;

  /// Constructor para la clase `JTranslateMultipleWidget`.
  ///
  /// Parámetros:
  /// - [texts]: La lista de cadenas que se van a traducir.
  /// - [onChange]: La función que se llama cuando cambian las traducciones.
  ///
  /// Ejemplo:
  /// ```dart
  /// JTranslateMultipleWidget(
  ///   texts: ['hello', 'goodbye'],
  ///   onChange: (translatedTexts) => Column(
  ///     children: translatedTexts.map((text) => Text(text)).toList(),
  ///   ),
  /// );
  /// ```
  const JTranslateMultipleWidget({
    super.key,
    required this.texts,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return JObserverWidget<Locale>(
      observable: JTranslations.locale,
      onChange: (locale) {
        final list = <String>[];
        for (int i = 0; i < texts.length; ++i) {
          list.add(texts[i].tr);
        }
        return onChange(list);
      },
    );
  }
}

/// Extensión de la clase `List<String>` para proporcionar una función de traducción en un widget.
///
/// Esta extensión añade el método `translateList` a la clase `List<String>`, que devuelve
/// un `JTranslateMultipleWidget` para la lista de cadenas.
extension JTranslateMultipleWidgetExtension on List<String> {
  /// Devuelve un `JTranslateMultipleWidget` para la lista de cadenas.
  ///
  /// Parámetros:
  /// - [builder]: Una función que se llama cuando cambian las traducciones.
  ///
  /// Ejemplo:
  /// ```dart
  /// ['hello', 'goodbye'].translateList((translatedTexts) => Column(
  ///   children: translatedTexts.map((text) => Text(text)).toList(),
  /// ));
  /// ```
  Widget translateList(Widget Function(List<String> values) builder) {
    return JTranslateMultipleWidget(
      texts: this,
      onChange: builder,
    );
  }
}
