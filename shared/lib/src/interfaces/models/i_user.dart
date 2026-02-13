import 'package:shared/src/interfaces/models/i_entity.dart';

/// User domain contract shared between app and API layers.
abstract interface class IUser implements IEntity {
  /// User email address used for identity and login.
  ///
  /// Returns `String`.
  String get email;

  /// Public username/display login identifier.
  ///
  /// Returns `String`.
  String get username;

  /// Persisted password hash value.
  ///
  /// Returns `String`.
  String get passwordHash;

  /// List of assigned group/role identifiers.
  ///
  /// Returns `List<String>`.
  List<String> get groups;

  /// Whether the user account is active and allowed to authenticate.
  ///
  /// Returns `bool`.
  bool get isActive;

  @override
  /// Creates a copy with selectively overridden user fields.
  ///
  /// Parameter `id`:
  /// Optional replacement for the user ID.
  ///
  /// Parameter `email`:
  /// Optional replacement for the user email.
  ///
  /// Parameter `username`:
  /// Optional replacement for the username.
  ///
  /// Parameter `groups`:
  /// Optional replacement for assigned role/group names.
  ///
  /// Parameter `passwordHash`:
  /// Optional replacement for the stored password hash.
  ///
  /// Parameter `createdAt`:
  /// Optional replacement for creation timestamp.
  ///
  /// Parameter `updatedAt`:
  /// Optional replacement for update timestamp.
  ///
  /// Parameter `isActive`:
  /// Optional replacement for account activation state.
  ///
  /// Returns `IUser`.
  IUser copyWith({
    String? id,
    String? email,
    String? username,
    List<String>? groups,
    String? passwordHash,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });

  /// Convenience flag indicating whether the user belongs to an admin group.
  ///
  /// Returns `bool`.
  bool get isAdmin;
}
