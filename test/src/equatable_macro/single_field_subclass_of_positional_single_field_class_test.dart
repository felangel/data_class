import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);
  final String baseField;
}

@Equatable()
class SingleFieldSubClass extends BaseClass {
  SingleFieldSubClass({
    required this.field,
    required String baseField,
  }) : super(baseField);
  final String field;
}

void main() {
  group(SingleFieldSubClass, () {
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
  });
}
