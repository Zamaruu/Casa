import 'dart:convert';

import 'package:api/src/abstract/controller/api.controller.dart';
import 'package:api/src/models/responses/api.response.dart';
import 'package:shelf/shelf.dart';

class HealthCheckController extends ApiController {
  HealthCheckController();

  factory HealthCheckController.endpoint() {
    final controller = HealthCheckController();
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "healthcheck";

  @override
  Future<void> registerEndpoints() async {
    router.get('/', healthcheck);
  }

  Future<ApiResponse> healthcheck(Request request) async {
    return runGuarded(() async {
      final healthcheckMap = <String, String>{
        "status": "ok",
        "timestamp": DateTime.now().toIso8601String(),
      };

      final json = jsonEncode(healthcheckMap);

      return ApiResponse.ok(json);
    });
  }
}
