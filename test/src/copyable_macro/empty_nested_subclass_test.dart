import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

abstract class SubClass extends BaseClass {
  const SubClass();
}

@Copyable()
class EmptyNestedSubClass extends SubClass {
  const EmptyNestedSubClass();
}

void main() {
  group(EmptyNestedSubClass, () {
    test('copyWith is correct', () {
      expect(
          const EmptyNestedSubClass().copyWith(), isA<EmptyNestedSubClass>());
    });
  });
}
