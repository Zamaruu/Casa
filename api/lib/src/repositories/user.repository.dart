import 'package:casa_api/src/abstract/repositories/typed.repo.dart';
import 'package:shared/shared.dart';

class UserRepository extends TypedApiRepo<IUser> {
  const UserRepository({required super.source});
}
