import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Equatable()
class EmptyClass {}

void main() {
  group(EmptyClass, () {
    test('== is correct', () {
      expect(EmptyClass(), equals(EmptyClass()));
    });

    test('hashCode is correct', () {
      expect(EmptyClass().hashCode, equals(EmptyClass().hashCode));
    });
  });
}
