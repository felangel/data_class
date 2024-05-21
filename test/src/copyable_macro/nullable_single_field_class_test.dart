import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Copyable()
class NullableSingleFieldClass {
  const NullableSingleFieldClass({this.field});
  final String? field;
}

void main() {
  group(NullableSingleFieldClass, () {
    test('copyWith creates a copy when no arguments are passed', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith(field: () => 'other');
      expect(copy.field, equals('other'));
    });

    test('copyWith creates a copy and overrides field with null', () {
      final instance = NullableSingleFieldClass(field: 'field');
      final copy = instance.copyWith(field: () => null);
      expect(copy.field, isNull);
    });
  });
}
