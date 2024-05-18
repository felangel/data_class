import 'package:data_class_macro/data_class_macro.dart';
import 'package:test/test.dart';

@Constructable()
class EmptyClass {}

abstract class PlainEmptyBaseClass {
  const PlainEmptyBaseClass();
}

@Data()
class EmptySubClass extends PlainEmptyBaseClass {}

abstract class PlainPositionalStringBaseClass {
  const PlainPositionalStringBaseClass(this.value);

  final String value;
}

abstract class PlainNamedStringBaseClass {
  const PlainNamedStringBaseClass({required this.value});

  final String value;
}

@Constructable()
class EmptyPlainPositionalStringSubclass
    extends PlainPositionalStringBaseClass {}

@Constructable()
class EmptyPlainNamedStringSubclass
    extends PlainNamedStringBaseClass {}

@Constructable()
class StringFieldPlainPositionalStringSubclass
    extends PlainPositionalStringBaseClass {
  final String field;
}

@Constructable()
class StringFieldPlainNamedStringSubclass
    extends PlainNamedStringBaseClass {
  final String field;
}

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

  group(EmptySubClass, () {
    test('constructor', () {
      expect(const EmptySubClass(), isA<EmptySubClass>());
      expect(const EmptySubClass(), isA<PlainEmptyBaseClass>());
    });
  });

  group(EmptyPlainPositionalStringSubclass, () {
    test('constructor', () {
      const instance = EmptyPlainPositionalStringSubclass(value: 'value');
      expect(instance.value, equals('value'));
      expect(instance, isA<EmptyPlainPositionalStringSubclass>());
      expect(instance, isA<PlainPositionalStringBaseClass>());
    });
  });

  group(EmptyPlainNamedStringSubclass, () {
    test('constructor', () {
      const instance = EmptyPlainNamedStringSubclass(value: 'value');
      expect(instance.value, equals('value'));
      expect(instance, isA<EmptyPlainNamedStringSubclass>());
      expect(instance, isA<PlainNamedStringBaseClass>());
    });
  });

  group(StringFieldPlainPositionalStringSubclass, () {
    test('constructor', () {
      const instance = StringFieldPlainPositionalStringSubclass(value: 'value', field: 'field');
      expect(instance.value, equals('value'));
      expect(instance.field, equals('field'));
      expect(instance, isA<StringFieldPlainPositionalStringSubclass>());
      expect(instance, isA<PlainPositionalStringBaseClass>());
    });
  });

  group(StringFieldPlainNamedStringSubclass, () {
    test('constructor', () {
      const instance = StringFieldPlainNamedStringSubclass(value: 'value', field: 'field');
      expect(instance.value, equals('value'));
      expect(instance.field, equals('field'));
      expect(instance, isA<StringFieldPlainNamedStringSubclass>());
      expect(instance, isA<PlainNamedStringBaseClass>());
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
      nullInstance = const NullableStringFieldClass();
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
