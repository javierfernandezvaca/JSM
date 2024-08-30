import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'package:chat/services/firebase.dart';
import 'package:chat/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JService.start<FirebaseService>(FirebaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHAT',
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
