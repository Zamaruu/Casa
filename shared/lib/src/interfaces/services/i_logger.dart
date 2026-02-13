import 'package:shared/shared.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

abstract interface class ILogger<L extends ILog> {
  /// The log level set by the environement varaibles.
  ELogLevel get level;

  Future<void> log(L logEntry);
}

abstract interface class IErrorLogger extends ILogger<IErrorLog> {}

abstract interface class IAuditLogger extends ILogger<IAuditLog> {}
