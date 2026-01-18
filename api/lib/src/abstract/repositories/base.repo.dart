import 'package:api/src/abstract/repositories/repo_source.dart';
import 'package:shared/shared.dart';

abstract class BaseApiRepo implements IRepository {
  @override
  final ApiRepoSource source;

  const BaseApiRepo({required this.source});
}
