import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/enums/e_todo_priority.dart';
import 'package:shared/src/enums/e_todo_status.dart';
import 'package:shared/src/interfaces/models/i_todo_item.dart';

part 'todo_item.model.g.dart';

@JsonSerializable()
class TodoItem extends Entity implements ITodoItem {
  @override
  final String listId;

  @override
  final String title;

  @override
  final String description;

  @override
  final ETodoStatus status;

  @override
  final ETodoPriority priority;

  @override
  final DateTime? dueDate;

  @override
  final List<String> assignedUserIds;

  @override
  final List<String> attachmentIds;

  @override
  final String createdByUserId;

  const TodoItem({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.listId,
    required this.title,
    this.description = '',
    this.status = ETodoStatus.open,
    this.priority = ETodoPriority.medium,
    this.dueDate,
    this.assignedUserIds = const [],
    this.attachmentIds = const [],
    required this.createdByUserId,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) => _$TodoItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoItemToJson(this);

  @override
  ITodoItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? listId,
    String? title,
    String? description,
    ETodoStatus? status,
    ETodoPriority? priority,
    DateTime? dueDate,
    List<String>? assignedUserIds,
    List<String>? attachmentIds,
    String? createdByUserId,
  }) {
    return TodoItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
      attachmentIds: attachmentIds ?? this.attachmentIds,
      createdByUserId: createdByUserId ?? this.createdByUserId,
    );
  }
}
