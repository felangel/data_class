import 'package:collection/collection.dart';
import 'package:data_class_macro/src/macro_extensions.dart';
import 'package:macros/macros.dart';

/// {@template equatable}
/// An experimental macro which implements value-equality.
/// 
/// ```dart
/// @Equatable()
/// class Person {
///   const Person({required this.name});
///   final String name;
/// }
/// 
/// void main() {
///   // Generated `hashCode` and `operator==` for value based equality.
///   print(Person(name: 'Dash') == Person(name: 'Dash')); // true
///   print(Person(name: 'Dash') == Person(name: 'Sparky')); // false
/// }
/// ```
/// {@endtemplate}
macro class Equatable implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro equatable}
  const Equatable();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  )  {
    return [
      _declareEquals(clazz, builder),
      _declareHashCode(clazz, builder),
    ].wait;
  }

  @override
  Future<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) {
    return [
      _buildEquals(clazz, builder),
      _buildHashCode(clazz, builder),
    ].wait;
  }

  Future<void> _declareEquals(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final (object, boolean) = await (
      // ignore: deprecated_member_use
      builder.resolveIdentifier(dartCore, 'Object'),
      // ignore: deprecated_member_use
      builder.resolveIdentifier(dartCore, 'bool'),      
    ).wait;
    return builder.declareInType(
      DeclarationCode.fromParts(
        [
          'external ',
          NamedTypeAnnotationCode(name: boolean),
          ' operator==(',
          NamedTypeAnnotationCode(name: object),
          ' other);',
        ],
      ),
    );
  }

  Future<void> _declareHashCode(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    // ignore: deprecated_member_use
    final integer = await builder.resolveIdentifier(dartCore, 'int');
    return builder.declareInType(
      DeclarationCode.fromParts(
        [
          'external ',
          NamedTypeAnnotationCode(name: integer),
          ' get hashCode;',
        ],
      ),
    );
  }

  Future<void> _buildEquals(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);
    final equality = methods.firstWhereOrNull(
      (m) => m.identifier.name == '==',
    );
    if (equality == null) return;
    
    final (equalsMethod, deepEquals, fields, identical) = await (
      builder.buildMethod(equality.identifier),
      // ignore: deprecated_member_use
      builder.resolveIdentifier(dataClassMacro, 'deepEquals'),
      builder.allFieldsOf(clazz),
      // ignore: deprecated_member_use
      builder.resolveIdentifier(dartCore, 'identical'),
    ).wait;
    
    if (fields.isEmpty) {
      return equalsMethod.augment(
        FunctionBodyCode.fromParts(
          [
            '{',
            'if (', NamedTypeAnnotationCode(name: identical),' (this, other)',')', 'return true;',
            'return other is ${clazz.identifier.name} && ',
            'other.runtimeType == runtimeType;',            
            '}',          
          ],
        ),      
      );
    }

    final fieldNames = fields.map((f) => f.identifier.name);
    final lastField = fieldNames.last;
    return equalsMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '{',
          'if (', NamedTypeAnnotationCode(name: identical),' (this, other)',')', 'return true;',
          'return other is ${clazz.identifier.name} && ',
          'other.runtimeType == runtimeType && ',          
          for (final field in fieldNames)
            ...[NamedTypeAnnotationCode(name: deepEquals), '(${field}, other.$field)', if (field != lastField) ' && '],
          ';',
          '}',          
        ],
      ),      
    );
  }

  Future<void> _buildHashCode(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);
    final hashCode = methods.firstWhereOrNull(
      (m) => m.identifier.name == 'hashCode',
    );
    if (hashCode == null) return;

    final (hashCodeMethod, object, fields) = await (
      builder.buildMethod(hashCode.identifier),
      // ignore: deprecated_member_use
      builder.resolveIdentifier(dartCore, 'Object'),
      builder.allFieldsOf(clazz),
    ).wait;

    final fieldNames = fields.map((f) => f.identifier.name);

    return hashCodeMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> ',
          NamedTypeAnnotationCode(name: object),
          '.hashAll([',
          fieldNames.join(', '),
          ']);',
        ],
      ),
    );
  }
}

