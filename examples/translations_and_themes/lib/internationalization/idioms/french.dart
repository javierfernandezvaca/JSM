import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var french = JLanguage(
  locale: const Locale('fr', 'FR'),
  translations: [
    JTranslation(key: 'TranslationsAndThemes', value: 'Traductions et Thèmes'),
    JTranslation(key: 'ChangeTheme', value: 'Changer le Thème'),
    JTranslation(key: 'SelectIdiom', value: 'Sélectionner Langue'),
    JTranslation(key: 'ShowMessage', value: 'Afficher le message'),
    JTranslation(key: 'English', value: 'Anglais'),
    JTranslation(key: 'German', value: 'Allemand'),
    JTranslation(key: 'Spanish', value: 'Espagnol'),
    JTranslation(key: 'French', value: 'Français'),
    JTranslation(key: 'Portuguese', value: 'Portugais'),
    JTranslation(key: 'Russian', value: 'Russe'),
    JTranslation(key: 'Chinese', value: 'Chinois'),
    JTranslation(key: 'Cancel', value: 'Annuler'),
    JTranslation(
        key: 'John-3:16',
        value:
            "Car Dieu a tant aimé le monde qu'il a donné son Fils unique, afin que quiconque croit en lui ne périsse pas mais ait la vie éternelle."),
  ],
);
