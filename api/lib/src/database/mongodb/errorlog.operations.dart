import 'package:casa_api/src/database/mongodb/mongo_operations.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

class MongoErrorLogOperations extends MongoOperations<IErrorLog> implements IErrorLogOperations {
  const MongoErrorLogOperations({required super.db});

  @override
  DbCollection get collection => db.collection('errorlogs');

  @override
  IErrorLog Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => ErrorLog.fromJson(doc);
}
