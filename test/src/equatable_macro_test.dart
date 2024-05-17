import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Equatable()
class EmptyClass {
  const EmptyClass();
}

@Equatable()
class StringFieldClass {
  const StringFieldClass({required this.value});
  final String value;
}

@Equatable()
class NullableStringFieldClass {
  const NullableStringFieldClass({required this.value});
  final String? value;
}

void main() {
  group(EmptyClass, () {
    test('hashCode', () {
      expect(
        const EmptyClass().hashCode,
        equals(const EmptyClass().hashCode),
      );
    });

    test('operator==', () {
      expect(EmptyClass(), equals(EmptyClass()));
    });
  });

  group(StringFieldClass, () {
    late StringFieldClass instance;

    setUp(() {
      instance = const StringFieldClass(value: 'hello');
    });

    test('hashCode', () {
      expect(
        instance.hashCode,
        equals(Object.hashAll([instance.value])),
      );
    });

    test('operator==', () {
      expect(instance, equals(StringFieldClass(value: 'hello')));
      expect(instance, isNot(equals(StringFieldClass(value: 'bye'))));
    });
  });

  group(NullableStringFieldClass, () {
    late NullableStringFieldClass nonNullInstance;
    late NullableStringFieldClass nullInstance;

    setUp(() {
      nonNullInstance = const NullableStringFieldClass(value: 'hello');
      nullInstance = const NullableStringFieldClass(value: null);
    });

    test('hashCode', () {
      expect(
        nonNullInstance.hashCode,
        equals(Object.hashAll([nonNullInstance.value])),
      );

      expect(
        nullInstance.hashCode,
        equals(Object.hashAll([nullInstance.value])),
      );
    });

    test('operator==', () {
      expect(nonNullInstance, equals(NullableStringFieldClass(value: 'hello')));
      expect(nonNullInstance, isNot(equals(StringFieldClass(value: 'bye'))));
    });
  });
}
