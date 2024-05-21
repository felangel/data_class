import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass({required this.stringField, required this.intField});
  final String stringField;
  final int intField;
}

@Stringable()
class EmptySubClass extends BaseClass {
  EmptySubClass({required super.stringField, required super.intField});
}

void main() {
  group(EmptySubClass, () {
    test('toString is correct', () {
      expect(
        EmptySubClass(stringField: 'stringField', intField: 42).toString(),
        equals('EmptySubClass(stringField: stringField, intField: 42)'),
      );
    });
  });
}
