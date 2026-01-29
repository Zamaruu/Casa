import 'package:shared/src/interfaces/response/i_response.dart';

abstract interface class IValueResponse<T> implements IResponse {
  T? get value;

  bool get hasValue;
}
