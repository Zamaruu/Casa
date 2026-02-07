import 'package:casa_api/src/database/mongodb/mongo_operations.dart';
import 'package:casa_api/src/utils/logger.util.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

class MongoApiKeyOperations extends MongoOperations<IApiKey> implements IApiKeyOperations {
  const MongoApiKeyOperations({required super.db});

  @override
  DbCollection get collection => db.collection('apikeys');

  @override
  IApiKey Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => ApiKey.fromJson(doc);
}
