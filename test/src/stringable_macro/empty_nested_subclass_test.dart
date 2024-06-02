import 'package:data_class/data_class.dart';
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
