import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.stringField, this.intField);
  final String stringField;
  final int intField;
}

@Constructable()
class EmptySubclass extends BaseClass {}

void main() {
  group(EmptySubclass, () {
    test('has a const constructor and requires the super class params', () {
      const instance = EmptySubclass(
        stringField: 'stringField',
        intField: 42,
      );
      expect(instance.stringField, equals('stringField'));
      expect(instance.intField, equals(42));
      expect(instance, isA<EmptySubclass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
