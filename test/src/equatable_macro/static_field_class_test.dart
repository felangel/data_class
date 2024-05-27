import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Equatable()
class StaticFieldClass {
  static const String field = 'field';
}

void main() {
  group(StaticFieldClass, () {
    test('== is correct', () {
      expect(StaticFieldClass(), equals(StaticFieldClass()));
    });

    test('hashCode is correct', () {
      expect(StaticFieldClass().hashCode, equals(StaticFieldClass().hashCode));
    });
  });
}
