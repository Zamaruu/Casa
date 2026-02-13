import 'package:shared/shared.dart';

/// Base repository contract that exposes its backing data source.
abstract interface class IRepository {
  /// Repository source implementation used for data access.
  ///
  /// Returns `IRepositorySource`.
  IRepositorySource get source;
}
