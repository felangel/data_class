import 'dart:core';

import 'package:collection/collection.dart';
import 'package:data_class_macro/src/macro_extensions.dart';
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
    // ignore: deprecated_member_use
    final string = await builder.resolveIdentifier(dartCore, 'String');
    return builder.declareInType(
      DeclarationCode.fromParts(
        [
          'external ',
          NamedTypeAnnotationCode(name: string),
          ' toString();',
        ],
      ),
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
    final toStringMethod = await builder.buildMethod(toString.identifier);
    final clazzName = clazz.identifier.name;
    final fields = await builder.fieldsOf(clazz);
    
    var superclass = await builder.superclassOf(clazz);
    while(superclass != null) {
      fields.addAll(await builder.fieldsOf(superclass));
      superclass = await builder.superclassOf(superclass);
    }
    // TODO(felangel): figure out why superclass fields result in duplicates
    // instead of de-duplicating manually here.
    final fieldNames = fields.map((f) => f.identifier.name).toSet();
    final toStringFields = fieldNames.map((name) {
      final field = fields.firstWhere((f) => f.identifier.name == name);
      return field.type.isNullable 
        ? "\${${field.identifier.name} == null ? '' : '${field.identifier.name}: \${${field.identifier.name}.toString()}'}" 
        : "${field.identifier.name}: \${${field.identifier.name}.toString()}";
    });
    

    return toStringMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> "',
          clazzName,
          '(',
          toStringFields.join(', '),
          ')',
          '";',
        ],
      ),
    );
  }
}
