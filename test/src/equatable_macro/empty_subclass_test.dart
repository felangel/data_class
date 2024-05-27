import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

@Equatable()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('== is correct', () {
      expect(EmptySubClass(), equals(EmptySubClass()));
    });

    test('hashCode is correct', () {
      expect(EmptySubClass().hashCode, equals(EmptySubClass().hashCode));
    });
  });
}
