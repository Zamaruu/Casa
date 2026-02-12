import 'package:casa/src/features/logs/data/repositories/errorlog.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final errorLogsListProvider = AsyncNotifierProvider.autoDispose<ErrorLogsListNotifier, IValueResponse<List<IErrorLog>>>(
  () => ErrorLogsListNotifier(),
);

class ErrorLogsListNotifier extends AutoDisposeAsyncNotifier<IValueResponse<List<IErrorLog>>> {
  @override
  Future<IValueResponse<List<IErrorLog>>> build() async {
    final response = await ref.read(errorLogRepositoryProvider).findAll();
    return response;
  }
}
