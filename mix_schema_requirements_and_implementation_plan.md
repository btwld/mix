# mix_schema v1 Requirements and Implementation Plan

Status: Draft for execution
Date: 2026-02-27
Owner: Mix 2.0 team

Related documents:
- `./mix_schema_ack_v1_handoff.md` (architecture brief and field matrix)
- `./mix_schema_decision_log.md` (locked decisions A-I)

---

## 1) Document Purpose
This document defines the executable requirements and delivery plan for `mix_schema` v1.

It is intended to remove ambiguity for implementation by specifying:
- what must be built (requirements),
- what must not be built (non-goals),
- how it will be delivered (milestones, acceptance criteria, tests, risk controls).

---

## 2) Product Goal
`mix_schema` provides strict, bidirectional schema-driven interchange for Mix stylers using Ack.

Primary outcomes:
1. Decode external payloads into typed Mix styler objects.
2. Validate payloads with actionable, path-based errors.
3. Encode Mix styler objects back to canonical payload maps.
4. Export JSON Schema for integrators.

---

## 3) Scope and Non-Goals

### In Scope (v1)
1. Main constructor compatibility for target stylers only.
2. Payload envelope parsing with required `schemaVersion`, `stylerType`, and `data`.
3. Strict validation at root and nested object levels.
4. Two-phase validation:
   - Schema-valid (Ack parse/validate)
   - Runtime-resolvable (registry-backed resolution)
5. Metadata support in scope:
   - `animation`: `CurveAnimationConfig` only in v1.
   - `modifier`: serializable forms + runtime callback forms only via registry-backed refs.
   - `variants`: `NamedVariant`, `WidgetStateVariant`, and `ContextVariantBuilder` via registry ID.
   - all other metadata forms are rejected in v1 unless explicitly added later.
6. Registry-backed runtime references via flat string IDs and scoped registries.
7. Canonical round-trip behavior (semantic equality + canonical map encoding).

### Out of Scope (v1)
1. Fluent APIs (`.color()`, `.size()`, etc.).
2. Factory constructor compatibility preservation.
3. Constructor/factory identity preservation in payload.
4. Custom schema DSL replacing Ack.

---

## 4) Normative Contract (Locked)
This section is normative and maps to locked decisions.

### 4.1 Envelope Contract
Payload shape:

```json
{
  "schemaVersion": 1,
  "stylerType": "box",
  "data": {}
}
```

Rules:
1. `schemaVersion` is required and must equal `1`.
2. Unsupported versions must fail with code `unsupported_schema_version`.
3. `stylerType` is required and is a closed, case-sensitive enum with allowed values:
   - `box`
   - `text`
   - `flex`
   - `icon`
   - `image`
   - `stack`
   - `flexBox`
   - `stackBox`
4. `data` is required.
5. Unknown fields are rejected at all object levels.
6. Any `stylerType` value outside the allowed set fails validation.

### 4.2 Validation Contract
1. Phase 1: schema validation with Ack.
2. Phase 2: runtime resolution validation for registry-backed fields.
3. Validation collects all errors; no fail-fast for the first schema error.

### 4.3 Error Contract
Minimum error shape:

```json
{
  "ok": false,
  "errors": [
    {
      "code": "<stable_code>",
      "path": "<field.path>",
      "message": "<human_readable>",
      "value": "<optional_offending_value>"
    }
  ]
}
```

Required codes include:
1. `unknown_field`
2. `unsupported_schema_version`
3. `unknown_registry_id`
4. Path format is dot path with zero-based array indices (example: `data.variants[0].style.color`).
5. JSON Pointer paths are not used in v1.
6. Error ordering is deterministic: sort by `path` ascending, then `code` ascending.
7. Ordering and shape rules apply to both decode and encode error results.
8. Encode must return contract errors in this same envelope shape.
9. Encode must not silently skip unknown runtime values and must not throw raw framework exceptions by default.

### 4.4 Registry Contract
1. Flat ID strings on the wire.
2. Registry scopes are canonical and case-sensitive:
   - `image_provider`
   - `animation_on_end`
   - `modifier_shader`
   - `modifier_clipper`
   - `context_variant_builder`
3. Field-to-scope mapping is fixed:

| Field | Scope |
|---|---|
| `ImageStyler.image` | `image_provider` |
| `AnimationConfig.onEnd` | `animation_on_end` |
| `Shader callback` modifier fields | `modifier_shader` |
| `CustomClipper` modifier fields | `modifier_clipper` |
| `ContextVariantBuilder.fn` | `context_variant_builder` |

4. Registry uniqueness is required per scope.
5. Cross-scope ID collisions are allowed.
6. Scoped lookup by field capability/type (no global namespace requirement).
7. Field resolution must use the canonical mapping table above.
8. Lifecycle: `register -> freeze -> decode/encode`.
9. Post-freeze registration throws.
10. Runtime decode/encode consumes immutable registry interfaces.

### 4.5 Round-Trip Contract
1. `decode(encode(obj))` must preserve semantic object equality.
2. `encode(decode(payload))` must equal canonicalized payload.
3. Canonicalization rules:
   - omit null/absent optionals,
   - normalize enum values to names,
   - preserve registry IDs as strings,
   - ignore map key order.

### 4.6 M3 Execution Locks (Pre-Implementation)
1. Tricky-field behavior is locked for v1:
   - `TextScaler`: only linear form is data-encodable (`{"type":"linear","factor":<double>}`).
   - `Locale`: data-encodable as `{"languageCode":"<string>","countryCode":"<string|null>"}`.
   - `TextStyler.textDirectives` (`List<Directive<String>>`): rejected in v1.
   - `IconStyler.icon` (`IconData`): rejected in v1.
   - `ImageStyler.image`: registry-backed only via `image_provider`.
2. Variant generalization must use a matching generic pair (`Spec` + `Style`):
   - nested decode/encode callbacks return style objects (for example `BoxStyler`, `TextStyler`), not `Spec`.
   - `ContextVariantBuilder` validation is enforced against the active styler callback type.
3. Dispatch sequencing is incremental: add each `decode/encode` `stylerType` switch case only with that styler's completed schema+codec implementation.
4. Composite stylers require reusable data-level helpers before composition:
   - `_decodeBoxData` / `_encodeBoxData`
   - `_decodeFlexData` / `_encodeFlexData`
   - `_decodeStackData` / `_encodeStackData`
5. M3 checkpoint gate command is required for every implementation step:
   - `cd packages/mix_schema && dart analyze && flutter test`

---

## 5) Functional Requirements

### FR-001 Envelope Parse and Dispatch
Implement envelope schema and dispatch by `stylerType`.
Acceptance:
1. All 8 supported `stylerType` values decode to correct styler codec path.
2. Missing/invalid envelope keys emit path-based errors.

### FR-002 Strict Field Validation
Reject unknown fields at root and nested levels.
Acceptance:
1. `additionalProperties: false` behavior enforced everywhere relevant.
2. Unknown nested keys produce `unknown_field` with exact path.

### FR-003 Version Gating
Enforce version = 1.
Acceptance:
1. Any non-1 version fails with `unsupported_schema_version` at path `schemaVersion`.

### FR-004 Main Constructor Coverage
Support main constructor params for v1 stylers and metadata.
Acceptance:
1. Box, Text, Flex, Icon, Image, Stack, FlexBox, StackBox constructor surfaces are covered.
2. `animation`, `modifier`, `variants` are decoded/encoded per v1 policy.
3. Animation v1 supports `CurveAnimationConfig` only.
4. Animation phase/keyframe/spring branches are deferred/rejected in v1 unless explicitly added later.
5. Variants v1 supports `NamedVariant`, `WidgetStateVariant`, and `ContextVariantBuilder` via registry ID.
6. Variant forms outside the v1 supported set are rejected.
7. Modifiers v1 support serializable forms; runtime callback forms are supported only via registry-backed refs.

### FR-005 Runtime-Backed Resolution
Support registry-backed fields using scoped ID resolution.
Acceptance:
1. Known IDs resolve correctly.
2. Missing IDs produce `unknown_registry_id` with path and ID.
3. No runtime mutation allowed after freeze.
4. Missing registry mapping during encode returns `unknown_registry_id` in the contract error envelope.
5. Decode and encode runtime-resolution errors are aggregated and deterministically ordered.
6. Encode does not silently skip unknown runtime values.

### FR-006 Tricky Field Policy
Implement safe subset + registry fallback policy for tricky/runtime values.
Acceptance:
1. `TextScaler` accepts only linear payload form (`type: linear` + numeric factor).
2. `Locale` is encoded/decoded only as `{languageCode, countryCode?}`.
3. `TextStyler.textDirectives` is rejected in v1 with explicit path/reason.
4. `IconStyler.icon` (`IconData`) is rejected in v1 with explicit path/reason.
5. `ImageStyler.image` requires registry resolution in scope `image_provider`.
6. Unsupported forms are aggregated and returned with deterministic path/code ordering.

### FR-007 JSON Schema Export
Export schema definitions from Ack for integrator use.
Acceptance:
1. Envelope + styler schema export exists and is consumable.
2. Contract docs clearly state difference between schema-valid and runtime-resolvable.

### FR-008 Bidirectional Codec Surface
Provide explicit map/object and object/map codec APIs.
Acceptance:
1. Decode and encode APIs are stable and documented.
2. Encode returns contract errors for unknown runtime registry mappings and does not throw raw framework exceptions by default.
3. Round-trip invariants are covered by tests.

### FR-009 Error Reporting Quality
Provide stable error shape for external consumers.
Acceptance:
1. Stable code strings, deterministic paths, readable messages.
2. Path format is dot path with zero-based array indices.
3. Error ordering is deterministic (`path` asc, then `code` asc).
4. Aggregated errors are returned in one response for both decode and encode.

---

## 6) Non-Functional Requirements

### NFR-001 Determinism
Given same input and registry state, decode/encode results are deterministic.

### NFR-002 Auditability
All locked decisions are reflected in code/tests and mapped to requirement IDs.

### NFR-003 Maintainability
Prefer thin helpers and explicit codecs over generic meta-abstractions.

### NFR-004 Change Safety
Structural expansion follows `I-A` (flatter M1/M2, split in M3/M4) to reduce early churn risk.

---

## 7) Implementation Workstreams

### W1 Schema Layer
1. Envelope schema
2. Primitive and enum schemas
3. Styler schemas and unions
4. JSON schema export plumbing

### W2 Codec Layer
1. Primitive codecs
2. DTO codecs
3. Styler codecs
4. Payload codec and dispatch

### W3 Registry Layer
1. `RegistryBuilder<T>` mutable bootstrap API
2. `FrozenRegistry<T>` immutable lookup API
3. Scoped registry bundle and collision/freeze handling

### W4 Validation and Errors
1. Aggregated schema validation
2. Runtime resolution validation
3. Stable error mapping (`code`, `path`, `message`, `value`)

### W5 Test and Quality
1. Unit tests (schema/codec/registry)
2. Integration tests (end-to-end payloads)
3. Round-trip invariant tests
4. Failure-path tests (unknown field/version/ID)

---

## 8) Delivery Plan (Milestones)

### M0 Finalization and Traceability
Goal: implementation-ready contract.
Deliverables:
1. Locked decisions reflected in docs.
2. Requirement IDs finalized.
3. Risks and acceptance gates agreed.
Exit criteria:
1. No open decision items.
2. No contradictory contract language across docs.

### M1 Vertical Slice (Flatter Structure)
Goal: prove architecture end-to-end.
Scope:
1. Envelope + one styler (`box`) decode/encode.
2. One registry-backed field path.
3. Error contract baseline.
4. JSON schema export baseline.
Exit criteria:
1. FR-001/002/003 baseline tests pass.
2. Registry freeze path validated.
3. Round-trip canonical behavior demonstrated on slice.

### M2 DTO Expansion (Still Flatter)
Goal: build reusable DTO/schema/codec primitives.
Scope:
1. Layout DTOs.
2. Painting DTOs.
3. Typography DTOs.
4. Strict nested validation tests.
Exit criteria:
1. DTOs used by stylers with consistent validation semantics.
2. No regression in M1 behavior.

### M3 Full Styler Coverage + Structural Split
Goal: complete v1 feature coverage and migrate to layered structure.
Scope:
1. All 8 stylers.
2. Metadata support across stylers.
3. Variant helper generalization using `Spec` + `Style` matching generics.
4. Extract reusable `*_Data` helpers (`box`, `flex`, `stack`) for composite stylers.
5. Begin migration to target file structure.
Exit criteria:
1. FR-004/005/006/008 covered by tests.
2. Each M3 step passes `cd packages/mix_schema && dart analyze && flutter test`.
3. Target structure migration substantially complete.

### M4 Hardening and Release Readiness
Goal: production-ready quality and docs.
Scope:
1. Error-path and diagnostics consistency.
2. Registry collision/freeze/missing-ID hardening.
3. Final cleanup and docs.
Exit criteria:
1. FR/NFR full checklist passes.
2. Handoff docs and implementation behavior match.

---

## 9) Test Strategy and Acceptance Matrix

Required test groups:
1. Envelope tests
   - valid payloads by stylerType
   - missing/invalid required keys
2. Strictness tests
   - unknown root key
   - unknown nested key
3. Version tests
   - schemaVersion != 1 => `unsupported_schema_version`
4. Registry tests
   - duplicate registration
   - post-freeze mutation
   - unknown ID decode failure
5. Round-trip tests
   - object semantic equality
   - canonical map output
6. Metadata tests
   - animation/modifier/variants encode/decode behavior

Minimum release gate:
1. All required tests pass.
2. Analyzer/CI pass.
3. Requirement-to-test traceability present.
4. Package gate passes for implemented M3 scope: `cd packages/mix_schema && dart analyze && flutter test`.

---

## 10) Risks and Mitigations

### R1 Ambiguous tricky-field subset
Risk: inconsistent implementations.
Mitigation:
1. Lock v1 behavior for `TextScaler`, `Locale`, `textDirectives`, `IconData`, and `ImageProvider` before coding.
2. Add explicit test cases for accepted/rejected forms as they are implemented.

### R2 JSON Schema vs Runtime mismatch
Risk: integrator confusion when schema-valid fails runtime phase.
Mitigation:
1. Keep explicit two-phase contract in docs.
2. Add integration tests showing this boundary.

### R3 Structural churn
Risk: wasted refactors if structure is over-expanded too early.
Mitigation:
1. Follow `I-A` staged structure policy.
2. Move files only when duplication boundaries are clear.

### R4 Error-contract drift
Risk: breaking integrators relying on error codes.
Mitigation:
1. Keep stable code list versioned.
2. Add tests asserting error code/path stability for key failures.

---

## 11) Implementation Checklist

### Contract
- [ ] Envelope schema + closed stylerType set
- [ ] Unsupported version error contract
- [ ] Strict nested unknown field rejection
- [ ] Two-phase validation wiring

### Registry
- [ ] `RegistryBuilder<T>` + `FrozenRegistry<T>`
- [ ] Freeze semantics and mutation guards
- [ ] Scoped capability/type lookup

### Codecs
- [ ] Payload codec
- [ ] Styler codecs (8)
- [ ] Metadata codecs
- [ ] Canonical encode behavior
- [ ] Variant helper generics use matching `Spec` + `Style` callback types
- [ ] Data-level decode/encode helpers extracted for `box`, `flex`, `stack`
- [ ] Tricky-field locks enforced (`TextScaler`, `Locale`, `textDirectives`, `IconData`, `ImageProvider`)

### Testing
- [ ] Unit + integration tests
- [ ] Round-trip invariants
- [ ] Unknown field/version/ID failures
- [ ] Error code/path stability
- [ ] Per-step M3 package gate passes: `cd packages/mix_schema && dart analyze && flutter test`

### Release readiness
- [ ] `melos run gen:build`
- [ ] `melos run ci`
- [ ] `melos run analyze`
- [ ] Docs match implementation

---

## 12) Execution Commands
```bash
melos bootstrap
melos run gen:build
melos run ci
melos run analyze
```

---

## 13) Done Definition
This plan is complete when:
1. Functional requirements FR-001 to FR-009 are implemented and tested.
2. Non-functional requirements NFR-001 to NFR-004 are satisfied.
3. Locked decisions A-I are enforced in code and tests.
4. Handoff brief, decision log, and this plan are mutually consistent.
