import 'package:api/src/controllers/user.controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ControllerBuilder {
  static Handler buildEndpoints() {
    final router = Router();

    // User
    final userController = UserController.endpoint();
    router.mount(userController.path, userController.handler);

    return router.call;
  }
}
