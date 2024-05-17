import 'package:macros/macros.dart';

NamedTypeAnnotation? checkNamedType(TypeAnnotation type, Builder builder) {
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

extension TypeDefinitionX on TypeDefinitionBuilder {
  Future<Identifier> getIdentifier(Uri library, String name) {
    // ignore: deprecated_member_use
    return resolveIdentifier(library, name);
  }
}

extension CodeX on Code {
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
