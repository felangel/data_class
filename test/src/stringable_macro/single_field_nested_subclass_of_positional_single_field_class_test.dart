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

@Stringable()
class NestedSubClass extends SubClass {
  NestedSubClass({
    required this.nestedSubField,
    required String subField,
    required String baseField,
  }) : super(subField, baseField);
  final String nestedSubField;
}

void main() {
  group(NestedSubClass, () {
    test('toString is correct', () {
      expect(
        NestedSubClass(
          baseField: 'baseField',
          subField: 'subField',
          nestedSubField: 'nestedSubField',
        ).toString(),
        equals(
          'NestedSubClass(nestedSubField: nestedSubField, subField: subField, baseField: baseField)',
        ),
      );
    });
  });
}
