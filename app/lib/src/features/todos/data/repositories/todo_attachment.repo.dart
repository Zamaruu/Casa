import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_attachment.api.dart';
import 'package:shared/shared.dart';

class TodoAttachmentRepoSource extends TypedRepoSource<ITodoAttachment, ITodoAttachmentApi> {
  const TodoAttachmentRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class TodoAttachmentRepo extends TypedCacheRepo<ITodoAttachment, ITodoAttachmentApi> {
  TodoAttachmentRepo({required super.source});

  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(String todoItemId) =>
      source.api.findByTodoItemId(todoItemId);
}
