import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.field);
  final String field;
}

@Copyable()
class EmptySubClass extends BaseClass {
  const EmptySubClass({required String field}) : super(field);
}

void main() {
  group(EmptySubClass, () {
    test('copyWith creates a copy when no arguments are passed', () {
      final instance = EmptySubClass(field: 'field');
      final copy = instance.copyWith();
      expect(copy.field, equals(instance.field));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = EmptySubClass(field: 'field');
      final copy = instance.copyWith(field: 'other');
      expect(copy.field, equals('other'));
    });
  });
}
