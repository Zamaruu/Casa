import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/home/data/provider/home_todos_provider.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';

class HomeRoute extends ConsumerWidget {
  const HomeRoute({super.key});

  static const int _maxItemsPerSection = 6;

  String _formatDueDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<ITodo> todos,
    bool showDueDate = false,
  }) {
    final visibleTodos = todos.take(_maxItemsPerSection).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CasaText(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (visibleTodos.isEmpty)
              const CasaText('Keine Einträge')
            else
              ...visibleTodos.map((todo) {
                final subtitleParts = <String>[
                  if (showDueDate && todo.dueDate != null)
                    'Fällig: ${_formatDueDate(todo.dueDate!)}',
                  'Priorität: ${todo.priority.name}',
                  'Status: ${todo.status.name}',
                ];

                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: CasaText(todo.title),
                  subtitle: CasaText(subtitleParts.join(' | ')),
                  onTap: () => CasaNavigator.go(
                    context,
                    '/todos/${todo.listId}?itemId=${todo.id}',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeTodosAsync = ref.watch(homeTodosSectionsProvider);

    return CasaScaffold(
      title: "Home",
      builder: (context, ref, layout) {
        return homeTodosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: CasaText('Fehler beim Laden der Home-Daten: $error'),
          ),
          data: (sections) {
            return ListView(
              children: [
                _buildSection(
                  context: context,
                  title: 'Due Todos',
                  todos: sections.dueTodos,
                  showDueDate: true,
                ),
                _buildSection(
                  context: context,
                  title: 'Recently Assigned Todos',
                  todos: sections.recentlyAssignedTodos,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
