# struct_annotation

[![build](https://github.com/felangel/struct/actions/workflows/main.yaml/badge.svg)](https://github.com/felangel/struct/actions/workflows/main.yaml)
[![pub package](https://img.shields.io/pub/v/struct_annotation.svg)](https://pub.dev/packages/struct_annotation)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**🚧 Experimental** support for data classes in Dart using [macros](https://dart.dev/language/macros).

## ✨ Features

🪨 `const` constructors with required, named parameters

🖨️ `copyWith` with optional, nullable, named parameters

✨ `toString` for an improved string representation

☯️ `operator==` and `hashCode` for value equality

## 🧑‍💻 Example

```dart
import 'package:struct_annotation/struct_annotation.dart';

@Struct()
class Person {
  final String name;
  final int age;
}

void main() {
  // 🪨 Create a const instance with required, name parameters.
  const jane = Person(name: 'Jane', age: 42);

  // 🖨️ Create copies of your object.
  final john = jane.copyWith(name: 'John');

  // ✨ Human-readable string representation.
  print(jane); // Person(name: Jane, age: 42)
  print(john); // Person(name: John, age: 42)

  // ☯️ Value equality comparisons.
  print(jane == jane.copyWith()); // true
  print(john == john.copyWith(age: 21)); // false
}
```

## 🚀 Quick Start

1. Switch to the Flutter `master` channel
   `flutter channel master`

1. Add `package:struct_annotation` to your `pubspec.yaml`

   ```yaml
   dependencies:
     struct_annotation: ^0.0.0-dev.1
   ```

1. Enable experimental macros in `analysis_options.yaml`

   ```yaml
   analyzer:
     enable-experiment:
       - macros
   ```

1. Use the `@Struct` annotation (see above example).

1. Run it

   ```sh
   dart --enable-experiment=macros run main.dart
   ```

_\*Requires Dart SDK >= 3.5.0-152.0.dev_
