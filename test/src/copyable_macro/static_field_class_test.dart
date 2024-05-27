import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Copyable()
class StaticFieldClass {
  const StaticFieldClass();
  static const String field = 'field';
}

void main() {
  group(StaticFieldClass, () {
    test('copyWith is correct', () {
      expect(StaticFieldClass().copyWith(), isA<StaticFieldClass>());
    });
  });
}
