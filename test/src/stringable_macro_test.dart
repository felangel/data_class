import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Stringable()
class EmptyClass {
  const EmptyClass();
}

@Stringable()
class StringFieldClass {
  const StringFieldClass({required this.value});
  final String value;
}

@Stringable()
class NullableStringFieldClass {
  const NullableStringFieldClass({this.value});
  final String? value;
}

void main() {
  group(EmptyClass, () {
    test('toString', () {
      expect(const EmptyClass().toString(), equals('EmptyClass()'));
    });
  });

  group(StringFieldClass, () {
    test('toString', () {
      expect(
        const StringFieldClass(value: 'hello').toString(),
        equals('StringFieldClass(value: hello)'),
      );
    });
  });

  group(NullableStringFieldClass, () {
    test('toString', () {
      expect(
        NullableStringFieldClass(value: 'hello').toString(),
        equals('NullableStringFieldClass(value: hello)'),
      );
      expect(
        NullableStringFieldClass(value: null).toString(),
        equals('NullableStringFieldClass(value: null)'),
      );
    });
  });
}
