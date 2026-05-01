# Mix JSON Schema — Reference Dart Implementation Execution Plan

Status: **Ready to execute.** Date: 2026-05-01.
Companion to: [`IMPLEMENTATION.md`](./IMPLEMENTATION.md) (locked architecture), [`spec.md`](./spec.md) (normative spec).

This is the runbook. It is meant to be executed end-to-end by an agent that has only this file plus the locked design docs (`IMPLEMENTATION.md`, `spec.md`, `schema.v1.json`, `registry.json`, `error-codes.json`, `examples.md`). The agent MUST NOT redesign anything: the architecture is locked, the validator strategy is locked (hand-rolled Draft 2020-12 subset), the package layout is locked.

## Context

The Mix Flutter styling framework needs a public JSON contract so external producers (AI agents, design tools, CMS, backends) can emit Mix widget trees declaratively, and Mix runtimes can render them. The contract was authored in `guides/mix_schema/` and reached **v1.0 Draft** status: ~3,960 lines across 7 files — `spec.md`, `schema.v1.json` (Draft 2020-12, ~1,466 lines, 130+ `$defs`), `registry.json`, `error-codes.json` (52 codes), `examples.md` (5 valid + 5 invalid fixtures), `README.md`, `SESSIONS.md`.

The contract cannot promote from **Draft → Candidate** until two things exist:

1. A reference implementation that proves it's implementable.
2. An independent second implementation built from `spec.md` text alone, demonstrating the spec is unambiguous.

**This plan ships (1).** The architecture for (1) was locked through a multi-round design pass (4 expert agents, two rounds of substantive pushback, and a parallel 4-agent verification audit against `schema.v1.json`, `examples.md`, the 41 locked decisions, and the existing `packages/mix/` runtime). The locked architecture is in [`IMPLEMENTATION.md`](./IMPLEMENTATION.md).

**Outcome target:** two new Dart packages — `packages/mix_schema/` (pure Dart, zero Flutter dep) and `packages/mix_schema_flutter/` (depends on `mix_schema` + `mix`) — with full validator/canonicalizer/parser/serializer, conformance tests passing all 5 valid + 5 invalid fixtures, and `dart pub publish --dry-run` clean. Total ~13–20 days of work, ~16k–22k LOC including tests.

**Why two packages:** `package:mix` transitively pulls the full Flutter SDK. Tree-shaking does not remove a declared dep at pub resolution time. A single-package architecture would force backend producers (one of the contract's stated audiences) to pull Flutter even when they never invoke the runtime path.

**Why hand-roll the JSON Schema validator:** off-the-shelf options are blocked. `json_schema` (pub.dev) supports only Draft 7, not 2020-12. `json_schema_builder` supports 2020-12 but its error model can't cleanly map to our 52 normative error codes. The schema only uses ~10 keywords (no `if/then/else`, no `unevaluatedProperties`, no external `$ref`); ~950 LOC hand-roll is tractable and gives full error-code control.

---

## References (read first)

- [`IMPLEMENTATION.md`](./IMPLEMENTATION.md) — **locked architecture**. Module ownership tables, validator pipeline, build order, audit resolutions, deferred decisions. **Do not redesign.**
- [`spec.md`](./spec.md) — normative spec.
- [`schema.v1.json`](./schema.v1.json) — formal JSON Schema (Draft 2020-12).
- [`registry.json`](./registry.json) — per-prop typing.
- [`error-codes.json`](./error-codes.json) — 52 codes (Decision #39, language-neutral source of truth).
- [`examples.md`](./examples.md) — 5 valid + 5 invalid normative fixtures.
- `CLAUDE.md` — project commands (`melos run gen:build`, `ci`, `analyze`, `fix`).
- `melos.yaml` — workspace config; categories `flutter_projects` / `dart_projects` matter for test/build splits.
- `packages/mix_annotations/pubspec.yaml` — example pure-Dart pubspec template.
- `packages/mix/pubspec.yaml` — example Flutter pubspec template.
- `lints_with_dcm.yaml` — top-level lint config (both new packages extend this).

---

## Phase 0 — Pre-flight

Before phase 1, verify the working tree and workspace are green. Use Glob/Read for any directory listing throughout this plan (per `CLAUDE.md` guidance — avoid bash `ls`/`cat`/`find`).

Verification commands:
- `git status`
- `melos bootstrap`
- `melos run analyze`
- `melos run ci`

If any are red on `main`, surface the failure and stop. Do not start phase 1 on a broken baseline.

---

## Workspace integration (precedes Phase 1)

Two new packages join the melos workspace. Both auto-include via the `packages/*` glob already in `melos.yaml`. The `categories:` block must be extended.

### `melos.yaml` — categories edit

Edit the `categories:` block. Add `mix_schema` to `dart_projects`, add `mix_schema_flutter` to `flutter_projects`:

```yaml
categories:
  flutter_projects:
    - packages/mix
    - packages/mix/example
    - packages/mix_lint_test
    - packages/annotations
    - packages/mix_schema_flutter
  dart_projects:
    - packages/mix_generator
    - packages/mix_lint
    - packages/mix_schema
```

No other `melos.yaml` change. Existing scripts (`gen:build`, `ci`, `analyze`, `test:dart`, `test:flutter`) iterate by category and pick up the new packages automatically.

### Root `pubspec.yaml`

No change. Melos discovers workspace members; the root `pubspec.yaml` doesn't enumerate them.

### `analysis_options.yaml` (per package)

Both new packages get a one-line file (matches `packages/mix_annotations/analysis_options.yaml`):

```yaml
include: ../../lints_with_dcm.yaml
```

### `packages/mix_schema/pubspec.yaml`

```yaml
name: mix_schema
description: Reference Dart implementation of the Mix JSON Schema (validator, canonicalizer, parser, serializer). Pure Dart; no Flutter dependency.
version: 1.0.0-draft
homepage: https://github.com/btwld/mix
repository: https://github.com/btwld/mix/tree/main/packages/mix_schema

environment:
  sdk: ">=3.11.0 <4.0.0"

dependencies:
  meta: ^1.15.0

dev_dependencies:
  test: ^1.24.4
  dart_code_metrics_presets: ^2.24.0
  flutter_lints: ^6.0.0
```

Notes:
- Zero Flutter SDK dep. MUST remain so for the Producer audience.
- No `path:` deps. Self-contained.
- No `build_runner`. No codegen (locked).

### `packages/mix_schema_flutter/pubspec.yaml`

```yaml
name: mix_schema_flutter
description: Flutter runtime bindings for the Mix JSON Schema reference implementation. Bridges parsed Mix JSON documents to the Mix runtime (BoxStyler, TextStyler, ...).
version: 1.0.0-draft
homepage: https://github.com/btwld/mix
repository: https://github.com/btwld/mix/tree/main/packages/mix_schema_flutter

environment:
  sdk: ">=3.11.0 <4.0.0"
  flutter: ">=3.41.0"

dependencies:
  flutter:
    sdk: flutter
  mix_schema:
    path: ../mix_schema
  mix:
    path: ../mix

dev_dependencies:
  flutter_test:
    sdk: flutter
  dart_code_metrics_presets: ^2.24.0
  flutter_lints: ^6.0.0
```

---

## Phase 1 — Foundations (1–2d)

**Goal:** ground the package: constants, asset loaders, error catalog, registry parser, JSON Pointer / structural-equality / bounds helpers. Nothing parses widget trees yet.

**Files (under `packages/mix_schema/`):**

| File | Scope | LOC |
|---|---|---|
| `lib/mix_schema.dart` | Public barrel. Exports `src/types/*.dart`, `src/validator.dart`, `src/canonicalizer.dart`, `src/parser.dart`, `src/serializer.dart`, `src/errors.dart`, `src/registry.dart`. Keep `_internal.dart` private. | 20–30 |
| `lib/src/_internal.dart` | Constants (`maxDocumentBytes = 1048576`, `maxDepth = 32`, `maxArrayLength = 1024`, `maxDirectiveChain = 16`, `maxTokenPathLength = 128`). RFC 6901 JSON Pointer encode/decode. `bool deepEquals(Object?, Object?)` per §Structural equality (key-order-insensitive for objects, ordered for arrays, `int`/`double` coercion). Bounds checkers (`countDepth`, `byteSize` for `String` JSON, `arrayLengthAt`). No `dart:io` import. | 220–280 |
| `lib/src/assets/schema.v1.json` | **Verbatim copy** of `guides/mix_schema/schema.v1.json`. | n/a |
| `lib/src/assets/registry.json` | **Verbatim copy** of `guides/mix_schema/registry.json`. | n/a |
| `lib/src/assets/error-codes.json` | **Verbatim copy** of `guides/mix_schema/error-codes.json`. | n/a |
| `lib/src/assets.dart` | `class MixSchemaAssets` with two factories: `MixSchemaAssets.embedded(Map<String,Object?> schema, Map<String,Object?> registry, Map<String,Object?> errorCodes)` for embedded use; `MixSchemaAssets.fromFiles(String dirPath)` using `dart:io File` (CLI only). The pure core MUST NOT call `dart:io` from `validator.dart`/`canonicalizer.dart`/`parser*.dart`. | 90–120 |
| `lib/src/errors.dart` | Mirrors `error-codes.json`. Sealed `MixSchemaError` with `code`, `message`, `path` (JSON Pointer string), optional `hint`, optional `severity`. Static catalog parsed at load. Compile-time-checked code names via Dart enum (e.g. `Errors.envelopeDocumentTooLarge`). `class ValidationResult(List<MixSchemaError>)` with `isValid` getter. | 200–260 |
| `lib/src/registry.dart` | Loads `registry.json` → typed views: `Registry.specs[String]` → `SpecDef`, `.modifiers[String]` → `ModifierDef`, `.directives[String][String]` → `DirectiveDef`, `.literals[String]` → `LiteralDef`, `.tokenNamespaces` (8 built-ins), `.enums[String]` → `List<String>`, `.enumAliases[String][String]` → `String`. Immutable. | 220–300 |
| `test/foundations/json_pointer_test.dart` | Encode/decode round-trips, escaping (`/`→`~1`, `~`→`~0`). | 60–90 |
| `test/foundations/deep_equals_test.dart` | Per §Structural equality: object key-order-insensitive, ordered arrays, int/double, null cases. | 80–120 |
| `test/foundations/registry_loader_test.dart` | Every spec/modifier/directive in `registry.json` parses; per-prop maps non-empty; FontWeight aliases present. | 80–120 |
| `test/foundations/errors_catalog_test.dart` | Catalog contains all 52 codes; Dart enum names match. | 60–90 |

**Acceptance:**
- `dart pub get` clean inside `packages/mix_schema/`.
- `melos exec --scope=mix_schema dart analyze` zero issues.
- `melos exec --scope=mix_schema dart test` all pass.
- `melos run analyze` workspace green.

**Estimate:** ~1,100–1,500 LOC. 1–2d.

---

## Phase 2 — Types (2–3d) — spec-ambiguity-surfacing phase

**Goal:** hand-write the typed model in 7 files mirroring spec.md sections. **`IMPLEMENTATION.md` flags this phase as the place ambiguities surface — the agent MUST NOT silently invent missing semantics. For every ambiguity, stop and write a question against `spec.md` before continuing. See risk callouts below.**

**Files:**

| File | Scope | LOC |
|---|---|---|
| `lib/src/types/document.dart` | `MixJsonDocument` envelope (`$schema`, `schema`, `mixRuntime?`, `tokens?`, `root`). `TokenBundle`. `fromJson` / `toJson` (canonical-form output: lex-sorted keys). `==` / `hashCode` via `deepEquals`. `copyWith`. | 180–240 |
| `lib/src/types/nodes.dart` | Sealed `WidgetNode` + 11 subclasses (`WidgetBox`, `WidgetFlexBox`, `WidgetRowBox`, `WidgetColumnBox`, `WidgetStackBox`, `WidgetStyledText`, `WidgetStyledIcon`, `WidgetStyledImage`, `WidgetPressable`, `WidgetPressableBox`, `WidgetExtension`). Sealed `StyleNode` + 8 subclasses (leaf: box/flex/text/icon/image/stack; composite: flexbox/stackbox) + `StyleExtension`. `SubStyleNode` (composite sub-styles, only `spec` + `props`). Inline sealed `AnimationNode` (curve / preset). | 540–720 |
| `lib/src/types/values.dart` | Sealed `Value`: `LiteralValue(Object literal)`, `TokenValue(String token)`, `ValueWithDirectives`. `PropertyValue` (`value?` + `token?` + `directives?`). 19 structured literals: `EdgeInsets`, `BorderRadius`, `BoxConstraints`, `Size`, `Offset`, `Rect`, `Alignment` (`{x,y}` + presets), `Matrix4` (ordered `ops` + `OpIdentity`/`OpTranslate`/`OpScale`/`OpRotateZ`), `Shadow`, `BorderSide`, `Border`, `Decoration`, `Gradient` (linear/radial/sweep), `TextStyle`, `StrutStyle`, `TextScaler`, `TextHeightBehavior`, `Icon` (material/cupertino/custom), `Image` (asset/network/host). `HostRef(String id)` lives here per audit row F. Each: `fromJson`/`toJson` + structural equality. | 1,200–1,600 |
| `lib/src/types/modifiers.dart` | Sealed `ModifierNode` + 30 subclasses + `ModifierExtension` + `ModifierReset` sentinel. `fromJson`/`toJson` per `registry.json` shape. **Two specials:** `ModifierBox.style` and `ModifierDefaultTextStyler.style` carry raw `StyleNode` (not Value) per spec §Modifiers. | 700–900 |
| `lib/src/types/directives.dart` | Sealed `DirectiveNode` + 27 subclasses. Three marker mixins: `ColorDirective`, `StringDirective`, `NumberDirective`. Typed prop fields (e.g. `Darken(int amount)`, `Multiply(num factor)`). | 380–520 |
| `lib/src/types/variants.dart` | `VariantNode { WhenExpr when, StyleNode style }`. Sealed `WhenExpr`: `WhenState` (9 states), `WhenNamed`, `WhenEnum`, `WhenContext` (6 sub: breakpoint/orientation/brightness/platform/directionality/preset), `WhenNot`, `WhenExtension`. | 280–360 |
| `lib/src/types/extensions.dart` | `ExtensionKey(String value)` with `_atomRegex = RegExp(r'^[a-z][a-z0-9_-]*$')`. `WidgetExtension` / `StyleExtension` / `ModifierExtension` payloads as opaque `Map<String,Object?>` (audit row G). Helpers. **Validators MUST NOT inspect or rewrite payloads.** | 140–200 |
| `test/types/widget_node_test.dart` | Round-trip every WidgetNode subclass: `fromJson(toJson(x)) == x`. | 200–280 |
| `test/types/style_node_test.dart` | Round-trip leaf and composite styles, including SubStyle. | 200–280 |
| `test/types/values_test.dart` | Round-trip Value primitive (3 shapes), each of the 19 literals, HostRef. | 320–460 |
| `test/types/modifiers_test.dart` | Round-trip every modifier (30 + reset + extension). | 240–340 |
| `test/types/directives_test.dart` | Round-trip every directive. Constraint validation deferred to phase 4. | 160–240 |
| `test/types/variants_test.dart` | Round-trip every WhenExpr shape across enclosing specs. | 180–260 |
| `test/types/extensions_test.dart` | Atom grammar accept/reject; payload byte-for-structure preservation. | 100–150 |

**Acceptance:**
- All round-trip tests pass.
- `==`/`hashCode` consistent with `deepEquals`.
- `dart analyze` + `dcm analyze` zero issues.
- **No `package:flutter` import anywhere under `lib/`.**

**Estimate:** ~5,500–7,500 LOC. 2–3d (more if ambiguity loops back to spec).

### Phase 2 risk callouts (likely ambiguity sites — surface to spec.md, don't improvise)

1. **`Rect` literal** — listed in `registry.json` (used by `image.centerSlice`) but not in `spec.md` §Structured literals catalog. Confirm if part of v1.0.
2. **`Gradient` discriminator** — `registry.json` keys it under `kinds.{linear,radial,sweep}` with field `kind`. `schema.v1.json` may not have a `Literal_Gradient` $def yet. Confirm canonical shape.
3. **`Image` source: `host` vs HostRef** — `Image` has `{source: "host", id: ...}` which differs from HostRef `{host: "..."}`. Phase 2 must keep these distinct types.
4. **Empty optional arrays vs canonical idempotency (#41)** — `toJson` emits nothing (not `[]`) for empty arrays; `fromJson` accepts missing OR empty identically.
5. **`AnimationNode` discriminator overlap** — `kind: "curve"` requires `curve` field; preset kinds forbid it. Encode as two non-overlapping sealed subclasses, not one class with optional `curve`.
6. **`box`/`defaultTextStyler` modifier `style` raw `StyleNode`** — breaks the "every modifier prop is a Value" pattern. Type as `StyleNode style`, not `Value style`.
7. **`Pressable.child` REQUIRED, `PressableBox.child` OPTIONAL (Decision #27)** — match `schema.v1.json` exactly.
8. **`Variant_*` `minItems: 1`** — non-empty `variants` if present. Combined with #41: `variants: []` is a phase-3 fix-up (omit, don't error). Phase 2 types accept either; phase 3 normalizes.
9. **`When_Extension` single `x:` key map** — model as `WhenExtension(String xKey, Object payload)`, serialize as one-key map.

If any further ambiguity arises, stop and write a question to `spec.md` review. **Do not silently choose a semantic.**

---

## Phase 3 — Canonicalizer (2–3d)

**Goal:** sugar → canonical, idempotent. Owns Decisions #15 (leaf-expanded literals), #36 (FontWeight aliases), #41 (empty-array omission). Single source of truth for sugar grammar; validator stage 3 reuses this code.

**Files:**

| File | Scope | LOC |
|---|---|---|
| `lib/src/canonicalizer.dart` | `class Canonicalizer { Map<String,Object?> normalize(Map<String,Object?> input) }`. Five sequential passes, each idempotent: (1) **alias normalization** (#36 input boundary, before structural changes); (2) **scalar → Value lift** (bare scalars at Value positions wrap to `{value:x}`); (3) **structured-literal sugar expansion** (`all`/`horizontal`/`vertical` → leaves, Alignment-presets → `{x,y}`, short-form colors `#rgb`/`#rrggbb` → `#rrggbbaa` lowercase, int → double at `double` positions); (4) **leaf-Value normalization** (#15: every sub-field of every structured literal becomes a Value object); (5) **shape pruning** (#41: drop empty optional arrays, drop `null`-valued optional fields). Lex-sort keys for serialization (byte-shape only — `deepEquals` is order-insensitive). Provide `bool isCanonical(Map<String,Object?>)`. | 580–780 |
| `test/canonicalizer/idempotency_test.dart` | For each example 1–5: `canonicalize(canonicalize(x)) == canonicalize(x)`. Plus 50 sugar permutations of example 1 converge identically. | 200–280 |
| `test/canonicalizer/golden_examples_test.dart` | For each of 5 valid examples: read sugar, canonicalize, deep-equals against canonical form. | 220–300 |
| `test/canonicalizer/leaf_expansion_test.dart` | EdgeInsets `{all:16}` → 4 leaves; BorderRadius `{all:8}` → 4 corners; Alignment presets → `{x,y}`; `#fff` → `#ffffffff`. | 220–300 |
| `test/canonicalizer/empty_array_test.dart` | #41: `variants:[]` → omitted; `modifiers:[]` → omitted. | 100–150 |
| `test/canonicalizer/font_weight_alias_test.dart` | #36: `FontWeight.normal` → `w400`; `bold` → `w700`. Already-canonical `w400` unchanged. | 80–120 |
| `test/conformance/golden/example_1_animated_button.sugar.json` | Verbatim from `examples.md`. | n/a |
| `test/conformance/golden/example_1_animated_button.canonical.json` | Verbatim from `examples.md`. | n/a |
| (… examples 2–5, same sugar/canonical pair) | | n/a |

**Acceptance:**
- All 5 examples canonicalize from sugar to canonical-form (deep-equals).
- Idempotency holds for all 5.
- `melos run analyze` green.

**Estimate:** ~1,400–2,000 LOC. 2–3d.

---

## Phase 4 — Validator (2–3d) — hand-rolled JSON Schema

**Goal:** 4-stage pipeline per `IMPLEMENTATION.md` §Validator pipeline. Hand-rolled Draft 2020-12 subset scoped to constructs `schema.v1.json` actually uses. Maps every internal failure 1:1 to a code in `error-codes.json`.

### 4.1 Validator module breakdown (~950 LOC core + ~370 LOC bounds/semantic)

| File | Scope | LOC |
|---|---|---|
| `lib/src/validator/json_pointer.dart` | RFC 6901 helpers (or import from `_internal.dart`). | 60–90 |
| `lib/src/validator/schema_loader.dart` | Loads `schema.v1.json` via `MixSchemaAssets`. Indexes `$defs` into `Map<String,SchemaNode>` keyed by JSON Pointer fragment. One-pass `$ref` rewrite to direct refs. **Forbids external `$ref`** — any `$ref` not starting with `#/` is rejected at load (§Security Considerations). | 110–150 |
| `lib/src/validator/schema_node.dart` | Internal AST: sealed `SchemaNode`. Subclasses: `SObject`, `SArray`, `SOneOf`, `SConst`, `SEnum`, `SPattern`, `SType`, `SFormat` (uri only), `SAnyOf`, `SNot`, `SRequiredAll`, `SMinMax`, `SPropertyNames`, `SMinMaxLengthString`. | 240–320 |
| `lib/src/validator/schema_validator.dart` | Walker. `validate(SchemaNode, Object?, String pointer, ErrorCollector)`. **Collect-all** within stage 2. Maps low-level failures to `error-codes.json` via `error_mapping.dart`. | 320–420 |
| `lib/src/validator/oneof_resolver.dart` | Discriminator handler. WidgetNode (`widget`), StyleNode (`spec`), DirectiveNode (`op`), AnimationNode (`kind`), Literal_Icon (`source`), Literal_Image (`source`), When_context (`context`). No-branch-matched → mapped error code per location. | 200–260 |
| `lib/src/validator/error_mapping.dart` | Switch table: (parent-`$defs`-name, property-name, internal-rule) → 52-code catalog. Examples: `Widget_Pressable.style` rejection → `widget.field-forbidden`; `Style_box` missing `spec` → `style.spec-missing`; `TokenPath` pattern fail → `token.form-invalid`; `ValueObject.value: null` → `value.null-forbidden`; AnimationNode preset+`curve` → `animation.curve-forbidden`. **~120 LOC; review line-by-line against `error-codes.json` after writing.** | 120–180 |
| `lib/src/validator/bounds.dart` | Stage 1: byte size, depth, array length, directive chain, token path. **Fail-closed**, short-circuits on first breach (§Security Considerations). | 90–130 |
| `lib/src/validator/semantic.dart` | Stage 4: per-prop type-matching against `registry.json`; directive target-type matching (color/string/number); directives-only-on-leaf check; variant spec-must-match (#25); token namespace validity (8 built-ins or `x:`); SubStyle-only-spec-and-props rule; `box`/`defaultTextStyler` raw-StyleNode exception. Collect-all. | 280–380 |
| `lib/src/validator.dart` | Public facade. `class Validator { Future<ValidationResult> validate(Object? document) }`. Sequencing: stage 1 (bounds, fail-closed) → stage 2 (`schema_validator`, collect-all) → stage 3 (`canonicalizer.normalize`) → stage 4 (`semantic.validate`, collect-all). Returns merged `ValidationResult` with stable JSON Pointer paths. | 140–200 |

### 4.2 Validator hand-roll scope (~950 LOC, the requested breakdown)

| Module | LOC | Role |
|---|---|---|
| JSON Pointer helper | 60–90 | RFC 6901 |
| `$defs`/`$ref` resolver | 110–150 | One-pass rewrite; rejects external `$ref` |
| Schema AST | 240–320 | All node types listed above |
| Walker | 320–420 | Type/property/required/additionalProperties/pattern/const/format |
| oneOf discriminator | 200–260 | All discriminated unions |
| Error mapping | 120–180 | Internal → 52-code catalog |
| **Subtotal** | **~950 LOC** | |

Stages 1, 3, 4 (bounds + canonicalizer reuse + semantic) add ~370 LOC on top.

### 4.3 Tests

| File | Scope | LOC |
|---|---|---|
| `test/validator/bounds_stage_test.dart` | >1MB, depth>32, arrays>1024, chain>16, token-path>128. Each emits the right code. | 200–260 |
| `test/validator/structural_stage_test.dart` | Per-`$def` exercises: every Widget_*, Style_*, Modifier_*, Directive_*, When_*, AnimationNode (both branches), Literal_Icon/Image (all sources), TokenPath, ExtensionId. | 480–680 |
| `test/validator/semantic_stage_test.dart` | Per-prop type matching, directive type mismatch, directives-only-leaf, #25 spec-must-match, token namespace. | 280–360 |
| `test/conformance/error_fixtures/i1_pressable_with_style.json` | examples.md I1; expects `widget.field-forbidden`. | n/a |
| `test/conformance/error_fixtures/i2_token_no_namespace.json` | I2; expects `token.form-invalid`. | n/a |
| `test/conformance/error_fixtures/i3_variant_spec_mismatch.json` | I3; expects `variant.spec-mismatch`. | n/a |
| `test/conformance/error_fixtures/i4_animation_curve_forbidden.json` | I4; expects `animation.curve-forbidden`. | n/a |
| `test/conformance/error_fixtures/i5_value_null_forbidden.json` | I5; expects `value.null-forbidden`. | n/a |
| `test/conformance/error_fixtures_test.dart` | Loads each i1–i5, runs full pipeline, asserts code at JSON Pointer path. | 120–180 |

**Acceptance:**
- All 5 invalid fixtures produce the documented error code at the documented path.
- All 5 valid fixtures pass cleanly.
- Pipeline ordering verified: bounds short-circuits; schema + semantic collect-all.
- Coverage: every code in `error-codes.json` either has a targeted test or is annotated render-time-only (`directive.no-base`, `host.unresolved`, `extension.unknown-handler`, `resolve.unresolved-leaf`, `token.unresolved`, `token.type-mismatch`, `envelope.mixruntime-mismatch`).

**Estimate:** ~3,000–4,200 LOC. 2–3d.

---

## Phase 5 — Parser/Serializer (pure) (3–4d)

**Goal:** round-trip via canonical structural equality (Decision #17), pure-Dart layer. `mix_schema` is independently shippable after this phase.

**Files:**

| File | Scope | LOC |
|---|---|---|
| `lib/src/parser_to_model.dart` | `class PureParser { MixJsonDocument parse(Map<String,Object?> canonical) }`. Walks canonical → typed model. Static parse — does NOT resolve tokens (deferred to phase 6). The only resolution-time error catchable here: `directive.no-base` (a directives-only Value at a leaf with no inherited base in the same StyleNode chain). | 480–620 |
| `lib/src/serializer_from_model.dart` | `class PureSerializer { Map<String,Object?> serialize(MixJsonDocument doc) }`. Walks typed model → canonical JSON. Lex-sort keys. Preserve `x:` payloads byte-for-structure. Deterministic. | 380–500 |
| `lib/src/parser.dart` | Public facade. `class Parser { Future<MixJsonDocument> parse(String json); MixJsonDocument parseMap(Map<String,Object?> canonical) }`. Convenience `parseValidating` runs Validator + Canonicalizer + PureParser in one call. | 100–140 |
| `lib/src/serializer.dart` | Public facade. `class Serializer { String toJson(MixJsonDocument doc); Map<String,Object?> toMap(MixJsonDocument doc) }`. | 90–130 |
| `test/conformance/roundtrip_test.dart` | For each of 5 valid examples: `serialize(parse(canonical))` is structurally equal to `canonical` per `deepEquals`. **NOT byte-equal** — contract is structural. | 200–280 |
| `test/parser/parse_negative_test.dart` | `directive.no-base` detection. | 120–180 |
| `test/parser/extension_preservation_test.dart` | `x:` payload survives parse + serialize unchanged (synthetic doc with nested `x:` content). | 100–150 |
| `test/serializer/canonical_output_test.dart` | Lex-key-sort verified; empty arrays omitted; Value-wrapping intact. | 140–200 |

**Acceptance:**
- Round-trip invariant 1 (IMPLEMENTATION.md): all 5 examples pass.
- End-to-end idempotency: `serialize(parse(canonicalize(serialize(parse(x))))) == serialize(parse(canonicalize(x)))`.
- `x:` byte-for-structure preserved.
- `dart pub publish --dry-run` clean.

**Estimate:** ~1,600–2,200 LOC. 3–4d.

---

## Phase 6 — Parser/Serializer (Flutter) (1–2d)

**Goal:** `mix_schema_flutter` brings typed model to Mix runtime objects (`BoxStyler`, `TextStyler`, `FlexStyler`, …) and back.

**Files (under `packages/mix_schema_flutter/`):**

| File | Scope | LOC |
|---|---|---|
| `lib/mix_schema_flutter.dart` | Public barrel. Re-exports `package:mix_schema/mix_schema.dart` + runtime-binding classes. | 25–40 |
| `lib/src/parser_to_runtime.dart` | `class RuntimeParser { Style toRuntime(StyleNode node, MixScope scope) }`. Walks typed `StyleNode` → matching Mix runtime object. Resolves tokens via inline bundle → `MixScope` → `token.unresolved`. Resolves `host:` via `HostResolver`. Modifier ordering, variant collection, animation attach. Mix runtime types to produce: `BoxStyler`, `TextStyler`, `IconStyler`, `ImageStyler`, `StackStyler`, `FlexStyler`, `FlexBoxStyler`, `StackBoxStyler` (one per spec, from `packages/mix/lib/src/specs/`). | 480–680 |
| `lib/src/serializer_from_runtime.dart` | `class RuntimeSerializer { StyleNode fromRuntime(Style runtime) }`. Inverse direction. Re-emit token references where the runtime carries token identity (Mix `Prop<T>` retains token info — preserve, don't eagerly resolve). | 420–560 |
| `lib/src/host_resolver.dart` | `abstract class HostResolver` consumer hook: `Object? resolve(String hostId)` → null emits `host.unresolved`. Reference impl `AllowlistHostResolver(Set<String> allow, Map<String,Object> bindings)`. | 80–120 |
| `test/runtime_pipeline_test.dart` | For each of 5 examples: JSON → validate → canonicalize → parse (pure) → toRuntime → render via `flutter_test` `WidgetTester`. Assert no runtime exceptions. | 280–380 |
| `test/runtime_roundtrip_test.dart` | Round-trip invariant 3 (IMPLEMENTATION.md): `parse(serialize(obj))` renders identically. Compare via `find.byType` + golden BoxStyler property checks. | 220–300 |
| `test/host_resolver_test.dart` | Allowlist hits/misses → `host.unresolved`. | 100–150 |

**Acceptance:**
- All 5 valid examples render under `flutter_test` without runtime exceptions.
- Round-trip invariant 3: render-equivalence holds.
- `mix_schema_flutter` only depends on `flutter`, `mix`, `mix_schema`.

**Estimate:** ~1,600–2,200 LOC. 1–2d.

---

## Phase 7 — Integration + conformance + polish (2–3d)

**Goal:** full pipeline, conformance surface, README/CHANGELOG, version finalization.

**Files:**

| File | Scope | LOC |
|---|---|---|
| `packages/mix_schema/README.md` | Intro, install, single-paragraph quickstart, links to `spec.md` and `examples.md`, error-code summary. Pure-Dart audience. | 200–300 |
| `packages/mix_schema/CHANGELOG.md` | `## 1.0.0-draft (2026-05-XX)`: initial reference impl. | 30–50 |
| `packages/mix_schema/example/main.dart` | One end-to-end demo: load example 1, validate, canonicalize, parse, print canonical JSON. Pure Dart. | 60–100 |
| `packages/mix_schema_flutter/README.md` | Same shape; Flutter audience; explains host-allowlist contract. | 200–300 |
| `packages/mix_schema_flutter/CHANGELOG.md` | Initial draft. | 30–50 |
| `packages/mix_schema_flutter/example/main.dart` | `MaterialApp` running example 1 with `MixScope` providing tokens. | 100–150 |
| `packages/mix_schema_flutter/test/conformance/end_to_end_test.dart` | One test per of 5 valid examples: producer JSON → all 7 stages → rendered widget visible to `WidgetTester`. | 280–380 |
| `packages/mix_schema/test/conformance/error_code_coverage_test.dart` | Asserts every code in `error-codes.json` is either tested or tagged `render-time-only`. **Safety net for catalog drift.** | 100–150 |
| `packages/mix_schema/lib/src/version.dart` | `const String mixSchemaVersion = '1.0.0';` mirrors envelope `schema` constant. | 20–30 |
| `packages/mix_schema/CONFORMANCE.md` | (Optional) declares this impl's roles per `spec.md` §Conformance. | 150–250 |

**Polish tasks:**
- `melos run analyze` resolve every issue.
- `melos run ci` confirm green.
- `dart pub publish --dry-run` for both packages.
- `pubspec.yaml` `version` lines match `CHANGELOG.md`.
- `melos run gen:build` succeeds (no-op for these packages but must not break workflow).

**Acceptance:**
- `melos run gen:build` succeeds.
- `melos run ci` green.
- `melos run analyze` green (Dart + DCM).
- `dart pub publish --dry-run` clean for both.
- `error_code_coverage_test.dart` passes (every code accounted for).

**Estimate:** ~1,600–2,300 LOC. 2–3d.

---

## Verification matrix

| Phase | Key commands |
|---|---|
| 0 | `git status`, `melos bootstrap`, `melos run analyze`, `melos run ci` |
| 1 | `melos exec --scope=mix_schema dart analyze`, `melos exec --scope=mix_schema dart test`, `melos run analyze` |
| 2 | Same as 1; ensure no `package:flutter` import in `lib/` |
| 3 | `melos exec --scope=mix_schema dart test --tags=canonicalizer`, full `dart test`, `melos run analyze` |
| 4 | `melos exec --scope=mix_schema dart test --tags=validator`, full `dart test`, `melos run analyze` |
| 5 | Full `dart test`, `melos exec --scope=mix_schema dart pub publish --dry-run`, `melos run analyze` |
| 6 | `melos exec --scope=mix_schema_flutter flutter test`, `melos run test:flutter`, `melos run analyze` |
| 7 | `melos run gen:build`, `melos run ci`, `melos run analyze`, `dart/flutter pub publish --dry-run` |

`melos run analyze` runs both `dart analyze` and `dcm analyze`. Both must be clean for "green slice" acceptance.

---

## Risk callouts (per phase)

### Phase 1
- **Asset-loading.** `dart:io` confined to `assets.dart::fromFiles`. Pure core uses `Map<String,Object?>` injection.
- **Named constants** (`MixSchemaConstants.maxDocumentBytes = 1048576;`) — keep the four-stage pipeline readable.

### Phase 2 — most exposed
See 9-item enumerated list under Phase 2 above. Surface to `spec.md`. Do not improvise.

### Phase 3
- **#36 alias normalization MUST run first** as input-boundary pass. Wrong order → `fontWeight: "normal"` ends up wrapped as `{value:"normal"}` and never normalizes.
- **Pass order: alias → scalar lift → sugar expansion → leaf-Value → empty-array prune.**
- **Lex-sort is structural-output-only.** `deepEquals` from phase 1 stays key-order-insensitive.

### Phase 4
- **External `$ref` rejection.** `schema_loader.dart` MUST reject any `$ref` not starting with `#/`. Add a test for `$ref: "https://attacker/x.json"` rejection at load.
- **Bounds is fail-closed; schema/semantic is collect-all.** Don't accidentally collect-all the bounds stage.
- **Error-mapping fan-out.** Single internal failure (e.g. `additionalProperties:false` rejection) maps to different codes at different `$def`s. The switch table is the single point of truth — review against `error-codes.json` line-by-line.
- **Phase 4 ships with 5 invalid fixtures; phase 7 closes the gap to all 52 codes via `error_code_coverage_test.dart`.** Don't conflate.

### Phase 5
- **`directive.no-base` is the only resolution-time error catchable in pure layer.** Document this in `parser_to_model.dart` for phase 6 author.
- **Round-trip is structural, not byte-equal.** Use `deepEquals`, never `String json1 == json2`.

### Phase 6
- **Mix runtime carries token identity.** `Prop<T>` retains token info — `RuntimeSerializer` reverse-emits the token reference. Do NOT eagerly resolve `color.primary` to `#2196f3ff` and lose token identity (breaks round-trip invariant 3).
- **Host allowlist is consumer-supplied.** Ship `AllowlistHostResolver` as reference; do NOT bake a default allowlist.

### Phase 7
- **`error_code_coverage_test.dart` is the safety net.** Without it the package can ship missing codes and pass green.
- **`gen:build` no-op confirmation.** Both new packages have no `build_runner` dep; melos's `packageFilters: dependsOn: build_runner` should ensure they're skipped cleanly.

---

## Total estimate and ship sequence

| Phase | LOC (incl. tests) | Days | Cumulative |
|---|---|---|---|
| 0 pre-flight | 0 | 0.25 | 0.25 |
| 1 foundations | 1,100–1,500 | 1–2 | 1.25–2.25 |
| 2 types | 5,500–7,500 | 2–3 | 3.25–5.25 |
| 3 canonicalizer | 1,400–2,000 | 2–3 | 5.25–8.25 |
| 4 validator | 3,000–4,200 | 2–3 | 7.25–11.25 |
| 5 parser/serializer (pure) | 1,600–2,200 | 3–4 | 10.25–15.25 |
| 6 parser/serializer (Flutter) | 1,600–2,200 | 1–2 | 11.25–17.25 |
| 7 integration + polish | 1,600–2,300 | 2–3 | 13.25–20.25 |
| **Total** | **15,800–21,900** | **13–20** | |

**Phase 5 is the natural ship checkpoint:** `mix_schema` (pure) is independently usable. `mix_schema_flutter` follows.

---

## Existing patterns to mirror

The new packages do not reuse existing Dart code from `packages/mix/`, but the executing agent should mirror these pubspec patterns:

- `packages/mix_annotations/pubspec.yaml` — pure-Dart pubspec template
- `packages/mix_annotations/analysis_options.yaml` — `include: ../../lints_with_dcm.yaml` one-liner
- `packages/mix/pubspec.yaml` — Flutter pubspec template (for `mix_schema_flutter`)

Mix runtime types the phase 6 `parser_to_runtime.dart` produces (located in `packages/mix/lib/src/specs/`):

| Spec | Runtime type |
|---|---|
| `box` | `BoxStyler` |
| `text` | `TextStyler` |
| `icon` | `IconStyler` |
| `image` | `ImageStyler` |
| `stack` | `StackStyler` |
| `flex` | `FlexStyler` |
| `flexbox` | `FlexBoxStyler` |
| `stackbox` | `StackBoxStyler` |

Token resolution pattern (phase 6): `MixScope` is an `InheritedModel<String>` exposing typed token maps (`Map<ColorToken, Color>`, `Map<SpaceToken, double>`, etc.). The runtime resolves token references via `token.resolve(context)` inside the `MixScope` widget tree.
