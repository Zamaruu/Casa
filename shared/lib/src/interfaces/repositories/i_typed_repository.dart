import 'package:shared/shared.dart';

abstract interface class ITypedRepository<T extends IEntity> implements IRepository, IDefaultEntityOperations<T> {}
