import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/abstract/entity.dart';

part 'todo_list.model.g.dart';

@JsonSerializable()
class TodoList extends Entity implements ITodoList {
  @override
  final String name;

  @override
  final String description;

  @override
  final String ownerUserId;

  @override
  final List<String> memberUserIds;

  @override
  final bool isShared;

  @override
  final List<ITodo> todos;

  const TodoList({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.description = '',
    required this.ownerUserId,
    this.memberUserIds = const [],
    this.isShared = false,
    this.todos = const [],
  });

  factory TodoList.fromJson(Map<String, dynamic> json) => _$TodoListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoListToJson(this);

  @override
  ITodoList copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
    String? ownerUserId,
    List<String>? memberUserIds,
    bool? isShared,
    List<ITodo>? todos,
  }) {
    return TodoList(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      memberUserIds: memberUserIds ?? this.memberUserIds,
      isShared: isShared ?? this.isShared,
      todos: todos ?? this.todos,
    );
  }
}
