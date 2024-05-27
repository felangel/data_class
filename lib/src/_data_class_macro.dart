import 'package:collection/collection.dart';

// Libraries used in augmented code.
final dartCore = Uri.parse('dart:core');
final dataClassMacro = Uri.parse(
  'package:data_class_macro/src/_data_class_macro.dart',
);

// Methods used in augmented code.
const undefined = Object();
final deepEquals = const DeepCollectionEquality().equals;

// TODO(felangel): use jenkins hash from `package:equatable`
// once https://github.com/felangel/equatable/pull/174 is published.
/// Generate a hash for the provided [fields].
int hashAll(Iterable<Object?>? fields) {
  return _finish(fields == null ? 0 : fields.fold(0, _combine));
}

int _combine(int hash, Object? object) {
  if (object is Map) {
    object.keys
        .sorted((Object? a, Object? b) => a.hashCode - b.hashCode)
        .forEach((Object? key) {
      hash = hash ^ _combine(hash, [key, (object! as Map)[key]]);
    });
    return hash;
  }
  if (object is Set) {
    object = object.sorted((Object? a, Object? b) => a.hashCode - b.hashCode);
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }
    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
