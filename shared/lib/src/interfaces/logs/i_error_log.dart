import 'package:shared/src/interfaces/logs/i_log.dart';

abstract interface class IErrorLog implements ILog {
  String get exceptionType;

  StackTrace get stacktrace;

  String? get httpMethod;

  String? get requestPath;
}
