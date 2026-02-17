import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/converters/uint8list.converter.dart';

part 'todo_attachment.model.g.dart';

@JsonSerializable()
class TodoAttachment extends Entity implements ITodoAttachment {
  @override
  final EAttachmentTargetType attachmentTargetType;

  @override
  final String attachmentTargetId;

  @override
  final String fileName;

  @override
  final String mimeType;

  @override
  final int sizeBytes;

  @override
  @Uint8ListConverter()
  final Uint8List blob;

  @override
  final String? storagePath;

  @override
  final String uploadedByUserId;

  const TodoAttachment({
    required super.id,
    super.createdAt,
    super.updatedAt,
    this.attachmentTargetType = EAttachmentTargetType.todoItem,
    required this.attachmentTargetId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.storagePath,
    required this.uploadedByUserId,
    required this.blob,
  });

  @override
  String get todoItemId => attachmentTargetId;

  factory TodoAttachment.fromJson(Map<String, dynamic> json) => _$TodoAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoAttachmentToJson(this);

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
  }) {
    return TodoAttachment(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachmentTargetType: attachmentTargetType ?? this.attachmentTargetType,
      attachmentTargetId: todoItemId ?? attachmentTargetId ?? this.attachmentTargetId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      storagePath: storagePath ?? this.storagePath,
      uploadedByUserId: uploadedByUserId ?? this.uploadedByUserId,
      blob: blob ?? this.blob,
    );
  }
}
