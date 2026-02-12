import 'package:casa_api/src/controllers/auth.controller.dart';
import 'package:casa_api/src/controllers/backend.controller.dart';
import 'package:casa_api/src/controllers/errorlog.controller.dart';
import 'package:casa_api/src/controllers/swagger.controller.dart';
import 'package:casa_api/src/controllers/user.controller.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:shelf_router/shelf_router.dart';

import 'meta.controller.dart';

abstract class ControllerBuilder {
  static String get root => "/api";

  static Router buildPublicEndpoints(IApiConfig config) {
    final router = Router();

    if (config.enableOpenApi) {
      // OpenAPI
      final swaggerController = SwaggerController.endpoint();
      router.mount(mergePaths(root, swaggerController.path), swaggerController.router.call);
    }

    // Auth
    final authController = AuthController.endpoint();
    router.mount(mergePaths(root, authController.path), authController.router.call);

    // Healthcheck
    final metaController = MetaController.endpoint();
    router.mount(mergePaths(root, metaController.path), metaController.router.call);

    return router;
  }

  static Router buildProtectedEndpoints() {
    final router = Router();

    // User
    final userController = UserController.endpoint();
    router.mount(mergePaths(root, userController.path), userController.router.call);

    // Backend
    final backendController = BackendController.endpoint();
    router.mount(mergePaths(root, backendController.path), backendController.router.call);

    // Logs
    final errorLogController = ErrorLogController.endpoint();
    router.mount(mergePaths(root, errorLogController.path), errorLogController.router.call);

    return router;
  }

  static String mergePaths(String root, String endpoint) {
    return "$root/$endpoint";
  }
}
