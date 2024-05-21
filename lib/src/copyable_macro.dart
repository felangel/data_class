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
    var superclass = await clazz.superclassTypeFromDeclaration(builder);

    while(superclass != null) {
      fields.addAll(await builder.fieldsOf(superclass));
      superclass = await superclass.superclassTypeFromDeclaration(builder);
    }

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
    final className = clazz.identifier.name;

    final fields = await builder.fieldsOf(clazz);
    var superclass = await clazz.superclassTypeFromDefinition(builder);

    while(superclass != null) {
      fields.addAll(await builder.fieldsOf(superclass));
      superclass = await superclass.superclassTypeFromDefinition(builder);
    }

    final docComments = CommentCode.fromString('/// Create a copy of [$className] and replace zero or more fields.');

    if (fields.isEmpty) {
      return copyWithMethod.augment(
        FunctionBodyCode.fromParts(['=> ', className, '();']),
        docComments: docComments,
      );
    }

    // Ensure all class fields have a type.
    if (fields.any((f) => f.type.checkNamed(builder) == null)) return;
    
    final body = FunctionBodyCode.fromParts(
      [
        '=> ',
        className,
        '(',
        for (final field in fields)
          ...[field.identifier.name, ': ', field.identifier.name, ' != null ? ',field.identifier.name, '.call()', ' : this.',field.identifier.name, ','],
        ');'
      ],
    );

    return copyWithMethod.augment(
      body,
      docComments: docComments,
    );
  }
}

