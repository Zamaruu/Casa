import 'package:casa_api/src/utils/logger.util.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

abstract class MongoOperations<T extends IEntity> implements IDefaultEntityOperations<T> {
  final Db db;

  const MongoOperations({required this.db});

  // region Getter

  /// The (main) Mongo-Collection the implementing class is connected to.
  DbCollection get collection;

  /// Function which deserializes a Mongo-Document into an Entity of type [T].
  T Function(Map<String, dynamic> doc) get fromMongo;

  // endregion

  // region Helper

  String createId() {
    return Uuid().v4();
  }

  // endregion

  // region Basic Data Operation

  @override
  Future<IValueResponse<T>> find(String id) async {
    try {
      final doc = await collection.findOne(where.eq("id", id));
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
    try {
      final docs = await collection.find().toList();
      final entities = docs.map((doc) => fromMongo(doc)).toList();

      return ValueResponse.success(value: entities);
    } catch (e, st) {
      final message = 'Error while finding all entities of type ${T.toString()}';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IValueResponse<T>> save(IEntity entity) async {
    try {
      if (entity.hasId == false) {
        entity = entity.copyWith(id: createId());
      }

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
  Future<IValueResponse<List<T>>> saveMany(List<T> entities) async {
    try {
      // Check for missing ids
      final saveEntities = <T>[];

      for (var entity in entities) {
        if (entity.hasId == false) {
          saveEntities.add(entity.copyWith(id: createId()) as T);
        } else {
          saveEntities.add(entity);
        }
      }

      final docs = saveEntities.map((e) => e.toJson()).toList();

      final result = await collection.insertMany(docs);

      if (result.hasWriteErrors) {
        final message = 'Error while saving ${result.writeErrorsNumber} entities of type ${T.toString()}.';
        apiLog(message: message, callingClass: runtimeType);
        return ValueResponse.failure(message: message);
      }

      return ValueResponse.success(value: saveEntities);
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
