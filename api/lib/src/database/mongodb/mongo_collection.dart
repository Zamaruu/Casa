import 'package:api/src/utils/logger.util.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

abstract class MongoCollection<T extends IEntity> implements IDefaultEntityOperations<T> {
  final Db db;

  const MongoCollection({required this.db});

  // region Getter

  /// The (main) Mongo-Collection the implementing class is connected to.
  DbCollection get collection;

  /// Function which deserializes a Mongo-Document into an Entity of type [T].
  T Function(Map<String, dynamic> doc) get fromMongo;

  // endregion

  // region Basic Data Operation

  @override
  Future<IValueResponse<T>> find(String id) async {
    try {
      final doc = await collection.findOne(where.id(ObjectId.parse(id)));
      if (doc == null) {
        final message = 'Entity of type ${T.toString()} with id $id not found';
        return ValueResponse.notFound(message: message);
      }

      final entity = fromMongo(doc);

      return ValueResponse.success(value: entity);
    } catch (e, st) {
      final message = 'Error while finding entity of type ${T.toString()} with id $id';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IValueResponse<List<T>>> findMany(List<String> ids) async {
    try {
      // TODO: implement findMany
      throw UnimplementedError();
    } catch (e, st) {
      final concatenatedIds = ids.join(', ');
      final message = 'Error while finding entities of type ${T.toString()} with ids $concatenatedIds';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IValueResponse<List<T>>> findAll() async {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<T>> save(IEntity entity) async {
    try {
      final json = entity.toJson();

      final result = await collection.insertOne(json);
      final id = result.id.toHexString();

      return ValueResponse.success(
        value: entity.copyWith(id: id) as T,
      );
    } catch (e, st) {
      final message = 'Error while saving entity of type ${T.toString()}.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IValueResponse<List<T>>> saveMany(List<IEntity> entities) async {
    try {
      final docs = entities.map((e) => e.toJson()).toList();

      final result = await collection.insertMany(docs);
      final ids = result.ids?.map((e) => e.id.toHexString()).toList();

      if (ids == null) {
        final message = 'Error while saving ${entities.length} entities of type ${T.toString()}.\nIds are null.';
        return ValueResponse.failure(message: message);
      }

      final updatedEntities = entities.map((e) => e.copyWith(id: ids.firstWhere((id) => id == e.id)) as T).toList();

      return ValueResponse.success(value: updatedEntities);
    } catch (e, st) {
      final message = 'Error while saving ${entities.length} entities of type ${T.toString()}.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IResponse> delete(IEntity entity) async {
    try {
      await collection.deleteOne(where.id(ObjectId.parse(entity.id)));
      return Response.success();
    } catch (e, st) {
      final message = 'Error while deleting entity of type ${T.toString()} with id ${entity.id}';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion
}
