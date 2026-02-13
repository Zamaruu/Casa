import 'package:shared/shared.dart';
import 'package:test/test.dart';

class _TestGuardedOperations extends GuardedOperations {
  int callbackCount = 0;
  String? lastMessage;
  Object? lastError;
  StackTrace? lastStackTrace;

  @override
  Future<void> guardedErrorCallback(String message, Object error, StackTrace stackTrace) async {
    callbackCount += 1;
    lastMessage = message;
    lastError = error;
    lastStackTrace = stackTrace;
  }
}

void main() {
  group('GuardedOperations.runGuarded', () {
    test('returns operation response on success and does not call callback', () async {
      final guarded = _TestGuardedOperations();

      final response = await guarded.runGuarded(() async => const Response.success(message: 'ok'));

      expect(response.isSuccess, isTrue);
      expect(response.message, 'ok');
      expect(guarded.callbackCount, 0);
    });

    test('returns failure response and calls callback when operation throws', () async {
      final guarded = _TestGuardedOperations();

      final response = await guarded.runGuarded(
        () => throw StateError('boom'),
        operationErrorMessage: 'while saving user',
      );

      expect(response.isError, isTrue);
      expect(response.error, isA<StateError>());
      expect(response.stackTrace, isNotNull);
      expect(response.message, contains('StateError'));
      expect(response.message, contains('_TestGuardedOperations'));
      expect(response.message, contains('Operation error message:'));
      expect(response.message, contains('while saving user'));

      expect(guarded.callbackCount, 1);
      expect(guarded.lastError, isA<StateError>());
      expect(guarded.lastStackTrace, isNotNull);
      expect(guarded.lastMessage, response.message);
    });

    test('builds message without operation section when no operationErrorMessage is set', () async {
      final guarded = _TestGuardedOperations();

      final response = await guarded.runGuarded(() => throw ArgumentError('invalid'));

      expect(response.isError, isTrue);
      expect(response.message, contains('ArgumentError'));
      expect(response.message, isNot(contains('Operation error message:')));
      expect(guarded.callbackCount, 1);
    });
  });

  group('GuardedOperations.runGuardedValue', () {
    test('returns operation value response on success and does not call callback', () async {
      final guarded = _TestGuardedOperations();

      final response = await guarded.runGuardedValue<int>(
        () async => const ValueResponse.success(value: 42),
      );

      expect(response.isSuccess, isTrue);
      expect(response.hasValue, isTrue);
      expect(response.value, 42);
      expect(guarded.callbackCount, 0);
    });

    test('returns failure value response and calls callback on error', () async {
      final guarded = _TestGuardedOperations();

      final response = await guarded.runGuardedValue<int>(
        () => throw UnsupportedError('nope'),
        operationErrorMessage: 'loading todo item',
      );

      expect(response.isError, isTrue);
      expect(response.hasValue, isFalse);
      expect(response.error, isA<UnsupportedError>());
      expect(response.message, contains('UnsupportedError'));
      expect(response.message, contains('Operation error message:'));
      expect(response.message, contains('loading todo item'));

      expect(guarded.callbackCount, 1);
      expect(guarded.lastError, isA<UnsupportedError>());
      expect(guarded.lastMessage, response.message);
    });
  });

  group('GuardedOperations.runCustomGuarded', () {
    test('returns operation result and does not call onError or callback on success', () async {
      final guarded = _TestGuardedOperations();
      var onErrorCalled = false;

      final result = await guarded.runCustomGuarded<String>(
        () async => 'ok',
        onError: (_, _, _) {
          onErrorCalled = true;
          return 'fallback';
        },
      );

      expect(result, 'ok');
      expect(onErrorCalled, isFalse);
      expect(guarded.callbackCount, 0);
    });

    test('calls callback and onError and returns mapped value when operation throws', () async {
      final guarded = _TestGuardedOperations();
      var onErrorCalled = false;
      String? onErrorMessage;
      Object? onErrorObject;
      StackTrace? onErrorStack;

      final result = await guarded.runCustomGuarded<int>(
        () => throw Exception('custom fail'),
        operationErrorMessage: 'during custom operation',
        onError: (message, error, stackTrace) {
          onErrorCalled = true;
          onErrorMessage = message;
          onErrorObject = error;
          onErrorStack = stackTrace;
          return -1;
        },
      );

      expect(result, -1);
      expect(onErrorCalled, isTrue);
      expect(onErrorMessage, contains('Exception'));
      expect(onErrorMessage, contains('during custom operation'));
      expect(onErrorObject, isA<Exception>());
      expect(onErrorStack, isNotNull);

      expect(guarded.callbackCount, 1);
      expect(guarded.lastMessage, onErrorMessage);
      expect(guarded.lastError, onErrorObject);
      expect(guarded.lastStackTrace, onErrorStack);
    });
  });
}
