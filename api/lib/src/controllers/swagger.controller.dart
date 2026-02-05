import 'dart:io';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
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
      final path = 'openapi/swagger.yaml';
      final yaml = File(path);

      return ApiResponse.ok(
        yaml.readAsStringSync(),
        headers: {'content-type': 'application/yaml'},
      );
    });
  }

  Future<ApiResponse> swagger(Request request) async {
    return runGuarded(() async {
      final html = await File('openapi/swagger.html').readAsString();

      return ApiResponse.ok(
        html,
        headers: {'content-type': 'text/html'},
      );
    });
  }
}
