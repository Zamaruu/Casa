import 'package:shared/shared.dart';

class DatabaseErrorLogger extends Logger<IErrorLog> implements IErrorLogger {
  final IErrorLogOperations operations;

  const DatabaseErrorLogger({required super.level, required this.operations});

  @override
  Future<void> log(IErrorLog logEntry) async {
    final shouldLog = shouldLogEntry(logEntry);

    if (shouldLog) {
      await operations.save(logEntry);
    }
  }
}
