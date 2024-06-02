import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Equatable()
class NullableSingleFieldClass {
  NullableSingleFieldClass({this.field});
  final String? field;
}

void main() {
  group(NullableSingleFieldClass, () {
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
  });
}
