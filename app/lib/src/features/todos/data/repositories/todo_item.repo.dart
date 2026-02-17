import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_item.api.dart';
import 'package:shared/shared.dart';

class TodoItemRepoSource extends TypedRepoSource<ITodo, ITodoItemApi> {
  const TodoItemRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class TodoItemRepo extends TypedCacheRepo<ITodo, ITodoItemApi> {
  TodoItemRepo({required super.source});

  Future<IValueResponse<List<ITodo>>> findByListId(String listId) => source.api.findByListId(listId);
}
