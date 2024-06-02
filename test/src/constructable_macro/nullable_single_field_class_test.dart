import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Constructable()
class NullableSingleFieldClass {
  final String? field;
}

void main() {
  group(NullableSingleFieldClass, () {
    test('has a const constructor and param defaults to null', () {
      expect(const NullableSingleFieldClass().field, isNull);
    });

    test('param can be used to specify a non-null value', () {
      expect(
        const NullableSingleFieldClass(field: 'field').field,
        equals('field'),
      );
    });
  });
}
