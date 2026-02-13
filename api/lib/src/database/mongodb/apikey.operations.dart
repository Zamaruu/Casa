import 'package:casa_api/src/database/mongodb/mongo_operations.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

class MongoApiKeyOperations extends MongoOperations<IApiKey> implements IApiKeyOperations {
  const MongoApiKeyOperations({required super.db});

  @override
  DbCollection get collection => db.collection('apikeys');

  @override
  IApiKey Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => ApiKey.fromJson(doc);

  @override
  Future<IValueResponse<IApiKey>> findByHash(String hash) async {
    return runGuardedValue(
      () async {
        final doc = await collection.findOne(where.eq('keyHash', hash));
        if (doc == null) {
          final message = 'ApiKey with hash $hash not found';
          return ValueResponse.notFound(message: message);
        }

        final apiKey = fromMongo(doc);

        return ValueResponse.success(value: apiKey);
      },
      operationErrorMessage: 'Error while finding apiKey with hash $hash',
    );
  }

  @override
  Future<IResponse> updateLastUsed(String id) async {
    return runGuarded(
      () async {
        final updateString = DateTime.now().toIso8601String();
        final result = await collection.updateOne(where.eq('id', id), modify.set('lastUsedAt', updateString));

        if (result.isFailure) {
          final message = 'Error while updating apiKey with id $id';
          return Response.failure(message: message);
        }

        return Response.success();
      },
      operationErrorMessage: "Error while updating 'lastUsed'-field on apiKey with id $id",
    );
  }
}
