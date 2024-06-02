import 'package:data_class/data_class.dart';
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
