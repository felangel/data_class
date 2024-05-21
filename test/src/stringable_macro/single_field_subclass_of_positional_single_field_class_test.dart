import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);
  final String baseField;
}

@Stringable()
class SingleFieldSubClass extends BaseClass {
  SingleFieldSubClass({
    required this.field,
    required String baseField,
  }) : super(baseField);
  final String field;
}

void main() {
  group(SingleFieldSubClass, () {
    test('toString is correct', () {
      expect(
        SingleFieldSubClass(baseField: 'baseField', field: 'field').toString(),
        equals('SingleFieldSubClass(field: field, baseField: baseField)'),
      );
    });
  });
}
