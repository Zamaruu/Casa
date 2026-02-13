import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_list.api.dart';
import 'package:shared/shared.dart';

class TodoListRepoSource extends TypedRepoSource<ITodoList, ITodoListApi> {
  const TodoListRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class TodoListRepo extends TypedCacheRepo<ITodoList, ITodoListApi> {
  TodoListRepo({required super.source});
}
