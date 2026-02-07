import 'package:shared/src/interfaces/i_copyable.dart';

import 'i_serializable.dart';

abstract interface class IEntity implements ICopyable<IEntity>, ISerializable {
  String get id;

  bool get hasId;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  @override
  IEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}
