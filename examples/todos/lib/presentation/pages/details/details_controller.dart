import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';
import 'package:todos/data/models/todos_model.dart';

class DetailsController extends JController {
  bool edition = false;
  final title = TextEditingController();
  final description = TextEditingController();
  final completed = false.observable;

  late TodosModel todo;

  @override
  void onInit() {
    edition = arguments['edition'];
    if (edition) {
      todo = arguments['todo'] as TodosModel;
      title.text = todo.title;
      description.text = todo.description;
      completed.value = todo.isCompleted;
    }
  }

  void addTodo() {
    if (title.text.trim().isEmpty || description.text.trim().isEmpty) {
      JDialog.snackBar(
        content: const Text('The title and description are required.'),
      );
    } else {
      final currentDateTime = DateTime.now();
      final newTodo = TodosModel(
        id: edition ? todo.id : JUtils.generateUniqueID(),
        title: title.text.trim(),
        description: description.text.trim(),
        isCompleted: completed.value,
        createdAt: edition ? todo.createdAt : currentDateTime,
        updatedAt: currentDateTime,
      );
      JRouter.back(result: {
        'todo': newTodo,
      });
    }
  }
}
