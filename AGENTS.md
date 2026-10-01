# Mix 2.0

Type-safe styling system for Flutter that separates style semantics from widgets.

## Environment Setup

If Flutter is not installed or `flutter --version` fails, run the setup script:

```bash
bash setup.sh
```

This installs FVM, Flutter SDK (3.44.0), DCM, and melos, then bootstraps all packages.

## Structure

```
packages/
  mix/              # Core framework (v2.0.0-rc.0)
  mix_annotations/  # Annotations for codegen
  mix_generator/    # build_runner generator
  mix_lint/         # Custom linter (not in pub workspace, see below)
```

## Pub workspace

The repo uses [Dart pub workspaces](https://dart.dev/tools/pub/workspaces): a single `pubspec.lock` and shared resolution at the root. Run `dart pub get` at the repo root to resolve all workspace packages.

- **In the workspace:** mix, mix_annotations, mix_generator, mix_winds, mix_winds/example.
- **Excluded:** `mix_lint` (an analyzer plugin; it uses the analyzer version its `analysis_server_plugin` requires, currently 14.x, while `mix_generator` uses analyzer >=9 <11). Run `dart pub get` inside `packages/mix_lint` when working on the linter.

## Commands

```bash
melos bootstrap           # Install dependencies
melos run gen:build       # Generate code (specs, exports)
melos run ci              # Run all tests
melos run analyze         # Dart + DCM analysis
melos run schema:fixtures # Regenerate checked-in packages/*/schema exports and fixtures
melos run schema:check    # Validate those files with Ajv (needs Node)
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
    .padding(.all(16))
    .borderRadius(.circular(8));

Box(style: style, child: child)
```

**Variants:** Context-aware styling:
```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(.color(Colors.black))
    .onHovered(.color(Colors.blue));
```

## Documentation

**Guides:**
- `guides/api-composition-guidelines.md` - Fluent chaining, sizing, merge patterns

**Website (comprehensive docs):** See [btwld/mix-docs](https://github.com/btwld/mix-docs)

**Reference implementations:**
- `packages/mix/lib/src/specs/box/` - Spec/Style/Widget pattern

## Critical Rules

- **Dart SDK:** >=3.12.0 (enables dot-shorthands)
- **Flutter:** >=3.44.0
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
scope: mix, mix_generator, mix_annotations, mix_lint
```

## Key Files

- `melos.yaml` - All script definitions
- `lints_with_dcm.yaml` - Linting rules
- `.fvmrc` - Flutter version (3.44.0)
- `packages/mix/lib/src/core/` - Core abstractions
