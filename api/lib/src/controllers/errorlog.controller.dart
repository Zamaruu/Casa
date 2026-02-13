import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';

class ErrorLogController extends CrudController<IErrorLog, IErrorLogOperations> {
  ErrorLogController({
    required super.logger,
    required super.operations,
  });

  factory ErrorLogController.endpoint() {
    final logger = services.logger;
    final errorLogOperations = services.database.get<IErrorLogOperations>();

    final controller = ErrorLogController(
      operations: errorLogOperations,
      logger: logger,
    );

    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => EApiController.errorLogs.path;

  @override
  IErrorLog Function(Map<String, dynamic> json) get entityFromJson => ErrorLog.fromJson;
}
