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
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = await Future.wait(
      fieldDeclarations.map(
        (f) async => (
          identifier: f.identifier,
          type: checkNamedType(f.type, builder),
        ),
      ),
    );

    final missingType = fields.firstWhereOrNull((f) => f.type == null);
    if (missingType != null) return null;
    
    if (fields.isEmpty) {
      return builder.declareInType(
        DeclarationCode.fromString(
          'external ${clazz.identifier.name} copyWith();',
        ),
      );
    }
    
    return builder.declareInType(
      DeclarationCode.fromParts(
        [
          'external ${clazz.identifier.name} copyWith({',
          for (final field in fields)
          ...[field.type!.identifier.name, if(field.type!.isNullable) '?', ' Function()? ', field.identifier.name, ',']
          ,'});',
        ],
      ),
    );
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
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = await Future.wait(
      fieldDeclarations.map(
        (f) async => (
          identifier: f.identifier,
          rawType: f.type,
          type: checkNamedType(f.type, builder),
        ),
      ),
    );
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

    final missingType = fields.firstWhereOrNull((f) => f.type == null);
    
    if (missingType != null) {
      return copyWithMethod.augment(
        FunctionBodyCode.fromString(
          '=> throw "Unable to copyWith to due missing type ${missingType.rawType.code.debugString}',
        ),
        docComments: docComments,
      );
    }
        
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

