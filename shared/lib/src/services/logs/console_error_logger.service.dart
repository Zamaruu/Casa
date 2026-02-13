import 'package:shared/shared.dart';

class ConsoleErrorLogger extends Logger<IErrorLog> implements IErrorLogger {
  const ConsoleErrorLogger({required super.level});

  @override
  Future<void> log(IErrorLog logEntry) async {
    final printLog = shouldLogEntry(logEntry);

    if (printLog) {
      final printMessage = _buildPrint(logEntry);

      print(printMessage);
    }
  }

  String _buildPrint(IErrorLog log) {
    final buffer = StringBuffer();

    final divider = '-----------------------------------------------------------------------------';

    buffer.writeln(divider);
    buffer.writeln('$runtimeType (${DateTime.now().toIso8601String()})');

    if (log.requestPath != null) {
      buffer.writeln('Called from: ${log.requestPath}');
    }
    buffer.writeln();
    buffer.writeln(log.title);
    buffer.writeln();

    buffer.writeln('Message: ${log.message}');
    buffer.writeln();

    // First lines of StackTrace
    final lines = log.stackTrace.toString().split('\n');
    for (final line in lines.take(5)) {
      buffer.writeln(line);
    }
    buffer.writeln();

    buffer.writeln(divider);

    final printLog = buffer.toString();

    return printLog;
  }
}
