import 'dart:convert';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/models/version/server_build_version.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shelf/shelf.dart';

class MetaController extends ApiController {
  MetaController({
    required super.logger,
  });

  factory MetaController.endpoint() {
    final logger = services.logger;

    final controller = MetaController(logger: logger);
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "meta";

  @override
  Future<void> registerEndpoints() async {
    router.get('/healthcheck', healthcheck);
    router.get('/version', version);
  }

  Future<ApiResponse> healthcheck(Request request) async {
    return runCustomGuarded(() async {
      final healthcheckMap = <String, String>{
        "status": "ok",
        "timestamp": DateTime.now().toIso8601String(),
      };

      final json = jsonEncode(healthcheckMap);

      return ApiResponse.ok(json);
    }, onError: onGuardedError);
  }

  Future<ApiResponse> version(Request request) async {
    return runCustomGuarded(() async {
      final version = ServerBuildVersion.fromEnvironment();

      final json = jsonEncode(version);

      return ApiResponse.ok(json);
    }, onError: onGuardedError);
  }
}
