import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var russian = JLanguage(
  locale: const Locale('ru', 'RU'),
  translations: [
    JTranslation(key: 'TranslationsAndThemes', value: 'Переводы и Темы'),
    JTranslation(key: 'ChangeTheme', value: 'Изменить Тему'),
    JTranslation(key: 'SelectIdiom', value: 'Выбрать Язык'),
    JTranslation(key: 'ShowMessage', value: 'Показать сообщение'),
    JTranslation(key: 'English', value: 'Английский'),
    JTranslation(key: 'German', value: 'Немецкий'),
    JTranslation(key: 'Spanish', value: 'Испанский'),
    JTranslation(key: 'French', value: 'Французский'),
    JTranslation(key: 'Portuguese', value: 'Португальский'),
    JTranslation(key: 'Russian', value: 'Русский'),
    JTranslation(key: 'Chinese', value: 'Китайский'),
    JTranslation(key: 'Cancel', value: 'Отмена'),
    JTranslation(
        key: 'John-3:16',
        value:
            'Ибо так возлюбил Бог мир, что отдал Сына Своего Единородного, чтобы всякий верующий в Него не погиб, но имел жизнь вечную.'),
  ],
);
