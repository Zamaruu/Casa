import 'package:api/src/models/responses/api.response.dart';
import 'package:api/src/services/auth/jwt.service.dart';
import 'package:api/src/services/auth/user_context.dart';
import 'package:api/src/utils/logger.util.dart';
import 'package:shared/shared.dart' hide Response;
import 'package:shelf/shelf.dart';

Middleware authMiddleware(JwtService verifier) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return ApiResponse.unauthorized('Missing Authorization header');
      }

      final token = authHeader.substring('Bearer '.length);

      try {
        final claims = verifier.verify(token);
        final user = User.fromJson(claims);

        final userContext = UserContext(user);

        final newRequestContext = <String, Object>{};
        newRequestContext['UserContext'] = userContext;
        newRequestContext.addAll(request.context);

        final userContextRequest = request.change(context: request.context);

        return innerHandler(userContextRequest);
      } catch (e, st) {
        final message = 'Invalid or expired user token.';
        apiLog(message: message, error: e, stackTrace: st);
        return Response.forbidden(message);
      }
    };
  };
}
