---
name: dart-codegen
description: Author Dart code generators with the build_runner / source_gen / code_builder / analyzer stack. Use when the user wants to write a new Dart code generator, build a custom builder, create annotations with generated implementations, design build.yaml for a generator package, handle cross-file or multi-phase generation dependencies, resolve analyzer Element/DartType to code_builder references, test generators with build_test, or troubleshoot build_runner issues like stale caches, cycles, or analyzer version conflicts. Trigger on "write a Dart builder", "custom code generator", "SharedPartBuilder", "GeneratorForAnnotation", "build.yaml", "source_gen", "code_builder", "TypeChecker", "aggregating builder", or when a user shows a build_runner error or asks how freezed/json_serializable/riverpod_generator/injectable/auto_route are built internally. Do NOT use for Dart macros (cancelled) or for just consuming an existing generator.
---

# Dart Code Generation: Authoring Generators

You are authoring a Dart code generator. This skill covers the full build_runner stack: `build_runner` (orchestrator), `build` (Builder/BuildStep/AssetId/Resolver), `source_gen` (Generator/GeneratorForAnnotation/SharedPartBuilder/TypeChecker/ConstantReader), `code_builder` (fluent code emission), `analyzer` (Element/DartType), `dart_style` (formatting), and `build_test` (testing).

**Macros are out of scope** — they were cancelled in early 2025. Always use build_runner.

## Mandatory first step: read the relevant reference

Before writing any code, read the references that match what the user is doing. These contain verified API details, version notes, and full examples. Do not rely on memory — analyzer and source_gen APIs churn.

- `references/architecture.md` — The stack, package responsibilities, two-package pattern, when to use which builder type
- `references/build_yaml.md` — Complete build.yaml schema, every key explained, capture groups, global_options
- `references/dependencies.md` — **Critical**: phase ordering, required_inputs, runs_before, reading another generator's output, aggregation patterns
- `references/analyzer_api.md` — Element/DartType walking, ConstantReader, TypeChecker, DartType → code_builder Reference bridge
- `references/code_builder.md` — Class/Method/Field specs, DartEmitter.scoped, Allocator, Code.scope, expression API
- `references/testing.md` — build_test, testBuilder, golden files, resolver-only tests, error-path tests
- `references/troubleshooting.md` — Stale resolver, analyzer version conflicts, cycles, missing part directives, rebuild storms
- `references/real_world.md` — How freezed/json_serializable/riverpod_generator/injectable/auto_route/drift are actually built
- `references/practical_patterns.md` — BuilderOptions, LibraryReader, AssetId rules, logging, element2 migration, pubspec templates, augmentations outlook
- `references/worked_example.md` — Complete scaffold for a minimal generator (two-package layout, build.yaml, generator, test). Read this first when starting a new generator from scratch.

## Core workflow for authoring a generator

**If starting from scratch, read `references/worked_example.md` first** — it has a complete minimal generator you can adapt by renaming. Then follow these steps:

1. **Clarify the goal**. What does the annotation look like? What is the generated output? Must it aggregate across files or is it one-input-one-output? Must generated code see private members of the user's class?
2. **Pick the builder type** (see `architecture.md`):
   - Default: `SharedPartBuilder` + `GeneratorForAnnotation<T>` writing into a combined `.g.dart` (json_serializable pattern)
   - Dedicated output file needed (e.g., `.freezed.dart`): `PartBuilder`
   - Standalone importable library: `LibraryBuilder`
   - Aggregating across many files: raw `Builder` with synthetic input (`$lib$`) and `findAssets(Glob)`
3. **Set up the two-package layout** (always): `my_pkg_annotations` (runtime dep, no analyzer) and `my_pkg_generator` (dev dep, depends on analyzer/source_gen/build).
4. **Write the build.yaml** per `build_yaml.md`. Decide `auto_apply`, `build_to`, `required_inputs`, `runs_before`, `applies_builders`.
5. **Implement the generator** using the analyzer patterns in `analyzer_api.md` and code emission patterns in `code_builder.md`.
6. **Test with build_test** per `testing.md`. Include at least: happy path, missing annotation field, wrong element kind (e.g., annotation on a function instead of a class), and cross-file resolver test.
7. **Run `dart run build_runner build --delete-conflicting-outputs`** in the example package to smoke-test end-to-end.

## Non-negotiable rules

- **Never read your own output.** This creates a cycle. Use two builders with `runs_before` if multi-pass is needed.
- **Never do string concatenation for non-trivial code.** Use `code_builder` with `DartEmitter.scoped()` so imports get prefixed correctly. Exception: if output is mostly boilerplate with simple interpolation, string templates are idiomatic (freezed, json_serializable do this).
- **Always run `dart_style`** on output before writing. Use `DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)`.
- **Always throw `InvalidGenerationSource`** (not `InvalidGenerationSourceError` — deprecated) with `element:` parameter on invalid input. This surfaces errors at the correct source location in the user's IDE.
- **Never use `TypeChecker.fromRuntime`** — removed in source_gen 4.0. Use `TypeChecker.fromUrl('package:foo/foo.dart#ClassName')`.
- **Never put heavy dependencies (analyzer, source_gen) in the annotation package.** Users depend on annotations in runtime code; they must not pull in 30MB of analyzer.
- **Never ship a generator that requires `dart:mirrors`** — it cannot be AOT-compiled, which is now standard.
- **Pin analyzer version ranges carefully** and watch build_runner's "Allow analyzer X.0.0" changelog entries. Analyzer breaks APIs in minor releases.
- **Write outputs ONLY to AssetIds declared in `buildExtensions`.** If your mapping says `{'.dart': ['.g.part']}` and you try to write `.foo.dart`, build_runner fails at runtime. See `practical_patterns.md`.
- **Validate `BuilderOptions` in the factory, not the Builder.** The top-level `Builder myGen(BuilderOptions o)` function must be synchronous, idempotent, side-effect-free. Throw there on bad config to fail the build early.
- **Use `log.info/warning/severe` from `package:build/build.dart`**, never `print()`. `print` breaks --verbose filtering and formatting.

## Dependency pattern (the part users always get wrong)

When generator B needs output from generator A:

```yaml
# B's build.yaml
builders:
  b_builder:
    import: "package:b/builder.dart"
    builder_factories: ["bBuilder"]
    build_extensions: {".g.dart": [".final.dart"]}
    required_inputs: [".g.dart"]   # ← this guarantees A runs first
    auto_apply: dependents
```

Then in B's build method: `final lib = await buildStep.resolver.libraryFor(buildStep.inputId.changeExtension('.g.dart'));` — the resolver now works because phase ordering guaranteed A finished.

For aggregation across many files (injectable pattern): Phase 1 writes `.injectable.json` per file to cache. Phase 2 uses `auto_apply: root_package`, `build_to: source`, and `findAssets(Glob('**/*.injectable.json'))` to build the combined output. Full walkthrough in `references/dependencies.md`.

## Type resolution (Element/DartType → code_builder Reference)

This is the other thing people get wrong. `DartType` from analyzer ≠ `Reference` from code_builder. You must bridge them and carry the import URI:

```dart
Reference typeRef(DartType t) {
  if (t is InterfaceType) {
    final uri = t.element.library.source.uri.toString();
    if (t.typeArguments.isEmpty) return refer(t.element.name, uri);
    return TypeReference((b) => b
      ..symbol = t.element.name
      ..url = uri
      ..isNullable = t.nullabilitySuffix == NullabilitySuffix.question
      ..types.addAll(t.typeArguments.map(typeRef)));
  }
  if (t is TypeParameterType) return refer(t.element.name); // no url for T
  return refer(t.getDisplayString());
}
```

Always emit with `DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true)` so imports are added and prefixed automatically.

## When working on a task

Follow this order every time:
1. Read the 1–3 reference files relevant to what's being asked
2. Confirm the builder type choice with the user if non-obvious
3. Produce the build.yaml before the Dart code — it forces design clarity
4. Write the generator, using `InvalidGenerationSource` for every validation branch
5. Write at least two tests (happy + error) in the same turn
6. End with the exact command to run: `dart run build_runner build --delete-conflicting-outputs`

If the user is troubleshooting, go straight to `references/troubleshooting.md` first.
