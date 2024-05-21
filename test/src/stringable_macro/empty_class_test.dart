import 'package:data_class_macro/data_class_macro.dart';
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