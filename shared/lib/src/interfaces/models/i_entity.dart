import 'package:shared/src/interfaces/misc/i_copyable.dart';

import '../misc/i_serializable.dart';

/// Base contract for persisted entities with identity and timestamps.
abstract interface class IEntity implements ICopyable<IEntity>, ISerializable {
  /// Stable unique identifier of the entity.
  ///
  /// Returns `String`.
  String get id;

  /// Indicates whether this entity already has a persisted identifier.
  ///
  /// Returns `bool`.
  bool get hasId;

  /// Timestamp when the entity was first created.
  ///
  /// Returns `DateTime?`.
  DateTime? get createdAt;

  /// Timestamp when the entity was last updated.
  ///
  /// Returns `DateTime?`.
  DateTime? get updatedAt;

  @override
  IEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}
