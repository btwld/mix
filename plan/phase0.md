# Phase 0 — Land the branch honestly (pre-merge fixes)

**Status:** Completed · **Depends on:** nothing · **Originally blocked:** merge of `feat/mix_schema`
**Scope:** small, correctness + hygiene only. No new format features in this phase.

## Objective

Make `feat/mix_schema` mergeable without shipping known traps: fix the two
confirmed correctness defects, close the hygiene gaps the review found, and sync
with `origin/main`. Everything bigger lands in later phases.

## Context

The review confirmed (by live probe) two defects reachable through the public,
documented API, plus a set of hygiene debts on a branch that is otherwise green
(163/477/199/257 tests passing, analyze + DCM clean). Fixing these before merge
keeps the package's "fail loud, no silent traps" promise honest.

## Requirements

### R0.1 — Fix the `builtInMixSchemaContract` icon/image trap `[review A1]`
The shared singleton freezes an **empty** registry, so any icon/image payload
fails decode (`unknown_registry_id`) and any `IconStyler`/`ImageStyler` fails
encode — while `lib/encode.dart:11-14` recommends producers use exactly this
singleton. Resolve the contradiction (see Resolved decisions D0.1 for the
options).
**Acceptance:**
- [x] A test exists that exercises icon and image payloads **through
      `builtInMixSchemaContract`** and pins the chosen behavior (working
      round-trip via resolvers, or an explicit typed failure with guidance).
- [x] No doc (README, doc comments, WIRE_CONTRACT.md) recommends a pattern that
      cannot work for icon/image.

### R0.2 — Domain error for empty contract freeze `[review A2]`
`MixSchemaContractBuilder().freeze()` with zero registered branches currently
throws ack's raw `ArgumentError` ("Invalid argument (schemas): must not be
empty").
**Acceptance:**
- [x] `freeze()` on an empty builder throws a mix_schema-owned error
      (`StateError` with actionable message naming `builtIn()`/`addStyler()`),
      before ack is reached. Unit test pins message shape.

### R0.3 — Core CHANGELOG entry `[review A5]`
`packages/mix` gained public classes `BrightnessVariant`, `BreakpointVariant`,
`NotVariant`, and the equality semantics of `ContextVariant.brightness/breakpoint/not`
changed from identity to value-based — undocumented on a published stable package.
**Acceptance:**
- [x] `packages/mix/CHANGELOG.md` documents both the additions and the equality
      change under the next unreleased version heading.

### R0.4 — Sync with `origin/main` `[review C6]`
Main has moved (mix `2.1.0` vs branch `2.0.3`).
**Acceptance:**
- [x] `origin/main` merged into `feat/mix_schema`; conflicts resolved; full gate
      green (`melos run gen:build && melos run ci && melos run analyze`).
- [x] Re-check R0.3's CHANGELOG placement against main's new version headings.

### R0.5 — Un-pin ack `[review C6]`
`ack` is a git-SHA dependency; a stable `ack 1.0.0` exists on pub.dev. Git deps
also block any future pub publish.
**Acceptance:**
- [x] `packages/mix_schema/pubspec.yaml` depends on `ack: ^1.0.0` (or the newest
      stable), no git ref. Full test suite green against the published version.
- [x] Any API drift between the pinned SHA and 1.0.0 is fixed or documented.

### R0.6 — Document the consumer surface `[review A7]`
Zero `///` doc comments on `mix_schema_contract.dart`, `mix_schema_error.dart`,
`registry.dart` — the entire surface a consumer touches.
**Acceptance:**
- [x] Every public declaration in those three files has a doc comment
      (contract lifecycle, each error code's meaning, result-type usage).
- [x] `dart analyze` / DCM still clean.

### R0.7 — Hygiene sweep `[review C6, C7]`
- [x] Delete `packages/mix_schema/melos_mix_schema.iml` (no sibling package
      commits per-package .iml files).
- [x] Remove the unused `'card'` spacing/radius keys from the tailwinds theme
      generator input (or regenerate without them), or record why they stay.
- [x] Fix stale `context_all_of` prose in `WIRE_CONTRACT.md` (no such core type
      exists — reword the exclusion in terms of real core types).
- [x] Add `dart_code_metrics_presets` dev-dep to `mix_schema` and `mix_tailwinds`
      so `melos analyze:dcm` covers them like the core packages — or record the
      explicit decision not to.

### R0.8 — Version constant guard `[review A4]`
- [x] A test asserts `mixSchemaVersion` equals the version in
      `packages/mix_schema/pubspec.yaml` (read the pubspec in the test), so the
      hand-maintained constant cannot silently desync. (Superseded in phase 1 by
      the format-version split — keep the test until then.)

### R0.9 — Optional, pre-reviewed fold-ins (prior review, deferred items)
Only if cheap while in the area; otherwise leave for their owning phase:
- [x] S7: route `MixSchemaContract.validate()` through `decode<Object>()`
      (removes the duplicated pipeline). Completed in Phase 5 R5.5.
      `[prior review S7]`
- [x] Test-helper dedup preference explicitly deferred out of this plan:
      one shared `test/support/codec_helpers.dart` for result-unwrapping
      remains optional test-only cleanup, not a phase gate. `[review C5-pref]`

## Non-goals (this phase)

Tokens, versioning envelope, `$merge`/`apply` grammar, coverage expansion,
tailwinds realignment, registry redesign beyond what D0.1 decides.

## Resolved decisions

**D0.1 — Shape of the icon/image fix.** Options:
1. **Ship per-call resolvers now** (`decode(..., resolveIcon:)` /
   encode reverse-map) — the phase-5 target design, pulled forward. Most work,
   ends the contradiction permanently.
2. **Singleton without icon/image branches** — `builtIn()` keeps them, the
   singleton registers only the 6 registry-free branches; docs say "icon/image
   require your own contract with a populated registry." Honest, small, slightly
   awkward API story.
3. **Document + pin failure** — keep behavior, add the missing test proving the
   failure, rewrite docs to require a custom contract for icon/image. Smallest
   diff, weakest fix.
   Recommendation from the review: (1) if phase 5 is near-term, else (2).
   **Decision:** Option 2. Keep `builtIn()` as the complete branch set, but make
   `builtInMixSchemaContract` expose only registry-free branches. Icon and image
   payloads require a custom contract with a populated registry until phase 5
   introduces the fuller per-call resolver API.
   (Superseded in phase 5 by R5.4 - see the decision log below.)

## Verification / exit criteria

- Full gate green: `melos run gen:build && melos run ci && melos run analyze`.
- New tests for R0.1, R0.2, R0.8 present and passing.
- `git status` clean; branch merged with `origin/main`; CHANGELOG entry present.

## Decision log & lessons

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| 2026-07-02 | D0.1: use Option 2 for icon/image singleton behavior. | This keeps Phase 0 scoped to correctness/hygiene while removing the misleading empty-registry trap from the shared singleton. |
| 2026-07-02 | Leave generated tailwinds `card` spacing/radius keys for now. | The only remaining keys are in `default_theme.g.dart`; the generator input is not present in this workspace, and generated files should not be hand-edited. |
| 2026-07-02 | Do not add `dart_code_metrics_presets` to `mix_schema`/`mix_tailwinds` in Phase 0. | Trial enablement made DCM scan both packages and surfaced hundreds of pre-existing style findings, which is outside this phase's correctness/hygiene scope. Keep the existing `melos analyze:dcm` filter and defer package-wide DCM cleanup. |
| 2026-07-03 | Optional fold-ins reconciled during final audit. | S7 was completed in Phase 5 when `validate()` was routed through `decode<Object>()`; the helper-dedup preference remains intentionally deferred as non-gating test cleanup. |
| 2026-07-04 | D0.1 superseded by Phase 5 R5.4. | Per-call resolvers/value forms replaced the registry policy; `builtInMixSchemaContract` now decodes icon/image directly. The Option 2 text describes phase 0-4 behavior only. |
