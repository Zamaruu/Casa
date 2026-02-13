import 'dart:convert';
import 'dart:io';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/openapi/openapi_builder.dart';
import 'package:shelf/shelf.dart';

import '../services/service_locator.dart';

class SwaggerController extends ApiController {
  final IApiConfig config;

  SwaggerController({required this.config, required super.logger});

  factory SwaggerController.endpoint() {
    final logger = services.logger;
    final config = services.get<IApiConfig>();

    final controller = SwaggerController(config: config, logger: logger);
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "swagger";

  @override
  Future<void> registerEndpoints() async {
    router.get('/specs', openapi);
    router.get('/ui', swagger);
    router.get('/', enabled);
  }

  Future<ApiResponse> enabled(Request request) async {
    return runCustomGuarded(() async {
      final enabled = config.enableOpenApi;
      final json = {"openApiEnabled": enabled};

      return ApiResponse.ok(jsonEncode(json));
    }, onError: onGuardedError);
  }

  Future<ApiResponse> openapi(Request request) async {
    return runCustomGuarded(() async {
      final path = 'openapi/openapi.json';
      final spec = File(path);

      if (!spec.existsSync()) {
        return ApiResponse.internalServerError('OpenAPI spec not found');
      }

      return ApiResponse.ok(
        spec.readAsStringSync(),
        headers: {'content-type': 'application/json'},
      );
    }, onError: onGuardedError);
  }

  Future<ApiResponse> swagger(Request request) async {
    return runCustomGuarded(() async {
      final html = OpenapiBuilder.buildSwaggerHtml();

      return ApiResponse.ok(
        html,
        headers: {'content-type': 'text/html'},
      );
    }, onError: onGuardedError);
  }
}
