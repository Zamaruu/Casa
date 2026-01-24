import 'package:api/src/controllers/user.controller.dart';
import 'package:api/src/models/responses/api.response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../abstract/controller/healthcheck.controller.dart';

abstract class ControllerBuilder {
  static Router buildEndpoints() {
    final String root = "/api";
    final router = Router();

    // Healthcheck
    final healthcheckController = HealthCheckController.endpoint();
    router.mount(mergePaths(root, healthcheckController.path), healthcheckController.router.call);

    // User
    final userController = UserController.endpoint();
    router.mount(mergePaths(root, userController.path), userController.router.call);

    return router;
  }

  static String mergePaths(String root, String endpoint) {
    return "$root/$endpoint";
  }
}
