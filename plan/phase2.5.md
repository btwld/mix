# Phase 2.5 — Cross-phase review fixes (ratchet hardening + contract doc lockstep)

**Status:** Not started · **Depends on:** phases 1–2 (repairs their landed output) · **Blocks:** phase 3 start; phase 4's backlog integrity
**Scope:** the fixes from the 2026-07-02 cross-phase review (`findings.md` Addendum,
IDs X1–X12): inventory-tool blind spots, manifest reclassification + backlog
regeneration, WIRE_CONTRACT/code lockstep, lenient-mode repairs, and test-gap
backfill. **No new wire vocabulary, no new styling coverage.**

## Objective

Re-true what phases 1–2 claimed before phase 3 builds on it: the ratchet actually
enumerates every tracked construct, the manifest's buckets match the plan's intent
(so phase 4's generated backlog is trustworthy), the spec matches tested behavior
again, and previously checked boxes in the phase 1/2 docs are true statements.
Small phase, one commit, then phase 3 starts clean.

## Context

A cross-phase review of `933bcfd7d..HEAD` (one delegated reviewer per feature
commit + lead verification with fresh gate output) judged the plan on track and
the architecture sound, with localized defects: the inventory tool misses
second-level subclasses (X1 — public `IdentityStyle` is unclassified today),
three manifest entries contradict phase 3/4 intent and silently shrink the
phase 4 backlog (X2), lenient mode deviates from its spec (X3) and its repair
loop is quadratic below the node cap (X6), the contract doc names a nonexistent
error code (X4), and the runtime skew guard's real guarantee is narrower than
phase 2's headline sentence (X5). Full detail and evidence: findings.md Addendum.

## Requirements

### R2.5.1 — Inventory tool integrity `[review X1, X7, X9]`
- Transitive inheritance closure for **all** tracked bases (`Style`, `Mix`,
  `ModifierMix`, `Directive`, `Variant`/`ContextVariant`, `AnimationConfig`,
  `MixToken`) — generalize the closure directives already have.
- Unknown enum-like field types fail the run with a readable error; the Flutter
  allowlist becomes a decision surface, not a silent skip.
- Provenance marks dirty worktrees (e.g. `<sha>+dirty`) so a generated backlog
  cannot claim a clean source revision.
**Acceptance:**
- [ ] `IdentityStyle` (and anything else the closure newly discovers) appears in
      the inventory and fails `--check` until classified in the manifest.
- [ ] Closure test: a fixture second-level subclass (e.g. locally declared
      `X extends WidgetStateVariant`) is discovered.
- [ ] Unknown enum type in a field position → loud failure, tested.
- [ ] Dirty-tree provenance pinned by test or demonstrated + recorded in
      session.md.

### R2.5.2 — Manifest reconciliation + backlog regeneration `[review X2, X10]`
- `TextStyleMix.$fontFeatures` / `$fontVariations` → `deferred: phase 4`
  (const data types; R4.7 already names them). Record the reversal in
  lessons.md's "Decisions we reversed".
- `WidgetModifierConfig.$orderOfModifiers`: reconcile with R4.4's planned
  `modifierOrder` support — reclassify `deferred: phase 4` **or** amend R4.4;
  either way, record which.
- Classify every id newly discovered by R2.5.1 (`IdentityStyle` gets a reasoned
  bucket).
- Sweep the remaining `never` reasons against phase 3/4 scope for further
  contradictions; fix or justify each.
- Regenerate `plan/coverage-backlog.md`; phase 4 consumes the regenerated file.
**Acceptance:**
- [ ] `--check` green; backlog regenerated with correct provenance; reversals
      recorded in lessons.md.
- [ ] New manifest-truthfulness test: every `supported` styler-field entry has a
      matching declared codec field, so the decision record cannot silently lie.

### R2.5.3 — Contract doc lockstep `[review X4, X5]`
- `unsupported_value` → `unsupported_encode_value` in WIRE_CONTRACT.md.
- Document the skew guard's actual guarantee: styler-root scope only (nested Mix
  types unguarded until phase 4 grows them), count-based unknown-field detection,
  and the net-zero add+remove blind spot.
**Acceptance:**
- [ ] Touched WIRE_CONTRACT sections re-spot-checked against tests; phase1.md
      R1.4 annotated as re-verified (the honest redo of that box).

### R2.5.4 — Lenient-mode repairs `[review X3, X6]`
- Warning-path policy per D2.5.2, implemented and spec'd.
- Cap lenient removals per decode (e.g. 256) → `limitExceeded`, spec'd.
**Acceptance:**
- [ ] Multi-removal test asserts exact warning paths (no `endsWith` masking).
- [ ] Removal-cap test green; structural-fatality lenient tests still green.

### R2.5.5 — Envelope diagnostics consistency `[review X8]`
- `{"v": null}` handling per D2.5.3.
- `validate()` failures carry the same warnings `decode()` does (additive field
  on the failure type; no breaking change).
**Acceptance:**
- [ ] Version-value matrix tested: `null`, `1.0`, `true`, `"1"`, `0`, `2`.
- [ ] validate-vs-decode warning-parity test.

### R2.5.6 — Test-gap backfill `[review X10]`
- Exact boundaries: depth 64 accepted / 65 rejected; 10,000 nodes accepted /
  10,001 rejected.
- Composite-styler skew accounting with real `FlexBoxStyler`/`StackBoxStyler`
  (owner-field counts, not synthetic owners only).
- Schema-export assertion: nested style definitions do **not** require `v`
  (R1.1's nested rule, export side).
**Acceptance:**
- [ ] All named tests green in the phase commit.

### R2.5.7 — Process remediation `[review X12]`
- Run the dummy-Prop drift demo once for real (scratch field on a local `mix`
  checkout → `--check` fails) and record the output in session.md.
- Apply the CI-workflow pin decision (D2.5.4).
**Acceptance:**
- [ ] session.md records the demo; phase2.md decision log notes it.

## Non-goals (this phase)

New wire vocabulary or coverage (phases 3–4); nested-Mix runtime skew guards
(phase 4 hook exists in R4.8); API reshaping (phase 5) beyond D2.5.1's
*sequencing* decision; tailwinds changes; per-encode cost optimization (phase 5's
benchmark owns encode-path cost questions).

## Open decisions

**D2.5.1 — AckSchema-hiding sequencing `[review X11]`.** The premortem assumed
the extension API was already hidden behind mix_schema-owned types; C2 is
actually scheduled for phase 5. (a) Pull the owned-type wrapper forward as
phase 3's first task, before the token/property grammars grow the Ack-typed
surface; (b) keep it in phase 5 and accept the larger reshaping diff.
Recommendation: (a) — cheaper before two grammar phases build on the surface.
**Decision:** _(record)_

**D2.5.2 — Lenient warning-path policy `[review X3]`.** (a) Translate warning
paths back to original-document indices via a removal journal (spec stays as
promised — most useful to consumers mapping warnings onto the payload they
sent); (b) amend spec + tests to "path in the partially-cleaned document at
removal time". Recommendation: (a).
**Decision:** _(record)_

**D2.5.3 — Null-`v` classification `[review X8]`.** (a) Special-case `/v` ahead
of the null preflight → `unsupported_version` (the spec already promises it;
version-skew telemetry wins); (b) keep `null_forbidden` and amend the spec.
Recommendation: (a).
**Decision:** _(record)_

**D2.5.4 — Reusable-workflow pin `[review X9]`.** (a) Pin `btwld/dart-actions`
to a commit SHA and bump deliberately; (b) accept `@main` (same org) with a
recorded rationale. Recommendation: (a) — the ratchet's PR guarantee should not
drift with another repo's default branch.
**Decision:** _(record)_

## Verification / exit criteria

- Full gate green: `melos run gen:build && melos run ci && melos run analyze`.
- Regenerated backlog committed; every finding X1–X10 addressed or explicitly
  deferred with owner + reason in the decision log (X11/X12 resolve via D2.5.1
  and R2.5.3/R2.5.7).
- WIRE_CONTRACT.md spot-check: every assertion touched this phase matches a test.
- Standard closeout: delegated review over the whole phase diff, session.md
  entry, README status board update, one commit
  (`fix(mix_schema): <description>`).
- Phase 2.5 closeout confirms every carry-forward lesson it owns in
  `plan/lessons.md` was applied or explicitly deferred with a reason.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
