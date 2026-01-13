import 'package:shared/src/interfaces/i_copyable.dart';

abstract interface class IEntity implements ICopyable<IEntity> {
  String get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;
}
