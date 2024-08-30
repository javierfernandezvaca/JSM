import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'home_controller.dart';
import 'widgets/label_widget.dart';
import 'widgets/button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => HomeController(),
      builder: (BuildContext _, HomeController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Modals And Dialogs'),
            actions: [
              JObserverWidget(
                observable: JTheme.currentTheme,
                onChange: (ThemeData theme) {
                  bool isLightTheme = theme == JTheme.lightTheme;
                  return IconButton(
                    onPressed: () {
                      JTheme.toggleTheme();
                    },
                    icon: Icon(
                      isLightTheme
                          ? Icons.mode_night_outlined
                          : Icons.wb_sunny_outlined,
                    ),
                    splashRadius: 20,
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ...
                    const LabelWidget(
                      title: 'SnackBar',
                    ),
                    // ...
                    Row(
                      children: [
                        ButtonWidget(
                          text: 'Material',
                          icon: Icons.android_outlined,
                          onPressed: () => controller.showMaterialSnackBar(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Container()),
                      ],
                    ),
                    // ...
                    const LabelWidget(
                      title: 'Alert',
                    ),
                    // ...
                    Row(
                      children: [
                        ButtonWidget(
                          text: 'Material',
                          icon: Icons.android_outlined,
                          onPressed: () => controller.showMaterialAlertDialog(),
                        ),
                        const SizedBox(width: 16),
                        ButtonWidget(
                          text: 'Cupertino',
                          icon: Icons.apple_outlined,
                          onPressed: () =>
                              controller.showCupertinoAlertDialog(),
                        ),
                      ],
                    ),
                    // ...
                    const LabelWidget(
                      title: 'Confirm',
                    ),
                    // ...
                    Row(
                      children: [
                        ButtonWidget(
                          text: 'Material',
                          icon: Icons.android_outlined,
                          onPressed: () =>
                              controller.showMaterialConfirmDialog(),
                        ),
                        const SizedBox(width: 16),
                        ButtonWidget(
                          text: 'Cupertino',
                          icon: Icons.apple_outlined,
                          onPressed: () =>
                              controller.showCupertinoConfirmDialog(),
                        ),
                      ],
                    ),
                    // ...
                    const LabelWidget(
                      title: 'ActionSheet',
                    ),
                    // ...
                    Row(
                      children: [
                        ButtonWidget(
                          text: 'Material',
                          icon: Icons.android_outlined,
                          onPressed: () => controller.showMaterialActionSheet(),
                        ),
                        const SizedBox(width: 16),
                        ButtonWidget(
                          text: 'Cupertino',
                          icon: Icons.apple_outlined,
                          onPressed: () =>
                              controller.showCupertinoActionSheet(),
                        ),
                      ],
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
