import 'package:collection/collection.dart';
import 'package:data_class_macro/src/macro_extensions.dart';
import 'package:macros/macros.dart';

/// {@template constructable}
/// An experimental macro which generates a const constructor.
/// 
/// ```dart
/// @Constructable()
/// class Person {
///   final String name;
/// }
/// 
/// void main() {
///   // Generated const constructor with required, named parameters.
///   const dash = Person(name: 'Dash');
/// }
/// ```
/// {@endtemplate}
macro class Constructable implements ClassDeclarationsMacro {
  /// {@macro constructable}
  const Constructable();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) {
    return _declareNamedConstructor(clazz, builder);
  }

  Future<void> _declareNamedConstructor(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final constructors = await builder.constructorsOf(clazz);
    if (constructors.any((c) => c.identifier.name == '')) {
      throw ArgumentError('A default constructor already exists.');
    }

    final superclass = clazz.superclass != null 
      ? await builder.typeDeclarationOf(clazz.superclass!.identifier) 
      : null;

    final List<({Identifier identifier, TypeAnnotation? type})> superclassPositionalParams = [];
    final List<({Identifier identifier, TypeAnnotation? type})> superclassNamedParams = [];

    if (superclass != null) {
      final superConstructors = await builder.constructorsOf(superclass);
      final defaultSuperConstructor = superConstructors.firstWhereOrNull(
        (c) => c.identifier.name == '',
      );

      if (defaultSuperConstructor == null) {
        builder.report(
          Diagnostic(
            DiagnosticMessage(
              'Super class of ${clazz.identifier.name} must have a default constructor',
              target: superclass.asDiagnosticTarget,
            ),
            Severity.error,
          ),
        );
        return;
      }

      // TODO(felangel): Ensure the super constructor is const
      // https://github.com/dart-lang/sdk/issues/55768

      for (final positionalParameter in defaultSuperConstructor.positionalParameters) {
        final type = await positionalParameter.resolveType(builder, superclass);  
        superclassPositionalParams.add((
          identifier: positionalParameter.identifier,
          type: type,
        ));
      }

      for (final namedParameter in defaultSuperConstructor.namedParameters) {
        final type = await namedParameter.resolveType(builder, superclass);
        superclassNamedParams.add((
          identifier: namedParameter.identifier,
          type: type,
        ));
      }

    }

    final missingSuperType = [
      ...superclassPositionalParams,
      ...superclassNamedParams,
    ].firstWhereOrNull((f) => f.type == null);
    if (missingSuperType != null) return null;

    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = await Future.wait(
      fieldDeclarations.map(
        (f) async => (
          diagnosticTarget: f.asDiagnosticTarget,
          identifier: f.identifier,
          type: checkNamedType(f.type, builder),
        ),
      ),
    );

    final missingType = fields.firstWhereOrNull((f) => f.type == null);
    if (missingType != null) return null;

    final superclassParams = [...superclassPositionalParams, ...superclassNamedParams];

    if (fields.isEmpty && superclassParams.isEmpty) {
      return builder.declareInType(
        DeclarationCode.fromString('const ${clazz.identifier.name}();'),
      );
    }

    final declaration = DeclarationCode.fromParts(
      [
        'const ${clazz.identifier.name}({\n',
        for (final param in superclassParams)
          ...['  ', if (!param.type!.isNullable) 'required ', param.type!.code, if (param.type!.isNullable)'?', ' ', param.identifier.name, ',\n'],
        for (final field in fields)
          ...['  ', if (!field.type!.isNullable) 'required ', 'this.', field.identifier.name, ',\n'],
        '})',
        if (superclass != null)
          ...[
            ': super(\n',
            for (final param in superclassPositionalParams)
              ...['  ', param.identifier.name, ',\n'],
            for (final param in superclassNamedParams)
              ...['  ', param.identifier.name, ': ', param.identifier.name, ',\n'],
            ')',
          ],
        ';'
      ],
    );
    return builder.declareInType(declaration);
  }
}

