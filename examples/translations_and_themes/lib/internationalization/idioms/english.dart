import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var english = JLanguage(
  locale: const Locale('en', 'US'),
  translations: [
    JTranslation(
        key: 'TranslationsAndThemes', value: 'Translations And Themes'),
    JTranslation(key: 'ChangeTheme', value: 'Change Theme'),
    JTranslation(key: 'SelectIdiom', value: 'Select Idiom'),
    JTranslation(key: 'ShowMessage', value: 'Show Message'),
    JTranslation(key: 'English', value: 'English'),
    JTranslation(key: 'German', value: 'German'),
    JTranslation(key: 'Spanish', value: 'Spanish'),
    JTranslation(key: 'French', value: 'French'),
    JTranslation(key: 'Portuguese', value: 'Portuguese'),
    JTranslation(key: 'Russian', value: 'Russian'),
    JTranslation(key: 'Chinese', value: 'Chinese'),
    JTranslation(key: 'Cancel', value: 'Cancel'),
    JTranslation(
        key: 'John-3:16',
        value:
            'For God so loved the world that he gave his only begotten Son, that whoever believes in him should not perish but have everlasting life.'),
  ],
);
