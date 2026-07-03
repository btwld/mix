# Phase 4 — Property grammar (`apply`/`$merge`) + coverage expansion

**Status:** Completed · **Depends on:** phase 1 (envelope), phase 2 + 2.5 (regenerated backlog), phase 3 (`$token` term) · **Blocks:** phase 5's gradient-bypass removal
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
- Directive table covers all 27 core directives (13 color, 5 string via existing
  text-directive vocab — reconcile spellings D4.1, 9 number).
**Acceptance:**
- [x] Per-directive round-trip (params preserved), incl. token+directive
      composition: `ColorRef.withAlpha()`-produced props encode and round-trip.
- [x] Unknown `op` → strict fail / lenient skip-with-warning (phase 1 modes).
- [x] Ratchet manifest: all `Directive` subclasses classified `supported`.

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
- [x] Named regression test: `BoxStyler().width(1).merge(BoxStyler().height(2))`
      encodes, round-trips, and resolves identically to the original under a
      context matrix (the review's headline sharp edge, green).
- [x] Merged-mix accumulation case (two partial paddings merged) round-trips
      with resolution equivalence.
- [x] Canonical rule tested: single-source props stay flat (no gratuitous
      `$merge`); `encode(decode(j)) == j` byte-stable goldens updated.
- [x] Schema export represents the term union without leaking internals.
- [x] Reserved control-marker collisions are tested: `$merge` and `apply` remain
      grammar-owned keys and cannot be redefined by field or extension payloads.

### R4.3 — Gradients (first coverage family — unblocks phase 5)
- `decoration.gradient` union under `"kind"`: `linear` / `radial` / `sweep`,
  mirroring `LinearGradientMix`/`RadialGradientMix`/`SweepGradientMix` fields;
  `GradientRotation` as the only supported `transform` (others fail encode).
- Remove `failIfPresent($gradient)` from the box decoration codec.
**Acceptance:**
- [x] Round-trip all three kinds + rotation; resolution equivalence vs
      hand-built Mix gradients.
- [x] tailwinds' gradient output (via its `applyGradient` path) is expressible:
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
- [x] Per-kind round-trip + resolution tests; fluent `.rotate()`/`.scale()`
      styler output becomes encodable (named test).
- [x] Ratchet manifest fully classified for modifiers; WIRE_CONTRACT.md +
      schema golden updated per kind.

### R4.5 — Animation expansion
- `spring`: `SpringAnimationConfig` (mass/stiffness/damping — pure data).
- Curves: keep the named table; add `{"cubic": [a,b,c,d]}` for `Cubic`.
- Decide `delay` optionality (D4.2 — review flagged required-`delay` ergonomics).
- `knownUnsupported` forever: `PhaseAnimationConfig`, `KeyframeAnimationConfig`
  (contain Listenables/closures), custom `Curve` subclasses, non-null `onEnd`
  without a registry/resolver story.
**Acceptance:**
- [x] Round-trip spring + cubic; unsupported configs keep typed encode failure.

### R4.6 — Variant expansion
- Add kinds: `orientation`, `directionality`, `platform`, `web`, and recursive
  `not` (generalizing today's not-widget-state special case) — all decode to
  existing core factories; encode recognizes factory-built variants (via the
  typed classes + stable keys pattern; if a factory lacks a typed class, follow
  the phase-0 precedent and add one in core, with CHANGELOG).
- `ContextVariantBuilder` and custom closure variants: `knownUnsupported`
  forever.
**Acceptance:**
- [x] Per-kind round-trip; nested `not(not(x))` normalization decided + tested.
- [x] Core asks (if any) are minimal, CHANGELOG'd, and included in the single
      phase commit unless Leo explicitly approves a split.

### R4.7 — Remaining field gaps (backlog-driven, decide per item)
Work the phase-2 backlog's remainder (as regenerated by phase 2.5):
`foregroundDecoration`, `decoration.image`
(DecorationImageMix — needs the image value forms; may pull from phase 5's
resolver work), `fontFeatures`/`fontVariations`, `strutStyle`, `textScaler`
(linear factor only), icon `shadows`, image `centerSlice` (Rect), `locale`.
Each item ends `supported` or `knownUnsupported(reason)` — no unclassified
leftovers.
**Acceptance:**
- [x] Backlog table in `plan/coverage-backlog.md` fully resolved; manifest
      matches; tests per added field.

### R4.8 — Per-family definition of done (applies to every family above)
- [x] Codec + WIRE_CONTRACT.md section + JSON Schema golden + round-trip test +
      resolution-equivalence test + error-path test land **together** per
      family; the gate stays green after each family (no long-lived red).
- [x] Nested Mix types added by the family gain the runtime skew guard
      (extending phase 2's styler-root guard) `[review X5]`.
- [x] New list-valued wire fields get an explicit lenient-removal granule and a
      test pinning it `[review X12]`.

## Non-goals (this phase)

Consumer changes (phase 5); representing closures/painters/Listenables (never);
unknown-field preservation (never); token math.

## Open decisions

**D4.1 — Directive `op` spellings vs existing text-directive vocab.** Existing
wire uses `uppercase`/`title_case`; core `Directive.key` may differ in casing.
Rule: wire spelling = existing vocabulary where one exists, else `Directive.key`
verbatim. Confirm against core's actual keys before freezing.
**Decision:** Use core `Directive.key` values verbatim for `apply[].op`. The
existing text-directive wire spellings already match core keys
(`uppercase`, `title_case`, etc.), so there is no parallel vocabulary. Directive
params are concrete JSON literals only in Phase 4; token refs inside directive
params are out of scope. `color_with_values.colorSpace`, when present, uses the
Flutter enum name.

**D4.2 — `delay` optionality.** Make `delay` optional (default 0) to match
`onEnd`'s optionality and hand-authoring ergonomics — additive within v1 per the
phase-1 policy. Recommendation: yes.
**Decision:** Make `delay` optional on decode with `Duration.zero` default,
matching core `CurveAnimationConfig`. Canonical encode continues to emit
`delay` so existing goldens stay explicit unless the animation family later
chooses compact canonical output deliberately.

**D4.3 — ack `flutter_codec` coordination.** The `btwld/ack` org has an
in-progress `flutter_codec` effort covering Flutter-primitive codecs (color,
alignment, edge insets, etc.) that overlaps `common_codecs.dart`. Before growing
that file further, check upstream ack for its current state and decide with the
maintainers (same org) whether these codecs should upstream into ack or stay
here. Affects R4.3–R4.7 implementation placement, not their wire shape.
**Decision:** Keep Flutter primitive codecs local to `mix_schema` for Phase 4.
Upstream Ack has stable `ack` 1.0.0 and a branch-only `flutter_codec` effort,
but it is not on main, uses raw Flutter-value shapes and `type` discriminators
where this phase specifies `kind`, and currently rejects the gradient transform
case Phase 4 requires. Treat upstream as a reference/test source, not a direct
dependency, unless maintainers explicitly request convergence during the phase.

## Verification / exit criteria

- Ratchet manifest: zero `deferred` entries remaining (only `supported` /
  `knownUnsupported(reason)`).
- Named regression tests green: merge-encode, fluent-transform-encode,
  token+directive composition, gradient fixture.
- Full gate green; goldens updated; WIRE_CONTRACT.md complete per family.
- Phase 4 closeout confirms every carry-forward lesson owned by Phase 4 in
  `plan/lessons.md` was either applied or explicitly deferred with a reason.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| 2026-07-02 | Phase-entry review adjustments applied before coding. | Corrected directive target to 27; property-term grammar and marker legality must land before coverage families; `$merge` and `apply` need explicit lenient-removal granules; newly touched nested Mix families need runtime skew guards per X5; Phase 3 token lessons remain opt-in by field; directive params remain concrete literals. |
| 2026-07-02 | D4.1: `apply[].op` uses core `Directive.key` verbatim. | Existing text-directive spellings match core keys; `ColorSpace` param uses enum name; no token refs inside directive params in Phase 4. |
| 2026-07-02 | D4.2: animation `delay` is optional on decode. | Missing `delay` means `Duration.zero`; canonical encode remains explicit for now. |
| 2026-07-02 | D4.3: keep Flutter primitive codecs local this phase. | Ack `flutter_codec` is branch-only and shape-incompatible with this contract today; use as reference only. |
| 2026-07-02 | Property grammar mirrors Prop terms. | `apply` is a directive list on any term; `$merge` encodes multi-source Props only; lenient mode now removes invalid `apply` / `$merge` entries rather than the whole parent field. |
| 2026-07-02 | Coverage triage split implemented. | Data-only gaps (`foregroundDecoration`, text strut/scaler/locale/style fields, icon shadows, image `centerSlice`) are supported; image decorations, advanced shape/directional border families, and `ElevationShadow` are explicit v1 unsupported entries. |
| 2026-07-02 | Modifier order and expanded modifier families use data-only wire forms. | Custom modifier order encodes as `{ "order": [...], "items": [...] }`; unsupported modifier internals (`clipper`, `physics`, order entries without a wire kind) fail encode loudly. |
| 2026-07-02 | Runtime skew guards extended to nested Phase 4 Mix values. | `BoxDecorationMix`, gradient variants, `WidgetModifierConfig`, and supported modifier mixes compare schema-owned field inventories against core `props.length`; tests pin both success and count-skew failure. |
| 2026-07-03 | Variant negation preserves explicit nesting. | General `context_not` handles expanded context variants; existing widget-state negation keeps its specialized canonical forms; `not(not(x))` is represented explicitly rather than normalized away. |
| 2026-07-03 | Token-aware encode remains field-owned. | R4.8 uncovered shadow-list token refs falling through to literal encode; canonical token validation now runs before runtime refs are created, and shadow-list codecs encode token refs before literal items. |
| 2026-07-03 | Closeout review fixed nested property-term coverage. | Nested `TextStyleMix`, `StrutStyleMix`, and `BoxDecorationMix.boxShadow` fields now decode/encode the same `apply` / `$merge` grammar as root styler fields, and schema export references property-control terms on representative nested fields. |
| 2026-07-03 | Gradient codecs are discriminated by `kind`. | Strict decode rejects fields from another gradient kind; lenient mode removes only the incompatible nested field and preserves the rest of the gradient. |
| 2026-07-03 | Lenient repair uses the smallest recoverable granule. | Unknown nested map keys and invalid `modifiers.order` entries are removed without dropping the containing style field. |
| 2026-07-03 | JSON Schema export constrains marker grammar, not all runtime semantics. | Shared property-term definitions validate `$token`, `$merge`, and `apply` marker shapes at field boundaries; runtime codecs remain authoritative for field-specific Flutter/Mix literals. |
| 2026-07-03 | Phase 4 verified and closed. | After closeout fixes, `melos run gen:build`, `melos run ci`, and `melos run analyze` all reported `SUCCESS`; the only repeated noise was the known pub-cache kernel-format warning. |
