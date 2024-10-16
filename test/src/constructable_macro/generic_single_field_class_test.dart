import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Constructable()
class GenericSingleFieldClass<T> {
  final T field;
}

void main() {
  group(GenericSingleFieldClass, () {
    test('has a const constructor and required param', () {
      expect(const GenericSingleFieldClass(field: false).field, equals(false));
      expect(const GenericSingleFieldClass(field: 'field').field, equals('field'));
      expect(const GenericSingleFieldClass(field: 42).field, equals(42));
      expect(const GenericSingleFieldClass(field: 42.0).field, equals(42.0));
    });
  });
}
