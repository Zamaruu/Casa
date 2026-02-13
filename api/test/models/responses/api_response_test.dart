import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('ApiResponse', () {
    test('ok and created use expected status and json content type', () async {
      final ok = ApiResponse.ok('{"x":1}');
      final created = ApiResponse.created('{"x":1}');

      expect(ok.statusCode, EHttpStatus.ok.code);
      expect(created.statusCode, EHttpStatus.created.code);
      expect(ok.headers['Content-Type'], 'application/json');
    });

    test('error constructors map to expected status codes', () {
      expect(ApiResponse.badRequest('{}').statusCode, 400);
      expect(ApiResponse.unauthorized('{}').statusCode, 401);
      expect(ApiResponse.forbidden('{}').statusCode, 403);
      expect(ApiResponse.notFound('{}').statusCode, 404);
      expect(ApiResponse.methodNotAllowed('{}').statusCode, 405);
      expect(ApiResponse.notAcceptable('{}').statusCode, 406);
      expect(ApiResponse.internalServerError('{}').statusCode, 500);
    });
  });
}
