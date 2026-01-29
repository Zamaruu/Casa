import 'package:shared/shared.dart';

abstract class BaseApiRepo<S extends IRepositorySource> implements IRepository {
  @override
  final S source;

  const BaseApiRepo({required this.source});
}
