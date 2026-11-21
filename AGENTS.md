# Mix contributor instructions

Mix is a type-safe Flutter styling system: immutable fluent Styler → resolved
Spec → Widget. Read [Architecture](ARCHITECTURE.md) for boundaries and decisions;
[the Mix skill](skills/mix/SKILL.md) routes to focused API references.

## Setup and packages

If `flutter --version` fails, run `bash setup.sh` to install the toolchain and
bootstrap. SDK requirements live in `packages/mix/pubspec.yaml` and `melos.yaml`;
`.fvmrc` pins Flutter. Use the consuming project's resolved version downstream.

This checkout uses **Melos package discovery and bootstrap**, not a Dart pub
workspace. Root `dart pub get` does not resolve every package. Run
`melos bootstrap`; use package-local `dart pub get` for isolated Dart work.
`mix_lint` is an analyzer plugin with its own analyzer requirements; check its
manifest before aligning versions with `mix_generator`.

- `mix`: runtime; `mix_annotations` / `mix_generator`: typed generation.
- `mix_lint`: analyzer rules; `mix_protocol`: JSON codecs and schemas.
- `mix_chart` / `mix_chart_protocol`: charts and optional serialization.
- `mix_winds`: utility compiler and widgets; `examples/showcase`: runnable UI.

## Commands

Run from the repository root; `melos.yaml` owns the script definitions.

```bash
melos bootstrap
melos run gen:build       # Clean, Flutter/Dart generation, Winds registry
melos run exports         # Separate generation of mix.dart
melos run ci              # Flutter + Dart tests
melos run analyze         # Inventory, Dart + DCM analysis
melos run schema:fixtures # Regenerate checked-in schemas and fixtures
melos run schema:check    # Independent Ajv validation (Node required)
melos run fix             # Apply lint fixes and formatting
```

## Editing and verification

- Edit spec, annotation or generator inputs, not `*.g.dart` or `mix.dart`.
- Prefer `@MixableSpec(target: Widget.new)` for widget-backed APIs. Use the
  `packages/mix/lib/src/specs/box/` implementation as the reference.
- Specs are immutable; fluent styler calls return new merged values. Plain
  values replace, while Mix values merge fieldwise.
- After runtime, spec, styler, generated API or generator changes, run
  `melos run gen:build && melos run ci && melos run analyze` before committing.
  Run `exports` separately when the public barrel changes, and schema fixture
  generation/validation when serialized output changes.
- Use focused tests while iterating (`test:flutter`, `test:dart`, package tests).
  For prose-only edits, check links and `git diff --check`; CI still runs.
- Follow package-specific instructions for Winds parity and other specialized work.

Use Conventional Commits (`docs:`, `fix(mix):`, etc.) and descriptive
`feat/`, `fix/`, `docs/`, `chore/`, `refactor/`, or `test/` branches.
Website documentation is maintained in [btwld/mix-docs](https://github.com/btwld/mix-docs).
