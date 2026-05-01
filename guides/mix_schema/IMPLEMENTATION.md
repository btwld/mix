# Mix JSON Schema — Reference Implementation Plan

Status: **Locked v1.** Date: 2026-05-01.
Companion to: [`spec.md`](./spec.md), [`registry.json`](./registry.json), [`error-codes.json`](./error-codes.json), [`examples.md`](./examples.md).

This document describes the reference Dart implementation plan derived from the normative spec. It is **not normative** — substantive contract decisions live in `spec.md`. This file pins:

- Which Dart packages, modules, and files own which spec sections, decisions, and conformance roles.
- The internal layering of the validator pipeline.
- The build order for shipping `packages/mix_schema/` and `packages/mix_schema_flutter/`.

The architecture was finalized after a design pass that audited the proposal against `spec.md`, `schema.v1.json`, `examples.md`, the 41 locked decisions, and the existing Mix Flutter runtime in `packages/mix/`. Pre-decision history is in [`SESSIONS.md`](./SESSIONS.md).

## Positioning

- **Reference, not authoritative.** The contract lives in `spec.md`. This implementation exists to (a) prove the contract is implementable and (b) provide a stable baseline against which the independent second implementation (required for Candidate promotion) can verify.
- **Two packages, hard separation.** Producers (backend tooling, CMS exporters, AI agents) MUST be able to depend on the pure layer alone — no Flutter SDK pull. Decision #22 (single strict mode) and Decision #17 (round-trip via canonical structural equality) are owned by the pure layer.
- **Hand-written types, no codegen.** Spec §Parser & Serializer requires hand-written Dart types. Codegen would couple the contract to Mix's annotations and break the public-contract-vs-internal-serialization separation (Decision #1).

---

## Package layout

### `packages/mix_schema/` — pure Dart, zero Flutter dep

```
lib/
├── mix_schema.dart                  # Public barrel
└── src/
    ├── _internal.dart               # Constants (1 MiB, depth 32, array 1024,
    │                                # directive chain 16, token path 128),
    │                                # JSON Pointer helpers, structural equality,
    │                                # asset loaders, bounds checkers.
    ├── registry.dart                # Loads registry.json → typed Registry
    ├── errors.dart                  # 52 error codes from error-codes.json
    ├── types/                       # ← spec §Parser & Serializer term
    │   ├── document.dart            # MixJsonDocument envelope, Tokens bundle
    │   ├── nodes.dart               # WidgetNode (10) + StyleNode (8) sealed families
    │   ├── values.dart              # PropertyValue, LiteralValue, 19 structured
    │   │                            # literals, HostRef (TaggedHostObject)
    │   ├── modifiers.dart           # ModifierNode (30) + Reset
    │   ├── directives.dart          # DirectiveNode (27)
    │   ├── variants.dart            # VariantNode + 5 kinds × 7 contexts
    │   └── extensions.dart          # ExtensionKey + x: prefix grammar
    │                                # (payloads opaque, never inspected)
    ├── validator.dart               # Bounds → schema-on-raw →
    │                                # internal canonicalize → semantic-on-canonical
    ├── canonicalizer.dart           # sugar → canonical, idempotent
    ├── parser_to_model.dart         # canonical JSON → typed model (pure)
    ├── serializer_from_model.dart   # typed model → canonical JSON (pure)
    ├── parser.dart                  # Public facade re-exporting parser_to_model
    └── serializer.dart              # Public facade re-exporting serializer_from_model
test/conformance/
├── golden/                          # Raw sugary inputs + expected canonical outputs
├── error_fixtures/                  # 5 invalid examples bound to specific codes
└── roundtrip_test.dart              # Pure-layer structural-equality round-trips
```

### `packages/mix_schema_flutter/` — depends on both `mix_schema` + `mix`

```
lib/
├── mix_schema_flutter.dart          # Re-exports mix_schema + runtime extensions
└── src/
    ├── parser_to_runtime.dart       # typed model → Mix runtime (BoxStyler, …)
    └── serializer_from_runtime.dart # Mix runtime → typed model
test/
└── runtime_pipeline_test.dart       # Full-pipeline tests including Flutter render
```

### Why two packages

`package:mix` transitively pulls the full Flutter SDK (foundation, widgets, painting, rendering). Tree-shaking does not remove a declared dependency at pub resolution time — the entire graph resolves. A single-package architecture would force backend producers to pull Flutter even when they never invoke the runtime path. The two-package split honors the spec's Producer audience explicitly and future-proofs the independent second implementation, which can target `mix_schema` alone.

---

## Module ownership

### Spec section → module

| Spec section | Owner |
|---|---|
| §Envelope | `types/document.dart` |
| §WidgetNode | `types/nodes.dart` |
| §StyleNode | `types/nodes.dart` |
| §Value primitive | `types/values.dart` |
| §Structured literals | `types/values.dart` |
| §Directives | `types/directives.dart` |
| §Variants | `types/variants.dart` |
| §Modifiers | `types/modifiers.dart` |
| §Animation | `types/nodes.dart` (inline AnimationNode) |
| §Tokens | `types/document.dart` (bundle) + `registry.dart` (namespace catalog) |
| §Extensions | `types/extensions.dart` |
| §Host references | `types/values.dart` (HostRef) |
| §Semantics — resolution order | `parser_to_model.dart` |
| §Semantics — merge rules | `parser_to_model.dart` |
| §Canonicalization | `canonicalizer.dart` |
| §Security Considerations — resource bounds | `validator.dart` (stage 1) + `_internal.dart` (constants) |
| §Conformance | distributed; see role table |
| §Versioning | `_internal.dart` (`schema` field constant) + pubspec |

### Conformance role → module(s)

| Role | Owner |
|---|---|
| Producer | external; this package supplies types + serializer |
| Validator | `validator.dart` + `errors.dart` + `registry.dart` |
| Canonicalizer | `canonicalizer.dart` |
| Parser | `parser.dart` (facade) → `parser_to_model.dart` (pure) → `parser_to_runtime.dart` (Flutter) |
| Serializer | `serializer.dart` (facade) → `serializer_from_model.dart` (pure) → `serializer_from_runtime.dart` (Flutter) |
| Consumer / runtime | `mix_schema_flutter` + `package:mix` |
| Lint tool | not in scope for v1.0 reference |

### Decision → owner

| # | Decision | Owner module |
|---|---|---|
| 1 | Public contract vs internal serialization | architectural; no codegen ⇒ hand-written `types/` |
| 15 | Leaf-expanded structured literals canonical | `canonicalizer.dart` (dedicated pass after sugar removal) |
| 17 | Round-trip via canonical structural equality | `parser_to_model.dart` + `serializer_from_model.dart` (pure) |
| 22 | Single strict validation mode | `validator.dart` (no lenient knob in surface API) |
| 36 | FontWeight aliases (`normal` → `w400`, `bold` → `w700`) | `canonicalizer.dart` (input-boundary pass) |
| 39 | `error-codes.json` language-neutral source of truth | `errors.dart` |
| 41 | Empty optional arrays omitted | `canonicalizer.dart` (same pass as Decision #15) |

---

## Validator pipeline

Four stages, run sequentially. Each stage MUST complete and report its errors before the next runs (collect-all within a stage; fail-closed on bounds).

```
producer JSON
    │
    ▼
Stage 1: Resource bounds + grammar (fail-closed; DoS guard)
    • Document size ≤ 1 MB                    → envelope.document-too-large
    • Tree depth ≤ 32                         → canonical.depth-exceeded
    • Array length ≤ 1024                     → canonical.array-too-long
    • Directive chain ≤ 16                    → directive.chain-too-long
    • Token path ≤ 128 chars                  → token.path-too-long
    • x: atom grammar                         → extension.atom-invalid
    │
    ▼
Stage 2: JSON Schema structural validation on raw (sugary) input
    • schema.v1.json (Draft 2020-12)
    • Discriminated unions, enum membership, additionalProperties:false
    • Library-internal rule names mapped 1:1 to error-codes.json
    │
    ▼
Stage 3: Internal canonicalize() — calls canonicalizer.dart
    • Idempotent (Decision invariant 1)
    • Sugar removal
    • Leaf expansion (Decision #15)
    • Empty array omission (Decision #41)
    • FontWeight alias normalization (Decision #36)
    │
    ▼
Stage 4: Semantic checks on canonical form
    • Per-prop type matching against registry.json
    • Directive target-type matching (color/string/number)
    • Directives-only-with-no-base detection
    • Variant spec-must-match (Decision #25)
    • Token namespace validity
    │
    ▼
ValidationResult (collect-all, stable JSON Pointer paths)
```

Stage 3 reuses `canonicalizer.dart` directly — sugar grammar lives in **exactly one place**. After validation succeeds, callers may run `Canonicalizer.normalize()` standalone if they only need the canonical JSON without semantic checks.

---

## Build order

Each phase produces a green slice that can land independently.

| # | Phase | Estimate | Deliverable |
|---|---|---|---|
| 1 | Foundations | 1–2d | `_internal.dart`, `registry.dart`, `errors.dart` + asset-loading tests |
| 2 | Types | 2–3d | 7-file `types/` split, `==` / `hashCode`, `fromJson` / `toJson`. **Surfaces spec ambiguities; feed back to `spec.md` before continuing.** |
| 3 | Canonicalizer | 2–3d | `canonicalizer.dart`, idempotency proof via golden tests |
| 4 | Validator | 2–3d | `validator.dart` (4 stages), 5 invalid fixtures from `examples.md` pass |
| 5 | Parser/Serializer (pure) | 3–4d | `parser_to_model.dart` + `serializer_from_model.dart` + facades, round-trip via structural equality |
| 6 | Parser/Serializer (Flutter) | 1–2d | `mix_schema_flutter`: `parser_to_runtime.dart` + `serializer_from_runtime.dart` |
| 7 | Integration + conformance | 2–3d | Full pipeline tests, error-code surface tests, public API docs, README, version bump |

**Total: ~13–20 days.** Wall time depends on spec ambiguities surfaced in phase 2.

After phase 5 the pure package is independently shippable. The Flutter package follows.

---

## Round-trip invariants

Defined on **canonical structural equality**, not byte-equal text (§Structural equality).

| Invariant | Owner |
|---|---|
| `canonicalize(canonicalize(x)) ≡ canonicalize(x)` | `canonicalizer.dart` |
| `serialize(parse(x)) ≡ x` for canonical `x` | `parser_to_model.dart` ↔ `serializer_from_model.dart` |
| `parse(serialize(obj))` renders identically to `obj` | `parser_to_runtime.dart` ↔ `serializer_from_runtime.dart` |

Pure-layer tests run with plain `dart test`. Runtime tests live in `mix_schema_flutter` and use `flutter_test`.

---

## Audit resolutions

Items surfaced during the design audit and pinned here for the independent implementation's reference.

| | Item | Resolution |
|---|---|---|
| A | `types/` vs `models/` naming | **`types/`** — matches spec §Parser & Serializer Deliverables literally |
| B | FontWeight aliases (#36) | Canonicalizer input-boundary pass (before structural changes) |
| C | Leaf-expanded structured literals (#15) | Canonicalizer dedicated pass after sugar removal, before final output |
| D | Empty optional arrays omitted (#41) | Canonicalizer, same pass as C |
| E | `test/conformance/` | Lives at root of `mix_schema` (pure): `golden/`, `error_fixtures/`, `roundtrip_test.dart` |
| F | HostRef placement | `types/values.dart` (avoids `modifiers.dart → extensions.dart` import edge) |
| G | `x:` round-trip preservation | `types/` treats payloads as opaque `Map<String, dynamic>`; validator never inspects; canonicalizer / parser / serializer guarantee byte-for-structure preservation |

---

## Out of scope for the reference implementation

- **TypeScript companion / producer SDKs** — deferred to v1.1.
- **Lint tool role** — optional per spec; no v1.0 deliverable.
- **`$ref` / named styles, action/event binding, conditional children, iteration, phase/keyframe animations** — deferred to ≥ v1.1 (per spec roadmap).
- **Code generation** — explicitly forbidden; types are hand-written.

---

## Open implementation decisions

These are deferred until phase entry, not blockers for the architecture lock:

1. **JSON Schema validator strategy** — off-the-shelf Dart library vs hand-roll a minimal Draft 2020-12 validator scoped to `schema.v1.json`'s constructs. Constraint: validator MUST emit codes from `error-codes.json` (Decision #39); wrapping a library's errors is brittle. Resolved before phase 4.
2. **Dual-source-of-truth between `schema.v1.json` and hand-written `types/`** — keep coherent without codegen. Pre-commit check that walks `$defs` against `types/` declarations is the leading candidate. Resolved before phase 2.
3. **Pre-commit / CI hooks** for invariant verification (idempotency, round-trip). Resolved before phase 3.

---

## References

- [`spec.md`](./spec.md) — normative specification
- [`schema.v1.json`](./schema.v1.json) — formal JSON Schema Draft 2020-12
- [`registry.json`](./registry.json) — per-prop typing
- [`error-codes.json`](./error-codes.json) — 52 codes
- [`examples.md`](./examples.md) — 5 valid + 5 invalid normative fixtures
- [`SESSIONS.md`](./SESSIONS.md) — design log
- `packages/mix/lib/src/` — Mix runtime types this implementation targets
