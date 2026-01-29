import 'package:api/src/abstract/repositories/typed.repo.dart';
import 'package:api/src/abstract/repositories/typed_source.dart';
import 'package:shared/shared.dart';

class UserRepoSource extends TypedRepoSource<IUser> {
  const UserRepoSource({
    required super.user,
    required super.operations,
  });
}

abstract class UserRepo extends TypedApiRepo<IUser> {
  const UserRepo({required super.source});
}
