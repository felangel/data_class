import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass([this.field = '']);
  final String field;
}

@Constructable()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    // TODO(felangel): this should be an optional, named param with a default.
    test('has a const constructor and requires the super class param', () {
      const instance = EmptySubClass(field: 'field');
      expect(instance.field, equals('field'));
      expect(instance, isA<EmptySubClass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
