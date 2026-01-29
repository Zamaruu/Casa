import 'package:flutter/foundation.dart';

void appLog({required String message, Object? error, StackTrace? stackTrace, Type? callingClass}) {
  final buffer = StringBuffer();

  final divider = '-----------------------------------------------------------------------------';

  buffer.writeln(divider);
  buffer.writeln('App-Logger (${DateTime.now().toIso8601String()})');

  if (callingClass != null) {
    buffer.writeln('Called from: $callingClass');
  }
  buffer.writeln();
  buffer.writeln(message);

  if (error != null) {
    buffer.writeln();
    buffer.writeln('Error: $error');
  }

  // First lines of StackTrace
  if (stackTrace != null) {
    buffer.writeln();
    final lines = stackTrace.toString().split('\n');
    for (final line in lines.take(5)) {
      buffer.writeln(line);
    }
  }

  buffer.writeln(divider);

  final log = buffer.toString();

  debugPrint(log);
}
