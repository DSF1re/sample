import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/models/todo.dart';
import 'package:todo/core/providers/todo/todo_provider.dart';

class DetailScreen extends HookConsumerWidget {
  const DetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    final todo = todosAsync.asData?.value.cast<Todo?>().firstWhere((t) => t!.id == id);

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Задача не найдена')),
      );
    }

    return _DetailView(todo: todo);
  }
}

class _DetailView extends StatefulHookConsumerWidget {
  const _DetailView({required this.todo});
  final Todo todo;

  @override
  ConsumerState<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<_DetailView> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _isPreview = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _bodyController = TextEditingController(text: widget.todo.description ?? '');
    _titleController.addListener(_onChanged);
    _bodyController.addListener(_onChanged);
    if (widget.todo.description != null && widget.todo.description!.isNotEmpty) {
      _isPreview = true;
    }
  }

  void _onChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onChanged);
    _bodyController.removeListener(_onChanged);
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_hasChanges) return;
    final updated = widget.todo.copyWith(
      title: _titleController.text.trim().isEmpty
          ? widget.todo.title
          : _titleController.text.trim(),
      description: _bodyController.text.isEmpty ? null : _bodyController.text,
    );
    await ref.read(todoListProvider.notifier).updateTodo(updated);
    _hasChanges = false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _save();
        if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _save();
              if (context.mounted) Navigator.pop(context);
            },
          ),
          title: TextField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
          actions: [
            IconButton(
              icon: Icon(_isPreview ? Icons.edit : Icons.visibility),
              onPressed: () => setState(() => _isPreview = !_isPreview),
              tooltip: _isPreview ? 'Редактировать' : 'Предпросмотр',
            ),
          ],
        ),
        body: _isPreview ? _buildPreview(colorScheme) : _buildEditor(colorScheme),
      ),
    );
  }

  Widget _buildEditor(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _bodyController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Напишите заметку в Markdown...',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerLowest,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPreview(ColorScheme colorScheme) {
    final body = _bodyController.text.isEmpty ? '*Пустая заметка*' : _bodyController.text;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Markdown(
        data: body,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          h3: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          p: TextStyle(fontSize: 15, height: 1.5, color: colorScheme.onSurface),
          code: TextStyle(
            fontSize: 13,
            fontFamily: 'monospace',
            color: colorScheme.primary,
            backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
          ),
          codeblockDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(left: BorderSide(color: colorScheme.primary, width: 3)),
            color: colorScheme.primaryContainer.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
