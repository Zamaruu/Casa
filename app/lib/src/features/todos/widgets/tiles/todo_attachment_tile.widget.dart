import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TodoAttachmentTile extends StatelessWidget {
  final ITodoAttachment attachment;

  const TodoAttachmentTile({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return CasaTile(
      leading: const Icon(Icons.attach_file),
      title: CasaText(attachment.fileName),
      subtitle: CasaText('${attachment.mimeType} | ${attachment.sizeBytes} Bytes'),
      thirdTitle: CasaText('Pfad: ${attachment.storagePath}'),
    );
  }
}
