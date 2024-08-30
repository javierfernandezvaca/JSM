import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'views/game_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      initialRoute: '/game',
      routes: [
        JRoute(route: '/game', page: const GameView()),
      ],
    );
  }
}
