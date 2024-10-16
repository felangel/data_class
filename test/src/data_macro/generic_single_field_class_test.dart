import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Data()
class GenericSingleFieldClass<T> {
  final T field;
}

void main() {
  group(GenericSingleFieldClass, () {
    test('has a const constructor and required param', () {
      expect(const GenericSingleFieldClass(field: 'field').field, equals('field'));
      expect(const GenericSingleFieldClass(field: 42).field, equals(42));
      expect(const GenericSingleFieldClass(field: true).field, equals(true));
    });

    test('copyWith creates a copy when no arguments are passed', () {
      final stringInstance = GenericSingleFieldClass(field: 'field');
      final stringCopy = stringInstance.copyWith();
      expect(stringCopy.field, equals(stringInstance.field));

      final intInstance = GenericSingleFieldClass(field: 42);
      final intCopy = intInstance.copyWith();
      expect(intCopy.field, equals(intInstance.field));

      final boolInstance = GenericSingleFieldClass(field: true);
      final boolCopy = boolInstance.copyWith();
      expect(boolCopy.field, equals(boolInstance.field));
    });

    test('copyWith creates a copy and overrides field', () {
      final stringInstance = GenericSingleFieldClass(field: 'field');
      final stringCopy = stringInstance.copyWith(field: 'other');
      expect(stringCopy.field, equals('other'));

      final intInstance = GenericSingleFieldClass(field: 42);
      final intCopy = intInstance.copyWith(field: 43);
      expect(intCopy.field, equals(43));

      final boolInstance = GenericSingleFieldClass(field: false);
      final boolCopy = boolInstance.copyWith(field: true);
      expect(boolCopy.field, equals(true));
    });

    test('== is correct', () {
      final stringInstanceA = GenericSingleFieldClass(field: 'field');
      final stringInstanceB = GenericSingleFieldClass(field: 'field');
      final stringInstanceC = GenericSingleFieldClass(field: 'other');
      expect(stringInstanceA, equals(stringInstanceB));
      expect(stringInstanceC, isNot(equals(stringInstanceB)));
      expect(stringInstanceC, isNot(equals(stringInstanceA)));

      final intInstanceA = GenericSingleFieldClass(field: 42);
      final intInstanceB = GenericSingleFieldClass(field: 42);
      final intInstanceC = GenericSingleFieldClass(field: 43);
      expect(intInstanceA, equals(intInstanceB));
      expect(intInstanceC, isNot(equals(intInstanceB)));
      expect(intInstanceC, isNot(equals(intInstanceA)));

      final boolInstanceA = GenericSingleFieldClass(field: false);
      final boolInstanceB = GenericSingleFieldClass(field: false);
      final boolInstanceC = GenericSingleFieldClass(field: true);
      expect(boolInstanceA, equals(boolInstanceB));
      expect(boolInstanceC, isNot(equals(boolInstanceB)));
      expect(boolInstanceC, isNot(equals(boolInstanceA)));
    });

    test('hashCode is correct', () {
      final stringInstanceA = GenericSingleFieldClass(field: 'field');
      final stringInstanceB = GenericSingleFieldClass(field: 'field');
      final stringInstanceC = GenericSingleFieldClass(field: 'other');
      expect(stringInstanceA.hashCode, equals(stringInstanceB.hashCode));
      expect(stringInstanceC.hashCode, isNot(equals(stringInstanceB.hashCode)));
      expect(stringInstanceC.hashCode, isNot(equals(stringInstanceA.hashCode)));

      final intInstanceA = GenericSingleFieldClass(field: 42);
      final intInstanceB = GenericSingleFieldClass(field: 42);
      final intInstanceC = GenericSingleFieldClass(field: 43);
      expect(intInstanceA.hashCode, equals(intInstanceB.hashCode));
      expect(intInstanceC.hashCode, isNot(equals(intInstanceB.hashCode)));
      expect(intInstanceC.hashCode, isNot(equals(intInstanceA.hashCode)));

      final boolInstanceA = GenericSingleFieldClass(field: false);
      final boolInstanceB = GenericSingleFieldClass(field: false);
      final boolInstanceC = GenericSingleFieldClass(field: true);
      expect(boolInstanceA.hashCode, equals(boolInstanceB.hashCode));
      expect(boolInstanceC.hashCode, isNot(equals(boolInstanceB.hashCode)));
      expect(boolInstanceC.hashCode, isNot(equals(boolInstanceA.hashCode)));
    });

    test('toString is correct', () {
      expect(
        GenericSingleFieldClass(field: 'field').toString(),
        equals('GenericSingleFieldClass(field: field)'),
      );
      expect(
        GenericSingleFieldClass(field: 42).toString(),
        equals('GenericSingleFieldClass(field: 42)'),
      );
      expect(
        GenericSingleFieldClass(field: true).toString(),
        equals('GenericSingleFieldClass(field: true)'),
      );
    });
  });
}
