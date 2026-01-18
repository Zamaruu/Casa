import 'package:casa/src/app/abstract/repository/repo_source.dart';

abstract class BaseRepo {
  final RepoSource source;

  const BaseRepo({required this.source});
}
