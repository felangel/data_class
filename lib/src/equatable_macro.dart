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
    return builder.declareInType(
      DeclarationCode.fromString('external bool operator==(Object other);'),
    );
  }

  Future<void> _declareHashCode(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    return builder.declareInType(
      DeclarationCode.fromString('external int get hashCode;'),
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
    
    final (equalsMethod, deepCollectionEquality, fields, identical) = await (
      builder.buildMethod(equality.identifier),
      collectionDeepCollectionEquality(builder),
      builder.fieldsOf(clazz),
      dartCoreIdentical(builder),
    ).wait;
    
    var superclass = await builder.superclassOf(clazz);
    while(superclass != null) {
      fields.addAll(await builder.fieldsOf(superclass));
      superclass = await builder.superclassOf(superclass);
    }
    
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

    // TODO(felangel): instead of using fields and converting to a set
    // this should be using the constructor params.
    final fieldNames = fields.map((f) => f.identifier.name).toSet();
    final lastField = fieldNames.last;
    return equalsMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '{',
          'if (', NamedTypeAnnotationCode(name: identical),' (this, other)',')', 'return true;',
          'return other is ${clazz.identifier.name} && ',
          'other.runtimeType == runtimeType && ',          
          for (final field in fieldNames)
            ...[NamedTypeAnnotationCode(name: deepCollectionEquality), '.equals(${field}, other.$field)', if (field != lastField) ' && '],
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
      dartCoreObject(builder),
      builder.fieldsOf(clazz),
    ).wait;

    var superclass = await builder.superclassOf(clazz);
    while(superclass != null) {
      fields.addAll(await builder.fieldsOf(superclass));
      superclass = await builder.superclassOf(superclass);
    }
    
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

