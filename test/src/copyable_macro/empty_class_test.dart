import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Copyable()
class EmptyClass {
  const EmptyClass();
}

void main() {
  group(EmptyClass, () {
    test('copyWith is correct', () {
      expect(EmptyClass().copyWith(), isA<EmptyClass>());
    });
  });
}
