# mix_schema Ack v1 - Decision Log

Date: 2026-02-27
Mode: Sequential decision review (one-by-one)
Companion implementation doc: `./mix_schema_requirements_and_implementation_plan.md`

## Locked Decisions (source of truth)
1. Unsupported fields policy: `reject`.
2. Round-trip guarantee: semantic equality.
3. Include constructor metadata in v1: `animation`, `modifier`, `variants`.
4. Runtime closures/opaque values: registry indirection (ID-based).
5. Unknown registry ID: hard fail at decode.
6. Registry wire ref format: flat string IDs.
7. Registry collisions: unique per registry; duplicate registration throws.
8. Registry mutability: frozen after bootstrap.
9. Enum encoding: enum names via `Ack.enumValues(Enum.values)`.
10. Optional nulls: omit null/absent fields on encode.
11. Payload versioning: required `schemaVersion`.
12. Validation errors: collect all errors with paths.
13. Root envelope: no generic `kind`.
14. Ack abstraction level: thin helpers only.
15. Constructor scope: main constructors only (no fluent/factory compatibility).
16. Tricky fields policy (`A = B1`): support safe subset; tricky/runtime forms only when registry-backed.
17. Two-layer validation contract (`B = B-A`): schema-valid first, runtime-resolvable second.
18. Unknown-field strictness depth (`C = C-A`): strict at root and nested objects.
19. Flat IDs with capability/type-scoped registries (`D`): uniqueness per registry, no global namespace requirement.
20. Registry lifecycle (`E = E-A`): `register -> freeze -> decode/encode`; any post-freeze registration throws.
21. Registry class shape (locked): use two types:
   - `RegistryBuilder<T>` for registration/bootstrap only.
   - `FrozenRegistry<T>` for runtime decode/encode lookups only (immutable API).
22. Round-trip invariants (`F = F-A`): semantic object equality is required; map equality is required only after canonicalization.
   - Canonicalization: omit null/absent optionals, normalize enums to name strings, preserve registry IDs as strings, ignore map key order.
23. Unsupported schema version handling (`G = G-A`): hard reject with stable code `unsupported_schema_version`, include `path: "schemaVersion"` and received value.
24. Structure complexity (`I = I-A`): start flatter in `M1/M2`, split into the full layered target structure in `M3/M4` when duplication/boundaries are clear.

## Post-lock Clarifications (Normative, Contract Tightening Only)
These clarifications are normative and do not change locked A-I scope. They tighten implementation behavior across docs.

### A) Canonical registry scopes + field mapping
- Registry scopes are case-sensitive:
  - `image_provider`
  - `animation_on_end`
  - `modifier_shader`
  - `modifier_clipper`
  - `context_variant_builder`
- Field-to-scope mapping:
  - `ImageStyler.image -> image_provider`
  - `AnimationConfig.onEnd -> animation_on_end`
  - `Shader callback modifier fields -> modifier_shader`
  - `CustomClipper modifier fields -> modifier_clipper`
  - `ContextVariantBuilder.fn -> context_variant_builder`
- ID uniqueness is required per scope.
- Cross-scope ID collisions are allowed.

### B) Encode-time unknown runtime value behavior
- Encode must not silently skip unknown runtime values.
- Encode must not throw raw framework exceptions by default.
- Encode must return contract errors in the same envelope shape as decode.
- Unknown/missing registry mapping during encode uses code `unknown_registry_id`.
- Encode errors are aggregated using the same model as decode.

### C) Metadata v1 scope freeze
- Animation v1 supported: `CurveAnimationConfig` only.
- Animation deferred/rejected in v1: phase/keyframe/spring branches unless explicitly added later.
- Variants v1 supported:
  - `NamedVariant`
  - `WidgetStateVariant`
  - `ContextVariantBuilder` via registry ID
- Other variant forms are rejected in v1.
- Modifiers v1:
  - serializable modifier forms supported
  - runtime callback forms only via registry-backed refs

### D) Error path format + deterministic ordering
- Path format is dot path with zero-based array indices (example: `data.variants[0].style.color`).
- JSON Pointer is not used in v1.
- Error ordering is deterministic: sort by `path` ascending, then `code` ascending.
- Ordering applies to both decode and encode error results.

### E) stylerType contract consistency
- `stylerType` is a closed, case-sensitive enum:
  - `box`, `text`, `flex`, `icon`, `image`, `stack`, `flexBox`, `stackBox`
- Any other value fails validation.

## Resolved Documentation Actions
- `H` resolved: explicit `M0` milestone added in the handoff execution plan.
- Drift between handoff and decision log resolved for `A/B/C/D`.
- Registry immutability shape clarified and locked (builder + frozen runtime view).

## Pending Decisions Requiring Owner Choice
- None. All tracked decisions are locked.

## Status
Decision review complete for items `A` through `I`.
