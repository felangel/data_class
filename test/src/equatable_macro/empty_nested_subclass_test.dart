import 'package:data_class/data_class.dart';
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
      expect(EmptyNestedSubClass().hashCode,
          equals(EmptyNestedSubClass().hashCode));
    });
  });
}
