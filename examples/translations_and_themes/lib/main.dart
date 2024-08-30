import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'internationalization/languages.dart';
import 'presentation/pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T & T',
      locale: const Locale('en', 'US'),
      translations: translations,
      routes: [
        JRoute(route: '/home', page: const HomePage()),
      ],
      initialRoute: '/home',
    );
  }
}
