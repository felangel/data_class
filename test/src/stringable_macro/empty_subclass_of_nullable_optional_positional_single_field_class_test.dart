import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass([this.field]);
  final String? field;
}

@Stringable()
class EmptySubClass extends BaseClass {
  EmptySubClass([super.field]);
}

void main() {
  group(EmptySubClass, () {
    test('toString is correct', () {
      expect(
        EmptySubClass('field').toString(),
        equals('EmptySubClass(field: field)'),
      );
      expect(
        EmptySubClass().toString(),
        equals('EmptySubClass()'),
      );
      expect(
        EmptySubClass(null).toString(),
        equals('EmptySubClass()'),
      );
    });
  });
}
