# Mix Generator - From-Scratch Rewrite

This package is being completely rewritten to auto-generate Spec and Styler class bodies for the Mix 2.0 styling framework.

## Project Context

**Goal**: Build a modern, maintainable code generator using best practices for `source_gen`, `code_builder`, and `build_runner`.

**Scope**: Generate two things per `@MixableSpec` annotation:
1. **Spec mixin** (`_$XSpecMethods`): `copyWith()`, `lerp()`, `debugFillProperties()`, `props`
2. **Styler class** (`XStyler`): Field declarations, dual constructors, `resolve()`, `merge()`, setters

## Important Guidelines

### Fresh Start - No Legacy Concerns

- This is a **complete rewrite** - do not reference or maintain compatibility with the old generator
- **No backwards compatibility required** - we can break any existing generated code patterns
- Focus on clean, idiomatic Dart code generation following modern best practices
- The old implementation has been removed; only a placeholder entry point remains

### Annotation Design Freedom

The current annotations in `mix_annotations` may be improved or redesigned if beneficial:
- Consider if there's a more idiomatic pattern for Dart code generation annotations
- Look at how successful packages like `freezed`, `json_serializable`, `auto_route` design their annotations
- Simplify where possible - the current `@MixableField` has options that may not be needed
- Document any proposed annotation changes before implementing

### Quality Over Speed

- Prefer clear, readable generator code over clever optimizations
- Extensive use of golden tests to validate output matches expected contract
- Type-driven generation - let the analyzer's type system guide decisions

## Planning Documents

| Document | Purpose |
|----------|---------|
| [PLAN.md](./PLAN.md) | Complete implementation plan with phases, patterns, and architecture |
| [EXPECTED_OUTPUT.md](./EXPECTED_OUTPUT.md) | Contract specification - what generated code must look like |

**Read PLAN.md thoroughly before implementing** - it contains critical decisions about emission strategy, type resolution, and edge cases.

## Related Packages

| Package | Path | Purpose |
|---------|------|---------|
| mix | `../mix/` | Core framework - contains Spec/Style/Widget implementations |
| mix_annotations | `../mix_annotations/` | Annotation definitions (`@MixableSpec`, `@MixableField`, etc.) |

**Key files in mix to reference:**
- `lib/src/core/spec.dart` - Base Spec class
- `lib/src/core/style.dart` - Base Style class
- `lib/src/core/prop.dart` - Prop wrapper class
- `lib/src/core/helpers.dart` - MixOps (lerp, merge, resolve)
- `lib/src/specs/box/` - Reference Spec/Style/Widget pattern

## Best Practices for Code Generation

### Builder Selection (source_gen)

Choose the appropriate builder based on output needs:

| Builder | Output | Use Case |
|---------|--------|----------|
| `PartBuilder` | `.g.dart` (unique extension) | Single generator owns the output file |
| `SharedPartBuilder` | `.g.dart` (shared) | Multiple generators contribute to same file |

**Current choice**: `PartBuilder` - we're the only generator for Spec files.

### code_builder Usage

Prefer `code_builder`'s fluent API for complex structures:

```dart
// Good - type-safe, handles edge cases
Class((b) => b
  ..name = 'BoxStyler'
  ..extend = refer('Style<BoxSpec>')
  ..mixins.addAll([refer('Diagnosticable'), ...])
  ..fields.addAll(buildFields())
  ..constructors.addAll(buildConstructors())
  ..methods.addAll(buildMethods()));
```

String templates are acceptable for simple, repetitive patterns:

```dart
// Acceptable for simple patterns
String buildProps(List<String> fields) {
  return '@override\nList<Object?> get props => [${fields.join(', ')}];';
}
```

### analyzer API Guidelines

- **Avoid deprecated `element2` APIs** - use standard `Element` APIs
- Use `DartType` inspection over string parsing for type decisions
- Detect collections via `InterfaceType` + library checks
- Use `TypeChecker.fromStatic()` for annotation detection (not `fromRuntime`)

```dart
// Good - type-safe checking
final isMixableSpec = TypeChecker.fromStatic(MixableSpec).hasAnnotationOf(element);

// Good - proper type inspection
if (type is InterfaceType && type.element.name == 'List') {
  final elementType = type.typeArguments.first;
}
```

### Testing Strategy

1. **Golden tests** - Compare generated output to expected fixtures
2. **Compile tests** - Run `flutter analyze` on generated code in real package
3. **Unit tests** - Test each resolver/builder in isolation

```dart
test('BoxSpec generated code matches expected fixture', () {
  final generated = runGenerator('fixtures/box_spec_input.dart');
  final expected = File('expected/box_spec.g.dart').readAsStringSync();
  expect(normalize(generated), equals(normalize(expected)));
});
```

## Architecture Overview

```
lib/src/
  core/
    registry/           # Type mappings (Flutter → Mix types)
    plans/              # FieldModel, StylerPlan (derived from Spec)
    builders/           # SpecMixinBuilder, StylerBuilder
    resolvers/          # LerpResolver, PropResolver, DiagnosticResolver
    curated/            # Curated maps for edge cases
    utils/              # Code emission helpers
```

**Key principle**: Plans are **derived from Spec + registries**, never extracted from existing code.

## Implementation Phases

1. **Phase 1**: Registries + Derived Plans (MixTypeRegistry, FieldModel, StylerPlan)
2. **Phase 2**: Type Resolution (LerpResolver, PropResolver, DiagnosticResolver)
3. **Phase 3**: Spec Mixin Builder (copyWith, lerp, debugFillProperties, props)
4. **Phase 4**: Styler Builder (fields, constructors, resolve, merge, setters)
5. **Phase 5**: Testing Infrastructure (golden tests, compile tests)

## Commands

```bash
# From monorepo root
melos bootstrap                    # Install dependencies
melos run gen:build               # Run all generators
melos run test:dart --scope=mix_generator  # Run generator tests
melos run analyze                 # Run analysis
```

## References

### Official Documentation
- [source_gen package](https://pub.dev/packages/source_gen)
- [code_builder package](https://pub.dev/packages/code_builder)
- [build_runner documentation](https://pub.dev/packages/build_runner)
- [analyzer package](https://pub.dev/packages/analyzer)

### Learning Resources
- [Dart Code Generation - Comprehensive Guide](https://medium.com/mj-studio/dart-code-generation-comprehensive-guide-490b15639c4e)
- [Code Generation with Dart & Flutter](https://codewithandrea.com/articles/dart-flutter-code-generation/)
- [Building Your First Dart Code Generator](https://dinkomarinac.dev/from-annotations-to-generation-building-your-first-dart-code-generator)

### Reference Implementations
Study these well-designed generators for patterns:
- [freezed](https://github.com/rrousselGit/freezed) - Immutable classes with unions
- [json_serializable](https://github.com/google/json_serializable.dart) - JSON serialization
- [auto_route](https://github.com/Milad-Akarie/auto_route_library) - Navigation code generation

## Critical Rules

1. **Contract-first**: Generated output MUST match EXPECTED_OUTPUT.md
2. **Type-driven**: Use analyzer type system, not string matching
3. **Fail fast**: Emit actionable errors for invalid inputs
4. **Test thoroughly**: Golden tests for every Spec type before moving on
5. **No magic**: Explicit curated maps over implicit heuristics for edge cases
