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

**Fluent chaining (recommended):**
```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .paddingAll(16)
    .borderRounded(8);

Box(style: style, child: child)
```

**Variants:** Context-aware styling:
```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(BoxStyler().color(Colors.black))
    .onHovered(BoxStyler().color(Colors.blue));
```

## Documentation

**Guides:**
- `guides/api-composition-guidelines.md` - Fluent chaining, sizing, merge patterns

**Website (comprehensive docs):**
- `website/src/content/documentation/overview/` - Introduction, getting started
- `website/src/content/documentation/guides/styling.mdx` - Style/Styler pattern
- `website/src/content/documentation/guides/dynamic-styling.mdx` - Variants (hover, press, dark)
- `website/src/content/documentation/guides/design-token.mdx` - MixScope, tokens
- `website/src/content/documentation/guides/animations.mdx` - Implicit, Phase, Keyframe
- `website/src/content/documentation/widgets/` - Widget-specific APIs

**Reference implementations:**
- `examples/` - Interactive widget examples (Box, HBox, VBox, Text, Icon)
- `packages/mix/lib/src/specs/box/` - Spec/Style/Widget pattern

## Critical Rules

- **Dart SDK:** >=3.10.0 (enables dot-shorthands)
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
