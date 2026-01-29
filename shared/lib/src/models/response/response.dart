import 'package:shared/shared.dart';

class Response implements IResponse {
  @override
  final EResponseStatus status;

  @override
  final String? message;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  const Response({
    required this.status,
    this.message,
    this.error,
    this.stackTrace,
  });

  const Response.success({String? message}) : this(status: EResponseStatus.success, message: message);

  const Response.failure({
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) : this(status: EResponseStatus.failure, error: error, stackTrace: stackTrace, message: message);

  @override
  bool get isError => status == EResponseStatus.failure;

  @override
  bool get isSuccess => status == EResponseStatus.success;

  @override
  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'message': message,
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
    };
  }
}
