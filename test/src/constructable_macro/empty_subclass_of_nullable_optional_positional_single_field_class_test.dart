import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass([this.field]);
  final String? field;
}

@Constructable()
class EmptySubclass extends BaseClass {}

void main() {
  group(EmptySubclass, () {
    test('has a const constructor and requires the super class param', () {
      const instance = EmptySubclass(field: 'field');
      expect(instance.field, equals('field'));
      expect(instance, isA<EmptySubclass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
