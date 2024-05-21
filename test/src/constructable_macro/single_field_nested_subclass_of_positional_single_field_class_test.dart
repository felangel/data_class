import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

abstract class BaseClass {
  const BaseClass(this.baseField);

  final String baseField;
}

abstract class SubClass extends BaseClass {
  const SubClass(this.subField, super.baseField);

  final String subField;
}

@Constructable()
class NestedSubClass extends SubClass {
  final String nestedSubField;
}

void main() {
  group(NestedSubClass, () {
    test('has a const constructor', () {
      const instance = NestedSubClass(
        baseField: 'baseField',
        subField: 'subField',
        nestedSubField: 'nestedSubField',
      );
      expect(instance.baseField, equals('baseField'));
      expect(instance.subField, equals('subField'));
      expect(instance.nestedSubField, equals('nestedSubField'));
      expect(instance, isA<NestedSubClass>());
      expect(instance, isA<SubClass>());
      expect(instance, isA<BaseClass>());
    });
  });
}
