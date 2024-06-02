import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass({required this.stringField, required this.intField});
  final String stringField;
  final int intField;
}

@Copyable()
class EmptySubClass extends BaseClass {
  const EmptySubClass({required String stringField, required int intField})
      : super(stringField: stringField, intField: intField);
}

void main() {
  group(EmptySubClass, () {
    test('copyWith creates a copy when no arguments are passed', () {
      final instance = EmptySubClass(stringField: 'stringField', intField: 42);
      final copy = instance.copyWith();
      expect(copy.stringField, equals(instance.stringField));
      expect(copy.intField, equals(instance.intField));
    });

    test('copyWith creates a copy and overrides field', () {
      final instance = EmptySubClass(stringField: 'stringField', intField: 42);
      final copy = instance.copyWith(intField: 0);
      expect(copy.stringField, equals(instance.stringField));
      expect(copy.intField, equals(0));
    });
  });
}
