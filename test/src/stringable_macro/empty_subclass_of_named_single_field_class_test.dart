import 'package:data_class/data_class.dart';
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
