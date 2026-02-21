import 'package:shared/src/enums/e_todo_priority.dart';
import 'package:shared/src/enums/e_todo_status.dart';
import 'package:shared/src/interfaces/models/i_entity.dart';

/// Todo item contract representing one actionable task in a todo list.
abstract interface class ITodo implements IEntity {
  /// Parent list ID this item belongs to.
  ///
  /// Returns `String`.
  String get listId;

  /// Short task title.
  ///
  /// Returns `String`.
  String get title;

  /// Detailed task description/content.
  ///
  /// Returns `String`.
  String get description;

  /// Current task status.
  ///
  /// Returns `ETodoStatus`.
  ETodoStatus get status;

  /// Task priority.
  ///
  /// Returns `ETodoPriority`.
  ETodoPriority get priority;

  /// Optional due date/time.
  ///
  /// Returns `DateTime?`.
  DateTime? get dueDate;

  /// Assigned user IDs responsible for this task.
  ///
  /// Returns `List<String>`.
  List<String> get assignedUserIds;

  /// Attachment entity IDs linked to this task.
  ///
  /// Returns `List<String>`.
  List<String> get attachmentIds;

  /// User ID of the creator.
  ///
  /// Returns `String`.
  String get createdByUserId;

  @override
  /// Creates a copy with selectively overridden todo item fields.
  ITodo copyWith({
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
  });
}
