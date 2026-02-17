import 'package:casa_api/src/database/mongodb/mongo_operations.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared/shared.dart';

class MongoTodoListOperations extends MongoOperations<ITodoList> implements ITodoListOperations {
  const MongoTodoListOperations({required super.db});

  @override
  DbCollection get collection => db.collection('todo_lists');

  @override
  TodoList Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => TodoList.fromJson(doc);
}

class MongoTodoItemOperations extends MongoOperations<ITodo> implements ITodoItemOperations {
  const MongoTodoItemOperations({required super.db});

  @override
  DbCollection get collection => db.collection('todo_items');

  @override
  Todo Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => Todo.fromJson(doc);

  @override
  Future<IValueResponse<List<ITodo>>> findByListId(String listId) async {
    return runGuardedValue(
      () async {
        final docs = await collection.find(where.eq('listId', listId)).toList();
        final items = docs.map((doc) => fromMongo(doc)).toList();
        return ValueResponse.success(value: items);
      },
      operationErrorMessage: 'Error while finding todo items by listId $listId',
    );
  }
}

class MongoTodoAttachmentOperations extends MongoOperations<ITodoAttachment> implements ITodoAttachmentOperations {
  const MongoTodoAttachmentOperations({required super.db});

  @override
  DbCollection get collection => db.collection('todo_attachments');

  @override
  TodoAttachment Function(Map<String, dynamic> doc) get fromMongo =>
      (Map<String, dynamic> doc) => TodoAttachment.fromJson(doc);

  @override
  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(String todoItemId) async {
    return runGuardedValue(
      () async {
        final docs = await collection
            .find(
              where.eq('attachmentTargetType', EAttachmentTargetType.todoItem.name).eq('attachmentTargetId', todoItemId),
            )
            .toList();
        final attachments = docs.map((doc) => fromMongo(doc)).toList();
        return ValueResponse.success(value: attachments);
      },
      operationErrorMessage: 'Error while finding todo attachments by todoItemId $todoItemId',
    );
  }
}
