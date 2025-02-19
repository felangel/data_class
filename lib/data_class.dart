/// Experimental support for data classes in Dart using package:macros.
library data_class;

export 'package:equatable/equatable.dart' show Equatable;

export 'src/constructable_macro.dart' show Constructable;
export 'src/copyable_macro.dart' show Copyable;
export 'src/data_macro.dart' show Data;
export 'src/stringable_macro.dart' show Stringable;
