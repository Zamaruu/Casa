import 'package:casa_api/src/controllers/controller_builder.dart';
import 'package:casa_api/src/middleware/auth.middleware.dart';
import 'package:casa_api/src/middleware/header.middleware.dart';
import 'package:casa_api/src/services/auth/jwt.service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../services/service_locator.dart';

Future<Handler> buildPipeline() async {
  final jwtService = services.get<JwtService>();

  final protectedEndpoints = ControllerBuilder.buildProtectedEndpoints();

  final publicEndpoints = ControllerBuilder.buildPublicEndpoints();

  final protectedPipeline = Pipeline()
      .addMiddleware(authMiddleware(jwtService))
      .addMiddleware(defaultHeaders())
      .addHandler(protectedEndpoints.call);

  final cascade = Cascade().add(publicEndpoints.call).add(protectedPipeline).handler;

  final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(corsHeaders()).addHandler(cascade);

  return handler;
}
