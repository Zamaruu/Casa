import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/logs/data/interfaces/i_errorlog.api.dart';
import 'package:casa/src/features/logs/data/repositories/errorlog.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorLogRepositoryProvider = Provider<ErrorLogRepo>((ref) {
  final user = ref.read(authUserProvider);

  final userApi = services.api.get<IErrorLogApi>();

  final source = ErrorLogRepoSource(
    ref: ref,
    user: user,
    api: userApi,
  );

  return ErrorLogRepository(source: source);
});

class ErrorLogRepository extends ErrorLogRepo {
  ErrorLogRepository({required super.source});
}
