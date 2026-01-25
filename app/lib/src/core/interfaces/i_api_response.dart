import 'package:shared/shared.dart';

abstract interface class IApiResponse<T> implements IValueResponse<T> {
  EHttpStatus get httpStatus;

  Map<String, dynamic> get rawBody;
}
