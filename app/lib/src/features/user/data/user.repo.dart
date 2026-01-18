import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_repo.dart';
import 'package:shared/shared.dart';

class UserRepoSource extends RepoSource {
  const UserRepoSource({required super.user});
}

abstract class UserRepo extends TypedRepo<IUser> {
  const UserRepo({required super.source});
}
