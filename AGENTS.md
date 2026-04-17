# Mix 2.0

Type-safe styling system for Flutter that separates style semantics from widgets.

## Current Focus

Read `CURRENT_GOAL.md` first when working on `mix_schema`.

The active priority is defining the right schema contract for `mix_schema`.
That contract should optimize for schema compatibility, correctness, future producers, AI-facing artifacts, and Ack as the single source of truth.

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
  mix_schema/       # Schema-first contract for building Mix interfaces
  mix_annotations/  # Annotations for codegen
  mix_generator/    # build_runner generator
  mix_lint/         # Custom linter (not in pub workspace, see below)
  mix_tailwinds/    # Tailwind proof-of-concept consumer of the schema contract
```

## Pub workspace

The repo uses [Dart pub workspaces](https://dart.dev/tools/pub/workspaces): a single `pubspec.lock` and shared resolution at the root. Run `dart pub get` at the repo root to resolve all workspace packages.

- **In the workspace:** mix, mix_schema, mix_annotations, mix_generator, mix_tailwinds, mix_tailwinds/example.
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

## mix_schema Vision

`mix_schema` is a schema-first contract for building Mix interfaces from structured input.
It should be designed around the product requirements of a durable schema layer, not around preserving the current implementation shape.

### What matters most

- **Schema compatibility first:** It should be easy to build Mix interfaces through the schema and hard to produce invalid payloads.
- **`mix_tailwinds` is a use case, not the source of truth:** It should fit naturally as a proof of concept and validation target, without forcing the schema to become Tailwind-specific.
- **Optimize for correctness over compatibility:** Breaking changes are acceptable while the contract is still taking shape if they make the schema cleaner, more durable, and easier to implement correctly.
- **Do not under-engineer or over-engineer:** Add abstraction only when it improves correctness, clarity, reuse, or exported contract quality.
- **Follow conventions where they help:** Match Mix and Dart naming and package conventions, but do not preserve incidental architecture if it fights the contract.

### Ack as the contract center

- **Ack is the single source of truth** for schema definitions.
- Use Ack in one place for **transform**, **validation**, and **schema export**.
- Avoid parallel manual contract layers that duplicate wire names, field shapes, or validation rules.
- Prefer designs where one contract definition can drive runtime decode, producer helpers, and exported schema artifacts.

### Decision test for schema work

When evaluating `mix_schema` changes, optimize for these questions:

- Can a future producer build valid Mix interfaces from the schema without knowing Mix internals?
- Can AI tooling consume stable schema artifacts and diagnostics to generate correct payloads?
- Does `mix_tailwinds` fit cleanly as a proof of concept for the contract?
- Would we accept a breaking change here because it produces a better long-term schema contract?

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

**Website (comprehensive docs):** See [btwld/mix-docs](https://github.com/btwld/mix-docs)

**Reference implementations:**
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
scope: mix, mix_generator, mix_annotations, mix_lint
```

## Key Files

- `melos.yaml` - All script definitions
- `lints_with_dcm.yaml` - Linting rules
- `.fvmrc` - Flutter version (3.41.2)
- `packages/mix/lib/src/core/` - Core abstractions
