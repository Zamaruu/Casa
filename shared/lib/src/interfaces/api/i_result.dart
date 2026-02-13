import 'package:shared/shared.dart';

/// Defines a generic result payload that can be serialized and returned
/// across package boundaries.
abstract interface class IResult implements ISerializable {
  /// Human-readable status or info message for the result.
  ///
  /// Returns `String?` and can be `null` when no message is provided.
  String? get message;

  /// Human-readable error message if the result represents a failure.
  ///
  /// Returns `String?` and can be `null` when no error message exists.
  String? get error;

  /// Captured stack trace associated with an error result.
  ///
  /// Returns `StackTrace?` and can be `null` for non-error results.
  StackTrace? get stackTrace;

  /// Optional payload value carried by this result.
  ///
  /// Returns `Object?` so implementations can transport arbitrary value types.
  Object? get value;
}
