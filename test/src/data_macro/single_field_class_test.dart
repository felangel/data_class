import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Data()
class SingleFieldClass {
  final String field;
}

void main() {
  group(SingleFieldClass, () {
    test('has a const constructor and required param', () {
      expect(const SingleFieldClass(field: 'field').field, equals('field'));
    });

    test('copyWith creates a copy when no arguments are passed', () {
      final instance = SingleFieldClass(field: 'field');
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = SingleFieldClass(field: 'field');
      final copy = instance.copyWith(field: () => 'other');
      expect(copy.field, equals('other'));
    });

    test('== is correct', () {
      final instanceA = SingleFieldClass(field: 'field');
      final instanceB = SingleFieldClass(field: 'field');
      final instanceC = SingleFieldClass(field: 'other');
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = SingleFieldClass(field: 'field');
      final instanceB = SingleFieldClass(field: 'field');
      final instanceC = SingleFieldClass(field: 'other');
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        SingleFieldClass(field: 'field').toString(),
        equals('SingleFieldClass(field: field)'),
      );
    });
  });
}
