import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Equatable()
class GenericSingleFieldClass<T> {
  GenericSingleFieldClass({required this.field});
  final T field;
}

void main() {
  group(GenericSingleFieldClass, () {
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
  });
}
