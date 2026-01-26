import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

@JsonSerializable()
class ValueResponse<T> extends Response implements IValueResponse<T> {
  @override
  final T? value;

  const ValueResponse({
    required super.status,
    super.message,
    super.error,
    super.stackTrace,
    this.value,
  });

  const ValueResponse.success({T? value, String? message}) : this(status: EResponseStatus.success, value: value);

  const ValueResponse.failure({
    String? message,
    Object? error,
    StackTrace? stackTrace,
    T? value,
  }) : this(status: EResponseStatus.failure, error: error, stackTrace: stackTrace, value: value, message: message);

  const ValueResponse.notFound({
    String? message,
  }) : this(status: EResponseStatus.notFound, message: message);

  @override
  bool get hasValue => value != null;
}
