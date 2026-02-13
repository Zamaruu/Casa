import 'package:casa/src/features/todos/data/provider/todo_attachments_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_item.repository.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoItemRoute extends ConsumerWidget {
  final String listId;
  final String itemId;

  const TodoItemRoute({
    super.key,
    required this.listId,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<ITodoItem>>.future(
      title: 'Todo-Details',
      future: ref.read(todoItemRepositoryProvider).find(itemId),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final item = response.value!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CasaText(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CasaText(item.description.isEmpty ? 'Keine Beschreibung' : item.description),
              const SizedBox(height: 12),
              CasaText('Liste: $listId'),
              CasaText('Status: ${item.status.name}'),
              CasaText('Priorität: ${item.priority.name}'),
              CasaText('Erstellt von: ${item.createdByUserId}'),
              if (item.dueDate != null) CasaText('Fällig: ${item.dueDate!.toIso8601String()}'),
              const SizedBox(height: 16),
              const CasaText('Anhänge', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              FutureBuilder<IValueResponse<List<ITodoAttachment>>>(
                future: ref.watch(todoAttachmentsByItemProvider(itemId).future),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final attachmentResponse = snapshot.data;

                  if (attachmentResponse == null || attachmentResponse.isError || attachmentResponse.hasValue == false) {
                    return const CasaText('Anhänge konnten nicht geladen werden');
                  }

                  final attachments = attachmentResponse.value!;

                  if (attachments.isEmpty) {
                    return const CasaText('Keine Anhänge vorhanden');
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attachments.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final attachment = attachments[index];

                      return CasaTile(
                        leading: const Icon(Icons.attach_file),
                        title: CasaText(attachment.fileName),
                        subtitle: CasaText('${attachment.mimeType} | ${attachment.sizeBytes} Bytes'),
                        thirdTitle: CasaText('Pfad: ${attachment.storagePath}'),
                      );
                    },
                  );
                },
              ),
            ],
          );
        }

        return Center(child: CasaText('Kein Todo-Item mit ID $itemId gefunden'));
      },
    );
  }
}
