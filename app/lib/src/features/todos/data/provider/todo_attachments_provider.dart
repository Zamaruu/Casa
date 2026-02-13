import 'package:casa/src/features/todos/data/repositories/todo_attachment.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final todoAttachmentsByItemProvider = AsyncNotifierProvider.autoDispose
    .family<TodoAttachmentsByItemNotifier, IValueResponse<List<ITodoAttachment>>, String>(
      TodoAttachmentsByItemNotifier.new,
    );

class TodoAttachmentsByItemNotifier
    extends AutoDisposeFamilyAsyncNotifier<IValueResponse<List<ITodoAttachment>>, String> {
  @override
  Future<IValueResponse<List<ITodoAttachment>>> build(String arg) async {
    return ref.read(todoAttachmentRepositoryProvider).findByTodoItemId(arg);
  }
}
