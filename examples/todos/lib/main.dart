import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';
import 'package:todos/presentation/pages/details/details_page.dart';
import 'package:todos/presentation/pages/todos/todos_page.dart';
import 'package:todos/data/services/todos_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ...
  await JService.start<TodosService>(TodosService());
  // ...
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODOS',
      routes: [
        JRoute(route: '/todos', page: const TodoPage()),
        JRoute(route: '/details', page: const DetailsPage()),
      ],
      initialRoute: '/todos',
    );
  }
}
