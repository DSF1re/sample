import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/models/todo.dart';
import 'package:todo/core/repository/todo/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required this.prefs});
  final SharedPreferences prefs;

  static const _key = 'todos';

  @override
  Future<List<Todo>> getAllTodos() async {
    final json = prefs.getString(_key);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getAllTodos();
    todos.add(todo);
    await _save(todos);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todos = await getAllTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await _save(todos);
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    final todos = await getAllTodos();
    todos.removeWhere((t) => t.id == id);
    await _save(todos);
  }

  @override
  Future<void> toggleTodo(int id) async {
    final todos = await getAllTodos();
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(isCompleted: !todos[index].isCompleted);
      await _save(todos);
    }
  }

  Future<void> _save(List<Todo> todos) async {
    final json = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_key, json);
  }
}
