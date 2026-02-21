import 'package:shared/shared.dart';

/// Abstract class which provides generic methods which run code in a standardized try catch with error handling.
///
/// TODO: Implement retry mechanisms.
abstract class GuardedOperations {
  const GuardedOperations();

  // region Error-Handling

  String _messageBuilder(String message, [String? operationErrorMessage]) {
    final messageBuffer = StringBuffer();

    messageBuffer.writeln(message);

    if (operationErrorMessage != null) {
      messageBuffer.writeln("Operation error message:");
      messageBuffer.writeln(operationErrorMessage);
    }

    return messageBuffer.toString();
  }

  /// Awaited method which is called when an error is catched in a guarded operation.
  ///
  /// Must be implemented by implementing (abstract) classes.
  Future<void> guardedErrorCallback(String message, Object error, StackTrace stackTrace);

  // endregion

  // region Guards

  // region Simple Guards

  /// Runs a simple operation in a try catch with error handling.
  ///
  /// Returns a simple [IResponse] which indicates the success or failure of the operation.
  Future<IResponse> runGuarded(
    Future<IResponse> Function() operation, {
    String? operationErrorMessage,
  }) async {
    try {
      return operation();
    } catch (e, st) {
      final guardedMessage = 'Unexpected error ${e.runtimeType} catched in $runtimeType guarded operation.';
      final message = _messageBuilder(guardedMessage, operationErrorMessage);

      await guardedErrorCallback(message, e, st);

      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Value Guards

  /// Runs a simple operation in a try catch with error handling.
  ///
  /// Returns a [IValueResponse] with the result of the operation.
  Future<IValueResponse<T>> runGuardedValue<T>(
    Future<IValueResponse<T>> Function() operation, {
    String? operationErrorMessage,
  }) async {
    try {
      return operation();
    } catch (e, st) {
      final guardedMessage = 'Unexpected error ${e.runtimeType} catched in $runtimeType guarded value oepration.';
      final message = _messageBuilder(guardedMessage, operationErrorMessage);

      await guardedErrorCallback(message, e, st);

      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  Future<IValueResponse<T>?> runGuardedNullableValue<T>(
    Future<IValueResponse<T>?> Function() operation, {
    String? operationErrorMessage,
  }) async {
    try {
      return operation();
    } catch (e, st) {
      final guardedMessage = 'Unexpected error ${e.runtimeType} catched in $runtimeType guarded value oepration.';
      final message = _messageBuilder(guardedMessage, operationErrorMessage);

      await guardedErrorCallback(message, e, st);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Custom Guards

  Future<T> runCustomGuarded<T>(
    Future<T> Function() operation, {
    String? operationErrorMessage,
    required T Function(String message, Object error, StackTrace stackTrace) onError,
  }) async {
    try {
      return operation();
    } catch (e, st) {
      final guardedMessage = 'Unexpected error ${e.runtimeType} catched in $runtimeType custom guarded operation.';
      final message = _messageBuilder(guardedMessage, operationErrorMessage);

      await guardedErrorCallback(message, e, st);

      return onError(message, e, st);
    }
  }

  // endreion

  // endregion

  // endregion
}
