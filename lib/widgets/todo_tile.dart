import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/models/todo.dart';
import 'package:todo/core/providers/theme/theme_provider.dart';
import 'package:todo/core/providers/todo/todo_provider.dart';
import 'package:todo/core/theme/colors.dart';

class TodoTile extends ConsumerWidget {
  const TodoTile({super.key, required this.todo, this.onTap});

  final Todo todo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final seedColor = seedColors[ref.watch(colorIndexProvider)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            width: 2,
            color: todo.isCompleted
                ? colorScheme.outlineVariant.withValues(alpha: 0.3)
                : seedColor.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) =>
                      ref.read(todoListProvider.notifier).toggleTodo(todo.id),
                  shape: const CircleBorder(),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (todo.description != null &&
                          todo.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            todo.description!
                                .replaceAll(RegExp(r'#+\s?'), '')
                                .split('\n')
                                .first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 20),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () =>
                      ref.read(todoListProvider.notifier).deleteTodo(todo.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
