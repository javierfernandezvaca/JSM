import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'package:todos/data/models/todos_model.dart';
import 'todos_controller.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => TodoController(),
      builder: (context, controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Task List'),
          ),
          body: JObserverWidget<List<TodosModel>>(
            observable: controller.todosList,
            onChange: (List<TodosModel> todos) {
              return Center(
                child: SizedBox(
                  width: 480,
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(todos[index].title),
                        subtitle: Text(todos[index].description),
                        leading: Checkbox(
                          value: todos[index].isCompleted,
                          onChanged: (value) {
                            // controller.updateTodoTaskState(index, value!);
                            controller.updateTodoTaskState(
                                todos[index], value!);
                          },
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    controller.onUpdateTodo(todos[index]),
                                splashRadius: 20,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    controller.onRemoveTodo(todos[index]),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.onAddTodo();
            },
            label: const Text('Add Task'),
          ),
        );
      },
    );
  }
}
