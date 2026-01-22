import 'package:shared/shared.dart';

class MultiResponse implements IResponse {
  final List<IResponse> responses;

  @override
  final Object? error;

  @override
  final String? message;

  @override
  final StackTrace? stackTrace;

  const MultiResponse(this.responses, {this.error, this.message, this.stackTrace});

  @override
  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  bool get isError => responses.any((element) => element.isError);

  @override
  bool get isSuccess => responses.every((element) => element.isSuccess);

  @override
  EResponseStatus get status => isSuccess ? EResponseStatus.success : EResponseStatus.failure;
}
