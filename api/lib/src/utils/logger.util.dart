void apiLog({required String message, Object? error, StackTrace? stackTrace, Type? callingClass}) {
  final buffer = StringBuffer();

  final divider = '-----------------------------------------------------------------------------';

  buffer.writeln(divider);
  buffer.writeln('API-Logger (${DateTime.now().toIso8601String()})');

  if (callingClass != null) {
    buffer.writeln('Called from: $callingClass');
  }
  buffer.writeln();
  buffer.writeln(message);
  buffer.writeln();

  if (error != null) {
    buffer.writeln('Error: $error');
    buffer.writeln();
  }

  // First lines of StackTrace
  if (stackTrace != null) {
    final lines = stackTrace.toString().split('\n');
    for (final line in lines.take(5)) {
      buffer.writeln(line);
    }
    buffer.writeln();
  }

  buffer.writeln(divider);

  final log = buffer.toString();

  print(log);
}
