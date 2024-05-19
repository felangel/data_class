import 'dart:core';

import 'package:collection/collection.dart';
import 'package:data_class_macro/src/macro_extensions.dart';
import 'package:macros/macros.dart';

/// {@template copyable}
/// An experimental macro which generates a copyWith method.
/// 
/// ```dart
/// @Copyable()
/// class Person {
///   const Person({required this.name});
///   final String name;
/// }
/// 
/// void main() {
///   // Generated `copyWith`
///   print(Person(name: 'Dash').copyWith(name: () => 'Sparky').name); // Sparky
/// }
/// ```
/// {@endtemplate}
macro class Copyable implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro copyable}
  const Copyable();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) {
    return _declareCopyWith(clazz, builder);
  }

  @override
  Future<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) {
    return _buildCopyWith(clazz, builder);
  }

  Future<void> _declareCopyWith(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(clazz);

    // Ensure all class fields have a type.
    if (fields.any((f) => f.type.checkNamed(builder) == null)) return null;
    
    if (fields.isEmpty) {
      return builder.declareInType(
        DeclarationCode.fromString(
          'external ${clazz.identifier.name} copyWith();',
        ),
      );
    }

    final declaration = DeclarationCode.fromParts(
      [
        'external ${clazz.identifier.name} copyWith({',
        for (final field in fields)
          ...[
            field.type.cast<NamedTypeAnnotation>().identifier.name,
            if(field.type.cast<NamedTypeAnnotation>().isNullable) '?',
            ' Function()? ', field.identifier.name,
            ',',
          ]
        ,'});',
      ],
    );
    
    return builder.declareInType(declaration);
  }

  Future<void> _buildCopyWith(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);
    final copyWith = methods.firstWhereOrNull(
      (m) => m.identifier.name == 'copyWith',
    );
    if (copyWith == null) return;
    final copyWithMethod = await builder.buildMethod(copyWith.identifier);
    final clazzName = clazz.identifier.name;

    // final fieldDeclarations = await builder.fieldsOf(clazz);
    // final fields = await Future.wait(
    //   fieldDeclarations.map(
    //     (f) async => (
    //       identifier: f.identifier,
    //       rawType: f.type,
    //       type: f.type.checkNamed(builder),
    //     ),
    //   ),
    // );
    final fields = await builder.fieldsOf(clazz);
    final docComments = CommentCode.fromString('/// Create a copy of [$clazzName] and replace zero or more fields.');

    if (fields.isEmpty) {
      return copyWithMethod.augment(
        FunctionBodyCode.fromParts(
          [
            '=> ',
            clazzName,
            '();',
          ],
        ),
        docComments: docComments,
      );
    }

    // Ensure all class fields have a type.
    if (fields.any((f) => f.type.checkNamed(builder) == null)) return;

    return copyWithMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> ',
          clazzName,
          '(',
          for (final field in fields)
            ...[field.identifier.name, ': ', field.identifier.name, '!= null ? ',field.identifier.name, '.call()', ' : this.',field.identifier.name, ','],
          ');'
        ],
      ),
      docComments: docComments,
    );
  }
}

