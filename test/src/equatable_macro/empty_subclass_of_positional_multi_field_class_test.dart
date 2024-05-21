import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.stringField, this.intField);
  final String stringField;
  final int intField;
}

@Equatable()
class EmptySubClass extends BaseClass {
  EmptySubClass(super.stringField, super.intField);
}

void main() {
  group(EmptySubClass, () {
    test('== is correct', () {
      final instanceA = EmptySubClass('stringField', 42);
      final instanceB = EmptySubClass('stringField', 42);
      final instanceC = EmptySubClass('otherField', 42);
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = EmptySubClass('stringField', 42);
      final instanceB = EmptySubClass('stringField', 42);
      final instanceC = EmptySubClass('otherField', 42);
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });
  });
}
