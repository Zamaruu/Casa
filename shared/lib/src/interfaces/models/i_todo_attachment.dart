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
  /// Creates a copy with selectively overridden todo attachment fields.
  ///
  /// Parameter `id`:
  /// Optional replacement for attachment ID.
  ///
  /// Parameter `createdAt`:
  /// Optional replacement for creation timestamp.
  ///
  /// Parameter `updatedAt`:
  /// Optional replacement for update timestamp.
  ///
  /// Parameter `attachmentTargetType`:
  /// Optional replacement for target domain type.
  ///
  /// Parameter `attachmentTargetId`:
  /// Optional replacement for target entity ID.
  ///
  /// Parameter `todoItemId`:
  /// Optional todo-specific alias for `attachmentTargetId`.
  ///
  /// Parameter `fileName`:
  /// Optional replacement for file name.
  ///
  /// Parameter `mimeType`:
  /// Optional replacement for MIME type.
  ///
  /// Parameter `sizeBytes`:
  /// Optional replacement for file size in bytes.
  ///
  /// Parameter `storagePath`:
  /// Optional replacement for storage path.
  ///
  /// Parameter `uploadedByUserId`:
  /// Optional replacement for uploader user ID.
  ///
  /// Returns `ITodoAttachment`.
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
  });
}
