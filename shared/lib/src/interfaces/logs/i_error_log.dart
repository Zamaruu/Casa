import 'package:shared/src/interfaces/logs/i_log.dart';

/// Specialized log contract for captured runtime errors/exceptions.
abstract interface class IErrorLog implements ILog {
  /// Runtime type name of the captured exception.
  ///
  /// Returns `String`.
  String get exceptionType;

  /// Captured stack trace for diagnostics.
  ///
  /// Returns `StackTrace`.
  StackTrace get stackTrace;

  /// Optional HTTP method if the error originated from an HTTP request.
  ///
  /// Returns `String?`.
  String? get httpMethod;

  /// Optional request path if the error originated from an HTTP request.
  ///
  /// Returns `String?`.
  String? get requestPath;
}
