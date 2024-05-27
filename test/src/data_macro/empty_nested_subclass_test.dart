import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass();
}

abstract class SubClass extends BaseClass {
  const SubClass();
}

@Data()
class EmptyNestedSubClass extends SubClass {}

void main() {
  group(EmptyNestedSubClass, () {
    test('has a const constructor', () {
      expect(const EmptyNestedSubClass(), isA<EmptyNestedSubClass>());
      expect(const EmptyNestedSubClass(), isA<SubClass>());
      expect(const EmptyNestedSubClass(), isA<BaseClass>());
    });

    test('copyWith is correct', () {
      expect(
        const EmptyNestedSubClass().copyWith(),
        isA<EmptyNestedSubClass>(),
      );
    });

    test('== is correct', () {
      expect(EmptyNestedSubClass(), equals(EmptyNestedSubClass()));
    });

    test('hashCode is correct', () {
      expect(EmptyNestedSubClass().hashCode, equals(EmptyNestedSubClass().hashCode));
    });

    test('toString is correct', () {
      expect(EmptyNestedSubClass().toString(), equals('EmptyNestedSubClass()'));
    });
  });
}
