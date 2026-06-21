import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/models/todo.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/core/repository/todo/todo_repository.dart';
import 'package:todo/core/repository/todo/todo_repository_impl.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TodoRepositoryImpl(prefs: prefs);
});

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final repo = ref.read(todoRepositoryProvider);
    return repo.getAllTodos();
  }

  Future<void> addTodo(String title) async {
    final repo = ref.read(todoRepositoryProvider);
    await repo.addTodo(Todo(title: title));
    await _refresh();
  }

  Future<void> toggleTodo(int id) async {
    final repo = ref.read(todoRepositoryProvider);
    await repo.toggleTodo(id);
    await _refresh();
  }

  Future<void> updateTodo(Todo todo) async {
    final repo = ref.read(todoRepositoryProvider);
    await repo.updateTodo(todo);
    await _refresh();
  }

  Future<void> deleteTodo(int id) async {
    final repo = ref.read(todoRepositoryProvider);
    await repo.deleteTodo(id);
    await _refresh();
  }

  Future<void> _refresh() async {
    final repo = ref.read(todoRepositoryProvider);
    state = AsyncData(await repo.getAllTodos());
  }
}

final todoListProvider =
    AsyncNotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);
