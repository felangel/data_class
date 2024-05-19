import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);
  final String baseField;
}

@Constructable()
class SingleFieldSubclass extends BaseClass {
  final String field;
}

void main() {
  group(SingleFieldSubclass, () {
    test('has a const constructor and has required param for all fields', () {
      const instance = SingleFieldSubclass(
        baseField: 'baseField',
        field: 'field',
      );
      expect(instance.baseField, equals('baseField'));
      expect(instance.field, equals('field'));
      expect(instance, isA<SingleFieldSubclass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
