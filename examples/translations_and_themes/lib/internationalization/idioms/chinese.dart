import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

var chinese = JLanguage(
  locale: const Locale('zh', 'CN'),
  translations: [
    JTranslation(key: 'TranslationsAndThemes', value: '翻译和主题'),
    JTranslation(key: 'ChangeTheme', value: '更改主题'),
    JTranslation(key: 'SelectIdiom', value: '选择语言'),
    JTranslation(key: 'ShowMessage', value: '显示留言'),
    JTranslation(key: 'English', value: '英语'),
    JTranslation(key: 'German', value: '德语'),
    JTranslation(key: 'Spanish', value: '西班牙语'),
    JTranslation(key: 'French', value: '法语'),
    JTranslation(key: 'Portuguese', value: '葡萄牙语'),
    JTranslation(key: 'Russian', value: '俄语'),
    JTranslation(key: 'Chinese', value: '中文'),
    JTranslation(key: 'Cancel', value: '取消'),
    JTranslation(
        key: 'John-3:16', value: '神爱世人，甚至将他的独生子赐给他们，叫一切信他的，不至灭亡，反得永生。'),
  ],
);
