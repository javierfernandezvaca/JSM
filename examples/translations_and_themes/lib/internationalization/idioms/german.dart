import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var german = JLanguage(
  locale: const Locale('de', 'DE'),
  translations: [
    JTranslation(
        key: 'TranslationsAndThemes', value: 'Übersetzungen und Themen'),
    JTranslation(key: 'ChangeTheme', value: 'Design ändern'),
    JTranslation(key: 'SelectIdiom', value: 'Wählen Sie Sprache aus'),
    JTranslation(key: 'ShowMessage', value: 'Nachricht anzeigen'),
    JTranslation(key: 'English', value: 'Englisch'),
    JTranslation(key: 'German', value: 'Deutsch'),
    JTranslation(key: 'Spanish', value: 'Spanisch'),
    JTranslation(key: 'French', value: 'Französisch'),
    JTranslation(key: 'Portuguese', value: 'Portugiesisch'),
    JTranslation(key: 'Russian', value: 'Russisch'),
    JTranslation(key: 'Chinese', value: 'Chinesisch'),
    JTranslation(key: 'Cancel', value: 'Stornieren'),
    JTranslation(
        key: 'John-3:16',
        value:
            'Denn Gott hat die Welt so sehr geliebt, dass er seinen eingeborenen Sohn gab, damit jeder, der an ihn glaubt, nicht verloren geht, sondern ewiges Leben hat.'),
  ],
);
