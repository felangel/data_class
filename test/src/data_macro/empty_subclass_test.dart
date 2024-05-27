import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

@Data()
class EmptySubClass extends BaseClass {}

void main() {
  group(EmptySubClass, () {
    test('has a const constructor', () {
      expect(const EmptySubClass(), isA<EmptySubClass>());
      expect(const EmptySubClass(), isA<BaseClass>());
    });

    test('copyWith is correct', () {
      expect(EmptySubClass().copyWith(), isA<EmptySubClass>());
    });

    test('== is correct', () {
      expect(EmptySubClass(), equals(EmptySubClass()));
    });

    test('hashCode is correct', () {
      expect(EmptySubClass().hashCode, equals(EmptySubClass().hashCode));
    });

    test('toString is correct', () {
      expect(EmptySubClass().toString(), equals('EmptySubClass()'));
    });
  });
}
