import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Equatable()
class SingleFieldClass {
  SingleFieldClass({required this.field});
  final String field;
}

void main() {
  group(SingleFieldClass, () {
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
  });
}
