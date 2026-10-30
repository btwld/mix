# Development workflow

Use this for changes inside the Mix monorepo. For downstream UI work, use the
consuming project's setup and resolved dependencies instead of assuming Melos.
Repository-specific commands and environment pins live in
[AGENTS.md](https://github.com/btwld/mix/blob/main/AGENTS.md), `melos.yaml`,
`.fvmrc`, and package manifests.

## Change the authoring inputs

For a widget-backed spec, follow `packages/mix/lib/src/specs/box/`:

1. Define nullable final resolved fields on `@immutable final class FooSpec
   with _$FooSpec`, with `@MixableSpec(target: Foo.new)` and its generated part.
2. Map fields to rendering in the widget. Use `@MixableField` only for necessary
   surface overrides. Generated stylers belong in the spec's generated part.
3. Regenerate and test resolved behavior. Do not edit `*.g.dart` by hand.

[Code generation](code-generation.md) owns annotation examples, target
restrictions, field forwarding and curated metadata. Keep that detail there.

## Commands and verification

```bash
melos bootstrap
melos run gen:build
melos run exports
melos run ci
melos run analyze
```

Melos discovers package paths and bootstraps dependencies. This checkout has no
pub workspace declaration; root `dart pub get` does not resolve all packages.
The analyzer plugin has package-specific dependency constraints.

`gen:build` cleans, generates Flutter/Dart parts, and updates the Winds registry.
`exports` separately generates the public barrel. Use `gen:watch` for iteration.
After spec, styler, runtime, generated API or generator changes, run
`gen:build && ci && analyze` through Melos before committing. Prose-only changes
need link checks and `git diff --check`; CI remains applicable.

For serialized output changes, regenerate fixtures with `schema:fixtures` and
validate with `schema:check` (Node/Ajv). `schema:inventory` verifies vocabulary
coverage. Do not update fixtures just to hide an unexplained mismatch.

## Match checks to ownership

- `mix`: resolution, interpolation, merge and widget tests.
- `mix_generator`: builder/annotation contracts and generated output tests.
- `mix_protocol` / chart sidecar: wire behavior, inventory and schema fixtures.
- `mix_winds`: translation, compiled layout plan, widget geometry and parity.

Use focused package tests while iterating; `test:flutter` and `test:dart` run
broader groups. `format:check` verifies formatting and `analyze` includes Dart,
DCM and schema inventory. Publication, release tags and unrelated fixes require
separate user scope; the development workflow does not authorize them.
