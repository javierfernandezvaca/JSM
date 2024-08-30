import 'package:todos/data/models/todos_model.dart';

abstract class TodosRepository {
  Future<List<TodosModel>> fetchTodos();
  Future<void> addTodo(TodosModel todo);
  Future<void> updateTodo(TodosModel todo);
  Future<void> removeTodo(TodosModel todo);
}
