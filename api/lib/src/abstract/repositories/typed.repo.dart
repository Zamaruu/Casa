import 'package:api/src/abstract/repositories/base.repo.dart';
import 'package:shared/shared.dart';

abstract class TypedApiRepo<T extends IEntity> extends BaseApiRepo implements ITypedRepository<T> {
  const TypedApiRepo({required super.source});
}
