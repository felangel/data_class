import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Stringable()
class SingleFieldClass {
  SingleFieldClass({required this.field});
  final String field;
}

void main() {
  group(SingleFieldClass, () {
    test('toString is correct', () {
      expect(
        SingleFieldClass(field: 'field').toString(),
        equals('SingleFieldClass(field: field)'),
      );
    });
  });
}
