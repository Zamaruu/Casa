import 'package:shared/shared.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

abstract class Logger<L extends ILog> implements ILogger<L> {
  @override
  final ELogLevel level;

  const Logger({required this.level});

  /// Returns true when the log level severity from the [log] matches or exceeds the set [level].
  bool shouldLogEntry(L log) {
    return log.logLevel.severity >= level.severity;
  }
}
