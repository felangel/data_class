import 'package:macros/macros.dart';

NamedTypeAnnotation? checkNamedType(TypeAnnotation type, Builder builder) {
  if (type is NamedTypeAnnotation) return type;
  if (type is OmittedTypeAnnotation) {
    builder.report(
      Diagnostic(
        DiagnosticMessage(
          'Only fields with explicit types are allowed on data classes, please add a type.',
          target: type.asDiagnosticTarget,
        ),
        Severity.error,
      ),
    );
  } else {
    builder.report(
      Diagnostic(
        DiagnosticMessage(
          'Only fields with named types are allowed on data classes.',
          target: type.asDiagnosticTarget,
        ),
        Severity.error,
      ),
    );
  }
  return null;
}

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

extension TypeDefinitionX on TypeDefinitionBuilder {
  Future<Identifier> _getIdentifier(Uri library, String name) {
    // ignore: deprecated_member_use
    return resolveIdentifier(library, name);
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
