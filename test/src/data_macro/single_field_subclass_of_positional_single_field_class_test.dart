import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);
  final String baseField;
}

@Data()
class SingleFieldSubClass extends BaseClass {
  final String field;
}

void main() {
  group(SingleFieldSubClass, () {
    test('has a const constructor and has required param for all fields', () {
      const instance = SingleFieldSubClass(
        baseField: 'baseField',
        field: 'field',
      );
      expect(instance.baseField, equals('baseField'));
      expect(instance.field, equals('field'));
      expect(instance, isA<SingleFieldSubClass>());
      expect(instance, isA<BaseClass>());
    });

    test('copyWith creates a copy when no arguments are passed', () {
      final instance = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
      expect(copy.baseField, equals(instance.baseField));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final copy = instance.copyWith(baseField: 'other');
      expect(copy.field, equals(instance.field));
      expect(copy.baseField, equals('other'));
    });

    test('== is correct', () {
      final instanceA = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final instanceB = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final instanceC = SingleFieldSubClass(
        field: 'field',
        baseField: 'other',
      );
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final instanceB = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final instanceC = SingleFieldSubClass(
        field: 'field',
        baseField: 'other',
      );
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        SingleFieldSubClass(baseField: 'baseField', field: 'field').toString(),
        equals('SingleFieldSubClass(field: field, baseField: baseField)'),
      );
    });
  });
}
