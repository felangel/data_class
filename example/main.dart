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
