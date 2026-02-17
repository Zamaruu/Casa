import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/todos/data/provider/todo_attachments_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_attachment.repository.dart';
import 'package:casa/src/features/todos/data/repositories/todo_item.repository.dart';
import 'package:casa/src/features/todos/widgets/tiles/todo_attachment_tile.widget.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoDetailDialog extends ConsumerStatefulWidget {
  final String listId;
  final String itemId;

  const TodoDetailDialog({
    super.key,
    required this.listId,
    required this.itemId,
  });

  @override
  ConsumerState<TodoDetailDialog> createState() => _TodoItemRouteState();
}

class _TodoItemRouteState extends ConsumerState<TodoDetailDialog> {
  late final IMenu menu;

  @override
  void initState() {
    super.initState();
    menu = _setupMenu();
  }

  IMenu _setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: 'Anhang hochladen',
          icon: Icons.upload_file_outlined,
          onTap: _uploadAttachment,
        ),
        MenuItem(
          title: 'Anhänge aktualisieren',
          icon: Icons.refresh,
          onTap: () => ref.invalidate(todoAttachmentsByItemProvider(widget.itemId)),
        ),
      ],
      farItems: [
        MenuItem.icon(
          icon: Icons.info_outline,
          onTap: () {},
        ),
      ],
    );
  }

  Future<void> _uploadAttachment() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(withData: true);
    } catch (e, st) {
      if (mounted) {
        final message = 'Fehler beim Laden der Dateien';

        appLog(message: message, error: e, stackTrace: st);
        CasaSnackbars.showDefaultSnackbar(
          message: message,
          context: context,
          type: ESnackbarType.error,
        );
      }
    }

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final currentUser = ref.read(authUserProvider);
    final userId = currentUser.id.isEmpty ? 'system' : currentUser.id;
    final rawBytes = file.bytes!;

    final attachment = TodoAttachment(
      id: '',
      attachmentTargetType: EAttachmentTargetType.todoItem,
      attachmentTargetId: widget.itemId,
      fileName: file.name,
      mimeType: _guessMimeType(file),
      sizeBytes: file.size,
      uploadedByUserId: userId,
      blob: rawBytes,
    );

    final response = await ref.read(todoAttachmentRepositoryProvider).save(attachment);
    if (!mounted) return;

    if (response.isSuccess) {
      CasaSnackbars.showDefaultSnackbar(
        message: "Anhang '${file.name}' hochgeladen",
        context: context,
        type: ESnackbarType.success,
      );
      ref.invalidate(todoAttachmentsByItemProvider(widget.itemId));
    } else {
      CasaSnackbars.showDefaultSnackbar(
        message: response.message ?? 'Fehler beim Hochladen des Anhangs',
        context: context,
        type: ESnackbarType.error,
      );
    }
  }

  String _guessMimeType(PlatformFile file) {
    final extension = file.extension?.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      case 'md':
        return 'text/markdown';
      case 'json':
        return 'application/json';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<ITodo>>.future(
      title: 'Todo-Details',
      menu: menu,
      showAppBar: false,
      future: ref.read(todoRepositoryProvider).find(widget.itemId),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final item = response.value!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CasaText(item.description.isEmpty ? 'Keine Beschreibung' : item.description),
              const SizedBox(height: 12),
              CasaText('Liste: ${widget.listId}'),
              CasaText('Status: ${item.status.name}'),
              CasaText('Priorität: ${item.priority.name}'),
              CasaText('Erstellt von: ${item.createdByUserId}'),
              if (item.dueDate != null) CasaText('Fällig: ${item.dueDate!.toIso8601String()}'),
              const SizedBox(height: 16),
              const CasaText('Anhänge', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              FutureBuilder<IValueResponse<List<ITodoAttachment>>>(
                future: ref.watch(todoAttachmentsByItemProvider(widget.itemId).future),
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

                      return TodoAttachmentTile(attachment: attachment);
                    },
                  );
                },
              ),
            ],
          );
        }

        return Center(child: CasaText('Kein Todo-Item mit ID ${widget.itemId} gefunden'));
      },
    );
  }
}
