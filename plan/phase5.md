# Phase 5 — Consumer realignment (tailwinds) + public API reshaping

**Status:** Not started · **Depends on:** phase 1 (options object), phase 4 R4.3 (gradients) for the bypass removal; other items independent · **Blocks:** publishing decision
**Scope:** mix_tailwinds stops paying runtime rent for a test-time guarantee;
mix_schema's public surface is reshaped to match how consumers actually use it.

## Objective

One producer story (build Mix stylers; encode when you need data), one consumer
story (decode with options), identity values via per-call resolvers — and the
schema contract enforced where it belongs: in tests.

## Context

`[review B5, C1–C3, C8]` Tailwinds currently builds JSON payloads at runtime and
immediately decodes them (payload-as-IR): per-build cost, a `StateError` failure
mode that can't logically occur with direct construction, a duplicated
variant-wrapping switch (translate vs payload paths ×4), and a sanctioned
gradient bypass that already broke the "everything we render is
wire-representable" guarantee the round-trip was meant to provide. The isolated
clean-sheet designer independently rejected shipping a JSON-builder producer API
("a second way to construct documents, immediately divergent"). Prior review
items S4 (flex-item round-trip) and S6 (`payloadX` test-only duplication) were
deferred and are re-confirmed; they land here.

## Requirements

### R5.1 — Benchmark first (decision gate)
Measure the current runtime cost of tailwinds' build-payload→decode on a
representative widget build (the parity fixtures are realistic corpora), and
the direct-styler-construction equivalent.
**Acceptance:**
- [ ] Numbers recorded in this doc's Decision log; D5.1 decided **on data**.

### R5.2 — Tailwinds builds stylers directly
(assuming D5.1 confirms the realignment)
- `TwTranslator` constructs Mix stylers via the fluent/constructor API instead
  of payload maps; variant wrapping uses the existing styler path only.
- The schema contract moves to **test-time enforcement**: contract tests take
  representative translator outputs, `encode()` them, and `validate()` the
  result against the contract (plus golden payload fixtures for the
  characterization set). "Everything tailwinds renders is wire-representable"
  becomes a CI invariant instead of a per-frame runtime detour — and, unlike
  today, it actually holds (gradients included, post phase 4).
**Acceptance:**
- [ ] No `mix_schema` imports remain in tailwinds' runtime widget path
      (`tw_widget.dart`, `tw_flex_item.dart`); imports live in translate-encode
      (if kept) and tests. `wire_literal_guard_test` updated to the new boundary.
- [ ] `tw_parser_characterization_test` (resolved-value oracle) green unchanged
      — it is the behavior-preservation net for this refactor.
- [ ] Visual parity suite green (same baselines).

### R5.3 — Delete the duplicated payload paths `[prior review S4, S6]`
- [ ] `tw_flex_item.dart`: construct `FlexibleModifierMix(flex:, fit:)` directly;
      delete the encode→decode round-trip, its two `StateError`s, and the
      `BuildContext` thread; retarget its contract test.
- [ ] Delete `payloadBox`/`payloadFlex`/`payloadText` + `_payloadFor` + the
      payload-side variant-wrapping switch; retarget
      `schema_payload_contract_test.dart` at real translator output via R5.2's
      encode-then-validate pattern. (Keep whatever `payloadIcon` usage is still
      production-real, or fold it into the same pattern.)

### R5.4 — Registry → per-call resolvers (mix_schema)
- Replace the frozen-registry-in-contract with call-scoped identity resolution:
  - `DecodeOptions.resolveIcon: IconData? Function(String name)` (and image
    equivalent), slotting into phase 1's options object;
  - `EncodeOptions.iconNames: Map<String, IconData>` reverse map (and image
    equivalent);
  - value forms for the common cases, killing most registry need outright:
    icons `{"codePoint": int, "fontFamily": str, "fontPackage"?: str,
    "matchTextDirection"?: bool}` (raw escape hatch; document tree-shaking
    caveat), images `{"url": ...}` → `NetworkImage`, `{"asset": ..., "package"?}`
    → `AssetImage`; other `ImageProvider`s fail encode with path.
- `builtInMixSchemaContract` becomes genuinely universal (no per-app state baked
  in); `RegistryBuilder`/`FrozenRegistry`/`MixSchemaScope` are deleted or
  reduced to an internal detail (D5.2 covers `animation_on_end`).
**Acceptance:**
- [ ] Icon/image round-trip through the **singleton** with resolvers — the
      phase-0 trap is structurally impossible now.
- [ ] Registry error codes (`unknownRegistryId/Value`) replaced/remapped with
      resolver-flavored equivalents; error-mapper test updated.
- [ ] WIRE_CONTRACT.md registry section rewritten (value forms + resolver names).

### R5.5 — Public surface reshaping (mix_schema) `[review C1–C3]`
- [ ] Move `SchemaStyler`/`SchemaModifier`/`SchemaVariant` (wire vocabulary) and
      `builtInMixSchemaContract` to the contract entry point (`mix_schema.dart`);
      `encode.dart` either becomes test-support / is absorbed, per D5.3.
- [ ] Verify the Phase 3 `AckSchema`-hiding wrapper is still complete after
      token/property grammar work; finish any remaining public-surface cleanup
      (`MixSchemaBranch<T>` for custom branches, `MixSchemaRootSchema` for the
      root schema handle) without reintroducing ack as a promised API. (Engine
      stays ack; the *API* stops promising ack.)
- [ ] Delete the now-orphaned producer helpers (or demote to a
      `mix_schema/testing.dart` support library) — decided by what R5.2/R5.3
      leave alive.
- [ ] `validate()` routed through `decode<Object>()` if not already done in
      phase 0 (S7).

### R5.6 — Remove the gradient bypass (needs phase 4 R4.3)
- [ ] Delete `applyGradient` callback threading from `_translate` and
      `tw_gradient.dart`'s post-decode application; gradients flow through the
      styler path like everything else (schema representability proven by the
      phase-4 fixture).

### R5.7 — Publishing checkpoint (decision, not necessarily execution)
With ack unpinned (phase 0), format charter (phase 1), and API reshaped (this
phase): decide whether/when mix_schema publishes.
**Acceptance:**
- [ ] Decision recorded (publish now / after tree-layer demo / stay internal).
      If publishing: remove `publish_to: none`, add `publish_mix_schema` job to
      `.github/workflows/publish.yml`, add to `changelog.yml` version-bump flow,
      write a real CHANGELOG + README quickstart.
- [ ] Before any publish decision, explicitly resolve the Phase 1 transition
      compromise: keep missing `v` as a warning for internal branch consumers, or
      flip missing `v` to fatal and update tests/docs together.

### R5.8 — mix_tailwinds public API compatibility checkpoint
- Before landing the tailwinds realignment, compare the exported
  `package:mix_tailwinds/mix_tailwinds.dart` surface against `origin/main`.
  The branch currently replaces the public `tw_semantic.dart` export with
  `tw_types.dart`; that preserves runtime parser/widget behavior, but removes
  public semantic-AST symbols such as `TwValue`, `TwProperty`, `TwParsedClass`,
  plugin registry constants, and Tailwind preset maps unless the phase restores
  or intentionally breaks them.
- Decide whether those symbols are supported API, internal implementation detail
  that can break in the alpha, or compatibility shims to keep through the
  realignment.
**Acceptance:**
- [ ] Public API diff recorded in this doc's Decision log, including the removed
      `tw_semantic.dart` symbols.
- [ ] Decision recorded: restore compatibility facade / document breaking
      alpha cleanup / replace with a new public API.
- [ ] If breaking, README/CHANGELOG call it out; if restoring, add a compile
      test that imports `package:mix_tailwinds/mix_tailwinds.dart` and uses the
      kept compatibility symbols.

## Non-goals (this phase)

The widget-tree document layer (own package, own plan when it starts — the
review confirmed the per-node style shape composes under it); rewriting the
validation engine (ack stays per the review's adjudication).

## Open decisions

**D5.1 — Keep or retire tailwinds' runtime decode.** Decided by R5.1's numbers
plus the bypass count. Default expectation per the review: retire to test-time.
If numbers say the cost is negligible AND phase 4 closed every bypass, keeping
runtime decode is defensible — record either way.
**Decision:** _(record)_

**D5.2 — `animation_on_end` callbacks.** With registries gone: resolver
(`resolveCallback`), or drop `onEnd` from the wire (knownUnsupported)?
Recommendation: drop for v1 (callbacks-over-wire is a smell; revisit with the
tree layer's event story).
**Decision:** _(record)_

**D5.3 — Fate of `encode.dart`.** (a) absorb the survivors into
`mix_schema.dart`; (b) keep as `package:mix_schema/testing.dart` for contract
tests. Recommendation: (b) if R5.2 keeps encode-then-validate tests in
consumers; else (a).
**Decision:** _(record)_

## Verification / exit criteria

- Full gate green + tailwinds visual parity suite green (unchanged baselines).
- Characterization oracle green through the realignment (no resolved-value
  drift).
- Grep-proof: no `package:mix_schema/` imports in tailwinds' runtime widget
  path; guard test enforces it.
- Benchmark numbers + all D5.x decisions recorded below.
- mix_tailwinds public API compatibility decision recorded; any breaking alpha
  cleanup is explicit in README/CHANGELOG or backed by compatibility tests.
- Phase 5 closeout confirms every carry-forward lesson owned by Phase 5 in
  `plan/lessons.md` was either applied or explicitly deferred with a reason.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
