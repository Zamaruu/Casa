import 'package:casa/src/core/interfaces/repositories/i_repo_source.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract class BaseRepo<S extends IRepoSource> implements IRepository {
  @override
  final S source;

  Ref get ref => source.ref;

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
