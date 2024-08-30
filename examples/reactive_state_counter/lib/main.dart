import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'presentation/pages/counter/counter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RSC',
      routes: [
        JRoute(route: '/counter', page: const CounterPage()),
      ],
      initialRoute: '/counter',
    );
  }
}
