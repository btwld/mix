# mix_schema Lessons Learned

## 2026-03-05 — M1

- Ack on the selected branch does not natively support transformed child
  branches inside `Ack.discriminated()`.
- The stable workaround is to normalize each child branch into an object-backed
  schema for dispatch and apply the branch transform at the outer discriminated
  layer.
- `FrozenRegistry` should own immutability itself instead of depending on
  `RegistryBuilder` to pass an unmodifiable map implementation.
- Strict color parsing is better than loose numeric coercion for this package:
  invalid color payloads should report `type_mismatch`, not generic conversion
  failure.

## 2026-03-05 — M2

- Expand shared schemas through one proven styler path before widening built-in
  styler coverage. This kept the slice testable and avoided premature breadth.
- Domain refinements are required even when base types validate:
  - box constraints need ordered min/max pairs
  - gradients need stops/count validation
  - box decorations need shape/border-radius compatibility checks
- The current shared painting layer is enough for richer `box` decoding, but it
  is not yet the final contract:
  - `shape_decoration` remains deferred
  - gradient transforms remain deferred
  - metadata factories are still separate work

## 2026-03-05 — M3 and M4

- `modifierOrder` has to target Mix's resolved widget modifier classes, not
  the `ModifierMix` classes used during decode. The runtime reorder step uses
  `WidgetModifier.runtimeType`.
- Unified object schemas can be better than `anyOf` unions when error shape is
  part of the contract. The edge-insets schema became simpler and produced the
  expected single-path failures once absolute and directional keys were handled
  in one strict schema.
- `ContextVariantBuilder` needs a correctly typed placeholder style in
  `VariantStyle`, but Mix ignores that placeholder at merge time and uses the
  builder output directly.
- Direct `melos exec` commands are the reliable repo-wide validation path in
  this environment. `melos run` prompts interactively here, which makes it a
  poor fit for automated verification.
- The workspace analysis failure is broader than the initial SDK-hash warning.
  Direct analyzer runs still fail in other packages (`examples`,
  `mix_generator`, `mix_tailwinds`, `mix_lint`, and `mix`), while
  `mix_schema` remains clean.

## 2026-03-05 — Post-Implementation Review

This section records the pre-redesign review state. Several items here were
intentionally addressed by the 2026-03-06 redesign completion work below.

- The package design is strongest where it stays explicit:
  - small public API
  - isolated error mapping
  - clear registry freeze lifecycle
  - direct decode into Mix runtime types
- The biggest drift from the original plan is reuse. The implementation proved
  the contract, but it did not fully achieve the "define once, reference
  everywhere" goal because shared schemas are still rebuilt through factories
  instead of being held in a single catalog.
- Fields-only vs full styler schemas solved the variant cycle cleanly enough
  for correctness, but the price was repeated field declarations. That is a
  good transitional pattern for a vertical slice and a poor final pattern for
  a full package.
- `metadata_schemas.dart` and `decoration_schemas.dart` became the package's
  main complexity sinks. Future work should split them by responsibility before
  adding any more breadth.
- Quality gates matter only if the package is actually wired into them.
  `mix_schema` passing format/analyze/test was useful, but the missing DCM
  config means part of the intended cleanliness bar was never enforced.
- A clean implementation needs the plan, the code, and the retrospective to
  evolve together. Once the Ack discriminated-branch assumption failed, the
  correction should have been reflected in the plan immediately instead of
  living mainly in simulation notes.
- Some runtime-only integrations are correct but signal friction in the helper
  layer:
  - `ContextVariantBuilder` needs an ignored placeholder style
  - `ImageStyler` metadata support needs a placeholder image provider
  Those are acceptable in v1, but they are good targets for a cleanup pass.
- Public API docs should be added early for packages whose main job is to
  define a contract. A small surface is an advantage only if it is also
  documented.

## 2026-03-06 — Redesign Completion

- A single catalog object is the right level of abstraction for this package.
  `MixSchemaCatalog` is enough to centralize shared schemas without inventing a
  second public registration DSL.
- Flattening metadata to `modifiers` and `modifierOrder` made the wire contract
  easier to read and removed a pointless level of nesting without changing the
  runtime model.
- DCM should be enabled before major refactors settle, not after. The final
  lint pass exposed weak JSON-cast and generic-boundary choices that were worth
  fixing, not merely formatting noise.
- Small typed helpers plus typed locals were more effective than broader
  abstraction when reconciling Ack generics, Mix runtime types, analyzer
  inference, and DCM expectations.
- The right stopping point for a redesign is package-local correctness plus
  synchronized docs. Once format, analyzer, DCM, tests, plan, simulation
  results, and lessons learned all agree, the package is ready for normal
  maintenance instead of more architectural churn.

## 2026-03-06 — Enum Surface Cleanup

- Enhanced enums are a better fit than static string-holder classes for closed
  discriminator vocabularies because they make exhaustive switches possible in
  the registration layer.
- Not every string constant should become a public enum. Built-in registry
  scopes are worth exposing publicly, but the rest of the discriminator sets
  are better kept internal to avoid hardening unnecessary API surface.
- The clean compromise was:
  - public `MixSchemaScope`
  - public `MixSchemaErrorCode`
  - internal non-exported enums for the remaining wire vocabularies
- A public enum only pulls its weight if the common setup path uses it.
  `RegistryBuilder.builtIn(scope: MixSchemaScope...)` is the right bridge for
  built-in registries because it improves ergonomics without forcing custom
  scopes into an enum-shaped API.
- Public behavior tests should use literal wire strings unless the symbol being
  referenced is itself part of the intended public API.
