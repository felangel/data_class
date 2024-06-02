import 'package:data_class/data_class.dart';
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
