import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Constructable()
class EmptyClass {}

@Constructable()
class StringFieldClass {
  final String value;
}

@Constructable()
class NullableStringFieldClass {
  final String? value;
}

void main() {
  group(EmptyClass, () {
    test('constructor', () {
      expect(const EmptyClass(), isA<EmptyClass>());
    });
  });

  group(StringFieldClass, () {
    late StringFieldClass instance;

    setUp(() {
      instance = const StringFieldClass(value: 'hello');
    });

    test('constructor', () {
      expect(
        instance,
        isA<StringFieldClass>().having((e) => e.value, 'value', 'hello'),
      );
    });
  });

  group(NullableStringFieldClass, () {
    late NullableStringFieldClass nonNullInstance;
    late NullableStringFieldClass nullInstance;

    setUp(() {
      nonNullInstance = const NullableStringFieldClass(value: 'hello');
      nullInstance = const NullableStringFieldClass(value: null);
    });

    test('constructor', () {
      expect(
        nonNullInstance,
        isA<NullableStringFieldClass>().having(
          (e) => e.value,
          'value',
          'hello',
        ),
      );
      expect(
        nullInstance,
        isA<NullableStringFieldClass>().having((e) => e.value, 'value', isNull),
      );
    });
  });
}
