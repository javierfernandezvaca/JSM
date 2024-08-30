import 'package:jsm/jservice/jservice.dart';
import 'package:todos/data/models/todos_model.dart';
import 'package:todos/data/services/todos_service.dart';
import 'package:todos/domain/repositories/todos_repository.dart';

class TodosRepositoryImpl implements TodosRepository {
  final _service = JService.find<TodosService>();

  @override
  Future<List<TodosModel>> fetchTodos() async {
    return _service.todosList.value;
  }

  @override
  Future<void> addTodo(TodosModel todo) async {
    _service.addTodo(todo);
  }

  @override
  Future<void> updateTodo(TodosModel todo) async {
    _service.updateTodo(todo);
  }

  @override
  Future<void> removeTodo(TodosModel todo) async {
    _service.removeTodo(todo);
  }
}
