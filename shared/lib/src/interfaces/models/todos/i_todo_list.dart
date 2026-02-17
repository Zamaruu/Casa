import 'package:shared/src/interfaces/models/i_entity.dart';

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

  @override
  /// Creates a copy with selectively overridden todo list fields.
  ///
  /// Parameter `id`:
  /// Optional replacement for list ID.
  ///
  /// Parameter `createdAt`:
  /// Optional replacement for creation timestamp.
  ///
  /// Parameter `updatedAt`:
  /// Optional replacement for update timestamp.
  ///
  /// Parameter `name`:
  /// Optional replacement for list name.
  ///
  /// Parameter `description`:
  /// Optional replacement for list description.
  ///
  /// Parameter `ownerUserId`:
  /// Optional replacement for owner user ID.
  ///
  /// Parameter `memberUserIds`:
  /// Optional replacement for member user IDs.
  ///
  /// Parameter `isShared`:
  /// Optional replacement for sharing state.
  ///
  /// Returns `ITodoList`.
  ITodoList copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
    String? ownerUserId,
    List<String>? memberUserIds,
    bool? isShared,
  });
}
