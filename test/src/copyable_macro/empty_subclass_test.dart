import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

@Copyable()
class EmptySubClass extends BaseClass {
  const EmptySubClass();
}

void main() {
  group(EmptySubClass, () {
    test('copyWith is correct', () {
      expect(EmptySubClass().copyWith(), isA<EmptySubClass>());
    });
  });
}
