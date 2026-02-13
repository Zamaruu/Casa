import 'package:shared/src/enums/e_attachment_target_type.dart';
import 'package:shared/src/interfaces/models/i_entity.dart';

/// Generic attachment contract reusable across multiple feature domains.
abstract interface class IAttachment implements IEntity {
  /// Domain type this attachment belongs to (todo, calendar event, recipe).
  ///
  /// Returns `EAttachmentTargetType`.
  EAttachmentTargetType get attachmentTargetType;

  /// ID of the concrete domain entity this attachment is linked to.
  ///
  /// Returns `String`.
  String get attachmentTargetId;

  /// Original file name.
  ///
  /// Returns `String`.
  String get fileName;

  /// MIME type of the attachment content.
  ///
  /// Returns `String`.
  String get mimeType;

  /// File size in bytes.
  ///
  /// Returns `int`.
  int get sizeBytes;

  /// Storage location/path resolved by the active storage backend.
  ///
  /// Returns `String`.
  String get storagePath;

  /// User ID of the uploader.
  ///
  /// Returns `String`.
  String get uploadedByUserId;

  @override
  /// Creates a copy with selectively overridden attachment fields.
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
  /// Parameter `fileName`:
  /// Optional replacement for the file name.
  ///
  /// Parameter `mimeType`:
  /// Optional replacement for the MIME type.
  ///
  /// Parameter `sizeBytes`:
  /// Optional replacement for the size in bytes.
  ///
  /// Parameter `storagePath`:
  /// Optional replacement for persisted storage path.
  ///
  /// Parameter `uploadedByUserId`:
  /// Optional replacement for uploader user ID.
  ///
  /// Returns `IAttachment`.
  IAttachment copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    EAttachmentTargetType? attachmentTargetType,
    String? attachmentTargetId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? storagePath,
    String? uploadedByUserId,
  });
}
