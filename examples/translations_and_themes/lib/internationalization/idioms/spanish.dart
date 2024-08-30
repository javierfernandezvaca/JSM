import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var spanish = JLanguage(
  locale: const Locale('es', 'ES'),
  translations: [
    JTranslation(key: 'TranslationsAndThemes', value: 'Traducciones y Temas'),
    JTranslation(key: 'ChangeTheme', value: 'Cambiar Tema'),
    JTranslation(key: 'SelectIdiom', value: 'Seleccionar Idioma'),
    JTranslation(key: 'ShowMessage', value: 'Mostrar Mensaje'),
    JTranslation(key: 'English', value: 'Inglés'),
    JTranslation(key: 'German', value: 'Alemán'),
    JTranslation(key: 'Spanish', value: 'Español'),
    JTranslation(key: 'French', value: 'Francés'),
    JTranslation(key: 'Portuguese', value: 'Portugués'),
    JTranslation(key: 'Russian', value: 'Ruso'),
    JTranslation(key: 'Chinese', value: 'Chino'),
    JTranslation(key: 'Cancel', value: 'Cancelar'),
    JTranslation(
        key: 'John-3:16',
        value:
            'Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna.'),
  ],
);
