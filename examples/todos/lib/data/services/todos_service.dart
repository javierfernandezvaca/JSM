import 'package:jsm/jsm.dart';
import 'package:todos/data/models/todos_model.dart';

class TodosService extends JService {
  final todosList = <TodosModel>[].observable;

  @override
  Future<void> onInit() async {
    await loadTodos();
  }

  @override
  Future<void> onClose() async {}

  Future<void> loadTodos() async {
    // ...
  }

  void addTodo(TodosModel todo) {
    todosList.value.add(todo);
    todosList.refresh();
  }

  void updateTodo(TodosModel todo) {
    int index = todosList.value.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todosList.value[index] = todo;
      todosList.refresh();
    }
  }

  void removeTodo(TodosModel todo) {
    todosList.value.remove(todo);
    todosList.refresh();
  }
}
