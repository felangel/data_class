import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Copyable()
class EmptyClass {
  const EmptyClass();
}

@Copyable()
class StringFieldClass {
  const StringFieldClass({required this.value});
  final String value;
}

@Copyable()
class NullableStringFieldClass {
  const NullableStringFieldClass({this.value});
  final String? value;
}

void main() {
  group(EmptyClass, () {
    test('copyWith', () {
      expect(const EmptyClass().copyWith(), isA<EmptyClass>());
    });
  });

  group(StringFieldClass, () {
    test('copyWith', () {
      const instance = const StringFieldClass(value: 'hello');
      expect(instance.copyWith().value, equals('hello'));
      expect(
        instance.copyWith(value: () => 'bye').value,
        equals('bye'),
      );
    });
  });

  group(NullableStringFieldClass, () {
    test('copyWith', () {
      final nonNullInstance = const NullableStringFieldClass(value: 'hello');
      final nullInstance = const NullableStringFieldClass(value: null);
      expect(nullInstance.copyWith().value, isNull);
      expect(nonNullInstance.copyWith().value, equals('hello'));
      expect(nullInstance.copyWith(value: null).value, isNull);
      expect(nonNullInstance.copyWith(value: null).value, equals('hello'));
      expect(
        nullInstance.copyWith(value: () => 'hello').value,
        equals('hello'),
      );
      expect(
        nonNullInstance.copyWith(value: () => null).value,
        isNull,
      );
    });
  });
}
