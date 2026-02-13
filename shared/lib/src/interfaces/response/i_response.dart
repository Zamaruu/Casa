import 'package:shared/src/enums/e_status.dart';
import 'package:shared/src/interfaces/misc/i_serializable.dart';

/// Base response contract used across API and app boundaries.
abstract interface class IResponse implements ISerializable {
  /// Operation status value.
  ///
  /// Returns `EStatus`.
  EStatus get status;

  /// Optional human-readable message for success or failure context.
  ///
  /// Returns `String?`.
  String? get message;

  /// Optional error payload/object associated with a failed response.
  ///
  /// Returns `Object?`.
  Object? get error;

  /// Optional stack trace attached to an error response.
  ///
  /// Returns `StackTrace?`.
  StackTrace? get stackTrace;

  /// Convenience flag indicating whether `message` is set.
  ///
  /// Returns `bool`.
  bool get hasMessage;

  /// Convenience flag indicating a successful response state.
  ///
  /// Returns `bool`.
  bool get isSuccess;

  /// Convenience flag indicating an error response state.
  ///
  /// Returns `bool`.
  bool get isError;
}
