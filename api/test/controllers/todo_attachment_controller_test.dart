import 'dart:convert';

import 'package:casa_api/src/controllers/todo_attachment.controller.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../helpers/test_doubles.dart';

void main() {
  group('TodoAttachmentController', () {
    test('getByItemId returns 200 with serialized attachments', () async {
      final operations = TestTodoAttachmentOperations()
        ..byItemResponse = ValueResponse.success(
          value: const [
            TodoAttachment(
              id: 'a1',
              attachmentTargetId: 'i1',
              fileName: 'note.txt',
              mimeType: 'text/plain',
              sizeBytes: 10,
              storagePath: '/tmp/note.txt',
              uploadedByUserId: 'u1',
            ),
          ],
        );
      final controller = TodoAttachmentController(operations: operations, logger: TestLogger());
      controller.registerEndpoints();

      final response = await controller.getByItemId(Request('GET', Uri.parse('http://localhost/')), 'i1');

      expect(response.statusCode, 200);
      final body = jsonDecode(await response.readAsString()) as List<dynamic>;
      expect(body.length, 1);
      expect(body.first['id'], 'a1');
      expect(body.first['attachmentTargetId'], 'i1');
    });

    test('registerEndpoints exposes by-item route', () async {
      final controller = TodoAttachmentController(operations: TestTodoAttachmentOperations(), logger: TestLogger());
      controller.registerEndpoints();

      final response = await controller.handler(Request('GET', Uri.parse('http://localhost/by-item/i1')));

      expect(response.statusCode, 200);
    });
  });
}
