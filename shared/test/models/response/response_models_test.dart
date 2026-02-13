import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('Response', () {
    test('success/failure flags and message checks work', () {
      const success = Response.success(message: 'ok');
      const failure = Response.failure(message: 'nope', error: 'err');

      expect(success.isSuccess, isTrue);
      expect(success.isError, isFalse);
      expect(success.hasMessage, isTrue);

      expect(failure.isSuccess, isFalse);
      expect(failure.isError, isTrue);
      expect(failure.hasMessage, isTrue);
    });

    test('toJson contains expected keys', () {
      const response = Response.failure(message: 'x', error: 'y');
      final json = response.toJson();

      expect(json['status'], 'failure');
      expect(json['message'], 'x');
      expect(json, contains('error'));
      expect(json, contains('stackTrace'));
    });
  });

  group('ValueResponse', () {
    test('hasValue reflects nullable payload', () {
      const withValue = ValueResponse<int>.success(value: 7);
      const withoutValue = ValueResponse<int>.failure(message: 'f');

      expect(withValue.hasValue, isTrue);
      expect(withValue.value, 7);
      expect(withoutValue.hasValue, isFalse);
      expect(withoutValue.value, isNull);
    });
  });

  group('MultiResponse', () {
    test('isSuccess/isError derive from child responses', () {
      const allSuccess = MultiResponse(
        responses: [Response.success(), Response.success()],
      );
      const mixed = MultiResponse(
        responses: [Response.success(), Response.failure()],
      );

      expect(allSuccess.isSuccess, isTrue);
      expect(allSuccess.isError, isFalse);
      expect(allSuccess.status, EStatus.success);

      expect(mixed.isSuccess, isFalse);
      expect(mixed.isError, isTrue);
      expect(mixed.status, EStatus.failure);
    });
  });

  group('MultiValueResponse', () {
    test('hasValue works with optional value', () {
      const withValue = MultiValueResponse<int>(responses: [Response.success()], value: 3);
      const withoutValue = MultiValueResponse<int>(responses: [Response.success()]);

      expect(withValue.hasValue, isTrue);
      expect(withValue.value, 3);
      expect(withoutValue.hasValue, isFalse);
    });
  });
}
