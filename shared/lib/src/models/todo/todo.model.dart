import 'package:shared/src/abstract/entity.dart';

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

  @override
  Todo copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
