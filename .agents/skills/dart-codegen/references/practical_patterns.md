# Practical Patterns: the stuff first-time authors get wrong

## Reading BuilderOptions (custom build.yaml options)

Users pass options in build.yaml:
```yaml
targets:
  $default:
    builders:
      my_pkg|my_gen:
        options:
          strict: true
          rename_prefix: "_$"
```

Read them in your factory:
```dart
Builder myGen(BuilderOptions options) {
  final strict = options.config['strict'] as bool? ?? false;
  final prefix = options.config['rename_prefix'] as String? ?? '_\$';
  return SharedPartBuilder([MyGenerator(strict: strict, prefix: prefix)], 'my_gen');
}
```

`options.config` is `Map<String, dynamic>`. Always defensive-cast with `as T?` and provide defaults. Factory runs once per build — do all validation there and throw early on bad config.

## LibraryReader: the convenience layer on LibraryElement

`LibraryReader` wraps a `LibraryElement` with generator-friendly helpers. You get one for free in `Generator.generate(LibraryReader library, BuildStep step)`.

```dart
class MyGen extends Generator {
  @override
  String generate(LibraryReader lib, BuildStep step) {
    final checker = TypeChecker.fromUrl('package:ann/ann.dart#MyAnn');
    // All elements annotated with MyAnn, across the library, in one call:
    for (final annotated in lib.annotatedWith(checker)) {
      final element = annotated.element;
      final reader = annotated.annotation; // already a ConstantReader
      // ...
    }
    return output;
  }
}
```

Key LibraryReader methods:
- `allElements` — every top-level element
- `classes` — `Iterable<ClassElement>`
- `annotatedWith(TypeChecker)` — `Iterable<AnnotatedElement>` (element + ConstantReader pre-packaged)
- `annotatedWithExact(TypeChecker)` — same, exact match only
- `findType(String name)` — lookup a class by name
- `pathToElement(Element)` — relative URL

Use this when you need to iterate multiple annotated elements and `GeneratorForAnnotation` doesn't fit (e.g., you want all annotated elements in one call to understand relationships between them, like freezed does).

## AssetId rules that trip everyone

1. **Output AssetIds you write MUST match a declared output in `buildExtensions`.** If declared `{'.dart': ['.g.part']}` and you try to write `.foo.dart`, build_runner throws at runtime.
2. `AssetId` format is `package|path`. Path is relative to package root: `lib/foo.dart`, not `/lib/foo.dart`.
3. Manipulation:
   ```dart
   step.inputId                              // current file
   step.inputId.changeExtension('.g.part')   // same name, new extension
   step.inputId.addExtension('.freezed')     // appends: foo.dart → foo.dart.freezed
   AssetId(step.inputId.package, 'lib/config.dart')  // construct fresh
   step.inputId.uri                          // package: URI for imports
   ```
4. For aggregators using `$lib$` synthetic input, construct outputs manually with `AssetId(package, 'lib/filename.dart')`.

## Multiple generators in one SharedPartBuilder

```dart
Builder myPkg(BuilderOptions o) => SharedPartBuilder(
  [
    MyGenerator(),
    MyEnumGenerator(),
    MyRouteGenerator(),
  ],
  'my_pkg',  // single partId — all three contribute to one .g.part
);
```

Each generator's output is concatenated. Use this when multiple annotations in your package should produce output to the same file.

## GeneratorForAnnotation unresolved annotations

If the user's annotation references types that can't yet be resolved (e.g., another generator hasn't emitted them), `GeneratorForAnnotation` by default throws. Override:

```dart
class MyGen extends GeneratorForAnnotation<MyAnn> {
  @override
  bool get throwOnUnresolved => false;  // skip silently instead of throwing
  // ...
}
```

Most generators should keep the default (`true`) — unresolved annotations are usually user errors. Set `false` only if you know you're in a multi-phase build where early runs legitimately see partial resolution.

## Logging

Inside a Builder/Generator:
```dart
import 'package:build/build.dart';  // provides `log`

log.info('Processing ${element.name}');    // verbose, visible with --verbose
log.warning('Deprecated annotation used');  // always visible, yellow
log.severe('Bad config');                   // red, highlighted
```

`log` is a zone-scoped `Logger`. Do NOT use `print()` — it bypasses build_runner's formatting and breaks --verbose filtering.

Prefer `throw InvalidGenerationSource(...)` over `log.severe` for user-facing errors — it stops the build with a proper source location, which severe logs don't do.

## element2 migration (analyzer 7+ → source_gen 3+)

Source_gen 3.0 switched to the analyzer `element2` API family. Key renames when migrating an older generator:

| Old (element) | New (element2) |
|---|---|
| `element.enclosingElement` / `enclosingElement3` | `element.enclosingElement` (consolidated) |
| `ClassElement.isAbstract` | unchanged |
| `ParameterElement` | `FormalParameterElement` |
| `element.session` | same but import path changed |
| `LibraryElement.exportNamespace` | unchanged |

Check `github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md` for the full list. When a method disappears, search for the suffix-less consolidated name first.

## Builder factory contract

The top-level function you register in `builder_factories`:
```dart
Builder myBuilder(BuilderOptions options) { /* ... */ }
```

Rules:
- **Must be synchronous.** Do no async work here — just validate options and return the Builder.
- **Must be idempotent.** Called once per build, but should construct the same Builder every time for the same options.
- **No side effects.** Don't read files, don't log — that's the Builder's job.
- **Throw from here** on malformed options. It fails the build early with a clear error.

## Forward-looking: augmentations

Augmentations (the `augment` keyword) are shipping in Dart 2026 as a standalone language feature, **not** replacing build_runner. They let generated code add members to an existing class without the `part of` + `_$Impl` shim dance. When they land, generators will be able to emit:
```dart
augment class User {
  augment String toJson() => ...;
}
```
instead of the current `part 'user.g.dart';` pattern with `_$UserToJson(this)` glue. If you're designing a new generator, structure your output so it can be converted to augmentations later (single source per user-class, minimal glue in the user's file).

This doesn't change anything today — keep using SharedPartBuilder. Just don't design yourself into a corner.

## Pubspec template: annotation package

```yaml
name: my_pkg_annotation
description: Annotations for my_pkg.
version: 1.0.0
environment:
  sdk: ^3.4.0
# NO analyzer, NO source_gen, NO build. Only meta if you need @sealed etc.
dependencies:
  meta: ^1.15.0
```

## Pubspec template: generator package

```yaml
name: my_pkg_generator
description: Code generator for my_pkg.
version: 1.0.0
environment:
  sdk: ^3.4.0
dependencies:
  my_pkg_annotation: ^1.0.0
  analyzer: '>=6.0.0 <9.0.0'    # widen range carefully
  build: ^2.4.0
  source_gen: ^2.0.0
  code_builder: ^4.10.0
  dart_style: ^3.0.0
  glob: ^2.1.0
dev_dependencies:
  build_runner: ^2.4.0
  build_test: ^2.2.0
  test: ^1.25.0
```

## User pubspec (what consumers write)

```yaml
dependencies:
  my_pkg_annotation: ^1.0.0
dev_dependencies:
  my_pkg_generator: ^1.0.0
  build_runner: ^2.4.0
```
