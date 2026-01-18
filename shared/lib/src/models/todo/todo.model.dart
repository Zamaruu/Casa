import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/abstract/entity.dart';

part 'todo.model.g.dart';

@JsonSerializable()
class Todo extends Entity {
  final String userId;

  final String title;

  final String description;

  final DateTime? dueDate;

  final bool completed;

  final List<String> tagIds;

  final List<String> childIds;

  const Todo({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.title,
    this.description = "",
    this.dueDate,
    this.completed = false,
    this.tagIds = const [],
    this.childIds = const [],
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  Todo copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    List<String>? tagIds,
    List<String>? childIds,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      tagIds: tagIds ?? this.tagIds,
      childIds: childIds ?? this.childIds,
    );
  }
}
