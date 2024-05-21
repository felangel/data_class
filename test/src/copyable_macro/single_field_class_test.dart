import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Copyable()
class SingleFieldClass {
  const SingleFieldClass({required this.field});
  final String field;
}

void main() {
  group(SingleFieldClass, () {
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
  });
}
