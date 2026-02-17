import 'dart:typed_data';

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
  String? get storagePath;

  /// Byte encoded content of the attachment.
  ///
  /// Returns `Uint8List`.
  Uint8List get blob;

  /// User ID of the uploader.
  ///
  /// Returns `String`.
  String get uploadedByUserId;

  @override
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
    Uint8List? blob,
    String? uploadedByUserId,
  });
}
