import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

typedef FieldMetadata = ({String name, bool isRequired, TypeAnnotation? type});

typedef ConstructorParams = ({
  List<FieldMetadata> positional,
  List<FieldMetadata> named,
});

Future<Identifier> dartCoreIdentical(TypeDefinitionBuilder builder) {
  return builder._getIdentifier(_dartCore, 'identical');
}

Future<Identifier> dartCoreObject(TypeDefinitionBuilder builder) {
  return builder._getIdentifier(_dartCore, 'Object');
}

Future<Identifier> collectionDeepCollectionEquality(
  TypeDefinitionBuilder builder,
) {
  return builder._getIdentifier(_dataClassMacro, 'deepCollectionEquality');
}

extension FieldMetadataX on FieldMetadata {
  List<Object> toConstructorParts() {
    return ['    ', if (isRequired) 'required ', type!.code, ' ', name, ',\n'];
  }

  List<Object> toSuperPositionalParts() => ['    ', name, ',\n'];
  List<Object> toSuperNamedParts() => ['    ', name, ': ', name, ',\n'];
}

extension TypeAnnotationX on TypeAnnotation {
  T cast<T extends TypeAnnotation>() => this as T;

  NamedTypeAnnotation? checkNamed(Builder builder) {
    if (this is NamedTypeAnnotation) return this as NamedTypeAnnotation;
    if (this is OmittedTypeAnnotation) {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only fields with explicit types are allowed on data classes, please add a type.',
            target: asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
    } else {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only fields with named types are allowed on data classes.',
            target: asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
    }
    return null;
  }
}

extension TypeDeclarationX on TypeDeclaration {
  Future<ConstructorParams> constructorParams(
    ConstructorDeclaration constructor,
    MemberDeclarationBuilder builder,
  ) async {
    final List<FieldMetadata> positional = [];
    final List<FieldMetadata> named = [];

    // TODO(felangel): refactor this to run in parallel.
    for (final positionalParameter in constructor.positionalParameters) {
      final type = await positionalParameter.resolveType(builder, this);
      positional.add((
        // TODO(felangel): this workaround until we are able to detect default values.
        isRequired:
            type?.isNullable == false ? true : positionalParameter.isRequired,
        name: positionalParameter.identifier.name,
        type: type,
      ));
    }

    for (final namedParameter in constructor.namedParameters) {
      final type = await namedParameter.resolveType(builder, this);
      named.add((
        isRequired: namedParameter.isRequired,
        name: namedParameter.identifier.name,
        type: type,
      ));
    }

    return (positional: positional, named: named);
  }

  Future<ConstructorDeclaration?> defaultConstructor(
    MemberDeclarationBuilder builder,
  ) async {
    final constructors = await builder.constructorsOf(this);
    final defaultConstructor = constructors.firstWhereOrNull(
      (c) => c.identifier.name == '',
    );
    return defaultConstructor;
  }
}

extension FieldDeclarationX on FieldDeclaration {
  List<Object> toConstructorParts() {
    return [
      '    ',
      if (!type.isNullable) 'required ',
      'this.',
      identifier.name,
      ',\n',
    ];
  }
}

extension ClassDeclarationX on ClassDeclaration {
  Future<TypeDeclaration?> superclassType(
    MemberDeclarationBuilder builder,
  ) async {
    final superclassType = superclass != null
        ? await builder.typeDeclarationOf(superclass!.identifier)
        : null;
    return superclassType;
  }
}

extension TypeDefinitionBuilderX on TypeDefinitionBuilder {
  Future<Identifier> _getIdentifier(Uri library, String name) {
    // ignore: deprecated_member_use
    return resolveIdentifier(library, name);
  }
}

extension FormalParameterDeclarationX on FormalParameterDeclaration {
  Future<TypeAnnotation?> resolveType(
    MemberDeclarationBuilder builder,
    TypeDeclaration clazz,
  ) async {
    if (type is NamedTypeAnnotation) return type;
    final fieldDeclarations = await builder.fieldsOf(clazz);
    final field = fieldDeclarations.firstWhereOrNull(
      (f) => f.identifier.name == name,
    );
    if (field == null) {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only fields with explicit types are allowed on data classes, please add a type.',
            target: this.asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
      return null;
    }
    return field.type;
  }
}

extension CodeX on Code {
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

// Used libraries
final _dartCore = Uri.parse('dart:core');
final _dataClassMacro = Uri.parse(
  'package:data_class_macro/data_class_macro.dart',
);
