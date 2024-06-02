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

@Equatable()
class NestedSubClass extends SubClass {
  NestedSubClass({
    required this.nestedSubField,
    required String subField,
    required String baseField,
  }) : super(subField, baseField);
  final String nestedSubField;
}

void main() {
  group(NestedSubClass, () {
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
  });
}
