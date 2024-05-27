import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Stringable()
class StaticFieldClass {
  static const field = 'field';
}

void main() {
  group(StaticFieldClass, () {
    test('toString is correct', () {
      expect(StaticFieldClass().toString(), equals('StaticFieldClass()'));
    });
  });
}
