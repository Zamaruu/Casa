import 'package:api/src/abstract/controller/api.controller.dart';
import 'package:api/src/models/responses/api.response.dart';
import 'package:api/src/utils/logger.util.dart';
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
    try {
      final healthcheckMap = <String, String>{
        "status": "ok",
        "timestamp": DateTime.now().toIso8601String(),
      };

      return ApiResponse.ok(healthcheckMap.toString());
    } catch (e, st) {
      final message = "Unexpected exeption in ${runtimeType.toString()}";
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ApiResponse.internalServerError(message);
    }
  }
}
