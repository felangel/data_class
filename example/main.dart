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
  const jane = Person(name: 'Jane', age: 42);
  final john = jane.copyWith(name: 'John');

  print(jane); // Person(name: Jane, age: 42)
  print(john); // Person(name: John, age: 42)

  print(jane == jane.copyWith()); // true
  print(john == john.copyWith(age: 21)); // false
}
