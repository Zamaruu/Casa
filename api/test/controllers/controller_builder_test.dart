import 'package:casa_api/src/controllers/controller_builder.dart';
import 'package:test/test.dart';

void main() {
  test('mergePaths combines root and endpoint', () {
    expect(ControllerBuilder.mergePaths('/api', 'todos/items'), '/api/todos/items');
  });
}
