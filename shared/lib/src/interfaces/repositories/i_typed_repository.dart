import 'package:shared/shared.dart';

/// Typed repository contract combining a data source and default entity
/// operations for a specific entity type `T`.
abstract interface class ITypedRepository<T extends IEntity> implements IRepository, IDefaultEntityOperations<T> {}
