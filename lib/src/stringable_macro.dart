import 'dart:core';

import 'package:collection/collection.dart';
import 'package:data_class/src/_data_class.dart';
import 'package:data_class/src/macro_extensions.dart';
import 'package:macros/macros.dart';

/// {@template stringable}
/// An experimental macro which adds a human-readable `toString`.
/// 
/// ```dart
/// @Stringable()
/// class Person {
///   const Person({required this.name});
///   final String name;
/// }
/// 
/// void main() {
///   // Generated `toString`.
///   print(Person(name: 'Dash')); // Person(name: Dash)
/// }
/// ```
/// {@endtemplate}
macro class Stringable implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro stringable}
  const Stringable();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) {
    return _declareToString(clazz, builder);
  }

  @override
  Future<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) {
    return _buildToString(clazz, builder);
  }

  Future<void> _declareToString(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final string = await builder.codeFrom(dartCore, 'String');
    return builder.declareInType(
      DeclarationCode.fromParts(['external ', string, ' toString();']),
    );
  }

  Future<void> _buildToString(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);
    final toString = methods.firstWhereOrNull(
      (m) => m.identifier.name == 'toString',
    );
    if (toString == null) return;
    final className = clazz.identifier.name;
    final (toStringMethod, fields) = await (
      builder.buildMethod(toString.identifier),
      builder.allFieldsOf(clazz),
    ).wait;
    final toStringFields = fields.map((field) {
      return '${field.type.isNullable ? 'if (${field.identifier.name} != null)' : ''} "${field.identifier.name}: \${${field.identifier.name}.toString()}", ';
    });

    return toStringMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> "',
          className,
          '(\${[',
          ...toStringFields,
          '].join(", ")})',
          '";',
        ],
      ),
    );
  }
}
