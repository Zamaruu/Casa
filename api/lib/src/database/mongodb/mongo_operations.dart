import 'package:casa_api/src/utils/logger.util.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

abstract class MongoOperations<T extends IEntity> extends GuardedOperations implements IDefaultEntityOperations<T> {
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

  T createAdditions(T entity) {
    if (entity.hasId == false) {
      entity = entity.copyWith(id: createId()) as T;
    }

    if (entity.createdAt == null) {
      entity = entity.copyWith(createdAt: DateTime.now()) as T;
    }

    entity = entity.copyWith(updatedAt: DateTime.now()) as T;

    return entity;
  }

  @override
  Future<void> guardedErrorCallback(String message, Object error, StackTrace stackTrace) async {
    apiLog(message: message, error: error, stackTrace: stackTrace, callingClass: runtimeType);
  }

  // endregion

  // region Basic Data Operation

  @override
  Future<IValueResponse<T>> find(String id) async {
    return runGuardedValue<T>(
      () async {
        final doc = await collection.findOne(where.eq("id", id));
        if (doc == null) {
          final message = 'Entity of type ${T.toString()} with id $id not found';
          return ValueResponse.notFound(message: message);
        }

        final entity = fromMongo(doc);

        return ValueResponse.success(value: entity);
      },
      operationErrorMessage: 'Error while finding entity of type ${T.toString()} with id $id',
    );
  }

  @override
  Future<IValueResponse<List<T>>> findMany(List<String> ids) async {
    return runGuardedValue(
      () async {
        // TODO: implement findMany
        throw UnimplementedError();
      },
      operationErrorMessage: 'Error while finding entities of type ${T.toString()} with ids ${ids.join(', ')}',
    );
  }

  @override
  Future<IValueResponse<List<T>>> findAll() async {
    return runGuardedValue(
      () async {
        final docs = await collection.find().toList();
        final entities = docs.map((doc) => fromMongo(doc)).toList();
        return ValueResponse.success(value: entities);
      },
      operationErrorMessage: 'Error while finding all entities of type ${T.toString()}',
    );
  }

  @override
  Future<IValueResponse<T>> save(T entity) async {
    return runGuardedValue(
      () async {
        if (entity.hasId == false) {
          entity = createAdditions(entity);
        }

        final json = entity.toJson();

        final result = await collection.insertOne(json);

        if (result.isFailure) {
          final message = 'Error while saving entity of type ${T.toString()}.';
          apiLog(message: message, callingClass: runtimeType);
          return ValueResponse.failure(message: message);
        } else {
          return ValueResponse.success(value: entity);
        }
      },
      operationErrorMessage: 'Error while saving entity of type ${T.toString()}',
    );
  }

  @override
  Future<IValueResponse<List<T>>> saveMany(List<T> entities) async {
    return runGuardedValue(
      () async {
        final saveEntities = <T>[];

        for (var entity in entities) {
          saveEntities.add(createAdditions(entity));
        }

        final docs = saveEntities.map((e) => e.toJson()).toList();

        final result = await collection.insertMany(docs);

        if (result.hasWriteErrors) {
          final message = 'Error while saving ${result.writeErrorsNumber} entities of type ${T.toString()}.';
          apiLog(message: message, callingClass: runtimeType);
          return ValueResponse.failure(message: message);
        } else {
          return ValueResponse.success(value: saveEntities);
        }
      },
      operationErrorMessage: 'Error while saving ${entities.length} entities of type ${T.toString()}',
    );
  }

  @override
  Future<IResponse> delete(IEntity entity) async {
    return runGuarded(
      () async {
        if (entity.hasId == false) {
          final message = 'Entity of type ${T.toString()} with id ${entity.id} has no id.';
          return Response.failure(message: message);
        }

        final result = await collection.deleteOne(where.eq('id', entity.id));

        if (result.isFailure) {
          final message = 'Error while deleting entity of type ${T.toString()} with id ${entity.id}.';
          apiLog(message: message, callingClass: runtimeType);
          return Response.failure(message: message);
        } else {
          return Response.success();
        }
      },
      operationErrorMessage: 'Error while deleting entity of type ${T.toString()} with id ${entity.id}',
    );
  }

  // endregion
}
