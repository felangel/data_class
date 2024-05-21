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
    final defaultClassConstructor = await clazz.defaultConstructor(builder);
    if (defaultClassConstructor != null) {
      throw ArgumentError('A default constructor already exists.');
    }

    ConstructorParams superclassConstructorParams = (positional: [], named: []);
    
    final superclass = await clazz.superclassTypeFromDeclaration(builder);
    if (superclass != null) {
      final defaultSuperConstructor = await superclass.defaultConstructor(builder);
      if (defaultSuperConstructor == null) {
        builder.report(
          Diagnostic(
            DiagnosticMessage(
              '${superclass.identifier.name} must have a default constructor',
              target: superclass.asDiagnosticTarget,
            ),
            Severity.error,
          ),
        );
        return;
      }

      superclassConstructorParams = await superclass.constructorParams(defaultSuperConstructor, builder,);

      // TODO(felangel): Ensure the super constructor is const
      // https://github.com/dart-lang/sdk/issues/55768      
    }

    final superclassParams = [
      ...superclassConstructorParams.positional,
      ...superclassConstructorParams.named,
    ];
    
    // Ensure all super class constructor params have a type.
    if (superclassParams.any((p) => p.type == null)) return null;

    final fields = await builder.fieldsOf(clazz);
    
    // Ensure all class fields have a type.
    if (fields.any((f) => f.type.checkNamed(builder) == null)) return null;

    if (fields.isEmpty && superclassParams.isEmpty) {
      return builder.declareInType(
        DeclarationCode.fromString('const ${clazz.identifier.name}();'),
      );
    }

    final declaration = DeclarationCode.fromParts(
      [
        'const ${clazz.identifier.name}({',
        for (final param in superclassParams) 
          ...[if (param.isRequired) 'required ', param.type!.code, ' ', param.name, ','],
        for (final field in fields) 
          ...[if (!field.type.isNullable) 'required ', 'this.', field.identifier.name, ','],
        '})',
        if (superclass != null)
          ...[
            ' : super(',
            for (final param in superclassConstructorParams.positional)
              ...[param.name, ','],
            for (final param in superclassConstructorParams.named)
              ...[param.name, ': ', param.name, ','],
            ')',
          ],
        ';',
      ],
    );

    return builder.declareInType(declaration);
  }
}