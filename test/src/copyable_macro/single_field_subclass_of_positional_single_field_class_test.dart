import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);
  final String baseField;
}

@Copyable()
class SingleFieldSubClass extends BaseClass {
  const SingleFieldSubClass({required String baseField, required this.field}) : super(baseField);
  final String field;
}

void main() {
  group(SingleFieldSubClass, () {
    test('copyWith creates a copy when no arguments are passed', () {
      final instance = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
      expect(copy.baseField, equals(instance.baseField));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = SingleFieldSubClass(
        field: 'field',
        baseField: 'baseField',
      );
      final copy = instance.copyWith(baseField: 'other');
      expect(copy.field, equals(instance.field));
      expect(copy.baseField, equals('other'));
    });
  });
}
