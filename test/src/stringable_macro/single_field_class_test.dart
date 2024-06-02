import 'package:data_class/data_class.dart';
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
