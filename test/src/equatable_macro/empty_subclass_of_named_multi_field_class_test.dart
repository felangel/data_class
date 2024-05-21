import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass({required this.stringField, required this.intField});
  final String stringField;
  final int intField;
}

@Equatable()
class EmptySubClass extends BaseClass {
  EmptySubClass({required super.stringField, required super.intField});
}

void main() {
  group(EmptySubClass, () {
    test('== is correct', () {
      final instanceA = EmptySubClass(intField: 42, stringField: 'stringField');
      final instanceB = EmptySubClass(intField: 42, stringField: 'stringField');
      final instanceC = EmptySubClass(intField: 42, stringField: 'otherField');
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = EmptySubClass(intField: 42, stringField: 'stringField');
      final instanceB = EmptySubClass(intField: 42, stringField: 'stringField');
      final instanceC = EmptySubClass(intField: 42, stringField: 'otherField');
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });
  });
}
