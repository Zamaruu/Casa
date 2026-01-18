import 'package:api/src/database/mongodb/mongo_collection.dart';
import 'package:api/src/utils/logger.util.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

class MongoUserRepository extends MongoCollection<IUser> implements IUserRepository {
  const MongoUserRepository({required super.db});

  @override
  DbCollection get collection => db.collection('users');

  @override
  User Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => User.fromJson(doc);

  @override
  Future<IValueResponse<IUser?>> findByEmail(String email) async {
    try {
      final doc = await collection.findOne(where.eq('email', email));

      if (doc == null) {
        final message = 'User with email $email not found';
        return ValueResponse.failure(message: message);
      }

      final user = fromMongo(doc);

      return ValueResponse.success(value: user);
    } catch (e, st) {
      final message = 'Error while finding user by email';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }
}
