import 'package:api/src/abstract/services/service_collection.dart';
import 'package:api/src/database/mongodb/user.operations.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared/shared.dart';

class MongoDatabaseService extends ServiceCollection<Type, IDefaultEntityOperations> {
  final mongo.Db mongoInstance;

  const MongoDatabaseService({required this.mongoInstance});

  @override
  Future<void> initalize() async {
    await mongoInstance.open();

    addAll({
      IUserOperations: MongoUserOperations(db: mongoInstance),
    });
  }
}
