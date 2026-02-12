import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/converters/stacktrace.converter.dart';
import 'package:shared/src/interfaces/api/i_result.dart';

part 'result.g.dart';

@JsonSerializable()
class Result implements IResult {
  @override
  final String? message;

  @override
  final String? error;

  @override
  @StackTraceConverter()
  final StackTrace? stackTrace;

  @override
  final Object? value;

  const Result({
    this.message,
    this.error,
    this.stackTrace,
    this.value,
  });

  @override
  Map<String, dynamic> toJson() => _$ResultToJson(this);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  // region Serialization

  // endregion
}
