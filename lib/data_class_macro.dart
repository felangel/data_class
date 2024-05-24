import 'package:collection/collection.dart';

export 'src/constructable_macro.dart' show Constructable;
export 'src/copyable_macro.dart' show Copyable;
export 'src/data_macro.dart' show Data;
export 'src/equatable_macro.dart' show Equatable;
export 'src/stringable_macro.dart' show Stringable;

final deepEquals = const DeepCollectionEquality().equals;
