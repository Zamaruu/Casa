import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/enums/e_attachment_target_type.dart';
import 'package:shared/src/interfaces/models/i_todo_attachment.dart';

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
  final String storagePath;

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
    required this.storagePath,
    required this.uploadedByUserId,
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
    );
  }
}
