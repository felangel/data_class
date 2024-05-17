// TODO(felangel): remove once https://github.com/dart-lang/sdk/commit/73bdc86dd50e11cedb3bf976c597a02ad209bdb4 lands on master
// ignore: unnecessary_import
import 'package:struct_annotation/src/struct_annotation.dart';
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
