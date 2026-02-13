import 'dart:convert';

import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class TodoAttachmentController extends CrudController<ITodoAttachment, ITodoAttachmentOperations> {
  TodoAttachmentController({
    required super.operations,
    required super.logger,
  });

  factory TodoAttachmentController.endpoint() {
    final logger = services.logger;
    final operations = services.database.get<ITodoAttachmentOperations>();

    final controller = TodoAttachmentController(
      operations: operations,
      logger: logger,
    );
    controller.registerEndpoints();

    return controller;
  }

  @override
  String get path => 'todos/attachments';

  @override
  ITodoAttachment Function(Map<String, dynamic> json) get entityFromJson => TodoAttachment.fromJson;

  @override
  void registerEndpoints() {
    super.registerEndpoints();
    router.get('/by-item/<itemId>', getByItemId);
  }

  Future<ApiResponse> getByItemId(Request request, String itemId) async {
    return runCustomGuarded(() async {
      final response = await operations.findByTodoItemId(itemId);

      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? 'Error while finding todo attachments by item');
      }

      final attachments = response.value ?? <ITodoAttachment>[];
      final json = jsonEncode(attachments.map((e) => e.toJson()).toList());
      return ApiResponse.ok(json);
    }, onError: onGuardedError);
  }
}
