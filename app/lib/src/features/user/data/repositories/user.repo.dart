import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/user/data/interfaces/i_user.api.dart';
import 'package:shared/shared.dart';

class UserRepoSource extends TypedRepoSource<IUser, IUserApi> {
  const UserRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class UserRepo extends TypedCacheRepo<IUser, IUserApi> {
  UserRepo({required super.source});
}
