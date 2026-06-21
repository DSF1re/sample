import 'package:todo/core/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
  Future<void> toggleTodo(int id);
}
