import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Copyable()
class GenericSingleFieldClass<T> {
  const GenericSingleFieldClass({required this.field});
  final T field;
}

void main() {
  group(GenericSingleFieldClass, () {
    test('copyWith creates a copy when no arguments are passed', () {
      final stringInstance = GenericSingleFieldClass(field: 'field');
      final stringCopy = stringInstance.copyWith();
      expect(stringCopy.field, equals(stringInstance.field));

      final intInstance = GenericSingleFieldClass(field: 42);
      final intCopy = intInstance.copyWith();
      expect(intCopy.field, equals(intInstance.field));

      final boolInstance = GenericSingleFieldClass(field: false);
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
  });
}
