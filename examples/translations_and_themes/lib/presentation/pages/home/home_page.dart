import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => HomeController(),
      builder: (BuildContext _, HomeController controller) {
        return Scaffold(
          appBar: AppBar(
            title: 'TranslationsAndThemes'.translate((str) => Text(str)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        JTheme.toggleTheme();
                      },
                      child: JObserverWidget(
                        observable: JTheme.currentTheme,
                        onChange: (ThemeData theme) {
                          bool isLightTheme = theme == JTheme.lightTheme;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                isLightTheme
                                    ? Icons.mode_night_outlined
                                    : Icons.wb_sunny_outlined,
                              ),
                              const SizedBox(width: 10),
                              'ChangeTheme'.translate((str) => Text(str)),
                            ],
                          );
                        },
                      ),
                    ),
                    // ...
                    const SizedBox(height: 5),
                    // ...
                    ElevatedButton(
                      onPressed: () {
                        controller.showLanguageSelectionSheet();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.translate,
                          ),
                          const SizedBox(width: 10),
                          'SelectIdiom'.translate((str) => Text(str)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    'John-3:16'.translate((value) => Text(value)),
                    const SizedBox(height: 16),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Text('John 3:16 (RVR1960)')),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.showMessage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.message_outlined,
                          ),
                          const SizedBox(width: 10),
                          'ShowMessage'.translate((str) => Text(str)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
