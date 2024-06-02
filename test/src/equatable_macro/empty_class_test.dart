import 'package:data_class/data_class.dart';
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
