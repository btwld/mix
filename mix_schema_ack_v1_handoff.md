# mix_schema Ack v1 Master Brief

Primary companion document:
- `./mix_schema_requirements_and_implementation_plan.md` (detailed requirements, workstreams, acceptance gates)

## 1) Why This Exists
`mix_schema` is a schema/codec package for Mix 2.0 that enables safe external style payloads.

Primary goals:
- Parse external payloads into strongly-typed Mix styler objects.
- Validate payloads strictly and return actionable errors.
- Encode Mix styler objects back to maps for transport/storage.
- Export schema definitions (JSON Schema) for integrators.

Target use cases:
- AI/agent protocols
- Server-driven UI
- Design tooling bridges

This document is the implementation contract for the next agent.

---

## 2) Core Direction (Locked)
Build `mix_schema` **on top of Ack**, not custom schema infrastructure.

Use Ack for:
- object schemas
- enums
- discriminated unions
- parse/safeParse
- validation errors
- JSON schema export

Write custom code for:
- Ack data <-> Mix object codecs
- reverse codecs (Mix -> map)
- runtime registry resolution for non-serializable values

---

## 3) Frozen Decisions From Planning (M0)
These are final unless explicitly changed by product owner.

1. Unsupported fields: `reject`.
2. Round-trip: semantic equality (not byte-for-byte map equality).
3. Include constructor metadata in v1: `animation`, `modifier`, `variants`.
4. Runtime closures/opaque runtime values: registry indirection by ID.
5. Unknown registry ID: hard decode failure.
6. Registry ref wire format: flat string IDs.
7. Registry collision policy: uniqueness per registry; duplicate registration throws.
8. Registry mutability: frozen after bootstrap/startup.
9. Enum encoding: enum `name` strings using `Ack.enumValues(Enum.values)`.
10. Optional/null encode policy: omit null/absent optionals.
11. Versioning: required `schemaVersion`.
12. Error strategy: collect all validation errors with field paths.
13. Root shape: no generic `kind` field.
14. Abstraction policy: Ack-first, thin helpers only.
15. Constructor compatibility scope: **main constructors only**.
16. Fluent/factory APIs are out of scope for v1.
17. Tricky field policy: support safe data subset; non-data forms require registry ID.
18. Validation contract is two-phase: `schema-valid` then `runtime-resolvable`.
19. Unknown-field rejection applies at root and nested objects (`additionalProperties: false`).
20. Flat IDs remain, with capability/type-scoped registry lookup per field.
21. Registry lifecycle is strict: `register -> freeze -> decode/encode`; post-freeze registration throws.
22. Registry implementation shape is two-type:
    - `RegistryBuilder<T>` is mutable and only used before freeze.
    - `FrozenRegistry<T>` is immutable/read-only and used during decode/encode.
23. Round-trip invariants follow canonical contract:
    - semantic object equality is required.
    - map equality is required only after canonicalization.
    - canonicalization omits null/absent optionals, normalizes enums to names, preserves registry IDs as strings, and ignores map key order.
24. Unsupported `schemaVersion` is a hard failure with stable error code `unsupported_schema_version`, path `schemaVersion`, and the received value.
25. Delivery structure policy (`I-A`): use a flatter package/file layout in `M1/M2`; introduce the full layered target structure in `M3/M4` as duplication boundaries become clear.

---

## 4) v1 Scope and Non-Goals

### In scope
- Main constructor params of target stylers.
- Bidirectional conversion:
  - `Map -> Ack validate/parse -> Mix Styler`
  - `Mix Styler -> Ack-shaped map`
- Strict payload validation.
- Registry-backed fields where raw serialization is unsafe/impossible.

### Explicit non-goals
- Fluent API compatibility (`.color()`, `.size()`, etc).
- Factory constructor pattern preservation (`BoxStyler.color(...)`).
- Recording constructor identity in payload.
- Building a custom schema DSL over Ack.

---

## 5) Canonical v1 Payload Contract
Top-level payload:

```json
{
  "schemaVersion": 1,
  "stylerType": "box",
  "data": { }
}
```

Rules:
- `schemaVersion`: required integer, currently only `1` accepted.
- Unsupported versions are rejected with code `unsupported_schema_version` at path `schemaVersion`, including the received value.
- `stylerType`: required discriminator for styler family, as a closed, case-sensitive enum.
- `data`: required object for that styler.
- Unknown fields rejected at top-level and nested schema objects.
- Any `stylerType` value outside the allowed set fails validation.
- Validation is two-phase:
  - Phase 1 (`schema-valid`): Ack parse/validate succeeds.
  - Phase 2 (`runtime-resolvable`): registry-backed refs resolve for required capabilities.
- Round-trip/test contract:
  - `decode(encode(obj))` must preserve semantic object equality.
  - `encode(decode(payload))` must equal canonicalized payload (not raw input map).

Allowed `stylerType` values:
- `box`
- `text`
- `flex`
- `icon`
- `image`
- `stack`
- `flexBox`
- `stackBox`

---

## 6) Suggested Package/File Structure

```text
packages/mix_schema/
  pubspec.yaml
  build.yaml
  lib/
    mix_schema.dart
    src/
      contracts/
        payload_contract.dart
        decode_error.dart
      registries/
        registry.dart
        registry_bundle.dart
        frozen_registry.dart
      schemas/
        primitives.dart
        enums.dart
        metadata/
          animation_schema.dart
          modifier_schema.dart
          variant_schema.dart
        dto/
          edge_insets_schema.dart
          constraints_schema.dart
          border_schema.dart
          shadow_schema.dart
          gradient_schema.dart
          decoration_schema.dart
          typography_schema.dart
          image_schema.dart
        stylers/
          box_styler_schema.dart
          text_styler_schema.dart
          flex_styler_schema.dart
          icon_styler_schema.dart
          image_styler_schema.dart
          stack_styler_schema.dart
          flexbox_styler_schema.dart
          stackbox_styler_schema.dart
        payload_schema.dart
      codecs/
        primitives_codec.dart
        dto_codec.dart
        metadata_codec.dart
        stylers_codec.dart
        payload_codec.dart
  test/
    contracts/
    schemas/
    codecs/
    integration/
```

Notes:
- Keep schemas and codecs separate.
- Keep helpers thin and reusable.
- Avoid introducing a DSL layer.
- This is the target end-state layout; implementation follows `I-A` with flatter `M1/M2` and staged split in `M3/M4`.
- Registry best practice here is class-based lifecycle control (`RegistryBuilder` + `FrozenRegistry`), not a `freezed` data class.

---

## 7) Styler Main Constructor Field Matrix (Source of Truth)
Reference files under `packages/mix/lib/src/specs/**/_style.dart`.

### 7.1 BoxStyler
- `alignment: AlignmentGeometry?`
- `padding: EdgeInsetsGeometryMix?`
- `margin: EdgeInsetsGeometryMix?`
- `constraints: BoxConstraintsMix?`
- `decoration: DecorationMix?`
- `foregroundDecoration: DecorationMix?`
- `transform: Matrix4?`
- `transformAlignment: AlignmentGeometry?`
- `clipBehavior: Clip?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<BoxSpec>>?`

### 7.2 TextStyler
- `overflow: TextOverflow?`
- `strutStyle: StrutStyleMix?`
- `textAlign: TextAlign?`
- `textScaler: TextScaler?`
- `maxLines: int?`
- `style: TextStyleMix?`
- `textWidthBasis: TextWidthBasis?`
- `textHeightBehavior: TextHeightBehaviorMix?`
- `textDirection: TextDirection?`
- `softWrap: bool?`
- `textDirectives: List<Directive<String>>?`
- `selectionColor: Color?`
- `semanticsLabel: String?`
- `locale: Locale?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<TextSpec>>?`

### 7.3 FlexStyler
- `direction: Axis?`
- `mainAxisAlignment: MainAxisAlignment?`
- `crossAxisAlignment: CrossAxisAlignment?`
- `mainAxisSize: MainAxisSize?`
- `verticalDirection: VerticalDirection?`
- `textDirection: TextDirection?`
- `textBaseline: TextBaseline?`
- `clipBehavior: Clip?`
- `spacing: double?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<FlexSpec>>?`

### 7.4 IconStyler
- `color: Color?`
- `size: double?`
- `weight: double?`
- `grade: double?`
- `opticalSize: double?`
- `shadows: List<ShadowMix>?`
- `textDirection: TextDirection?`
- `applyTextScaling: bool?`
- `fill: double?`
- `semanticsLabel: String?`
- `opacity: double?`
- `blendMode: BlendMode?`
- `icon: IconData?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<IconSpec>>?`

### 7.5 ImageStyler
- `image: ImageProvider<Object>?` (registry-backed)
- `width: double?`
- `height: double?`
- `color: Color?`
- `repeat: ImageRepeat?`
- `fit: BoxFit?`
- `alignment: AlignmentGeometry?`
- `centerSlice: Rect?`
- `filterQuality: FilterQuality?`
- `colorBlendMode: BlendMode?`
- `semanticLabel: String?`
- `excludeFromSemantics: bool?`
- `gaplessPlayback: bool?`
- `isAntiAlias: bool?`
- `matchTextDirection: bool?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<ImageSpec>>?`

### 7.6 StackStyler
- `alignment: AlignmentGeometry?`
- `fit: StackFit?`
- `textDirection: TextDirection?`
- `clipBehavior: Clip?`
- `animation: AnimationConfig?`
- `modifier: WidgetModifierConfig?`
- `variants: List<VariantStyle<StackSpec>>?`

### 7.7 FlexBoxStyler
Box + Flex constructor surface (combined):
- Box-like: `decoration`, `foregroundDecoration`, `padding`, `margin`, `alignment`, `constraints`, `transform`, `transformAlignment`, `clipBehavior`
- Flex-like: `direction`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, `verticalDirection`, `textDirection`, `textBaseline`, `flexClipBehavior`, `spacing`
- Metadata: `animation`, `modifier`, `variants`

### 7.8 StackBoxStyler
Box + Stack constructor surface (combined):
- Box-like: `decoration`, `foregroundDecoration`, `padding`, `margin`, `alignment`, `constraints`, `transform`, `transformAlignment`, `clipBehavior`
- Stack-like: `stackAlignment`, `fit`, `textDirection`, `stackClipBehavior`
- Metadata: `animation`, `modifier`, `variants`

---

## 8) Runtime/Registry-Backed Field Policy (Locked)
These cannot be safely encoded as plain data without a strategy.
Use registry IDs where needed.

Canonical registry scopes (case-sensitive):
- `image_provider`
- `animation_on_end`
- `modifier_shader`
- `modifier_clipper`
- `context_variant_builder`

Field-to-scope mapping (normative):

| Field | Scope |
|---|---|
| `ImageStyler.image` | `image_provider` |
| `AnimationConfig.onEnd` | `animation_on_end` |
| `Shader callback` modifier fields | `modifier_shader` |
| `CustomClipper` modifier fields | `modifier_clipper` |
| `ContextVariantBuilder.fn` | `context_variant_builder` |

ID uniqueness and collision policy:
- uniqueness is required per scope
- cross-scope ID collisions are allowed

### Definitely registry-backed
- `ImageProvider<Object>` fields (e.g. `ImageStyler.image`)
- `AnimationConfig.onEnd` callback (if present)
- `Shader callback` in modifiers
- `CustomClipper` in clip modifiers
- `ContextVariantBuilder.fn` (closure) in variants

### Tricky-type safe subset (Decision A = `B1`)
- `TextScaler`: support data-encodable subset; custom/non-standard forms require registry IDs.
- `Paint` and `GradientTransform`: support data-encodable subset; custom/runtime forms require registry IDs.
- Any value that is neither data-encodable nor registry-resolved is rejected.

Lookup policy (Decision D):
- payload holds string ID
- decode resolves via capability/type-scoped registry by field
- no global cross-registry namespace requirement
- missing ID => decode failure with path + missing ID
- missing/unknown mapping during encode => contract error with code `unknown_registry_id`, with path + missing ID
- encode must not silently skip unknown runtime values and must not throw raw framework exceptions by default
- decode and encode errors are aggregated using the shared error envelope
- registry lifecycle follows Decision `E-A`: register before freeze; decode/encode after freeze.
- decode/encode APIs should consume `FrozenRegistry` types to make runtime mutation impossible by interface.

---

## 9) Variants Strategy for v1
`variants` are in scope, but not all variant forms are equally serializable.

Supported v1 variant forms:
- `NamedVariant`
- `WidgetStateVariant` (as explicit state enum string)
- `ContextVariantBuilder` via registry ID

Rejected in v1:
- all other variant forms, including non-supported `ContextVariant` forms

---

## 10) Animation Strategy for v1
`AnimationConfig` is in scope.

Supported in v1:
- `CurveAnimationConfig` only
- fields: duration, curve (enum/string key), delay, optional `onEnd` registry ID

Deferred/rejected in v1 unless explicitly added later:
- phase animation branches
- keyframe animation branches
- spring animation branches

---

## 11) Modifier Strategy for v1
`WidgetModifierConfig` is in scope.

Supported in v1:
- serializable modifier mixes
- use discriminated schemas by modifier type
- runtime callback forms only via registry-backed refs

Must preserve:
- order semantics (`orderOfModifiers`)
- reset semantics where modeled

---

## 12) Error Contract
Decode and encode errors must provide:
- stable code
- field path
- readable message
- optional offending value (safe subset)

Collect all errors in one response.
Do not stop at first failure.
Path format is dot path with zero-based array indices (example: `data.variants[0].style.color`).
JSON Pointer is not used in v1.
Error ordering is deterministic: sort by `path` ascending, then `code` ascending.
Encode and decode must both use this same shape and ordering.
Encode must not silently skip unknown runtime values and must not throw raw framework exceptions by default.

Required shape:

```json
{
  "ok": false,
  "errors": [
    {
      "code": "unknown_field",
      "path": "data.padding.extra",
      "message": "Unknown field 'extra'",
      "value": 10
    }
  ]
}
```

Unsupported schema version example:

```json
{
  "ok": false,
  "errors": [
    {
      "code": "unsupported_schema_version",
      "path": "schemaVersion",
      "message": "Unsupported schemaVersion '2'; only '1' is supported in v1.",
      "value": 2
    }
  ]
}
```

Unknown runtime mapping during encode example:

```json
{
  "ok": false,
  "errors": [
    {
      "code": "unknown_registry_id",
      "path": "data.animation.onEnd",
      "message": "Unknown registry ID 'fade_done' in scope 'animation_on_end'.",
      "value": "fade_done"
    }
  ]
}
```

---

## 13) Execution Plan (Agent-Ready)

### M0 - Finalization Gate (must complete first)
Deliver a consistent implementation contract before coding starts.

Required:
1. Freeze remaining owner decisions in the decision log.
2. Keep handoff + decision log synchronized after each lock.
3. Remove all ambiguous "potentially supported" language.

### M1 - Spike (vertical slice)
Deliver one end-to-end slice proving the architecture.

Structure mode for M1 (`I-A`):
- keep files flatter/minimal to optimize learning velocity.
- do not force full directory decomposition yet.

Required:
1. Scaffold package dependencies and codegen.
2. Add primitive schema + codec.
3. Add one discriminated union schema + codec.
4. Add one styler schema (`box` preferred) + envelope parse.
5. Add registry plumbing with one concrete registry-backed field.
6. Add tests and demonstrate JSON schema export.

### M2 - DTO layer
Deliver DTO schemas/codecs needed by constructor fields.

Structure mode for M2 (`I-A`):
- continue flatter organization while DTO boundaries stabilize.
- prepare split points but defer major file tree expansion.

Required:
1. Layout DTOs (insets, constraints, geometry).
2. Painting DTOs (border, radius, shadow, gradient, decoration).
3. Typography DTOs (text style / strut / text height behavior).
4. Strict validation tests.

### M3 - Styler coverage
Deliver all 8 styler constructors in scope.

Structure mode for M3 (`I-A`):
- begin migration to the full layered target structure from Section 6.

Required:
1. Per-styler schema + codec.
2. Envelope dispatch by `stylerType`.
3. Metadata support (`animation`, `modifier`, `variants`) using v1 strategy.
4. Round-trip semantic tests per styler.

### M4 - Hardening
Deliver production-readiness.

Structure mode for M4 (`I-A`):
- complete remaining structural split and cleanup to match target architecture.

Required:
1. Error-path quality and consistency.
2. Registry freeze/collision/missing-ID tests.
3. Unsupported-case docs and explicit rejections.
4. Cleanup, naming consistency, import hygiene.

---

## 14) Definition of Done
Done means all are true:
1. `melos bootstrap` passes.
2. code generation passes.
3. test suite passes.
4. static analysis passes.
5. docs reflect actual behavior.
6. all M0 decisions are enforced in code/tests.

---

## 15) Commands

```bash
melos bootstrap
melos run gen:build
melos run ci
melos run analyze
```

---

## 16) Practical Guardrails For Next Agent
- Do not broaden scope into fluent/factory APIs.
- Keep payload contract strict (`additionalProperties: false` at root and nested objects).
- Prefer explicit codec code over clever generic metaprogramming.
- Add helper abstractions only when duplication is repeated and obvious.
- If a field cannot be represented safely, reject with explicit path/reason.

---

## 17) Source References (for implementation)
Styler constructors live at:
- `packages/mix/lib/src/specs/box/box_style.dart`
- `packages/mix/lib/src/specs/text/text_style.dart`
- `packages/mix/lib/src/specs/flex/flex_style.dart`
- `packages/mix/lib/src/specs/icon/icon_style.dart`
- `packages/mix/lib/src/specs/image/image_style.dart`
- `packages/mix/lib/src/specs/stack/stack_style.dart`
- `packages/mix/lib/src/specs/flexbox/flexbox_style.dart`
- `packages/mix/lib/src/specs/stackbox/stackbox_style.dart`

Metadata models:
- `packages/mix/lib/src/animation/animation_config.dart`
- `packages/mix/lib/src/modifiers/widget_modifier_config.dart`
- `packages/mix/lib/src/variants/variant.dart`

---

## 18) Immediate First Task (if agent starts now)
Implement M1 only, with this acceptance check:
- Parse payload for `box` styler with strict validation.
- Resolve one registry-backed field.
- Encode decoded object back to canonical map.
- Tests prove semantic round-trip and all-error reporting.
