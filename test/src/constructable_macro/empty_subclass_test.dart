import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

@Constructable()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('has a const constructor', () {
      expect(const EmptySubClass(), isA<EmptySubClass>());
      expect(const EmptySubClass(), isA<BaseClass>());
    });
  });
}
