# Mix 2.0

Type-safe styling system for Flutter that separates style semantics from widgets.

## Environment Setup

If Flutter is not installed or `flutter --version` fails, run the setup script:

```bash
bash setup.sh
```

This installs FVM, Flutter SDK (3.41.2), DCM, and melos, then bootstraps all packages.

## Structure

```
packages/
  mix/              # Core framework (v2.0.0-rc.0)
  mix_annotations/  # Annotations for codegen
  mix_generator/    # build_runner generator
  mix_lint/         # Custom linter (not in pub workspace, see below)
  mix_docs_preview/ # Doc preview widgets and manifest for the website
website/            # Documentation site
```

## Pub workspace

The repo uses [Dart pub workspaces](https://dart.dev/tools/pub/workspaces): a single `pubspec.lock` and shared resolution at the root. Run `dart pub get` at the repo root to resolve all workspace packages.

- **In the workspace:** mix, mix_annotations, mix_generator, mix_tailwinds, mix_tailwinds/example, mix_docs_preview.
- **Excluded:** `mix_lint` (uses analyzer ^7.x for custom_lint_builder; other packages use analyzer >=9). Run `dart pub get` inside `packages/mix_lint` when working on the linter.

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
- `packages/mix_docs_preview/` - Doc preview widgets (Box, HBox, VBox, Text, Icon, etc.)
- `packages/mix/lib/src/specs/box/` - Spec/Style/Widget pattern

## Critical Rules

- **Dart SDK:** >=3.11.0 (enables dot-shorthands)
- **Flutter:** >=3.41.0
- **Immutability:** Specs are always immutable; use `copyWith()` for changes
- **Code generation:** Run `melos run gen:build` after modifying specs
- **mix.dart is generated:** Don't edit directly; run `melos run exports`

## Testing

```bash
melos run test:flutter    # Flutter package tests
melos run test:dart       # Dart package tests
melos run test:coverage   # With coverage report
```

## Git Conventions

**Branch naming** (Git Flow prefixes):
- `feat/` - New features
- `fix/` - Bug fixes
- `chore/` - Maintenance (deps, config, cleanup)
- `docs/` - Documentation changes
- `refactor/` - Code restructuring
- `test/` - Test additions/updates

**Commit messages** (Conventional Commits):
```
<type>(<scope>): <description>

type: feat, fix, chore, docs, refactor, test, ci
scope: mix, mix_generator, mix_annotations, mix_lint, mix_docs_preview, website
```

## Key Files

- `melos.yaml` - All script definitions
- `lints_with_dcm.yaml` - Linting rules
- `.fvmrc` - Flutter version (3.41.2)
- `packages/mix/lib/src/core/` - Core abstractions
