import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_repo.dart';
import 'package:shared/shared.dart';

class UserRepoSource extends TypedRepoSource<IUser> {
  const UserRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class UserRepo extends TypedRepo<IUser> {
  const UserRepo({required super.source});
}
