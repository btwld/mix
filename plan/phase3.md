# Phase 3 — Token model (`$token` grammar + theme document)

**Status:** Not started · **Depends on:** phase 1 (envelope/modes), phase 2 recommended (classification), phase 2.5 (review fixes) · **Blocks:** the token-sharing target; parts of phase 4 (token-backed breakpoints)
**Scope:** wire grammar for token references, a theme/token-definition document,
preflight tooling, and the end-to-end inheritance demo.

## Objective

Styles as data can say "use token X here"; tokens are defined in a separate
theme document; resolution stays 100% client-side via `MixScope` inheritance —
the codec transports references, core resolves them. This is the calibrated
token target: define tokens once, styles just inherit.

## Context

`[review B1]` Today the gap is bidirectional: encode hard-fails on any
`TokenSource`-backed Prop (`readProp`, `common_codecs.dart:325-355`), and no
wire form exists to *express* a token reference on decode. Mix core is already
able: `Prop.token()` is public, 11 typed token classes exist
(`value_tokens.dart`), `MixScope` exposes kind-grouped token maps, and token
refs compose with directives at runtime (`ColorRef.withAlpha` → directive).
The branch precedent for core cooperation exists (typed variant classes were
added to core precisely to make variants encodable).

Phase 2.5's D2.5.1 decides whether hiding `AckSchema` behind mix_schema-owned
extension types happens as this phase's *first* task (before the token grammar
grows the Ack-typed surface) — apply its recorded outcome at phase entry
`[review X11]`.

## Requirements

### R3.1 — Token reference wire form (decode)
- Grammar: `{"$token": "<name>"}` accepted in any token-capable field position;
  `$token` is a reserved marker (with `$merge` reserved for phase 4 — reject any
  other `$`-prefixed key now with a clear error).
- Field's static type selects the canonical core token class:
  `Color→ColorToken`, `Radius→RadiusToken`, `TextStyle→TextStyleToken`,
  `FontWeight→FontWeightToken`, `BorderSide→BorderSideToken`,
  `List<Shadow>→ShadowToken`, `List<BoxShadow>→BoxShadowToken`,
  `Duration→DurationToken`, `Breakpoint→BreakpointToken`.
- The `double` ambiguity (`SpaceToken` vs `DoubleToken` — `MixToken` equality
  includes runtimeType, so class matters for `MixScope` lookup): double-valued
  references carry optional `"kind": "space" | "double"`, default `"space"`.
- Decode produces `Prop.token(<CanonicalToken>(name))` — nothing resolved at
  decode time; unknown-token failure stays core's runtime `StateError`.
**Acceptance:**
- [ ] Decode tests per token kind (all 11), incl. double `kind` defaulting and
      explicit `"kind": "double"`.
- [ ] Token name validation rule decided (D3.1) and enforced with a typed error.
- [ ] Unknown `$`-marker rejected with a clear code/message.
- [ ] Reserved control-marker collisions are tested: token terms cannot smuggle
      unrelated `$` keys, and custom extension points cannot redefine `$token`.

### R3.2 — Token reference encode
- A single-source `TokenSource`-backed Prop encodes to `{"$token": name}`
  (plus `"kind"` for double tokens, always written, derived from the runtime
  class). This *removes* the token clause from the encode-policy exclusion list.
- Custom `MixToken` subclasses (app-defined classes) fail encode explicitly —
  Dart identities the format cannot name.
**Acceptance:**
- [ ] Round-trip per kind: styler built with `Prop.token` → encode → decode →
      equal token class + name (and resolution-equivalent under a fixture
      `MixScope`).
- [ ] Custom token subclass → typed encode failure with path.
- [ ] WIRE_CONTRACT.md encode-policy section updated (tokens no longer listed
      as failing).

### R3.3 — Theme document
- New top-level document: `{"v": 1, "type": "theme", ...}` with kind-grouped
  maps mirroring `MixScope`'s constructor parameters: `colors`, `spaces`,
  `doubles`, `radii`, `textStyles`, `shadows`, `boxShadows`, `borders`,
  `fontWeights`, `breakpoints`, `durations`.
- Values reuse the exact same value codecs as style documents (one codec
  inventory — no theme-only grammar).
- Same-kind aliases allowed: a theme value may be `{"$token": otherName}`,
  resolved **eagerly at decode time** with cycle detection (aliases are a
  document feature; `MixScope` receives a flat concrete map).
- Decode result exposes `Map<MixToken, Object>` ready for `MixScope(tokens:)`;
  no widget wrapper shipped (that's one line of core).
- Theme documents encode back (for tooling round-trips).
**Acceptance:**
- [ ] Decode/encode round-trip for a full multi-kind theme fixture.
- [ ] Alias chain resolves; alias cycle → typed error with the cycle path;
      cross-kind alias → typed error.
- [ ] Registered under the root contract's `type` union (or a parallel entry
      point — D3.2) and reflected in the JSON Schema export golden.

### R3.4 — Preflight walker
- Public `tokenReferencesOf(style)`: walks a decoded styler via public
  `Prop.sources` (incl. variants' nested styles, modifiers, animation) and
  returns every `(kind, name)` reference — so CI/servers can diff style docs
  against theme docs *before* shipping, instead of crashing a client at
  first frame.
**Acceptance:**
- [ ] Completeness test: every `$token` in a fixture document appears in the
      walk (incl. deeply nested in variants).
- [ ] A doc'd example: diffing a style doc's references against a theme doc.

### R3.5 — Token-backed breakpoint variants
- `ContextVariant.mobile()/tablet()/desktop()` (BreakpointRef-backed) become
  encodable: `{"kind": "context_breakpoint", "token": "<name>"}` alongside the
  existing inline min/max form. (Closes the `[review B4]` variant gap that hits
  idiomatic responsive code.)
**Acceptance:**
- [ ] Round-trip both forms; encode of a `BreakpointRef`-backed variant emits
      the token form (currently an `UnsupportedEncodeValueError`,
      `variant_codec.dart:154-162`).

### R3.6 — End-to-end inheritance demo (the calibrated story)
- A test (and optionally a runnable example) proving the full loop: theme
  document + style documents with `$token` refs → decode both → mount
  `MixScope(tokens:)` → widgets resolve; swapping the theme document (e.g.
  dark theme) restyles without touching the style documents; nested
  `MixScope.inherit` scopes override tokens for a subtree.
**Acceptance:**
- [ ] Widget test pinning: token swap changes resolved values; subtree scope
      overrides; unknown token surfaces core's loud `StateError` in dev.

## Non-goals (this phase)

Token math beyond core directives (no `calc()`); per-brightness token dimensions
inside one theme document (apps swap documents or nest scopes — core's job);
directive `apply` on token refs (phase 4, grammar); cross-document `$ref`
(tree-layer concept, permanently out of the style format).

## Open decisions

**D3.1 — Token name grammar.** Free string vs constrained pattern (like
registry ids). Recommendation: constrain (`[A-Za-z0-9_.-]{1,128}` — dots for
namespacing like `color.text.primary`), validated at decode.
**Decision:** _(record)_

**D3.2 — Theme document entry point.** Same root contract (`type: "theme"` as a
9th branch) vs a dedicated `ThemeCodec`-style entry. Recommendation: dedicated
entry point — a theme is not a styler; keeping the styler union pure keeps
`decode<T extends Style>` honest.
**Decision:** _(record)_

**D3.3 — Canonical-class interop rule.** Data-referenced tokens must be
registered under canonical classes; Dart-side scopes wanting `SpaceToken`
ergonomics register the same value under both. Document as a rule + preflight
check, or add a core helper? Recommendation: document + preflight; no core ask.
**Decision:** _(record)_

## Verification / exit criteria

- Full gate green; JSON Schema golden updated (token forms + theme document).
- WIRE_CONTRACT.md: "Token references" + "Theme document" sections match tests.
- R3.6 demo test green — this is the phase's definition of done.
- Inventory manifest (phase 2) updated: token constructs move to `supported`.
- Phase 3 closeout confirms every carry-forward lesson owned by Phase 3 in
  `plan/lessons.md` was either applied or explicitly deferred with a reason.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
