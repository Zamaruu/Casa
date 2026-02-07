import 'package:shared/src/interfaces/i_entity.dart';

abstract class Entity implements IEntity {
  @override
  final String id;

  @override
  final DateTime? createdAt;

  @override
  final DateTime? updatedAt;

  const Entity({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool get hasId => id.isNotEmpty;
}
