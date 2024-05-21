import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Stringable()
class NullableSingleFieldClass {
  NullableSingleFieldClass({this.field});
  final String? field;
}

void main() {
  group(NullableSingleFieldClass, () {
    test('toString is correct', () {
      expect(
        NullableSingleFieldClass(field: 'field').toString(),
        equals('NullableSingleFieldClass(field: field)'),
      );
      expect(
        NullableSingleFieldClass().toString(),
        equals('NullableSingleFieldClass()'),
      );
    });
  });
}
