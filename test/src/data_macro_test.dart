import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Data()
class EmptyClass {}

@Data()
class StringFieldClass {
  final String value;
}

@Data()
class NullableStringFieldClass {
  final String? value;
}

void main() {
  group(EmptyClass, () {
    test('constructor', () {
      expect(const EmptyClass(), isA<EmptyClass>());
    });

    test('copyWith', () {
      expect(const EmptyClass().copyWith(), isA<EmptyClass>());
    });

    test('hashCode', () {
      expect(
        const EmptyClass().hashCode,
        equals(const EmptyClass().hashCode),
      );
    });

    test('operator==', () {
      expect(EmptyClass(), equals(EmptyClass()));
    });

    test('toString', () {
      expect(EmptyClass().toString(), equals('EmptyClass()'));
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

    test('copyWith', () {
      expect(instance.copyWith(), equals(instance));
      final copy = instance.copyWith(value: () => 'bye');
      expect(copy, isNot(equals(instance)));
      expect(copy.value, equals('bye'));
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

    test('toString', () {
      expect(instance.toString(), equals('StringFieldClass(value: hello)'));
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

    test('copyWith', () {
      expect(nullInstance.copyWith(), equals(nullInstance));
      expect(nonNullInstance.copyWith(), equals(nonNullInstance));
      expect(nullInstance.copyWith(value: null), equals(nullInstance));
      expect(nonNullInstance.copyWith(value: null), equals(nonNullInstance));
      expect(
        nullInstance.copyWith(value: () => 'hello'),
        isA<NullableStringFieldClass>().having(
          (e) => e.value,
          'value',
          'hello',
        ),
      );
      expect(
        nonNullInstance.copyWith(value: () => null),
        isA<NullableStringFieldClass>().having((e) => e.value, 'value', isNull),
      );
      final copy = nonNullInstance.copyWith(value: () => 'bye');
      expect(copy, isNot(equals(nonNullInstance)));
      expect(copy.value, equals('bye'));
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

    test('toString', () {
      expect(
        nonNullInstance.toString(),
        equals('NullableStringFieldClass(value: hello)'),
      );
      expect(
        nullInstance.toString(),
        equals('NullableStringFieldClass()'),
      );
    });
  });
}
