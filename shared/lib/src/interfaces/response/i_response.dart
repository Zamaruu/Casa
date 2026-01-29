import 'package:shared/src/enums/e_response_status.dart';
import 'package:shared/src/interfaces/i_serializable.dart';

abstract interface class IResponse implements ISerializable {
  EResponseStatus get status;

  String? get message;

  Object? get error;

  StackTrace? get stackTrace;

  bool get hasMessage;

  bool get isSuccess;

  bool get isError;
}
