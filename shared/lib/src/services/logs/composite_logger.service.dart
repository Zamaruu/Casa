import 'package:shared/shared.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

/// A composite logger that logs to multiple loggers.
///
/// All loggers must implement the [ILogger] interface with type [L].
class CompositeLogger<L extends ILog> extends Logger<L> {
  final List<ILogger<L>> _loggers;

  const CompositeLogger({required super.level, required loggers}) : _loggers = loggers;

  @override
  Future<void> log(logEntry) async {
    final shouldLog = shouldLogEntry(logEntry);

    if (shouldLog) {
      for (final logger in _loggers) {
        await logger.log(logEntry);
      }
    }
  }
}
