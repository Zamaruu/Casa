import 'package:shared/shared.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/enums/e_feature.dart';
import 'package:shared/src/interfaces/logs/i_log.dart';

abstract class Log extends Entity implements ILog {
  @override
  final String title;

  @override
  final String message;

  @override
  final ELogLevel logLevel;

  @override
  final EFeature feature;

  @override
  final String? userId;

  @override
  final String? correlationId;

  const Log({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.title,
    required this.message,
    required this.logLevel,
    required this.feature,
    this.userId,
    this.correlationId,
  });

  @override
  ILog copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? message,
    ELogLevel? logLevel,
    EFeature? feature,
    String? userId,
    String? correlationId,
  });
}
