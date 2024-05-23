import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Data()
class EmptyClass {}

void main() {
  group(EmptyClass, () {
    test('has a const constructor', () {
      expect(const EmptyClass(), isA<EmptyClass>());
    });

    test('copyWith is correct', () {
      expect(EmptyClass().copyWith(), isA<EmptyClass>());
    });

    test('== is correct', () {
      expect(EmptyClass(), equals(EmptyClass()));
    });

    test('hashCode is correct', () {
      expect(EmptyClass().hashCode, equals(Object.hashAll([])));
    });

    test('toString is correct', () {
      expect(EmptyClass().toString(), equals('EmptyClass()'));
    });
  });
}
