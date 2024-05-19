import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Constructable()
class SingleFieldClass {
  final String field;
}

void main() {
  group(SingleFieldClass, () {
    test('has a const constructor and required param', () {
      expect(const SingleFieldClass(field: 'field').field, equals('field'));
    });
  });
}
