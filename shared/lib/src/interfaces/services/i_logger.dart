import 'package:shared/shared.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

/// Generic logger contract for structured log types.
abstract interface class ILogger<L extends ILog> {
  /// Active minimum log level used by the logger implementation.
  ///
  /// Returns `ELogLevel`.
  ELogLevel get level;

  /// Persists or emits a single log entry.
  ///
  /// Parameter `logEntry`:
  /// Log payload of type `L` to process.
  ///
  /// Returns `Future<void>`.
  Future<void> log(L logEntry);
}

/// Logger contract specialized for error logs.
abstract interface class IErrorLogger extends ILogger<IErrorLog> {}

/// Logger contract specialized for audit logs.
abstract interface class IAuditLogger extends ILogger<IAuditLog> {}
