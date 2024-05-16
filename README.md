# struct_annotation

**🚧 Experimental 🚧**

Experimental support for data classes in Dart using [macros](https://dart.dev/language/macros).

```dart
import 'package:struct_annotation/struct_annotation.dart';

@Struct()
class Person {
  const Person({required this.name, required this.age});

  final String name;
  final int age;
}

void main() {
  final jane = Person(name: 'Jane', age: 42);
  final john = jane.copyWith(name: 'John');

  print(jane); // Person(name: Jane, age: 42)
  print(john); // Person(name: John, age: 42)

  print(jane == jane.copyWith()); // true
  print(john == john.copyWith(age: 21)); // false
}
```

_Requires Dart SDK >= 3.5.0-152.0.dev_
