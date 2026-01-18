import 'package:shared/src/enums/e_response_status.dart';

abstract interface class IResponse {
  EResponseStatus get status;

  Object? get error;

  StackTrace? get stackTrace;

  bool get isSuccess;

  bool get isError;
}
