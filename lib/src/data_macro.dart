import 'dart:core';

import 'package:data_class_macro/data_class_macro.dart';
import 'package:macros/macros.dart';

/// {@template data}
/// An experimental macro which transforms a plain Dart class into a data class.
/// 
/// ```dart
/// @Data()
/// class Person {
///   final String name;
/// }
/// 
/// void main() {
///   // Generated const constructor with required, named parameters.
///   const dash = Person(name: 'Dash');
///   
///   // Generated `toString`
///   print(dash); // Person(name: Dash)
/// 
///   // Generated `copyWith`
///   print(dash.copyWith(name: 'Sparky')); // Person(name: Sparky)
/// 
///   // Generated `hashCode` and `operator==` for value based equality.
///   print(dash == Person(name: 'Dash')); // true
/// }
/// ```
/// {@endtemplate}
macro class Data implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro data}
  const Data();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    await const Constructable().buildDeclarationsForClass(clazz, builder);
    await const Equatable().buildDeclarationsForClass(clazz, builder);
    await const Stringable().buildDeclarationsForClass(clazz, builder);
    await const Copyable().buildDeclarationsForClass(clazz, builder);
  }

  @override
  Future<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    await const Equatable().buildDefinitionForClass(clazz, builder);
    await const Stringable().buildDefinitionForClass(clazz, builder);
    await const Copyable().buildDefinitionForClass(clazz, builder);
  }
}

