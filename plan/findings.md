# mix_schema Clean-Sheet Review — Findings Snapshot

Snapshot of the review that produced this plan, committed here so the plan is
self-contained (the original working session used a gitignored `.context/`
scratch file that isn't available outside that session). This is the source of
truth for every `[review Xn]` tag in `plan/phase*.md`. Finding IDs are stable —
don't renumber.

**Date:** 2026-07-02 · **Branch reviewed:** `feat/mix_schema` · **Mode:** combined
(implementation + tests + consumer lessons) · **Method:** clean-sheet-review —
3 exploration agents + baseline verification + 4 evidence probes + 1 isolated
clean-sheet designer (firewalled from the current implementation) + synthesis.

**Baseline verified green before judging:** mix_schema 163/163 tests, mix_tailwinds
477/477, mix scoped (variants + default_text_style_modifier) 199/199, mix_generator
257/257; `dart analyze` + DCM clean workspace-wide.

**Calibrated targets:** (1) anchor — preset packages like mix_tailwinds; (2) design
target — server-driven styling (styles as validated JSON over the wire/storage,
with a versioning/evolution policy); (3) design target — shared tokens, defined
separately (theme/token document), referenced on the wire, resolved client-side
via MixScope inheritance; (4) extensibility check — a future full Mix widget-tree
document layer should compose on top without rework.

---

## Verdict

**Redesign — at the contract level, not the code level. Keep the skeleton,
replace the policies.**

An isolated clean-sheet designer (given only the neutral problem brief + Mix
core, firewalled from ever seeing `mix_schema` or the tailwinds translate layer)
independently converged on the same architecture already built: a JSON document
discriminated by styler type, codecs that decode into *real* Mix stylers (no DTO
layer), fail-explicit encode, canonical wire forms, strict validation of
untrusted input, zero changes to `packages/mix`. Code quality, test discipline,
and spec-doc accuracy are all high and verified.

Four contract-level policies are each incompatible with the calibrated targets,
and they define the library's fitness more than the code does:
- **No token vocabulary** (bidirectional — token-backed props fail encode, and no
  wire form can express a token reference at all).
- **No wire versioning or evolution policy** (any additive schema change hard-
  breaks every older decoder, with no version-skew signal).
- **Single-source-only encode** (idiomatic Mix composition — `.merge()`, even
  `.width(1).merge(.height(2))` — fails encode).
- **A registry frozen into the contract** (the documented `builtInMixSchemaContract`
  singleton can never decode or encode any icon/image payload — confirmed by
  live probe).

Plus: the reference consumer's runtime build-payload→decode pattern should be
retired to test-time.

Most of the code survives. The contract grows up.

---

## Problem reframed (neutral brief)

Mix styles exist only as Dart code at compile time. They need to exist as
*data*: (R1) ecosystem packages that generate Mix styles from another
vocabulary (Tailwind-like utilities first) need a stable, verifiable definition
of "what Mix can express as data," with explicit failure modes; (R2) apps need
server-driven styling — untrusted JSON validated and instantiated as live Mix
styles, with a deliberate evolution story; (R3) design tokens must be definable
separately (theme document), referenced by name from style data, and resolved
client-side through MixScope inheritance; (R4) a future widget-tree document
layer must compose on top without rework; (R5) encode must fail explicitly on
unrepresentable runtime values, never drop silently. Hard constraints: `mix` is
a published stable package (serialization-free, near-frozen); identity values
(IconData, ImageProvider, callbacks) require indirection; closures are not data.

Classification note: "Ack as engine," "decode into real stylers," "payload as
tailwinds' runtime IR," and "single-source encode policy" are all *design
choices*, not requirements. "Mix core public API" is the only external
commitment.

---

## What the current approach gets right (preserve all of this)

1. **Decode target = real Mix stylers, no intermediate representation.** The
   clean-sheet designer independently chose the same thing: stylers already are
   a validated, immutable IR with public `.create()`/`$`-field access.
2. **Fail-loud encode policy, structurally enforced** — `readProp`/
   `failIfPresent`/`UnsupportedSchemaField` funnel every field through the same
   guards; no silent drops anywhere (verified).
3. **Canonical wire forms, verified beyond the existing tests** — alternative
   decode inputs (`rgb()` colors, `{x,y}` center alignment, 4-key uniform edge
   insets, 4-corner uniform radius) all re-encode to the single canonical form
   (dynamic probes, all passed).
4. **Error quality** — multi-error aggregation with JSON-Pointer paths that stay
   precise through recursive `Ack.lazy` variant nesting
   (`#/variants/0/style/decoration/color`). Verified excellent.
5. **Single-owner wire vocabulary** (`primitive_wire.dart`) shared by codec and
   producer paths — drift prevented by construction, plus characterization
   tests.
6. **`WIRE_CONTRACT.md` discipline** — every spot-checked assertion (5/5)
   matches code.
7. **Freeze-once lifecycle with defensive `StateError`s**, tested including the
   retained-builder-reference aliasing case.
8. **Test methodology** — round-trip identity + byte-identical canonical
   re-encode per branch, golden JSON Schema export with per-branch property
   sets and ack-internals leak check, contract handshake tests in the consumer.
9. **Modern Dart surface** — `final`/`sealed` throughout, exhaustive-switch
   results, zero lint ignores, DCM-clean.
10. **Core cooperation done right** — the branch made `BrightnessVariant`/
    `BreakpointVariant`/`NotVariant` typed value objects in core so variants
    could be encoded without key parsing. Correct pattern, precedent for the
    token work.
11. **The consumer proves the concept** — tailwinds' parse→translate→schema
    pipeline with layering enforced by tests (parser purity, wire-literal
    guard) and visual parity against real Tailwind (0.89–4.86% pixel diff).

---

## Issues found

### A. Correctness defects (confirmed, as-built vs its own stated contract)

| ID | Finding | Evidence |
|----|---------|----------|
| **A1** | **`builtInMixSchemaContract` cannot decode or encode any icon/image payload.** Its registry freezes empty; there is no post-freeze injection; docs recommend this singleton to producers. Live probe: `unknown_registry_id` on decode, `MixSchemaEncodeFailure` on encode, 100% reproducible. No test in the repo round-trips icon/image through the singleton — every icon test builds a private contract, which is why this was invisible. Tailwinds avoids the registry entirely (`TwIcon` wraps Flutter `Icon` directly). | dynamic probe; `encode.dart:11-17`; `icon_styler_codec.dart:22-26` |
| **A2** | **`MixSchemaContractBuilder().freeze()` with zero branches throws a raw Ack `ArgumentError`** ("Invalid argument (schemas): must not be empty"), not a mix_schema domain error. | dynamic probe stack trace; `mix_schema_contract.dart:113` |
| **A3** | **Explicit `null` is rejected on every optional field except `constraints.maxWidth/maxHeight`** (which *require* null to mean infinity). `{"padding": null}` hard-fails. Inconsistent null semantics are a served-JSON footgun and the general prohibition is undocumented. | dynamic probe; `common_codecs.dart:242,244` |
| **A4** | **`mixSchemaVersion` (`'0.0.1'`) hand-duplicates `pubspec.yaml` version with no test tying them**; stamped only into `exportJsonSchema()`, never into payloads. | `mix_schema_contract.dart:17,188` |
| **A5** | **`packages/mix` CHANGELOG has no entry** for the new public `BrightnessVariant`/`BreakpointVariant`/`NotVariant` classes and the equality-semantics change to three `ContextVariant` factories — on a published stable package. | branch-hygiene pass |
| **A6** | **Payload resource limits were removed** (`mix_schema_limits.dart` deleted in commit `9239a75e8`) with no replacement depth/size caps on the untrusted-input path. *(Unverified whether ack imposes its own caps — flagged, not probe-confirmed.)* | commit `9239a75e8` |
| **A7** | **Zero doc comments** on the entire consumer-facing surface (`mix_schema_contract.dart`, `mix_schema_error.dart`, `registry.dart` — all `grep -c '^///'` = 0), while `encode.dart` is well documented. | API/hygiene pass |

### B. Contract-fitness gaps vs the calibrated targets (design, evidence-backed)

| ID | Gap | Who hits it |
|----|-----|-------------|
| **B1** | **Tokens: zero vocabulary, bidirectional.** `readProp` rejects `TokenSource` on encode; no wire form exists to *express* a token reference on decode. Mix core is ready (public `TokenSource`, 11 typed token classes, MixScope maps). | Token target — by definition. Also any preset package built on a token-based design system. |
| **B2** | **No wire versioning/evolution policy.** Payloads carry no version; unknown fields are rejected at every nesting level (verified at 4 depths); therefore **every additive schema change is a hard breaking change for all older decoders**, and the failure looks like a generic validation error with no skew signal. | Server-driven — fatal as-is. |
| **B3** | **Single-source encode policy vs Mix's merge model.** `Prop.mergeProp` always accumulates sources (verified in core), so any `.merge()`-composed style — including `.width(1).merge(.height(2))`, where both route through the shared `constraints` field — fails encode. Encode-ability depends on construction history, not on the value. In practice `encode()` means "re-serialize what you decoded," not "serialize Mix styles." | Server-driven encode-side; any preset package composing from fragments. |
| **B4** | **Coverage is a tailwinds-shaped slice:** modifiers 4/28 (and `.rotate()`/`.scale()` route through modifiers, so fluent transforms are unencodable); gradients + `foregroundDecoration` + `decoration.image` missing (forcing tailwinds' sanctioned bypass); animation = named-curve only (no spring — pure data in core — no `Cubic`, no phase/keyframe); directives 5/19, text-only, and directives-on-Prop blocked entirely (so `ColorRef.withAlpha()` composition is invisible to the wire); variants missing the idiomatic token-backed breakpoints (`ContextVariant.mobile()/tablet()/desktop()` fail encode) plus orientation/platform/web/directionality; `fontFeatures`/`fontVariations`/`strutStyle`/icon `shadows`/image `centerSlice` absent. | All targets, at different speeds. |
| **B5** | **Registry-in-contract shape** is wrong even beyond A1: identity resolution is app-scoped and call-scoped by nature (which icons exist is an app decision at decode time), not a property of a frozen schema. | Anyone styling icons/images from data. |
| **B6** | **`delay` required on animation payloads** (while `onEnd` is optional) — documented but hostile ergonomics for hand-authored payloads. | Server-driven authors. |

### C. API-shape and hygiene (objective first, preferences flagged)

| ID | Finding | Kind |
|----|---------|------|
| **C1** | Entry-point split is miswired: `SchemaStyler`/`SchemaModifier`/`SchemaVariant` (contract vocabulary) and `builtInMixSchemaContract` (consumer decode entry) live in producer-only `encode.dart`; a decode-only consumer importing `mix_schema.dart` can't even enumerate valid `type` values. | objective |
| **C2** | ack leaks into the extension API: `addStyler` takes `AckSchema<JsonMap, T>`, `rootSchema` is public, `JsonMap` re-exported. Pure consumers (decode/validate/encode/export) are insulated; extenders are locked to ack. | objective, asymmetric |
| **C3** | Producer helpers are a subset-of-contract grown ad hoc — `payloadTextStyle` covers 6 of 14 spec'd textStyle fields; `payloadBorderSide` lacks `strokeAlign`; tailwinds hand-builds edge maps despite `payloadEdgeInsets` existing. Second producers hit missing helpers immediately. | objective |
| **C4** | Two codec idioms for one job: styler roots use `SchemaField`/`SchemaObject`; nested Mix types (border, shadow, constraints…) hand-write decode/encode maps. | preference: consolidate when touched |
| **C5** | Test-helper duplication — the same result-unwrap switch in 13 files / 25 occurrences; no shared helper. | preference |
| **C6** | Packaging debt: git-SHA-pinned `ack` (a stable `ack 1.0.0` exists on pub.dev — the pin is stale, and pub.dev rejects git deps at publish time); excluded from publish + changelog workflows; `mix_schema`/`mix_tailwinds` lack the DCM dev-dep the core packages have; committed `melos_mix_schema.iml`; **branch is behind origin/main** (main at mix 2.1.0; branch at 2.0.3) — merge before landing. | objective |
| **C7** | `WIRE_CONTRACT.md` references `context_all_of` as excluded, but no such core type exists — stale prose. Unused `'card'` keys in tailwinds' generated theme. | nits |
| **C8** | In tailwinds: `payloadBox/Flex/Text` duplicate the translate path and are test-only (prior code-level review's deferred item **S6**); `tw_flex_item.dart` constructs a `FlexibleModifierMix` via full JSON encode→decode instead of calling its public constructor — a backwards widget→schema dependency on a hot path (prior review's deferred **S4**; re-confirmed independently here). | objective |

---

## Clean-sheet proposal (independent design, then adjudicated)

The firewalled designer produced "`mix_codec`": same skeleton, different
policies. Load-bearing deltas:

1. **Property grammar mirrors `Prop`'s real model.** A field value is
   `Literal | {"$token": name, "kind"?, "apply"?: [directive…]} | {"$merge": [term…], "apply"?}`
   — sources + directives, exactly what a `Prop` is. Tokens, directive
   composition, and multi-source merge stacks all become representable; the
   single-source restriction disappears. `$merge` is encoder-emitted only;
   producers rarely write it. Only two reserved markers in the whole format.
2. **Theme document** (`"type": "theme"`) with kind-grouped token maps reusing
   the same value codecs, same-kind aliases with cycle detection, decoding to
   `Map<MixToken, Object>` fed straight into `MixScope(tokens:)` — plus a
   `tokenReferencesOf(style)` preflight walker so CI/servers can diff style
   docs against theme docs before shipping.
3. **Versioned envelope + explicit evolution policy:** required integer `"v"`;
   strict mode (default, fail-closed for untrusted input) vs lenient mode
   (explicit opt-in: unknown key/kind/enum skips the smallest enclosing
   property with a path-qualified warning — the old-client/new-data story);
   additive-change rules within a version; `unsupportedVersion` as a
   first-class error.
4. **Identity via per-call resolvers, not a frozen registry:**
   `DecodeOptions.resolveIcon` / `EncodeOptions.iconNames`, plus value forms —
   `{"codePoint": …}` raw icons, `{"url": …}`/`{"asset": …}` images — making
   common cases registry-free entirely.
5. **Coverage = "everything in core that is data"**: ~27 modifier kinds, all 3
   gradients, spring + cubic animation, full variant union
   (orientation/platform/web/directionality/not), 19 directives as
   `{"op": Directive.key}` objects, decorations/shape-borders as `kind`
   unions. Non-goals stay non-goals: closures, painters, phase/keyframe,
   shader masks fail encode permanently.
6. **Drift ratchet instead of hoping:** a CI analyzer script enumerates every
   `Prop` field / `Directive.key` / variant / animation / modifier in core and
   requires each to appear in exactly one bucket — `supported` or
   `knownUnsupported(reason)`. New core construct → CI diff → human decision.
   Plus a runtime exhaustiveness assert on encode so version skew throws
   instead of dropping. **This is the structural answer to "how does the
   schema track core."**
7. **No JSON-builder producer API.** Producers build stylers with plain Mix
   and call `encode()` when they need data; the designer explicitly rejected a
   payload-helper surface as "a second way to construct documents, immediately
   divergent." (Independent corroboration of the `payloadX`/`encode.dart`
   concerns in C3/C8.)
8. Result-based decode that never throws and collects *all* issues (with
   severity + DoS caps); throw-based encode with path-qualified exceptions.

**Where the lead adjudicated against the designer:**

- **Keep ack.** The designer hand-rolls a table-driven validator — not worth
  the trade today. The ack layer exists, is green, its error quality is
  *verified* excellent, JSON Schema export is nearly free, and it's the same
  maintainer (btwld) with a stable 1.0.0 on pub.dev. Swap the git pin for
  `^1.0.0`, hide `AckSchema` behind a mix_schema-owned type in the extension
  API (C2), revisit engine ownership only if ack blocks the property grammar.
- **Keep the existing wire spellings** (`w100`, `scrolled_under`,
  `line_through`). The designer's "wire names = Dart names" rule is cleaner
  but re-spelling a working vocabulary is churn without user value; adopt the
  principle for *new* vocabulary only.
- **Adopt everything else**: property grammar, theme document, versioned
  envelope + strict/lenient, resolvers + value forms, coverage-by-inventory,
  drift ratchet, producer story, restored input limits.

---

## Current-to-proposed comparison

| Element | Action |
|---|---|
| Decode-to-real-stylers, discriminated `type` union, contract freeze lifecycle | **Keep** |
| Ack engine + error mapper + sealed results | **Keep** (pin → `^1.0.0`; hide `AckSchema` from public extension signatures) |
| Canonical forms, golden/round-trip/characterization tests, WIRE_CONTRACT.md practice | **Keep** (extend) |
| Core typed-variant change, DefaultTextStyle.merge fix, generator DRY | **Keep** (add CHANGELOG entry) |
| Field grammar (single-source literals only) | **Change** → `Literal | $token | $merge` + `apply` (mirrors Prop) |
| Envelope (no version) | **Change** → required `v`, strict/lenient modes, documented evolution rules |
| Null policy (inconsistent) | **Change** → uniform: absent-only, null forbidden (keep the constraints exception or move infinity to `"infinity"` string) |
| Registry (frozen-in-contract) | **Remove** → per-call resolvers + `codePoint`/`url`/`asset` value forms |
| `encode.dart` payload-helper public API + `SchemaStyler/Modifier/Variant` placement | **Remove/relocate** → vocabulary + singleton move to the contract surface; helpers become test utilities (or die with the tailwinds realignment) |
| Tailwinds runtime build-payload→decode (incl. `tw_flex_item` round-trip, `payloadX` dual API) | **Remove** → build stylers directly; enforce the contract in tests (encode fixtures → validate) |
| Coverage: modifiers/gradients/animation/variants/text-fields | **Add** (inventory-driven, staged) |
| Token model + theme document + preflight walker | **Add** |
| Drift ratchet (analyzer inventory check) + encode exhaustiveness assert | **Add** (build first — it generates the coverage backlog) |
| Input limits (depth/node caps) | **Add** (restore) |
| Widget-tree document layer | **Defer** (separate package; current per-node style shape composes under it) |
| `validate()` duplicating decode (prior review **S7**), `valueField`/`mixField` near-dup, test-helper dedup, `.iml`, `'card'` theme keys | **Remove/fold** when touched |

---

## Migration path (smallest reversible steps) → executed as `plan/phase0.md`–`phase5.md`

Phase 0 lands the branch honestly (A1, A2, A5, C6 sync, doc comments). Phase 1
is the format v1 charter (B2 versioning, A3 null policy, input limits). Phase 2
builds the drift ratchet (structural answer above) before any coverage work.
Phase 3 is the token model (B1). Phase 4 is the property grammar (B3) plus
inventory-driven coverage expansion (B4). Phase 5 realigns the consumer (B5
registry removal, C1/C2/C3 API reshaping, C8 tailwinds cleanup) and revisits
publishing (C6). Full detail, acceptance criteria, and open decisions live in
the phase docs themselves — this snapshot is the "why," not the "how."

---

## Premortem (recommended path)

1. **Grammar complexity leaks to producers/LLMs** (`$merge` misuse). Signal:
   fixture/fuzz friction. Mitigation: encoder-only `$merge`; schema export
   marks it internal; lint-level warning in validate.
2. **ack evolution breaks the wrapped layer.** Signal: `^1.0.0` CI failure.
   Mitigation: extension API already hidden behind owned types (phase 0); same-
   org upstream conversation (their `flutter_codec` branch overlaps
   `common_codecs.dart` — coordinate instead of duplicating).
3. **Token class ambiguity** (`SpaceToken` vs `DoubleToken` — `MixToken`
   equality includes runtimeType). Signal: core `StateError` on first frame in
   dev. Mitigation: `kind` on double token refs; canonical-class rule;
   preflight diff in CI.
4. **Ratchet never gets built → coverage stalls at "what tailwinds needed"
   again.** Signal: next core field ships with no schema counterpart.
   Mitigation: phase 2 ordered *before* coverage expansion, deliberately.
5. **Tailwinds keeps the runtime round-trip and its cost/bypasses compound.**
   Signal: widget-build profiling; each new unrepresentable feature needing
   another `applyGradient`-style callback. Mitigation: phase 5 decision forced
   by an explicit benchmark, not deferred by default.

---

## Reconciliation with the prior code-level review

A separate, earlier code-review session (not this clean-sheet review) judged
`mix_schema`/`mix_tailwinds` at the code-quality level and concluded the
architecture was "sound, not over-layered; findings are localized polish." This
review confirms those code-level conclusions — no conflict, different
altitude: that session didn't evaluate scope/policy against server-driven/token
targets (calibrated only for this review). Its deferred findings map into this
plan: **S4** (flex-item round-trip) and **S6** (payloadX test-only duplication)
are promoted to phase 5 actions (tagged C8); **S7** (validate duplicates
decode) folds into phase 1. Remaining deferred items (S1/S3/S5/S8 and a
dead-code cleanup batch) stay opportunistic — fold in whenever the owning file
is touched by a phase above.

## Branch verdict beyond mix_schema

The non-schema changes on the branch are sound: core variant typed-classes
(necessary for encode; additive; needs CHANGELOG — A5), `DefaultTextStyle.merge`
fix (genuine core bug, well tested), generator/lint DRY consolidation
(behavior-preserving, covered), melos `--no-select` (correct for CI), tailwinds
restructure (monolith fully migrated, no orphans, characterization + visual-
parity oracles are exemplary). Loose ends: A5 CHANGELOG, stale-vs-main (C6),
unused `'card'` theme keys (C7), DCM dev-dep absent in the two new packages
(C6).

## Assumptions & open questions (carried into phase docs as D-items where actionable)

- Publishing intent/timing for mix_schema affects whether phase 1 moves first.
- Upstream `ack flutter_codec` — duplicate or coordinate? Recommend
  coordinating before phase 4 grows `common_codecs.dart` further.
- Tailwinds runtime decode cost is unmeasured — phase 5 starts with a
  benchmark (R5.1).
- Whether ack imposes its own depth/size limits on parse (A6) — check before
  building phase 1's limits from scratch.

## Baseline verification (evidence the review stands on)

`fvm flutter test`: mix_schema 163 passed (18 files), mix_tailwinds 477 passed,
mix scoped (variants + default_text_style_modifier) 199 passed; `dart test`
mix_generator 257 passed. `melos run analyze` (dart + DCM): zero issues across
all 7 packages. Dynamic correctness probes ran in a throwaway `/tmp` package
against the real path deps; repo tree verified untouched at session end.

---

## Addendum — cross-phase review after phase 2 (2026-07-02)

Review of commits `933bcfd7d..b785f0cc1` (phases 1–2 + process docs) against this
snapshot and the phase docs. Method: one delegated reviewer per feature commit +
lead verification. Fresh evidence: mix_schema **195/195** tests, `melos run
schema:inventory` green (379 ids at HEAD), PR-CI wiring traced into
`btwld/dart-actions` `ci.yml@main` (the `melos-commands` input exists and runs
`melos run analyze` before tests on every PR). **Verdict: on plan, architecture
sound.** The items below are owned by [`phase2.5.md`](phase2.5.md); IDs `X*` are
stable — don't renumber.

| ID | Finding | Evidence |
|----|---------|----------|
| **X1** | Inventory discovery uses name-suffix + direct-superclass matching; only directives get a transitive inheritance closure. Confirmed miss: public `IdentityStyle` (`packages/mix/lib/src/core/style.dart:205`) has no inventory id and no manifest entry — the ratchet never forced a decision. Any future second-level subclass of a tracked base (e.g. `X extends WidgetStateVariant`) is silently invisible: the exact drift the tool exists to catch. | `tool/inventory_check.dart:307-327` |
| **X2** | Manifest entries contradict plan intent: `TextStyleMix.$fontFeatures`/`$fontVariations` classified `never: runtime-only` though `FontFeature(String, [int])`/`FontVariation(String, double)` are const data and B4 + phase 4 R4.7 name them as gaps; `WidgetModifierConfig.$orderOfModifiers` classified `never` while R4.4 plans `modifierOrder` support. All three silently vanish from phase 4's generated backlog. | `schema_inventory_manifest.dart:836,840`; backlog `Never` group; `phase4.md` R4.4/R4.7 |
| **X3** | Lenient-mode warnings carry paths into the *partially-cleaned* document (after a list removal, the next warning's index refers to the shifted list), while `WIRE_CONTRACT.md:64` promises the original path. The test masks it by asserting only `endsWith('/kind')`. | `mix_schema_contract.dart:342-350`; `format_v1_contract_test.dart:238-241` |
| **X4** | `WIRE_CONTRACT.md` documents error code `unsupported_value`; the real public code is `unsupported_encode_value`. A consumer switching on the documented string never matches. | `WIRE_CONTRACT.md:294` vs `mix_schema_error.dart:30` |
| **X5** | The runtime skew guard covers only the 8 styler roots; nested Mix types (`BoxDecorationMix`, `TextStyleMix`, …) have no guard, so a consumer on a newer `mix` can silently drop a nested field. Also: unknown-future-field detection is count-based (`props.length`), so a simultaneous add+remove (net-zero) is invisible — nowhere documented. The name-level check is sound (two independent declaration sources, not tautological), but `inventoryName` labels are unverified against what the `read` closure actually reads. | `schema_field.dart:165-192`; `styler_field_inventory.dart:119` |
| **X6** | Lenient decode worst case is quadratic: up to 10,000 full reparse passes (one granule removed per pass) with no removal cap below the node cap. Bounded and opt-in, but a DoS lever if lenient is used on hostile input. | `mix_schema_contract.dart:321` |
| **X7** | The tool's Flutter-enum allowlist *silently skips* unknown enum-like field types — contradicting phase 2's own lesson "AST ratchets should fail on unclassifiable source, not skip it". | `tool/inventory_check.dart:401-409,474-503` |
| **X8** | Envelope diagnostics: `{"v": null}` fails as `null_forbidden` though the spec says malformed `v` → `unsupported_version` (version-skew telemetry misses null-`v` docs); and `validate()` failures drop the missing-`v` transition warning that `decode()` carries. | `mix_schema_contract.dart:439,445`; `WIRE_CONTRACT.md:36`; `mix_schema_error.dart:119-125` |
| **X9** | Backlog provenance stamps `git rev-parse HEAD` even when the worktree is dirty (misreports the source revision); the reusable CI workflow is consumed unpinned (`@main`) so the ratchet's PR guarantee can drift with someone else's default branch. | `tool/inventory_check.dart:534-542`; `.github/workflows/test.yml:42` |
| **X10** | Test gaps: exact limit boundaries (depth 64 vs 65; 10,000 vs 10,001 nodes); `v: 1.0`/`v: true`; lenient warning indices across multiple list removals; composite-styler (FlexBox/StackBox) skew accounting with real stylers; schema export never asserts nested styles do *not* require `v`; a manifest entry flipped to `supported` without codec backing fails nothing (the decision record can lie). | reviewer reports; `format_v1_contract_test.dart`; `inventory_check_test.dart` |
| **X11** | Plan inconsistency: the Premortem (#2) claims the extension API was "already hidden behind owned types (phase 0)" as the ack-risk mitigation, but C2 is scheduled for phase 5 and phase 0 didn't do it — phases 3–4 would grow the Ack-typed public surface before it's hidden. | this file: Premortem #2 vs Migration path |
| **X12** | Checkbox integrity: phase 1's R1.4 "[x] no code/doc conflict" is overstated (X3/X4/X8 are conflicts); phase 2's "dummy-Prop demo demonstrated once manually" has no session record. Design note for phase 4: the lenient granule grammar hard-codes wire-shape names (`'variants'`, `'modifiers'`, `'style'`) far from the codecs that own them — new list-valued fields silently get coarse removal granules. | `phase1.md`; `phase2.md`; `mix_schema_contract.dart:585-630` |

Verified sound in the same review (no action): envelope written last on encode and
export incl. the custom-branch override test; `"infinity"` confined to constraints
max bounds; null preflight walks arrays/variants with pointer-correct paths;
structural errors stay fatal in lenient mode; limits counted pre-Ack and monotone
under lenient removals; every new error code reachable via public API; manifest's
four failure modes (missing/stale/conflicting/duplicate) implemented and tested;
backlog deterministic with accurate provenance; melos `analyze` chain + PR
workflow wiring real end-to-end.
