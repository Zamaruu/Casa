import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:shared/shared.dart';

abstract class BaseRepo<S extends RepoSource> implements IRepository {
  @override
  final S source;

  const BaseRepo({required this.source});

  // Future<R> runGuarded<R extends IResponse>(Future<R> Function() action) async {
  //   try {
  //     return await action();
  //   } catch (e, st) {
  //     return Response.failure(message: 'An unexpected error occurred.', error: e, stackTrace: st);
  //   }
  // }
}
