import 'dart:io';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/openapi/openapi_builder.dart';
import 'package:shelf/shelf.dart';

class SwaggerController extends ApiController {
  SwaggerController();

  factory SwaggerController.endpoint() {
    final controller = SwaggerController();
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "swagger";

  @override
  Future<void> registerEndpoints() async {
    router.get('/specs', openapi);
    router.get('/ui', swagger);
  }

  Future<ApiResponse> openapi(Request request) async {
    return runGuarded(() async {
      final path = 'openapi/openapi.json';
      final spec = File(path);

      if (!spec.existsSync()) {
        return ApiResponse.internalServerError('OpenAPI spec not found');
      }

      return ApiResponse.ok(
        spec.readAsStringSync(),
        headers: {'content-type': 'application/json'},
      );
    });
  }

  Future<ApiResponse> swagger(Request request) async {
    return runGuarded(() async {
      final html = OpenapiBuilder.buildSwaggerHtml();

      return ApiResponse.ok(
        html,
        headers: {'content-type': 'text/html'},
      );
    });
  }
}
