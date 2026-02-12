import 'package:shared/src/enums/e_status.dart';
import 'package:shared/src/interfaces/misc/i_serializable.dart';

abstract interface class IResponse implements ISerializable {
  EStatus get status;

  String? get message;

  Object? get error;

  StackTrace? get stackTrace;

  bool get hasMessage;

  bool get isSuccess;

  bool get isError;
}
