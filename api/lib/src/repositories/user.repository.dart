import 'package:api/src/abstract/repositories/typed.repo.dart';
import 'package:shared/shared.dart';

class UserRepository extends TypedApiRepo<IUser> implements IUserRepository {
  const UserRepository({required super.source});

  @override
  Future<IResponse> delete(IUser entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<IUser>> find(String id) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<List<IUser>>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<IUser?>> findByEmail(String email) {
    // TODO: implement findByEmail
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<List<IUser>>> findMany(List<String> ids) {
    // TODO: implement findMany
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<IUser>> save(IUser entity) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<List<IUser>>> saveMany(List<IUser> entities) {
    // TODO: implement saveMany
    throw UnimplementedError();
  }
}
