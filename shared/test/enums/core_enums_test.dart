import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('EDatabase', () {
    test('getByName resolves known names and defaults to mongodb', () {
      expect(EDatabase.getByName('sqlite'), EDatabase.sqlite);
      expect(EDatabase.getByName('mariadb'), EDatabase.mariadb);
      expect(EDatabase.getByName('unknown'), EDatabase.mongodb);
      expect(EDatabase.getByName(null), EDatabase.mongodb);
    });
  });

  group('ELogLevel', () {
    test('getByName resolves known names and defaults to info', () {
      expect(ELogLevel.getByName('debug'), ELogLevel.debug);
      expect(ELogLevel.getByName('warn'), ELogLevel.warn);
      expect(ELogLevel.getByName('invalid'), ELogLevel.info);
      expect(ELogLevel.getByName(null), ELogLevel.info);
    });

    test('getFromSeverity resolves known severities and defaults to info', () {
      expect(ELogLevel.getFromSeverity(0), ELogLevel.misc);
      expect(ELogLevel.getFromSeverity(4), ELogLevel.error);
      expect(ELogLevel.getFromSeverity(999), ELogLevel.info);
    });
  });

  group('EApiController', () {
    test('fromString resolves known controller and falls back to unknown', () {
      expect(EApiController.fromString('auth'), EApiController.auth);
      expect(EApiController.fromString('logs/error'), EApiController.errorLogs);
      expect(EApiController.fromString('missing'), EApiController.unknown);
    });

    test('endpoint formats with leading slash', () {
      expect(EApiController.user.endpoint, '/user');
      expect(EApiController.unknown.endpoint, '/');
    });
  });

  group('EHttpStatus', () {
    test('fromCode maps known and unknown statuses', () {
      expect(EHttpStatus.fromCode(200), EHttpStatus.ok);
      expect(EHttpStatus.fromCode(404), EHttpStatus.notFound);
      expect(EHttpStatus.fromCode(999), EHttpStatus.unknown);
      expect(EHttpStatus.fromCode(null), EHttpStatus.unknown);
    });

    test('status category getters behave correctly', () {
      expect(EHttpStatus.ok.isSuccessful, isTrue);
      expect(EHttpStatus.badRequest.isClientError, isTrue);
      expect(EHttpStatus.internalServerError.isServerError, isTrue);
      expect(EHttpStatus.ok.isClientError, isFalse);
    });

    test('nameWithCode combines enum name and code', () {
      expect(EHttpStatus.notFound.nameWithCode, 'notFound - 404');
    });
  });
}
