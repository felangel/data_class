import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);

  final String baseField;
}

abstract class SubClass extends BaseClass {
  const SubClass(this.subField, super.baseField);

  final String subField;
}

@Copyable()
class NestedSubClass extends SubClass {
  const NestedSubClass({
    required String subField,
    required String baseField,
    required this.nestedSubField,
  }) : super(subField, baseField);
  final String nestedSubField;
}

void main() {
  group(NestedSubClass, () {
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
  });
}
