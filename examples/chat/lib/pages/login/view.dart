import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return JPage(
      create: () => LoginController(),
      builder: (context, controller) {
        return Scaffold(
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              controller.onExitApp();
              if (didPop) {
                return;
              }
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CHAT',
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.chat_outlined,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.onSignIn();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 10),
                        Text('Continue with Google'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
