import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:casa/src/core/interfaces/repositories/i_repo_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract class RepoSource implements IRepoSource {
  @override
  final Ref ref;

  const RepoSource({required this.ref});
}

abstract class AuthenticatedRepoSource extends RepoSource implements IAuthenticatedRepoSource {
  @override
  final IUser user;

  const AuthenticatedRepoSource({required super.ref, required this.user});
}

abstract class TypedRepoSource<T extends IEntity> extends AuthenticatedRepoSource implements ITypedRepoSource<T> {
  @override
  final ITypedApi<T> api;

  const TypedRepoSource({
    required super.ref,
    required super.user,
    required this.api,
  });
}
