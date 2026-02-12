import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/logs/data/interfaces/i_errorlog.api.dart';
import 'package:shared/shared.dart';

class ErrorLogRepoSource extends TypedRepoSource<IErrorLog, IErrorLogApi> {
  const ErrorLogRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class ErrorLogRepo extends TypedCacheRepo<IErrorLog, IErrorLogApi> {
  ErrorLogRepo({required super.source});
}
