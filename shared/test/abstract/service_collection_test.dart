import 'package:shared/shared.dart';
import 'package:test/test.dart';

class _TestServiceCollection extends ServiceCollection<String, Object> {
  @override
  Future<void> initalize() async {}
}

class _BaseService {}

class _ConcreteService extends _BaseService {
  final String name;

  _ConcreteService(this.name);
}

void main() {
  group('ServiceCollection', () {
    test('addAll and getByKey provide keyed access', () {
      final collection = _TestServiceCollection();
      final service = _ConcreteService('alpha');

      collection.addAll({'svc': service});

      expect(collection.getByKey('svc'), same(service));
    });

    test('get<T> resolves by runtime type', () {
      final collection = _TestServiceCollection();
      final service = _ConcreteService('beta');

      collection.addAll({'svc': service});

      final resolved = collection.get<_ConcreteService>();
      expect(resolved, same(service));
      expect(resolved.name, 'beta');
    });

    test('get<T> throws when type is missing', () {
      final collection = _TestServiceCollection();
      collection.addAll({'base': _BaseService()});

      expect(() => collection.get<_ConcreteService>(), throwsA(isA<StateError>()));
    });
  });
}
