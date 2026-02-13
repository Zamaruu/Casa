import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_feature.dart';
import 'package:test/test.dart';

class _TestErrorLog implements IErrorLog {
  @override
  final String id;

  @override
  final DateTime? createdAt;

  @override
  final DateTime? updatedAt;

  @override
  final String title;

  @override
  final String message;

  @override
  final ELogLevel logLevel;

  @override
  final EFeature? feature;

  @override
  final String? userId;

  @override
  final String? correlationId;

  @override
  final String exceptionType;

  @override
  final StackTrace stackTrace;

  @override
  final String? httpMethod;

  @override
  final String? requestPath;

  const _TestErrorLog({
    this.id = '',
    this.createdAt,
    this.updatedAt,
    this.title = 'title',
    this.message = 'message',
    this.logLevel = ELogLevel.info,
    this.feature,
    this.userId,
    this.correlationId,
    this.exceptionType = 'Exception',
    this.stackTrace = StackTrace.empty,
    this.httpMethod,
    this.requestPath,
  });

  @override
  bool get hasId => id.isNotEmpty;

  @override
  IErrorLog copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? message,
    ELogLevel? logLevel,
    EFeature? feature,
    String? userId,
    String? correlationId,
    String? exceptionType,
    StackTrace? stackTrace,
    String? httpMethod,
    String? requestPath,
  }) {
    return _TestErrorLog(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      message: message ?? this.message,
      logLevel: logLevel ?? this.logLevel,
      feature: feature ?? this.feature,
      userId: userId ?? this.userId,
      correlationId: correlationId ?? this.correlationId,
      exceptionType: exceptionType ?? this.exceptionType,
      stackTrace: stackTrace ?? this.stackTrace,
      httpMethod: httpMethod ?? this.httpMethod,
      requestPath: requestPath ?? this.requestPath,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'logLevel': logLevel.name,
      'exceptionType': exceptionType,
      'stackTrace': stackTrace.toString(),
    };
  }
}

class _SpyLogger extends Logger<IErrorLog> {
  int calls = 0;
  IErrorLog? last;

  _SpyLogger({required super.level});

  @override
  Future<void> log(IErrorLog logEntry) async {
    calls += 1;
    last = logEntry;
  }
}

void main() {
  group('CompositeLogger', () {
    test('forwards log entry to all loggers when severity threshold matches', () async {
      final a = _SpyLogger(level: ELogLevel.misc);
      final b = _SpyLogger(level: ELogLevel.misc);
      final composite = CompositeLogger<IErrorLog>(level: ELogLevel.info, loggers: [a, b]);
      const entry = _TestErrorLog(logLevel: ELogLevel.warn);

      await composite.log(entry);

      expect(a.calls, 1);
      expect(b.calls, 1);
      expect(a.last, same(entry));
      expect(b.last, same(entry));
    });

    test('does not forward log entry when below threshold', () async {
      final a = _SpyLogger(level: ELogLevel.misc);
      final composite = CompositeLogger<IErrorLog>(level: ELogLevel.error, loggers: [a]);
      const entry = _TestErrorLog(logLevel: ELogLevel.info);

      await composite.log(entry);

      expect(a.calls, 0);
      expect(a.last, isNull);
    });
  });
}
