import 'package:shared/src/interfaces/response/i_response.dart';

/// Response contract that carries an optional typed payload value.
abstract interface class IValueResponse<T> implements IResponse {
  /// Optional payload value for the response.
  ///
  /// Returns `T?`.
  T? get value;

  /// Convenience flag indicating whether [value] is present.
  ///
  /// Returns `bool`.
  bool get hasValue;
}
