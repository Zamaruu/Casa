import 'package:api/src/controllers/controller_builder.dart';
import 'package:api/src/middleware/auth.middleware.dart';
import 'package:api/src/middleware/header.middleware.dart';
import 'package:api/src/services/auth/jwt.service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../services/service_locator.dart';

Future<Handler> buildPipeline() async {
  final jwtService = services.get<JwtService>();

  final protectedEndpoints = ControllerBuilder.buildProtectedEndpoints();

  final publicEndpoints = ControllerBuilder.buildPublicEndpoints();

  final protectedPipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addMiddleware(authMiddleware(jwtService))
      .addMiddleware(defaultHeaders())
      .addHandler(protectedEndpoints.call);

  final handler = Cascade().add(publicEndpoints.call).add(protectedPipeline).handler;

  return handler;
}
