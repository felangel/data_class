import 'dart:core';

// This import is needed to ensure we can resolve deepCollectionEquality.
// ignore: unused_import
import 'package:data_class_macro/data_class_macro.dart';
import 'package:collection/collection.dart';
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
///   print(dash.copyWith(name: () => 'Sparky')); // Person(name: Sparky)
/// 
///   // Generated `hashCode` and `operator==` for value based equality.
///   print(dash == Person(name: 'Dash')); // true
/// }
/// ```
/// {@endtemplate}
macro class Data with _Shared implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro data}
  const Data();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) {
    return Future.wait([
      _declareNamedConstructor(clazz, builder),
      _declareEquals(clazz, builder),
      _declareHashCode(clazz, builder),
      _declareToString(clazz, builder),
      _declareCopyWith(clazz, builder),
    ]);
  }

  @override
  Future<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) {
    return Future.wait([
      _buildEquals(clazz, builder),
      _buildHashCode(clazz, builder),
      _buildToString(clazz, builder),
      _buildCopyWith(clazz, builder),
    ]);
  }

  Future<void> _declareNamedConstructor(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = await Future.wait(
      fieldDeclarations.map(
        (f) async => (
          identifier: f.identifier,
          type: _checkNamedType(f.type, builder),
        ),
      ),
    );

    final missingType = fields.firstWhereOrNull((f) => f.type == null);
    if (missingType != null) return null;

    if (fields.isEmpty) {
      return builder.declareInType(
        DeclarationCode.fromString('const ${clazz.identifier.name}();'),
      );
    }

    return builder.declareInType(
      DeclarationCode.fromParts(
        [
          'const ${clazz.identifier.name}({',
          for (final field in fields)
            ...['required', ' ', 'this.', field.identifier.name, ','],
          '});',
        ],
      ),
    );
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

  Future<void> _declareToString(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    return builder.declareInType(
      DeclarationCode.fromString('external String toString();'),
    );
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
          type: _checkNamedType(f.type, builder),
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

  Future<void> _buildEquals(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);
    final equality = methods.firstWhereOrNull(
      (m) => m.identifier.name == '==',
    );
    if (equality == null) return;
    final equalsMethod = await builder.buildMethod(equality.identifier);
    final deepCollectionEquality = await builder.getIdentifier(
      Uri.parse('package:data_class_macro/data_class_macro.dart'),
      'deepCollectionEquality',
    );
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = fieldDeclarations.map(
      (f) => f.identifier.name,
    );
    final identical = await builder.getIdentifier(
      Uri.parse('dart:core'),
      'identical',
    );
    
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
    
    final lastField = fields.last;
    return equalsMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '{',
          'if (', NamedTypeAnnotationCode(name: identical),' (this, other)',')', 'return true;',
          'return other is ${clazz.identifier.name} && ',
          'other.runtimeType == runtimeType && ',          
          for (final field in fields)
            ...[NamedTypeAnnotationCode(name: deepCollectionEquality), '.equals(${field}, other.$field)', if (field != lastField) '&& '],
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
    final hashCodeMethod = await builder.buildMethod(hashCode.identifier);
    final object = await builder.getIdentifier(
      Uri.parse('dart:core'),
      'Object',
    );
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = fieldDeclarations.map(
      (f) => f.identifier.name,
    );

    return hashCodeMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> ',
          NamedTypeAnnotationCode(name: object),
          '.hashAll([',
          fields.join(', '),
          ']);',
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
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = fieldDeclarations.map(
      (f) => '${f.identifier.name}: \${${f.identifier.name}.toString()}',
    );
        
    return toStringMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> "',
          clazzName,
          '(',
          fields.join(', '),
          ')',
          '";',
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
          type: _checkNamedType(f.type, builder),
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

mixin _Shared {
  NamedTypeAnnotation? _checkNamedType(TypeAnnotation type, Builder builder) {
    if (type is NamedTypeAnnotation) return type;
    if (type is OmittedTypeAnnotation) {
      builder.report(Diagnostic(
          DiagnosticMessage(
              'Only fields with explicit types are allowed on data classes, please add a type.',
              target: type.asDiagnosticTarget),
          Severity.error));
    } else {
      builder.report(Diagnostic(
          DiagnosticMessage(
              'Only fields with named types are allowed on data classes.',
              target: type.asDiagnosticTarget),
          Severity.error));
    }
    return null;
  }
}

extension on TypeDefinitionBuilder {
  Future<Identifier> getIdentifier(Uri library, String name) {
    // ignore: deprecated_member_use
    return resolveIdentifier(library, name);
  }
}

extension on Code {
  /// Used for error messages.
  String get debugString {
    final buffer = StringBuffer();
    _writeDebugString(buffer);
    return buffer.toString();
  }

  void _writeDebugString(StringBuffer buffer) {
    for (final part in parts) {
      switch (part) {
        case Code():
          part._writeDebugString(buffer);
        case Identifier():
          buffer.write(part.name);
        case OmittedTypeAnnotation():
          buffer.write('<omitted>');
        default:
          buffer.write(part);
      }
    }
  }
}
