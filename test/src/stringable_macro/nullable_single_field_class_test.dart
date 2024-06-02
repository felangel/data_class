import 'package:data_class/data_class.dart';
import 'package:test/test.dart';

@Stringable()
class NullableSingleFieldClass {
  NullableSingleFieldClass({this.fieldA, this.fieldB});
  final String? fieldA;
  final String? fieldB;
}

void main() {
  group(NullableSingleFieldClass, () {
    test('toString is correct', () {
      expect(
        NullableSingleFieldClass(fieldA: 'fieldA', fieldB: 'fieldB').toString(),
        equals('NullableSingleFieldClass(fieldA: fieldA, fieldB: fieldB)'),
      );
      expect(
        NullableSingleFieldClass(fieldA: 'fieldA').toString(),
        equals('NullableSingleFieldClass(fieldA: fieldA)'),
      );
      expect(
        NullableSingleFieldClass(fieldB: 'fieldB').toString(),
        equals('NullableSingleFieldClass(fieldB: fieldB)'),
      );
      expect(
        NullableSingleFieldClass().toString(),
        equals('NullableSingleFieldClass()'),
      );
    });
  });
}
