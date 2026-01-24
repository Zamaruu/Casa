import 'package:api/src/controllers/controller_builder.dart';
import 'package:api/src/middleware/header.middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<Handler> buildPipeline() async {
  final endpoints = ControllerBuilder.buildEndpoints();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addMiddleware(defaultHeaders())
      .addHandler(endpoints.call);

  return handler;
}
