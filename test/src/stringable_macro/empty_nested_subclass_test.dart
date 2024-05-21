import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {}

abstract class SubClass extends BaseClass {}

@Stringable()
class EmptyNestedSubClass extends SubClass {}

void main() {
  group(EmptyNestedSubClass, () {
    test('toString is correct', () {
      expect(EmptyNestedSubClass().toString(), equals('EmptyNestedSubClass()'));
    });
  });
}
