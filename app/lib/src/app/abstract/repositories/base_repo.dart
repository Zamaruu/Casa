import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:shared/shared.dart';

abstract class BaseRepo implements IRepository {
  final RepoSource source;

  const BaseRepo({required this.source});
}
