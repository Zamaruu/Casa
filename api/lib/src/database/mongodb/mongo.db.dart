import 'package:casa_api/src/database/mongodb/user.operations.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared/shared.dart';

import 'apikey.operations.dart';

class MongoDatabaseService extends ServiceCollection<Type, IDefaultEntityOperations> {
  final mongo.Db mongoInstance;

  MongoDatabaseService({required this.mongoInstance});

  @override
  Future<void> initalize() async {
    await mongoInstance.open();

    addAll({
      IUserOperations: MongoUserOperations(db: mongoInstance),
      IApiKeyOperations: MongoApiKeyOperations(db: mongoInstance),
    });
  }
}
