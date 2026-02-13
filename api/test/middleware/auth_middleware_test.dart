import 'dart:convert';

import 'package:casa_api/src/middleware/auth.middleware.dart';
import 'package:casa_api/src/models/auth/auth_context.dart';
import 'package:shared/src/models/apikey/api_key.model.dart';
import 'package:shared/src/models/user/user.model.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../helpers/test_doubles.dart';

void main() {
  group('authMiddleware', () {
    test('returns unauthorized when header missing', () async {
      final middleware = authMiddleware(
        userAuth: TestUserAuthenticator(),
        apiKeyAuth: TestApiKeyAuthenticator(),
      );

      final handler = middleware((_) async => Response.ok('ok'));
      final response = await handler(Request('GET', Uri.parse('http://localhost/api')));

      expect(response.statusCode, 401);
      expect(await response.readAsString(), contains('Missing Authorization header'));
    });

    test('accepts valid bearer token and injects AuthContext.user', () async {
      final user = const User(id: 'u1', email: 'u@t.dev', username: 'u', passwordHash: 'h');
      final middleware = authMiddleware(
        userAuth: TestUserAuthenticator(authenticateResult: user),
        apiKeyAuth: TestApiKeyAuthenticator(),
      );

      final handler = middleware((request) async {
        final ctx = request.context['AuthContext'] as AuthContext;
        return Response.ok(jsonEncode({'type': ctx.type.name, 'id': (ctx.principal as User).id}));
      });

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/api'), headers: {'authorization': 'Bearer token'}),
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['type'], 'user');
      expect(body['id'], 'u1');
    });

    test('accepts valid api key and injects AuthContext.apiKey', () async {
      final apiKey = const ApiKey(id: 'k1', name: 'key', keyHash: 'hash');
      final middleware = authMiddleware(
        userAuth: TestUserAuthenticator(),
        apiKeyAuth: TestApiKeyAuthenticator(authenticateResult: apiKey),
      );

      final handler = middleware((request) async {
        final ctx = request.context['AuthContext'] as AuthContext;
        return Response.ok(jsonEncode({'type': ctx.type.name, 'id': (ctx.principal as ApiKey).id}));
      });

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/api'), headers: {'authorization': 'ApiKey raw'}),
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['type'], 'apiKey');
      expect(body['id'], 'k1');
    });

    test('returns unauthorized for unsupported scheme', () async {
      final middleware = authMiddleware(
        userAuth: TestUserAuthenticator(),
        apiKeyAuth: TestApiKeyAuthenticator(),
      );

      final handler = middleware((_) async => Response.ok('ok'));
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/api'), headers: {'authorization': 'Basic abc'}),
      );

      expect(response.statusCode, 401);
      expect(await response.readAsString(), contains('Unsupported authorization scheme'));
    });
  });
}
