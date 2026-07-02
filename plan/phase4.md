# Phase 4 — Property grammar (`apply`/`$merge`) + coverage expansion

**Status:** Not started · **Depends on:** phase 1 (envelope), phase 2 (backlog), phase 3 (`$token` term) · **Blocks:** phase 5's gradient-bypass removal
**Scope:** the wire format learns to represent what a `Prop` actually is
(sources + directives), then coverage expands family-by-family from the phase-2
backlog. Large phase — staged and parallelizable by family; each family lands
independently green.

## Objective

Dissolve the "encode-ability depends on construction history" defect by making
the grammar mirror `Prop`'s real model, then close the coverage gaps that force
consumers into bypasses — gradients first (it deletes tailwinds' `applyGradient`
escape hatch).

## Context

`[review B3]` `Prop.mergeProp` always accumulates sources (verified in core,
`prop.dart:189-197`), so `.width(1).merge(.height(2))` — both landing on the
shared `constraints` field — fails encode today while the equivalent
single-constructor styler succeeds. `[review B4]` Coverage: modifiers 4/28
(fluent `.rotate()`/`.scale()` route through modifiers → unencodable), gradients
+ `foregroundDecoration` + `decoration.image` missing, animation curve-only
(spring is pure data in core), directives 5/19 (text-only; directives-on-Prop
blocked entirely, hiding `ColorRef.withAlpha()`-style composition).

## Requirements

### R4.1 — `apply` directives on terms
- Grammar: any term (literal or `$token`) may carry
  `"apply": [{"op": "<Directive.key>", ...params-by-field-name}, ...]`.
- `op` values are core's stable `Directive.key` strings verbatim
  (`color_darken`, `number_multiply`, `uppercase`, …) — no parallel vocabulary.
- Decode → `Prop.directives([...])` merged onto the term's Prop; encode emits
  `apply` from `Prop.$directives` (removing the directives clause from the
  encode exclusions).
- Directive table covers all 19 core directives (13 color, 5 string via existing
  text-directive vocab — reconcile spellings D4.1, 9 number).
**Acceptance:**
- [ ] Per-directive round-trip (params preserved), incl. token+directive
      composition: `ColorRef.withAlpha()`-produced props encode and round-trip.
- [ ] Unknown `op` → strict fail / lenient skip-with-warning (phase 1 modes).
- [ ] Ratchet manifest: all `Directive` subclasses classified `supported`.

### R4.2 — `$merge` source stacks
- Grammar: `{"$merge": [Term, ...], "apply"?: [...]}` — ordered; mirrors
  `Prop.sources`. Encoder emits it **only** when `sources.length > 1`; producers
  never need to hand-write it; a one-element `$merge` is legal only as a carrier
  for `apply` on a literal.
- Decode reconstructs the accumulated sources in order (values → `ValueSource`,
  mixes → `MixSource`, `$token` → `TokenSource`), preserving core's resolution
  semantics (last-wins for plain values, accumulate for mixes) *by construction*.
- `readProp`'s single-source guard is relaxed accordingly; the directives guard
  is replaced by R4.1 emission.
**Acceptance:**
- [ ] Named regression test: `BoxStyler().width(1).merge(BoxStyler().height(2))`
      encodes, round-trips, and resolves identically to the original under a
      context matrix (the review's headline sharp edge, green).
- [ ] Merged-mix accumulation case (two partial paddings merged) round-trips
      with resolution equivalence.
- [ ] Canonical rule tested: single-source props stay flat (no gratuitous
      `$merge`); `encode(decode(j)) == j` byte-stable goldens updated.
- [ ] Schema export represents the term union without leaking internals.

### R4.3 — Gradients (first coverage family — unblocks phase 5)
- `decoration.gradient` union under `"kind"`: `linear` / `radial` / `sweep`,
  mirroring `LinearGradientMix`/`RadialGradientMix`/`SweepGradientMix` fields;
  `GradientRotation` as the only supported `transform` (others fail encode).
- Remove `failIfPresent($gradient)` from the box decoration codec.
**Acceptance:**
- [ ] Round-trip all three kinds + rotation; resolution equivalence vs
      hand-built Mix gradients.
- [ ] tailwinds' gradient output (via its `applyGradient` path) is expressible:
      prove with a fixture matching `tw_gradient.dart` output. (Actual bypass
      deletion is phase 5.)

### R4.4 — Modifier expansion (backlog-driven)
- Target: every data-representable modifier kind from the phase-2 backlog —
  expected set: `align`, `aspectRatio`, `box`, `clipOval`, `clipRect`,
  `clipRRect`, `clipPath?`, `clipTriangle`, `defaultTextStyler`,
  `fractionallySizedBox`, `iconTheme`, `intrinsicHeight`, `intrinsicWidth`,
  `padding`, `rotatedBox`, `scrollView`, `sizedBox`, `transform`, `scale`,
  `translate`, `rotate`, `skew`, `visibility` (+ existing 4).
- `knownUnsupported(reason)` forever: `shaderMask`, `mouseCursor` (v1),
  non-null custom `clipper`s.
- `modifierOrder` support: serialize `$orderOfModifiers` as kind strings
  (removes the current "custom modifier order not representable" throw).
**Acceptance:**
- [ ] Per-kind round-trip + resolution tests; fluent `.rotate()`/`.scale()`
      styler output becomes encodable (named test).
- [ ] Ratchet manifest fully classified for modifiers; WIRE_CONTRACT.md +
      schema golden updated per kind.

### R4.5 — Animation expansion
- `spring`: `SpringAnimationConfig` (mass/stiffness/damping — pure data).
- Curves: keep the named table; add `{"cubic": [a,b,c,d]}` for `Cubic`.
- Decide `delay` optionality (D4.2 — review flagged required-`delay` ergonomics).
- `knownUnsupported` forever: `PhaseAnimationConfig`, `KeyframeAnimationConfig`
  (contain Listenables/closures), custom `Curve` subclasses, non-null `onEnd`
  without a registry/resolver story.
**Acceptance:**
- [ ] Round-trip spring + cubic; unsupported configs keep typed encode failure.

### R4.6 — Variant expansion
- Add kinds: `orientation`, `directionality`, `platform`, `web`, and recursive
  `not` (generalizing today's not-widget-state special case) — all decode to
  existing core factories; encode recognizes factory-built variants (via the
  typed classes + stable keys pattern; if a factory lacks a typed class, follow
  the phase-0 precedent and add one in core, with CHANGELOG).
- `ContextVariantBuilder` and custom closure variants: `knownUnsupported`
  forever.
**Acceptance:**
- [ ] Per-kind round-trip; nested `not(not(x))` normalization decided + tested.
- [ ] Core asks (if any) are separate, minimal, CHANGELOG'd commits.

### R4.7 — Remaining field gaps (backlog-driven, decide per item)
Work the phase-2 backlog's残り: `foregroundDecoration`, `decoration.image`
(DecorationImageMix — needs the image value forms; may pull from phase 5's
resolver work), `fontFeatures`/`fontVariations`, `strutStyle`, `textScaler`
(linear factor only), icon `shadows`, image `centerSlice` (Rect), `locale`.
Each item ends `supported` or `knownUnsupported(reason)` — no unclassified
leftovers.
**Acceptance:**
- [ ] Backlog table in `plan/coverage-backlog.md` fully resolved; manifest
      matches; tests per added field.

### R4.8 — Per-family definition of done (applies to every family above)
- [ ] Codec + WIRE_CONTRACT.md section + JSON Schema golden + round-trip test +
      resolution-equivalence test + error-path test land **together** per
      family; the gate stays green after each family (no long-lived red).

## Non-goals (this phase)

Consumer changes (phase 5); representing closures/painters/Listenables (never);
unknown-field preservation (never); token math.

## Open decisions

**D4.1 — Directive `op` spellings vs existing text-directive vocab.** Existing
wire uses `uppercase`/`title_case`; core `Directive.key` may differ in casing.
Rule: wire spelling = existing vocabulary where one exists, else `Directive.key`
verbatim. Confirm against core's actual keys before freezing.
**Decision:** _(record)_

**D4.2 — `delay` optionality.** Make `delay` optional (default 0) to match
`onEnd`'s optionality and hand-authoring ergonomics — additive within v1 per the
phase-1 policy. Recommendation: yes.
**Decision:** _(record)_

**D4.3 — ack `flutter_codec` coordination.** Before growing `common_codecs.dart`
further, decide with the ack maintainers (same org) whether Flutter-primitive
codecs upstream into ack (`.context/ack-flutter-codec/` overlap) or stay here.
Affects R4.3–R4.7 implementation placement, not their wire shape.
**Decision:** _(record)_

## Verification / exit criteria

- Ratchet manifest: zero `deferred` entries remaining (only `supported` /
  `knownUnsupported(reason)`).
- Named regression tests green: merge-encode, fluent-transform-encode,
  token+directive composition, gradient fixture.
- Full gate green; goldens updated; WIRE_CONTRACT.md complete per family.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
