import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_feature.dart';

/// Base contract for structured log entries.
abstract interface class ILog implements IEntity {
  /// Short summary/title of the log entry.
  ///
  /// Returns `String`.
  String get title;

  /// Detailed message associated with the log entry.
  ///
  /// Returns `String`.
  String get message;

  /// Severity of the log entry.
  ///
  /// Returns `ELogLevel`.
  ELogLevel get logLevel;

  /// Optional feature/domain the log belongs to.
  ///
  /// Returns `EFeature?`.
  EFeature? get feature;

  /// Optional related user ID if the log is tied to a user action/context.
  ///
  /// Returns `String?`.
  String? get userId;

  /// Optional correlation ID for tracing request chains across services.
  ///
  /// Returns `String?`.
  String? get correlationId;
}
