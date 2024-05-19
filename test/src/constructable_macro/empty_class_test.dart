import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Constructable()
class EmptyClass {}

void main() {  
  group(EmptyClass, () {
    test('has a const constructor', () {
      expect(const EmptyClass(), isA<EmptyClass>());
    });
  });
}