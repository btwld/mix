# Phase 5 — Consumer realignment (tailwinds) + public API reshaping

**Status:** Completed · **Depends on:** phase 1 (options object), phase 4 R4.3 (gradients) for the bypass removal; other items independent · **Blocks:** publishing decision
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
- [x] Numbers recorded in this doc's Decision log; D5.1 decided **on data**.
- [x] Benchmark method records fixture set, repeat count, current
      `package:mix_schema` runtime import count, and gradient-bypass count.
- [x] Final post-refactor benchmark confirms the direct-styler path against the
      same fixture corpus before closeout.

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
- [x] No `mix_schema` imports remain in tailwinds' public/runtime path
      (`tw_parser.dart`, `tw_widget.dart`, `tw_flex_item.dart`,
      `translate/tw_translator.dart`, `translate/tw_accumulators.dart`);
      imports live only in tests/test-support. `wire_literal_guard_test`
      updated to the new boundary.
- [x] `tw_parser_characterization_test` (resolved-value oracle) green unchanged
      — it is the behavior-preservation net for this refactor.
- [x] Visual parity suite green (same baselines).

### R5.3 — Delete the duplicated payload paths `[prior review S4, S6]`
- [x] `tw_flex_item.dart`: construct `FlexibleModifierMix(flex:, fit:)` directly;
      delete the encode→decode round-trip, its two `StateError`s, and the
      `BuildContext` thread; retarget its contract test.
- [x] Delete `payloadBox`/`payloadFlex`/`payloadText` + `_payloadFor` + the
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
- [x] Icon/image round-trip through the **singleton** with resolvers — the
      phase-0 trap is structurally impossible now.
- [x] Registry error codes (`unknownRegistryId/Value`) replaced/remapped with
      resolver-flavored equivalents; error-mapper test updated.
- [x] `animation_on_end` registry cleanup lands with D5.2: codec behavior, docs,
      error mapping, and tests no longer imply callback-over-wire support.
- [x] WIRE_CONTRACT.md and README registry/resolver sections rewritten (value
      forms + resolver names), with end-to-end recommended-path tests.

### R5.5 — Public surface reshaping (mix_schema) `[review C1–C3]`
- [x] Move `SchemaStyler`/`SchemaModifier`/`SchemaVariant` (wire vocabulary) and
      `builtInMixSchemaContract` to the contract entry point (`mix_schema.dart`);
      `encode.dart` either becomes test-support / is absorbed, per D5.3.
- [x] Verify the Phase 3 `AckSchema`-hiding wrapper is still complete after
      token/property grammar work; finish any remaining public-surface cleanup
      (`MixSchemaBranch<T>` for custom branches, `MixSchemaRootSchema` for the
      root schema handle) without reintroducing ack as a promised API. (Engine
      stays ack; the *API* stops promising ack.)
- [x] Delete the now-orphaned producer helpers (or demote to a
      `mix_schema/testing.dart` support library) — decided by what R5.2/R5.3
      leave alive.
- [x] `validate()` routed through `decode<Object>()` if not already done in
      phase 0 (S7).
- [x] Compile/API tests prove `package:mix_schema/mix_schema.dart` exposes the
      consumer contract entry point without promising Ack types, and the chosen
      `JsonMap`, `encode.dart`, and `testing.dart` fate is importable only where
      intended.

### R5.6 — Remove the gradient bypass (needs phase 4 R4.3)
- [x] Delete `applyGradient` callback threading from `_translate` and
      `tw_gradient.dart`'s post-decode application; gradients flow through the
      styler path like everything else (schema representability proven by the
      phase-4 fixture).

### R5.7 — Publishing checkpoint (decision, not necessarily execution)
With ack unpinned (phase 0), format charter (phase 1), and API reshaped (this
phase): decide whether/when mix_schema publishes.
**Acceptance:**
- [x] Decision recorded (publish now / after tree-layer demo / stay internal).
      If publishing: remove `publish_to: none`, add `publish_mix_schema` job to
      `.github/workflows/publish.yml`, add to `changelog.yml` version-bump flow,
      write a real CHANGELOG + README quickstart.
- [x] Before any publish decision, explicitly resolve the Phase 1 transition
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
- [x] Public API diff recorded in this doc's Decision log, including the removed
      `tw_semantic.dart` symbols.
- [x] Decision recorded: restore compatibility facade / document breaking
      alpha cleanup / replace with a new public API.
- [x] If breaking, README/CHANGELOG call it out; if restoring, add a compile
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
**Decision:** Retire runtime decode to test-time enforcement. Baseline
benchmark on 2026-07-03 used `fvm flutter test tool/phase5_benchmark.dart
--reporter expanded` with 5,000 iterations over 10 box, 7 flex, and 7 text
class-string fixtures. Current payload-build→decode costs were 31.67us/box,
15.07us/flex, and 20.96us/text fixture; payload-build-only lower bounds were
3.39us, 1.99us, and 1.88us respectively. Current runtime imports of
`package:mix_schema` exist in 3 production files, and the gradient bypass still
threads post-decode application. The post-refactor benchmark on 2026-07-03 used
the same 10 box, 7 flex, 7 text corpus shape and 5,000 repeat count: direct
translation measured 4.97us/box, 3.57us/flex, and 2.25us/text fixture.
Runtime `package:mix_schema` import count was 0 and gradient post-decode bypass
count was 0.

**D5.2 — `animation_on_end` callbacks.** With registries gone: resolver
(`resolveCallback`), or drop `onEnd` from the wire (knownUnsupported)?
Recommendation: drop for v1 (callbacks-over-wire is a smell; revisit with the
tree layer's event story).
**Decision:** Drop `onEnd` from v1 wire. Decode treats `onEnd` as an unknown
animation field; encode fails loudly for `CurveAnimationConfig` /
`SpringAnimationConfig` values carrying callbacks. Revisit callbacks with the
future widget-tree/event layer instead of app-scoped registries.

**D5.3 — Fate of `encode.dart`.** (a) absorb the survivors into
`mix_schema.dart`; (b) keep as `package:mix_schema/testing.dart` for contract
tests. Recommendation: (b) if R5.2 keeps encode-then-validate tests in
consumers; else (a).
**Decision:** Move consumer-facing contract vocabulary and
`builtInMixSchemaContract` to `mix_schema.dart`; demote any remaining payload
helper surface to `package:mix_schema/testing.dart` for contract tests.
`encode.dart` may remain only as a compatibility re-export during this
unpublished transition.

**D5.4 — mix_tailwinds public semantic API.** Restore the `tw_semantic.dart`
facade, document a breaking alpha cleanup, or replace it with a new public API?
**Decision:** Restore a compatibility facade. `origin/main` exported semantic
AST/value/plugin symbols (`TwValue`, `TwProperty`, `TwParsedClass`,
`functionalPlugins`, `namedPlugins`, `gradientDirections`, Tailwind defaults,
etc.); Phase 5 keeps those importable from `package:mix_tailwinds/mix_tailwinds.dart`
and adds a compile test.

**D5.5 — Options API names.** Phase 5's sketch says `DecodeOptions` /
`EncodeOptions`, while the branch already has `MixSchemaDecodeOptions`.
**Decision:** Keep MixSchema-prefixed names. Extend `MixSchemaDecodeOptions`
with icon/image resolver callbacks and add `MixSchemaEncodeOptions` for reverse
name maps / value-form policy. Avoid generic `DecodeOptions` names in the public
surface.

**D5.6 — Publishing and missing `v` checkpoint.** Publish now, after the
tree-layer demo, or stay internal; keep missing `v` warning or make it fatal?
**Decision:** Stay unpublished until the tree-layer demo proves the composed
contract. Keep missing `v` as a warning for internal branch consumers in this
phase; revisit before a publishable v1 checkpoint.

## Verification / exit criteria

- Full gate green + tailwinds visual parity suite green (unchanged baselines).
  Visual parity commands for this phase are the Flutter golden harnesses from
  `packages/mix_tailwinds/example`: `fvm flutter test test/parity_golden_test.dart`
  plus the stable supporting goldens `test/shrink_golden_test.dart` and
  `test/duration_delay_golden_test.dart`. Do not update committed goldens unless
  the root cause is understood and the new images are intended.
- Characterization oracle green through the realignment (no resolved-value
  drift).
- Grep-proof: no `package:mix_schema/` imports in tailwinds' runtime widget
  path; guard test enforces it.
- Benchmark numbers + all D5.x decisions recorded below.
- mix_tailwinds public API compatibility decision recorded; any breaking alpha
  cleanup is explicit in README/CHANGELOG or backed by compatibility tests.
- Phase 5 closeout confirms every carry-forward lesson owned by Phase 5 in
  `plan/lessons.md` was either applied or explicitly deferred with a reason.

## Decision log & lessons

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| 2026-07-03 | Phase-entry review adjustments applied before coding. | A read-only subagent review required promoting R5.8 to D5.4, recording benchmark method/import/bypass counts, broadening the tailwinds runtime import guard to public/runtime translator files, spelling out `animation_on_end` cleanup, choosing MixSchema-prefixed option names, adding public API compile checks, requiring README resolver docs/tests, naming the visual parity commands, and treating this entry review as the post-Phase-4 cross-phase review before coding. |
| 2026-07-03 | D5.1: retire tailwinds runtime decode. | Baseline benchmark: current payload-build→decode vs payload-build-only lower bound was 31.67us vs 3.39us for box, 15.07us vs 1.99us for flex, and 20.96us vs 1.88us for text fixtures; current production `mix_schema` import count is 3, with one gradient post-decode bypass. |
| 2026-07-03 | D5.2: drop callback-over-wire support. | `animation_on_end` does not become a resolver; `onEnd` is out of v1 until the future event/tree layer owns callback semantics. |
| 2026-07-03 | D5.3: testing support owns payload helpers. | Consumer vocabulary and the built-in singleton move to `mix_schema.dart`; any surviving payload helpers are test-support via `mix_schema/testing.dart`, with `encode.dart` only a temporary compatibility re-export if needed. |
| 2026-07-03 | D5.4: restore mix_tailwinds semantic compatibility. | Compared `mix_tailwinds.dart` against `origin/main`: the branch replaced `tw_semantic.dart` with one-line `tw_types.dart`, removing semantic AST/plugin/preset symbols. Restore a compatibility facade and compile test. |
| 2026-07-03 | D5.5: keep MixSchema-prefixed options. | Extend `MixSchemaDecodeOptions`; introduce `MixSchemaEncodeOptions`. Do not add generic `DecodeOptions` / `EncodeOptions` names. |
| 2026-07-03 | D5.6: stay unpublished and keep missing-`v` warning. | Publishing waits for the tree-layer demo; the missing-version transition compromise remains warning-only for this internal phase. |
| 2026-07-03 | Post-refactor benchmark: direct tailwinds path confirmed. | Same 10 box / 7 flex / 7 text corpus shape and 5,000 repeat count: 4.97us/box, 3.57us/flex, 2.25us/text. Runtime `package:mix_schema` import count is 0; gradient post-decode bypass count is 0. |
| 2026-07-03 | Registry surface reduced to internal legacy support. | Public identity failures now use `unresolved_identity_name` / `unresolved_identity_value`; `RegistryBuilder`, `FrozenRegistry`, and `MixSchemaScope` are no longer exported or exposed from `mix_schema.dart`. |
| 2026-07-03 | Tailwinds CSS corner gradients needed a shared transform. | The default Tailwinds `cssAngleRect` strategy produced `TwCssKeywordLinearTransform`, which was not schema-encodable while only `GradientRotation` was supported. Phase 5 moved the bounds-aware transform to `mix` as `CssKeywordLinearTransform`, kept the Tailwinds compatibility subclass, and added `css_linear` wire support. |
| 2026-07-03 | Closeout review completed and addressed. | Fresh delegated reviewer found one low-risk doc gap: raw `IconData` value forms needed the Flutter icon tree-shaking caveat required by R5.4. README and WIRE_CONTRACT now include it; no major code findings remained. |
| 2026-07-03 | Exit verification passed. | Fresh full gate reported success: `melos run gen:build`, `melos run ci`, and `melos run analyze`. Tailwinds visual parity passed with `fvm flutter test test/parity_golden_test.dart test/shrink_golden_test.dart test/duration_delay_golden_test.dart --reporter compact` from `packages/mix_tailwinds/example`; focused mix_schema and tailwinds contract suites also passed. |
