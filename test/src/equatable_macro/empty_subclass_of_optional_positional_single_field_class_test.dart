import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass([this.field = '']);
  final String field;
}

@Equatable()
class EmptySubClass extends BaseClass {
  EmptySubClass([super.field]);
}

void main() {
  group(EmptySubClass, () {
    test('== is correct', () {
      final instanceA = EmptySubClass('field');
      final instanceB = EmptySubClass('field');
      final instanceC = EmptySubClass('other');
      expect(instanceA, equals(instanceB));
      expect(instanceC, isNot(equals(instanceB)));
      expect(instanceC, isNot(equals(instanceA)));
    });

    test('hashCode is correct', () {
      final instanceA = EmptySubClass('field');
      final instanceB = EmptySubClass('field');
      final instanceC = EmptySubClass('other');
      expect(instanceA.hashCode, equals(instanceB.hashCode));
      expect(instanceC.hashCode, isNot(equals(instanceB.hashCode)));
      expect(instanceC.hashCode, isNot(equals(instanceA.hashCode)));
    });
  });
}
