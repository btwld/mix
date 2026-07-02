# Phase 2 — Drift ratchet (core-surface inventory tool)

**Status:** Not started · **Depends on:** phase 0 (clean baseline) · **Blocks:** phase 4 (it generates phase 4's backlog)
**Scope:** dev tooling + CI + one runtime assert. No wire-format changes.

## Objective

Make schema coverage a *decision* instead of an accident: a CI tool that
enumerates every data-bearing construct in `packages/mix` and fails unless each
one is explicitly classified `supported` or `knownUnsupported(reason)` by
mix_schema. Its first run produces the authoritative coverage backlog that
drives phase 4.

## Context

`[review B4]` Coverage today is a tailwinds-shaped slice (modifiers 4/28,
animation 1/4 configs, directives 5/19, variant gaps) — not because anyone
decided that, but because nothing forces the decision. The clean-sheet design's
strongest structural idea was this ratchet: cheaper than codegen, stronger than
hand-hoping, and it converts "what's missing?" from an audit question into a CI
diff. The branch's own history shows the failure mode it prevents: the encode
path was hardened per-styler by hand (`UnsupportedSchemaField`), which guards
known fields but says nothing when core grows a *new* one.

## Requirements

### R2.1 — Inventory extraction (`tool/inventory_check.dart`)
An analyzer-based script (dev-only, in `packages/mix_schema/tool/`) that parses
`package:mix` sources and enumerates:
- every `Prop<T>` field (and bare data field, e.g. `$textDirectives`) on every
  public `Style` subclass and every public `Mix<T>` type used in styler fields
  (BoxDecorationMix, TextStyleMix, BorderMix, …);
- every `ModifierMix` subclass reachable via `WidgetModifierConfig`;
- every `Directive` subclass and its `key`;
- every `Variant`/`ContextVariant` subclass and factory-produced kind;
- every `AnimationConfig` subclass; the named-`Curve` inventory;
- every `MixToken` subclass (for phase 3);
- every enum type appearing in a field position.
**Acceptance:**
- [ ] Deterministic output (sorted, stable) listing each construct with a stable
      id (e.g. `BoxStyler.$foregroundDecoration`, `directive:color_darken`,
      `modifier:ClipOvalModifierMix`).
- [ ] Runs against the monorepo's `mix` at HEAD (path dep), so drift is caught
      at the source before release.

### R2.2 — Classification manifest
A checked-in manifest (Dart const table or committed data file — D2.1) mapping
every inventory id to exactly one bucket:
- `supported` — a codec covers it (optionally: since format version);
- `knownUnsupported(reason)` — deliberate exclusion with a human-readable reason
  (e.g. `closure-backed, not data`, `deferred: phase 4`).
**Acceptance:**
- [ ] The check fails with a readable diff when: (a) a core construct is in
      neither bucket (new core API landed), (b) a manifest entry no longer exists
      in core (stale), (c) an entry is in both.
- [ ] Every current gap from the review is classified — the initial manifest IS
      the coverage decision record (gradients: deferred-phase-4; `Paint`
      fields: never; `PhaseAnimationConfig`: never; etc.).

### R2.3 — CI wiring
- [ ] `melos.yaml` script (e.g. `schema:inventory`) + included in the `ci`
      chain (or `analyze` chain — D2.2) so it runs on every PR.
- [ ] Fast enough not to hurt CI (< ~30s); if analyzer resolution is slow,
      cache or scope the entry points.

### R2.4 — Coverage backlog artifact
- [ ] First run's classified output is checked in as `plan/coverage-backlog.md`
      (grouped: supported / deferred-with-target-phase / never-with-reason).
      Phase 4's checklist is generated from the "deferred" group.
- [ ] The backlog includes a short provenance header naming the inventory tool,
      command, source package revision, and whether any entries were manually
      curated. Do not hand-edit generated output without recording why.

### R2.5 — Runtime exhaustiveness assert (encode-side skew guard)
Per styler, encode asserts that the set of fields it consumed (covered +
declared-unsupported) equals the styler's actual field inventory (via the public
`props`/`$`-field surface). Mismatch — e.g. app upgraded `mix` beyond what this
`mix_schema` build knows — throws a typed error naming the field, instead of
silently dropping it.
**Acceptance:**
- [ ] Assert exists on every styler encode path with negligible cost (debug-mode
      `assert` acceptable — D2.3).
- [ ] Test simulates skew (a locally-declared styler subclass with an extra
      field, or a hand-built field-list mismatch) and pins the error.

## Non-goals (this phase)

Closing the gaps themselves (phase 4). Codegen of codecs (rejected by the
review's adjudication: tables/ratchet beat a generator for 8 stylers on a stable
core — revisit only if the manifest churn rate proves painful).

## Open decisions

**D2.1 — Manifest form.** Dart const map next to the codecs (compile-checked,
IDE-navigable) vs YAML/JSON data file (diff-friendly, tool-writable).
Recommendation: Dart const map — the tool reads it via analyzer anyway.
**Decision:** _(record)_

**D2.2 — CI placement.** Inside `melos run analyze` chain vs `ci` chain vs both.
Recommendation: `analyze` (it's a static check).
**Decision:** _(record)_

**D2.3 — Assert mode.** Always-on throw vs debug-only `assert`. Recommendation:
throw in encode (encode is not hot-path for consumers; skew must never drop data
silently even in release — this is the R5 fail-loud promise under version skew).
**Decision:** _(record)_

## Verification / exit criteria

- Deleting any manifest entry → CI fails with a readable diff (demonstrated).
- Adding a dummy `Prop` field to a local `mix` checkout → CI fails (demonstrated
  once manually; documented in the tool's header).
- `plan/coverage-backlog.md` is included in the phase commit; phase 4 checklist
  references it.
- Phase 2 closeout confirms every carry-forward lesson owned by Phase 2 in
  `plan/lessons.md` was either applied or explicitly deferred with a reason.
- Full gate green.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
