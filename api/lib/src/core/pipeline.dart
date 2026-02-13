import 'dart:io';

import 'package:casa_api/src/controllers/controller_builder.dart';
import 'package:casa_api/src/interfaces/auth/i_api_key_authenticator.dart';
import 'package:casa_api/src/interfaces/auth/i_user_authenticator.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:casa_api/src/middleware/auth.middleware.dart';
import 'package:casa_api/src/middleware/header.middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_static/shelf_static.dart';

import '../services/service_locator.dart';

Future<Handler> buildPipeline(IApiConfig config) async {
  final jwtService = services.get<IUserAuthenticator>();
  final apiKeyService = services.get<IApiKeyAuthenticator>();

  final protectedEndpoints = ControllerBuilder.buildProtectedEndpoints();

  final publicEndpoints = ControllerBuilder.buildPublicEndpoints(config);

  final protectedPipeline = Pipeline()
      .addMiddleware(authMiddleware(userAuth: jwtService, apiKeyAuth: apiKeyService))
      .addMiddleware(defaultHeaders())
      .addHandler(protectedEndpoints.call);

  final apiHandler = _buildApiHandler(
    publicEndpoints.call,
    protectedPipeline,
  );

  final staticFilesHandler = await _buildStaticFiles();

  final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(corsHeaders()).addHandler((request) {
    if (request.url.path.startsWith('api')) {
      return apiHandler(request);
    }

    return staticFilesHandler != null ? staticFilesHandler(request) : _notFoundHandler(request);
  });

  return handler;
}

Future<Handler?> _buildStaticFiles() async {
  final spaDirectory = Directory('web');
  if (!await spaDirectory.exists()) return null;

  final staticHandler = createStaticHandler(
    'web',
    defaultDocument: 'index.html',
  );

  final indexFile = File('web/index.html');

  return (Request request) async {
    final response = await staticHandler(request);

    if (response.statusCode != 404) {
      return response;
    }

    if (request.method != 'GET') {
      return response;
    }

    if (request.url.path.startsWith('api')) {
      return response;
    }

    if (await indexFile.exists()) {
      return Response.ok(
        await indexFile.readAsBytes(),
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    }

    return Response.notFound('index.html not found');
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
