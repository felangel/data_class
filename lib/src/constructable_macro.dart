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

    final fieldDeclarations = await builder.fieldsOf(clazz);
    final fields = await Future.wait(
      fieldDeclarations.map(
        (f) async => (
          identifier: f.identifier,
          type: checkNamedType(f.type, builder),
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
            ...[if (!field.type!.isNullable) 'required', ' ', 'this.', field.identifier.name, ','],
          '});',
        ],
      ),
    );
  }
}

