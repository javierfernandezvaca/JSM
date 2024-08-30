import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';
import 'package:translations_and_themes/internationalization/languages.dart';

class HomeController extends JController {
  void showLanguageSelectionSheet() {
    final languageName = {
      'zh': 'Chinese'.tr,
      'en': 'English'.tr,
      'fr': 'French'.tr,
      'de': 'German'.tr,
      'pt': 'Portuguese'.tr,
      'ru': 'Russian'.tr,
      'es': 'Spanish'.tr,
    };
    // ...
    JDialog.cupertinoActionSheet(
      actions: translations.map((JLanguage language) {
        return CupertinoActionSheetAction(
          child: Text(languageName[language.locale.languageCode]!),
          onPressed: () {
            JTranslations.changeLocale(language.locale);
          },
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr,
          style: const TextStyle(color: Colors.red),
        ),
        onPressed: () {},
      ),
    );
  }

  void showMessage() {
    JDialog.snackBar(content: Text('John-3:16'.tr));
  }
}
