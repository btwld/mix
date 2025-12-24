# Mix 2.0

Type-safe styling system for Flutter that separates style semantics from widgets.

## Structure

```
packages/
  mix/              # Core framework (v2.0.0-rc.0)
  mix_annotations/  # Annotations for codegen
  mix_generator/    # build_runner generator
  mix_lint/         # Custom linter
examples/           # Interactive widget gallery
website/            # Documentation site
```

## Commands

```bash
melos bootstrap           # Install dependencies
melos run gen:build       # Generate code (specs, exports)
melos run ci              # Run all tests
melos run analyze         # Dart + DCM analysis
melos run fix             # Auto-fix lint issues
```

## Verification

Before committing:
```bash
melos run gen:build && melos run ci && melos run analyze
```

## Architecture

Core pattern: **Spec** (immutable data) + **Style** (mutable builder) + **Widget**

```
packages/mix/lib/src/
  core/       # Mix, Spec, Style, Prop, Directive
  specs/      # BoxSpec, TextSpec, IconSpec, etc.
  modifiers/  # Widget wrappers (Padding, Align, etc.)
  variants/   # NamedVariant, ContextVariant
  theme/      # Tokens, Material integration
```

## Examples

**Properties:** Use `$` prefix for type-safe props:
```dart
Style($box.color.blue(), $text.style.bold())
```

**Variants:** Context-aware styling:
```dart
Style($box.color.black(), $on.dark($box.color.white()))
```

**Fluent chaining:**
```dart
final box = BoxMix().size(200, 200).padding(EdgeInsetsMix.all(16));
```

## Documentation

- `guides/api-composition-guidelines.md` - Fluent chaining, sizing, merge patterns
- `examples/` - Interactive widget examples (Box, HBox, VBox, Text, Icon)
- `website/` - Full documentation site (Next.js)
- `packages/mix/lib/src/specs/box/` - Reference implementation for Spec/Style/Widget pattern

## Critical Rules

- **Dart SDK:** >=3.9.0 (enables dot-shorthands)
- **Flutter:** >=3.38.1
- **Immutability:** Specs are always immutable; use `copyWith()` for changes
- **Code generation:** Run `melos run gen:build` after modifying specs
- **mix.dart is generated:** Don't edit directly; run `melos run exports`

## Testing

```bash
melos run test:flutter    # Flutter package tests
melos run test:dart       # Dart package tests
melos run test:coverage   # With coverage report
```

## Key Files

- `melos.yaml` - All script definitions
- `lints_with_dcm.yaml` - Linting rules
- `.fvmrc` - Flutter version (3.38.1)
- `packages/mix/lib/src/core/` - Core abstractions
