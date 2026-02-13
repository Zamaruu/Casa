import 'package:shared/shared.dart';

abstract interface class IResult implements ISerializable {
  String? get message;

  String? get error;

  StackTrace? get stackTrace;

  Object? get value;
}
