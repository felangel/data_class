// TODO(felangel): remove once https://github.com/dart-lang/sdk/commit/73bdc86dd50e11cedb3bf976c597a02ad209bdb4 lands on master
// ignore: unnecessary_import
import 'package:data_class_macro/src/data_class_macro.dart';
import 'package:data_class_macro/data_class_macro.dart';

@Data()
class Person {
  final String name;
}

void main() {
  // 🪨 Create a const instance with required, name parameters.
  const dash = Person(name: 'Dash');

  // 🖨️ Create copies of your object.
  final sparky = dash.copyWith(name: () => 'Sparky');

  // ✨ Human-readable string representation.
  print(dash); // Person(name: Dash)
  print(sparky); // Person(name: Sparky)

  // ☯️ Value equality comparisons.
  print(dash == dash.copyWith()); // true
  print(dash == sparky); // false
}
