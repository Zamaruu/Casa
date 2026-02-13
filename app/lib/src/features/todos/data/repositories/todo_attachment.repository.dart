import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_attachment.api.dart';
import 'package:casa/src/features/todos/data/repositories/todo_attachment.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoAttachmentRepositoryProvider = Provider<TodoAttachmentRepo>((ref) {
  final user = ref.read(authUserProvider);
  final api = services.api.get<ITodoAttachmentApi>();

  final source = TodoAttachmentRepoSource(
    ref: ref,
    user: user,
    api: api,
  );

  return TodoAttachmentRepository(source: source);
});

class TodoAttachmentRepository extends TodoAttachmentRepo {
  TodoAttachmentRepository({required super.source});
}
