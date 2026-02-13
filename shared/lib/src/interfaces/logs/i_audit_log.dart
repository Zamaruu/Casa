import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_action.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

/// Specialized log contract for auditable business actions.
abstract interface class IAuditLog implements ILog {
  /// Optional email of the actor that triggered the audited action.
  ///
  /// Returns `String?`.
  String? get userEmail;

  /// Type name of the affected entity (for example `user`, `todo`, `recipe`).
  ///
  /// Returns `String`.
  String get entityType;

  /// Optional ID of the affected entity instance.
  ///
  /// Returns `String?`.
  String? get entityId;

  /// Action that was attempted or executed.
  ///
  /// Returns `EAction`.
  EAction get action;

  /// Outcome of the audited action.
  ///
  /// Returns `EStatus`.
  EStatus get outcome;

  /// Optional client IP address associated with the action.
  ///
  /// Returns `String?`.
  String? get ipAddress;

  /// Optional client user-agent associated with the action.
  ///
  /// Returns `String?`.
  String? get userAgent;

  /// Optional additional context fields that do not fit fixed audit fields.
  ///
  /// Returns `Map<String, dynamic>?`.
  Map<String, dynamic>? get metadata;

  /// Optional field-level before/after changes captured for the action.
  ///
  /// Returns `Map<String, dynamic>?`.
  Map<String, dynamic>? get changes;
}
