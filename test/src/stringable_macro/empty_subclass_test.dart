import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

@Stringable()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('toString is correct', () {
      expect(EmptySubClass().toString(), equals('EmptySubClass()'));
    });
  });
}
