import 'dart:io';

import 'package:casa_api/src/controllers/controller_builder.dart';
import 'package:casa_api/src/middleware/auth.middleware.dart';
import 'package:casa_api/src/middleware/header.middleware.dart';
import 'package:casa_api/src/services/auth/jwt.service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_static/shelf_static.dart';

import '../services/service_locator.dart';

Future<Handler> buildPipeline() async {
  final jwtService = services.get<JwtService>();

  final protectedEndpoints = ControllerBuilder.buildProtectedEndpoints();

  final publicEndpoints = ControllerBuilder.buildPublicEndpoints();

  final protectedPipeline = Pipeline()
      .addMiddleware(authMiddleware(jwtService))
      .addMiddleware(defaultHeaders())
      .addHandler(protectedEndpoints.call);

  final apiHandler = _buildApiHandler(
    publicEndpoints.call,
    protectedPipeline,
  );

  final staticFilesHandler = await _buildStaticFiles();

  final cascade = Cascade()
      .add(apiHandler) // 1️⃣ API FIRST
      .add(staticFilesHandler ?? _notFoundHandler)
      .handler;

  final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(corsHeaders()).addHandler(cascade);

  return handler;
}

Future<Handler?> _buildStaticFiles() async {
  final spaDirectory = Directory('web');
  final directoryExisits = await spaDirectory.exists();

  if (directoryExisits == false) {
    // Local / Debug: no static file serving or a file system exception will be thrown
    return null;
  }

  final staticHandler = createStaticHandler(
    'web',
    defaultDocument: 'index.html',
    serveFilesOutsidePath: false,
  );

  return (Request request) async {
    final response = await staticHandler(request);

    // SPA-Fallback: anything that is not a real file → index.html
    if (response.statusCode == 404 && !request.url.path.startsWith('api')) {
      return staticHandler(
        request.change(path: 'index.html'),
      );
    }

    return response;
  };
}

Handler _buildApiHandler(
  Handler publicHandler,
  Handler protectedHandler,
) {
  final cascade = Cascade().add(publicHandler).add(protectedHandler).handler;

  return (Request request) {
    if (!request.url.path.startsWith('api')) {
      return Response.notFound('Not an API route');
    }

    return cascade(request);
  };
}

Response _notFoundHandler(Request request) => Response.notFound('Route not found');
