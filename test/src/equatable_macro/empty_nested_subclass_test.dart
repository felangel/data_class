import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {}

abstract class SubClass extends BaseClass {}

@Equatable()
class EmptyNestedSubClass extends SubClass {}

void main() {
  group(EmptyNestedSubClass, () {
    test('== is correct', () {
      expect(EmptyNestedSubClass(), equals(EmptyNestedSubClass()));
    });

    test('hashCode is correct', () {
      expect(EmptyNestedSubClass().hashCode, equals(Object.hashAll([])));
    });
  });
}
