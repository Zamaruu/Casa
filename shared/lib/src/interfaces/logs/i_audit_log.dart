import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_action.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

abstract interface class IAuditLog implements ILog {
  String? get userEmail;

  String get entityType;
  String? get entityId;

  EAction get action;
  EStatus get outcome;

  String? get ipAddress;
  String? get userAgent;

  Map<String, dynamic>? get metadata;
  Map<String, dynamic>? get changes;
}
