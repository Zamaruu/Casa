import 'package:shared/src/enums/e_response_status.dart';

abstract interface class IResponse {
  EResponseStatus get status;

  String? get message;

  Object? get error;

  StackTrace? get stackTrace;

  bool get hasMessage;

  bool get isSuccess;

  bool get isError;
}
