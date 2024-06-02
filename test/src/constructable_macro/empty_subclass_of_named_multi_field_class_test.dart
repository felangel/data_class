import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass({required this.stringField, required this.intField});
  final String stringField;
  final int intField;
}

@Constructable()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('has a const constructor and requires the super class param', () {
      const instance = EmptySubClass(
        stringField: 'stringField',
        intField: 42,
      );
      expect(instance.stringField, equals('stringField'));
      expect(instance.intField, equals(42));
      expect(instance, isA<EmptySubClass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
