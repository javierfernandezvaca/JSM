import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var portuguese = JLanguage(
  locale: const Locale('pt', 'BR'),
  translations: [
    JTranslation(key: 'TranslationsAndThemes', value: 'Traduções e Temas'),
    JTranslation(key: 'ChangeTheme', value: 'Alterar Tema'),
    JTranslation(key: 'SelectIdiom', value: 'Selecionar Idioma'),
    JTranslation(key: 'ShowMessage', value: 'Mostrar mensagem'),
    JTranslation(key: 'English', value: 'Inglês'),
    JTranslation(key: 'German', value: 'Alemão'),
    JTranslation(key: 'Spanish', value: 'Espanhol'),
    JTranslation(key: 'French', value: 'Francês'),
    JTranslation(key: 'Portuguese', value: 'Português'),
    JTranslation(key: 'Russian', value: 'Russo'),
    JTranslation(key: 'Chinese', value: 'Chinês'),
    JTranslation(key: 'Cancel', value: 'Cancelar'),
    JTranslation(
        key: 'John-3:16',
        value:
            'Porque Deus amou o mundo de tal maneira que deu o seu Filho Unigénito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.'),
  ],
);
