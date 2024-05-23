import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Data()
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

    test('copyWith creates a copy when no arguments are passed', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith(field: () => 'other');
      expect(copy.field, equals('other'));
    });

    test('copyWith creates a copy and overrides field with null', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith(field: () => null);
      expect(copy.field, isNull);
    });

    test('== is correct', () {
      final instanceA = NullableSingleFieldClass(field: 'field');
      final instanceB = NullableSingleFieldClass(field: 'field');
      final instanceC = NullableSingleFieldClass();
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = NullableSingleFieldClass(field: 'field');
      final instanceB = NullableSingleFieldClass(field: 'field');
      final instanceC = NullableSingleFieldClass();
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        NullableSingleFieldClass(field: 'field').toString(),
        equals('NullableSingleFieldClass(field: field)'),
      );
      expect(
        NullableSingleFieldClass().toString(),
        equals('NullableSingleFieldClass()'),
      );
    });
  });
}
