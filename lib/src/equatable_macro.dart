import 'package:collection/collection.dart';
import 'package:data_class_macro/src/_data_class_macro.dart';
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
      builder.codeFrom(dartCore, 'Object'),
      builder.codeFrom(dartCore, 'bool'),      
    ).wait;
    return builder.declareInType(
      DeclarationCode.fromParts(
        ['external ', boolean, ' operator==(', object, ' other);'],
      ),
    );
  }

  Future<void> _declareHashCode(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final integer = await builder.codeFrom(dartCore, 'int');
    return builder.declareInType(
      DeclarationCode.fromParts(['external ', integer, ' get hashCode;']),
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
    
    final (equalsMethod, deepEquals, identical, fields) = await (
      builder.buildMethod(equality.identifier),
      builder.codeFrom(dataClassMacro, 'deepEquals'),
      builder.codeFrom(dartCore, 'identical'),
      builder.allFieldsOf(clazz),
    ).wait;

    if (fields.isEmpty) {
      return equalsMethod.augment(
        FunctionBodyCode.fromParts(
          [
            '{',
            'if (', identical,' (this, other)',')', 'return true;',
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
          'if (', identical,' (this, other)',')', 'return true;',
          'return other is ${clazz.identifier.name} && ',
          'other.runtimeType == runtimeType && ',
          for (final field in fieldNames)
            ...[deepEquals, '(${field}, other.$field)', if (field != lastField) ' && '],
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

    final (hashCodeMethod, hashAll, fields) = await (
      builder.buildMethod(hashCode.identifier),
      builder.codeFrom(dataClassMacro, 'hashAll'),
      builder.allFieldsOf(clazz),
    ).wait;

    final fieldNames = fields.map((f) => f.identifier.name);

    return hashCodeMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> ',
          hashAll,
          '([',
          fieldNames.join(', '),
          ']);',
        ],
      ),
    );
  }
}

