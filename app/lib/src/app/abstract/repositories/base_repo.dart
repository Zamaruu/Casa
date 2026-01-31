import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:shared/shared.dart';

abstract class BaseRepo<S extends RepoSource> implements IRepository {
  @override
  final S source;

  const BaseRepo({required this.source});

  Future<IResponse> runGuarded<R extends IResponse>(Future<R> Function() action) async {
    try {
      return await action();
    } catch (e, st) {
      final message = "runGuarded catched an unexpected error in $runtimeType.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  Future<R> runGuardedValue<R extends IValueResponse>(Future<R> Function() action) async {
    try {
      return await action();
    } catch (e, st) {
      final message = "runGuardedValue catched an unexpected error in $runtimeType.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st) as R;
    }
  }
}
