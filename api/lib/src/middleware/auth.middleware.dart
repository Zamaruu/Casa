import 'package:casa_api/src/interfaces/auth/i_api_key_authenticator.dart';
import 'package:casa_api/src/interfaces/auth/i_user_authenticator.dart';
import 'package:casa_api/src/models/auth/auth_context.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware({
  required IUserAuthenticator userAuth,
  required IApiKeyAuthenticator apiKeyAuth,
}) {
  return (innerHandler) {
    return (request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null) {
        return Response.unauthorized('Missing Authorization header');
      }

      // -------- Bearer JWT --------
      if (authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);

        final user = await userAuth.authenticate(token);
        if (user == null) {
          return Response.unauthorized('Invalid bearer token');
        }

        final ctx = AuthContext.user(user);
        return innerHandler(
          request.change(context: {'AuthContext': ctx}),
        );
      }

      // -------- ApiKey --------
      if (authHeader.startsWith('ApiKey ')) {
        final rawKey = authHeader.substring(7);

        final apiKey = await apiKeyAuth.authenticate(rawKey);
        if (apiKey == null) {
          return Response.unauthorized('Invalid API key');
        }

        final ctx = AuthContext.apiKey(apiKey);
        return innerHandler(
          request.change(context: {'AuthContext': ctx}),
        );
      }

      return Response.unauthorized('Unsupported authorization scheme');
    };
  };
}
