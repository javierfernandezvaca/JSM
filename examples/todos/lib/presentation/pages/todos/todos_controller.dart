import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'package:todos/data/models/todos_model.dart';
import 'package:todos/domain/repositories/todos_repository_impl.dart';

class TodoController extends JController {
  final todosList = <TodosModel>[].observable;
  final todoRepository = TodosRepositoryImpl();

  @override
  void onInit() async {
    fetchTodos();
  }

  @override
  void onClose() {}

  void fetchTodos() async {
    final todos = await todoRepository.fetchTodos();
    todosList.value.clear();
    todosList.value.addAll(todos);
    todosList.refresh();
  }

  void onAddTodo() async {
    final result = await JRouter.toNamed(
      page: '/details',
      arguments: {
        'edition': false,
        'todo': null,
      },
    );
    if (result != null) {
      final todo = result['todo'] as TodosModel;
      todoRepository.addTodo(todo);
      fetchTodos();
    }
  }

  void onUpdateTodo(TodosModel todo) async {
    final result = await JRouter.toNamed(
      page: '/details',
      arguments: {
        'edition': true,
        'todo': todo,
      },
    );
    if (result != null) {
      final todo = result['todo'] as TodosModel;
      todoRepository.updateTodo(todo);
      fetchTodos();
    }
  }

  void updateTodoTaskState(TodosModel todo, bool isCompleted) {
    todo.isCompleted = isCompleted;
    todoRepository.updateTodo(todo);
    fetchTodos();
  }

  void onRemoveTodo(TodosModel todo) async {
    JDialog.materialConfirmationDialog(
        title: const Text('Delete Task'),
        content: const Text('Do you want to delete the task?'),
        confirmLabel: const Text('OK'),
        cancelLabel: const Text('Cancel'),
        onConfirm: () {
          todoRepository.removeTodo(todo);
          fetchTodos();
        });
  }

  // ...
}
