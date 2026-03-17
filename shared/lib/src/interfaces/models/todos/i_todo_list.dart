import 'package:shared/shared.dart';

/// Todo list contract representing a personal or shared task container.
abstract interface class ITodoList implements IEntity {
  /// Display name of the todo list.
  ///
  /// Returns `String`.
  String get name;

  /// Optional description of the list purpose.
  ///
  /// Returns `String`.
  String get description;

  /// User ID of the list owner.
  ///
  /// Returns `String`.
  String get ownerUserId;

  /// User IDs allowed to access this list.
  ///
  /// Returns `List<String>`.
  List<String> get memberUserIds;

  /// Whether the list is shared (`true`) or private (`false`).
  ///
  /// Returns `bool`.
  bool get isShared;

  /// List of todos in the list.
  ///
  /// Returns `List<ITodo>`.
  /// Will be empty by default and can either be filled by api query argument or manually by setting the list property in app state.
  List<ITodo> get todos;

  /// Creates a copy with selectively overridden todo list fields.
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
  });
}
