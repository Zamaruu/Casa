import 'package:casa_api/src/abstract/repositories/repo_source.dart';
import 'package:shared/shared.dart';

abstract class TypedRepoSource<T extends IEntity> extends ApiRepoSource {
  final IDefaultEntityOperations<T> operations;

  const TypedRepoSource({
    required super.user,
    required this.operations,
  });
}
