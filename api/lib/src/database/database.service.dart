import 'package:api/src/database/mongodb/mongo.db.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared/shared.dart';

class DatabaseServiceCollection implements IServiceCollection<Type, IDefaultEntityOperations> {
  final EDatabase database;

  final String databaseConnectionString;

  final Map<Type, IDefaultEntityOperations> collection;

  DatabaseServiceCollection({required this.database, required this.databaseConnectionString})
    : collection = <Type, IDefaultEntityOperations>{};

  @override
  Future<void> initalize() async {
    switch (database) {
      case EDatabase.mongodb:
        final mongoInstance = mongo.Db(databaseConnectionString);
        final mongoDatabase = MongoDatabaseService(mongoInstance: mongoInstance);
        await mongoDatabase.initalize();

        final mongoServices = mongoDatabase.collection;
        collection.addAll(mongoServices);

        break;
      case EDatabase.mariadb:
        // TODO: Handle this case.
        throw UnimplementedError();
      case EDatabase.sqlite:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  IDefaultEntityOperations<IEntity> get<T>() {
    return collection.values.firstWhere((element) => element is T);
  }

  @override
  IDefaultEntityOperations<IEntity> getByKey(Type key) {
    return collection[key]!;
  }
}
