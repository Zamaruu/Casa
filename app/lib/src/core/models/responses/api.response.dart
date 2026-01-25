import 'package:casa/src/core/interfaces/i_api_response.dart';
import 'package:shared/shared.dart';

class ApiResponse<T> extends ValueResponse<T> implements IApiResponse<T> {
  const ApiResponse({
    super.value,
    required super.status,
    required this.httpStatus,
    this.rawBody = const {},
  });

  const ApiResponse.failure({
    super.value,
    super.message,
    super.error,
    super.stackTrace,
    required this.httpStatus,
    this.rawBody = const {},
  }) : super.failure();

  const ApiResponse.success({
    super.value,
    required this.httpStatus,
    this.rawBody = const {},
  }) : super.success();

  @override
  final EHttpStatus httpStatus;

  @override
  final Map<String, dynamic> rawBody;
}
