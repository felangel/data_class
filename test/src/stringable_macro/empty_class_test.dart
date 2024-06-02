import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Stringable()
class EmptyClass {}

void main() {
  group(EmptyClass, () {
    test('toString is correct', () {
      expect(EmptyClass().toString(), equals('EmptyClass()'));
    });
  });
}
