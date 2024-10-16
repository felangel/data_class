import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Stringable()
class GenericSingleFieldClass<T> {
  GenericSingleFieldClass({required this.field});
  final T field;
}

void main() {
  group(GenericSingleFieldClass, () {
    test('toString is correct', () {
      expect(
        GenericSingleFieldClass(field: 'field').toString(),
        equals('GenericSingleFieldClass(field: field)'),
      );
      expect(
        GenericSingleFieldClass(field: 42).toString(),
        equals('GenericSingleFieldClass(field: 42)'),
      );
      expect(
        GenericSingleFieldClass(field: true).toString(),
        equals('GenericSingleFieldClass(field: true)'),
      );
    });
  });
}
