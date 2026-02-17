import 'dart:typed_data';

import 'package:shared/src/enums/e_attachment_target_type.dart';
import 'package:shared/src/interfaces/models/i_attachment.dart';

/// Todo-specific attachment contract.
///
/// Extends [IAttachment] and exposes a todo-focused alias property.
abstract interface class ITodoAttachment implements IAttachment {
  /// Todo item ID alias for [attachmentTargetId].
  ///
  /// Returns `String`.
  String get todoItemId;

  @override
  ITodoAttachment copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    EAttachmentTargetType? attachmentTargetType,
    String? attachmentTargetId,
    String? todoItemId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? storagePath,
    String? uploadedByUserId,
    Uint8List? blob,
  });
}
