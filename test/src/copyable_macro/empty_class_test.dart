import 'package:data_class/data_class.dart';
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
