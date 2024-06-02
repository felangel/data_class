## 0.0.2

- chore: migrate from `package:data_class_macro` to `package:data_class`

## 0.0.1

- chore: initial version of `package:data_class`

## 0.0.0-dev.12

- feat: improve hash to use jenkins hash
- fix: support classes with static fields

## 0.0.0-dev.11

- feat: simpler `copyWith` syntax
- fix: `toString()` omits trailing comma when terminating with a `null` field.

## 0.0.0-dev.10

- refactor: simplify various macro implementations
  - remove unnecessary de-duping
  - improve internal performance
  - extract shared logic
- tests: additional unit tests for `@Data`

## 0.0.0-dev.9

- fix: `@Data` inheritance compatibility
- fix: `@Data` composability with other macros

## 0.0.0-dev.8

- feat: `@Data` can be applied to subclasses
- feat: `@Stringable()` (`toString`) excludes `null` fields
- tests: comprehensive unit tests

## 0.0.0-dev.7

- feat: add `@Constructable` macro (`const` constructor)
- feat: add `@Equatable` macro (`operator==` and `hashCode`)
- feat: add `@Stringable` macro (`toString`)
- feat: add `@Copyable` macro (`copyWith`)
- feat: make nullable fields optional constructor params
- feat: throw if a default constructor already exists

## 0.0.0-dev.6

- chore: rename to `Data()` to avoid confusion

## 0.0.0-dev.5

- deps: remove unnecessary dependency on `package:equatable`
- docs: add topics to `pubspec.yaml`

## 0.0.0-dev.4

- feat: `copyWith` support for setting nullable fields to `null`
- docs: improved example and `README.md`

## 0.0.0-dev.3

- feat: support for empty classes
- docs: improved example and `README.md`
- tests: unit tests

## 0.0.0-dev.2

- feat: generate named constructor
- feat: generate doc comments for `copyWith`
- docs: `README.md` improvements

## 0.0.0-dev.1

- fix: `Error: MacroImplementationExceptionImp`

## 0.0.0-dev

- chore: create package
