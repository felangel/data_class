import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.stringField, this.intField);
  final String stringField;
  final int intField;
}

@Data()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('has a const constructor and requires the super class params', () {
      const instance = EmptySubClass(
        stringField: 'stringField',
        intField: 42,
      );
      expect(instance.stringField, equals('stringField'));
      expect(instance.intField, equals(42));
      expect(instance, isA<EmptySubClass>());
      expect(instance, isA<BaseClass>());
    });

    test('copyWith creates a copy when no arguments are passed', () {
      final instance = EmptySubClass(stringField: 'stringField', intField: 42);
      final copy = instance.copyWith();
      expect(copy.stringField, equals(instance.stringField));
      expect(copy.intField, equals(instance.intField));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = EmptySubClass(stringField: 'stringField', intField: 42);
      final copy = instance.copyWith(intField: () => 0);
      expect(copy.stringField, equals(instance.stringField));
      expect(copy.intField, equals(0));
    });

    test('== is correct', () {
      final instanceA = EmptySubClass(stringField: 'stringField', intField: 42);
      final instanceB = EmptySubClass(stringField: 'stringField', intField: 42);
      final instanceC = EmptySubClass(stringField: 'otherField', intField: 42);
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = EmptySubClass(stringField: 'stringField', intField: 42);
      final instanceB = EmptySubClass(stringField: 'stringField', intField: 42);
      final instanceC = EmptySubClass(stringField: 'otherField', intField: 42);
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        EmptySubClass(stringField: 'stringField', intField: 42).toString(),
        equals('EmptySubClass(stringField: stringField, intField: 42)'),
      );
    });
  });
}
