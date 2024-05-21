import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass({required this.field});
  final String field;
}

@Stringable()
class EmptySubClass extends BaseClass {
  EmptySubClass({required super.field});
}

void main() {
  group(EmptySubClass, () {
    test('toString is correct', () {
      expect(
        EmptySubClass(field: 'field').toString(),
        equals('EmptySubClass(field: field)'),
      );
    });
  });
}
