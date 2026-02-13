import 'package:casa_api/src/services/logs/database_logger.service.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import '../../helpers/test_doubles.dart';

void main() {
  group('DatabaseErrorLogger', () {
    test('saves entry when severity passes threshold', () async {
      final ops = TestErrorLogOperations();
      final logger = DatabaseErrorLogger(level: ELogLevel.info, operations: ops);

      await logger.log(testErrorLog(level: ELogLevel.error));

      expect(ops.saveCalls, 1);
    });

    test('does not save entry below threshold', () async {
      final ops = TestErrorLogOperations();
      final logger = DatabaseErrorLogger(level: ELogLevel.error, operations: ops);

      await logger.log(testErrorLog(level: ELogLevel.info));

      expect(ops.saveCalls, 0);
    });
  });
}
