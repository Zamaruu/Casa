import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/converters/stacktrace.converter.dart';
import 'package:shared/src/enums/e_feature.dart';
import 'package:shared/src/models/logs/log.model.dart';

part 'errorlog.model.g.dart';

@JsonSerializable()
class ErrorLog extends Log implements IErrorLog {
  @override
  final String exceptionType;

  @override
  @StackTraceConverter()
  final StackTrace stacktrace;

  @override
  final String? httpMethod;

  @override
  final String? requestPath;

  // region Constructors

  const ErrorLog({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.title,
    required super.message,
    required super.logLevel,
    required super.feature,
    super.userId,
    super.correlationId,
    required this.exceptionType,
    required this.stacktrace,
    this.httpMethod,
    this.requestPath,
  });

  // endregion

  // region Serialization

  @override
  Map<String, dynamic> toJson() => _$ErrorLogToJson(this);

  factory ErrorLog.fromJson(Map<String, dynamic> json) => _$ErrorLogFromJson(json);

  // endregion

  // region Methods

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
    StackTrace? stacktrace,
    String? httpMethod,
    String? requestPath,
  }) {
    return ErrorLog(
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
      stacktrace: stacktrace ?? this.stacktrace,
      httpMethod: httpMethod ?? this.httpMethod,
      requestPath: requestPath ?? this.requestPath,
    );
  }

  // endregion
}
