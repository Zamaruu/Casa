import 'package:api/src/controllers/auth.controller.dart';
import 'package:api/src/controllers/user.controller.dart';
import 'package:shelf_router/shelf_router.dart';

import 'healthcheck.controller.dart';

abstract class ControllerBuilder {
  static String get root => "/api";

  static Router buildPublicEndpoints() {
    final router = Router();

    // Auth
    final authController = AuthController.endpoint();
    router.mount(mergePaths(root, authController.path), authController.router.call);

    // Healthcheck
    final healthcheckController = HealthCheckController.endpoint();
    router.mount(mergePaths(root, healthcheckController.path), healthcheckController.router.call);

    return router;
  }

  static Router buildProtectedEndpoints() {
    final router = Router();

    // User
    final userController = UserController.endpoint();
    router.mount(mergePaths(root, userController.path), userController.router.call);

    return router;
  }

  static String mergePaths(String root, String endpoint) {
    return "$root/$endpoint";
  }
}
