import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);

  final String baseField;
}

abstract class SubClass extends BaseClass {
  const SubClass(this.subField, super.baseField);

  final String subField;
}

@Data()
class NestedSubClass extends SubClass {
  final String nestedSubField;
}

void main() {
  group(NestedSubClass, () {
    test('has a const constructor', () {
      const instance = NestedSubClass(
        baseField: 'baseField',
        subField: 'subField',
        nestedSubField: 'nestedSubField',
      );
      expect(instance.baseField, equals('baseField'));
      expect(instance.subField, equals('subField'));
      expect(instance.nestedSubField, equals('nestedSubField'));
      expect(instance, isA<NestedSubClass>());
      expect(instance, isA<SubClass>());
      expect(instance, isA<BaseClass>());
    });

    test('copyWith creates a copy when no arguments are passed', () {
      final instance = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final copy = instance.copyWith();
      expect(copy.nestedSubField, equals(instance.nestedSubField));
      expect(copy.subField, equals(instance.subField));
      expect(copy.baseField, equals(instance.baseField));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final copy = instance.copyWith(baseField: 'other');
      expect(copy.nestedSubField, equals(instance.nestedSubField));
      expect(copy.subField, equals(instance.subField));
      expect(copy.baseField, equals('other'));
    });

    test('== is correct', () {
      final instanceA = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final instanceB = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final instanceC = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'other',
      );
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final instanceB = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'baseField',
      );
      final instanceC = NestedSubClass(
        nestedSubField: 'nestedSubField',
        subField: 'subField',
        baseField: 'other',
      );
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        NestedSubClass(
          baseField: 'baseField',
          subField: 'subField',
          nestedSubField: 'nestedSubField',
        ).toString(),
        equals(
          'NestedSubClass(nestedSubField: nestedSubField, subField: subField, baseField: baseField)',
        ),
      );
    });
  });
}
