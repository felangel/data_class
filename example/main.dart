import 'package:data_class_macro/data_class_macro.dart';

abstract class Thing {
  const Thing(this.id, {required this.name});

  final int id;
  final String name;
}

@Constructable()
class Person extends Thing {
  final String? nickname;
}

void main() {
  // 🪨 Create a const instance with required, name parameters.
  const dash = Person(id: 0, name: 'Dash', nickname: 'Dashy');
  print(dash.id);
  print(dash.name);
  print(dash.nickname);

  // // 🖨️ Create copies of your object.
  // final sparky = dash.copyWith(name: () => 'Sparky');

  // // ✨ Human-readable string representation.
  // print(dash); // Person(name: Dash)
  // print(sparky); // Person(name: Sparky)

  // // ☯️ Value equality comparisons.
  // print(dash == dash.copyWith()); // true
  // print(dash == sparky); // false
}
