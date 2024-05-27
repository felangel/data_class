import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Constructable()
class StaticFieldClass {
  static const String field = 'field';
}

void main() {
  group(StaticFieldClass, () {
    test('has a const constructor', () {
      expect(const StaticFieldClass(), isA<StaticFieldClass>());
    });
  });
}
