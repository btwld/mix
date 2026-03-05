# mix_schema v1 — Implementation Plan

**Version:** 14.0.0 | **Date:** 2026-03-05 | **Owner:** Mix 2.0 team

---

## 1) Purpose

`mix_schema` bridges external UI payloads (AI agents, server-driven UI, design tooling) into Mix-powered Flutter UI through a deterministic, validated pipeline. Decoded payloads feed into the standard Mix pipeline: **Styler → Spec → Widget**.

The package provides:

- **Decode:** payload `Map` → Ack-validated → `.transform()` → Mix types directly (Mix constructors handle `Prop` wrapping internally).
- **Validation:** aggregated, path-based errors with deterministic ordering.
- **Registry:** runtime-only values (callbacks, providers, builders) referenced by string ID.

v1 is **decode-only**. Encode (Mix → JSON) is out of scope and will be designed independently when needed.

## 2) Architecture

Build on Ack as the primary decode engine. Ack handles schema validation (strict objects, enums, discriminated unions, parse/safeParse, unknown-field rejection) and the decode conversion layer via `.transform()`. Write custom code only for registry resolution and error mapping.

No custom schema DSL. No separate codec layer. Define each schema once, reference everywhere. Prefer schema-with-transform over intermediate types.

### Wire identifier naming convention

Three rules:

**JSON field names use camelCase** (standard JSON convention): `type`, `clipBehavior`, `minWidth`, `textDirection`.

**Wire `type` values are snake_case of the Flutter/Mix class name.** This is a derivation, not an invention. Take the class name, convert to snake_case, and apply one suffix rule:

- **Flutter classes:** snake_case the full name. `LinearGradient` → `linear_gradient`. `RoundedRectangleBorder` → `rounded_rectangle_border`. `EdgeInsetsDirectional` → `edge_insets_directional`.
- **Mix Styler classes:** drop the `Styler` suffix (it's a Mix implementation detail, not meaningful on the wire). `BoxStyler` → `box`. `FlexBoxStyler` → `flex_box`.
- **Mix Variant classes:** drop the `Variant` suffix. `NamedVariant` → `named`. `WidgetStateVariant` → `widget_state`. Context variant factories use the factory name: `ContextVariant.brightness()` → `context_brightness`, `ContextVariant.breakpoint()` → `context_breakpoint`. Two semantic aliases exist: `enabled` (canonical shorthand for `not(disabled)`) and `context_not_widget_state` (composite operation, no single class).
- **Mix ModifierMix classes:** drop the `ModifierMix` suffix. `BlurModifierMix` → `blur`. `OpacityModifierMix` → `opacity`. `DefaultTextStyleModifierMix` → `default_text_style`.
- **Variant types with qualifiers:** `{base}_{qualifier}` following the class structure. `text_scaler_linear` (future class `TextScalerLinear`).

This convention applies to all `type` discriminator values: stylers, variants, modifiers, gradients, decorations, borders, edge insets, border radius, shape borders, and text scalers. It also applies to registry scope names and error codes.

Flutter enum values on the wire use Dart's `.name` output (camelCase for multi-word enums like `spaceBetween`, `hardEdge`). This is controlled by `Ack.enumValues()` and matches how Dart serializes enums.

### Ack-native decode pipeline

Schema validates shape, types, enums, and rejects unknown fields. `.refine()` handles cross-field constraints. `.transform()` converts validated data directly into Mix types (`EdgeInsetsMix`, `BoxDecorationMix`, `BoxStyler`, etc.). No intermediate DTO layer. Mix's main constructors already take plain values and handle `Prop.maybe()` / `Prop.maybeMix()` wrapping internally, so `.transform()` targets these constructors directly.

### Two-phase validation

**Phase 1 — schema-valid:** Ack validates shape, types, enums, unknown-field rejection, cross-field refinements.

**Phase 2 — runtime-resolvable:** resolve registry-backed values during `.transform()`. Missing registry IDs surface as `SchemaTransformError` with path context.

Errors from both phases are aggregated into one response.

## 3) Scope

**In scope (v1):**

- Decode (Ack-native) for built-in styler families.
- Custom styler registration (developers manually register decode schema).
- Strict validation at root and nested levels (Ack strict-by-default).
- Two-phase validation.
- Metadata: animation (v1 subset), modifiers (serializable + registry-backed), variants (v1 subset).
- Registry-backed runtime references (forward lookup only).

**Out of scope (v1):**

- Encode (Mix → JSON). Will be designed independently when needed.
- Codegen for custom styler schemas (decide post-v1).
- Fluent APIs (`.color()`, `.size()`).
- Factory constructor compatibility.
- Custom schema DSL.

---

## 4) Payload Contract

```json
{
  "type": "box",
  "padding": { "top": 10, "left": 20 },
  "decoration": {
    "type": "box_decoration",
    "color": 4294198070
  }
}
```

`type` is required. No `schemaVersion` field in v1. Absence of the field means v1. When v2 ships, presence of a `schemaVersion` field will distinguish versions.

`type` is a string discriminator matching a registered styler. Unknown values fail with an enum-style error listing valid options at path `#/type`.

Styler fields sit inline next to `type`. No `data` wrapper. This makes root payloads structurally identical to every nested discriminated type (gradients, decorations, variants, modifiers, borders, etc.).

Unknown fields rejected at root and nested levels (Ack strict-by-default).

### Payload dispatch via discriminated schema

The payload schema uses `Ack.discriminated()` with `type` as the discriminator key. Built automatically at freeze time from all registered stylers:

```dart
// Built automatically by StylerRegistry.freeze()
final payloadSchema = Ack.discriminated(
  discriminatorKey: 'type',
  schemas: registry.normalizedSchemas,
);
```

`mix_schema` owns discriminator literal injection. Before freeze, each branch is normalized through an internal discriminated-branch registry that injects `'type': Ack.literal(key)` into the underlying object-backed schema while preserving any `.transform()` wrappers. Ack then handles discriminated dispatch over the normalized branches. The same internal mechanism is used for stylers and all static discriminated families (gradients, decorations, borders, edge insets, border radius, shape borders, variants, modifiers, and text scalers).

Single `safeParse()` call validates the full payload. Ack handles:

- Missing `type` → `required_field` at `#/type`
- Unknown `type` → enum error listing valid options at `#/type`
- Invalid fields → errors at `#/<fieldName>` with correct paths (no `data/` prefix)

No manual dispatch code. No two-step parsing. No `@AckType`.

### Built-in styler IDs

These ship as default registrations: `box`, `text`, `flex`, `icon`, `image`, `stack`, `flex_box`, `stack_box`.

Custom stylers register alongside these using the same API. Registration happens before freeze.

## 5) Error Contract

```json
{
  "ok": false,
  "errors": [
    {
      "code": "<stable_code>",
      "path": "<json_pointer>",
      "message": "<human_readable>",
      "value": "<optional_offending_value>"
    }
  ]
}
```

**Path format:** JSON Pointer (RFC 6901), matching Ack's native output (e.g., `#/variants/0/style/color`). No custom path formatting.

**Ordering:** sort by `path` ascending, then `code` ascending.

**Aggregated:** collect all errors, no fail-fast.

### Stable error codes (v1)

| Code                     | When                                                                                |
| ------------------------ | ----------------------------------------------------------------------------------- |
| `type_mismatch`          | Value is wrong type (Ack `TypeMismatchError`)                                       |
| `required_field`         | Required field missing (Ack `ObjectRequiredPropertiesConstraint`)                   |
| `unknown_field`          | Unrecognized field at any level (Ack strict-by-default)                             |
| `invalid_enum`           | Enum value not in allowed set (Ack `EnumConstraint`)                                |
| `constraint_violation`   | Other constraint failure (min, max, pattern, etc.)                                  |
| `validation_failed`      | `.refine()` cross-field check failed                                                |
| `transform_failed`       | `.transform()` threw (includes registry lookup failures)                            |
| `unknown_type`           | `type` value not in registered set (Ack discriminated schema handles this natively) |
| `unknown_registry_id`    | Registry ID not found in scope                                                      |
| `unsupported_value_type` | Field value not representable in v1                                                 |

### Error code mapping from Ack

Every Ack error type maps deterministically to a stable v1 code. No gaps, no passthrough.

| Ack error type           | v1 code                  | How to detect                                                         |
| ------------------------ | ------------------------ | --------------------------------------------------------------------- |
| `TypeMismatchError`      | `type_mismatch`          | Direct type check                                                     |
| `SchemaConstraintsError` | `unknown_type`           | Constraint is `EnumConstraint` AND path is a discriminator `type` key |
| `SchemaConstraintsError` | `invalid_enum`           | Constraint is `EnumConstraint` (all other paths)                      |
| `SchemaConstraintsError` | `required_field`         | Constraint is `ObjectRequiredPropertiesConstraint`                    |
| `SchemaConstraintsError` | `unknown_field`          | Constraint is `ObjectNoAdditionalPropertiesConstraint`                |
| `SchemaConstraintsError` | `constraint_violation`   | All other constraint types                                            |
| `SchemaValidationError`  | `validation_failed`      | Refine failures                                                       |
| `SchemaTransformError`   | `unknown_registry_id`    | Inner exception is `RegistryLookupError`                              |
| `SchemaTransformError`   | `unsupported_value_type` | Inner exception is `UnsupportedValueError`                            |
| `SchemaTransformError`   | `transform_failed`       | All other transform failures                                          |
| `SchemaNestedError`      | (unwrap children)        | Recursively map each child error                                      |

**Discriminator path detection:** The mapping layer checks whether an `EnumConstraint` error falls on a `type` key inside a discriminated schema. If so, it promotes `invalid_enum` to `unknown_type` for clearer diagnostics. This is the only promotion rule.

**Custom transform exceptions:** mix_schema defines two exception types thrown inside `.transform()` callbacks:

```dart
/// Thrown when a registry lookup fails during transform.
class RegistryLookupError implements Exception {
  final String scope;
  final String id;
  RegistryLookupError(this.scope, this.id);
}

/// Thrown when a field value isn't representable in v1.
class UnsupportedValueError implements Exception {
  final String reason;
  UnsupportedValueError(this.reason);
}
```

Ack wraps these as `SchemaTransformError` with path context. The mapping layer inspects the inner exception type to select the correct v1 code.

## 6) Registry Contract

Some Mix values are runtime-only (closures, `ImageProvider`, custom clippers, etc.) and can't be serialized. The registry maps string IDs to these values.

### Lifecycle

`register → freeze → decode`

Post-freeze registration throws. Post-freeze mutation throws. All decode operations consume frozen registries.

### Implementation shape

`RegistryBuilder<T>` — mutable API used during bootstrap.
`FrozenRegistry<T>` — immutable API used during decode.

### Registry type

**Value registries** (forward lookup only):

- `register(id, value)` — maps string ID to runtime value.
- `lookup(id) → T?` — returns value or null (null triggers `unknown_registry_id`).
- ID uniqueness required per scope.

v1 is decode-only, so reverse lookup is not needed.

### Scopes (case-sensitive, fixed)

| Field                           | Scope                     |
| ------------------------------- | ------------------------- |
| `ImageStyler.image`             | `image_provider`          |
| `AnimationConfig.onEnd`         | `animation_on_end`        |
| Shader callback modifier fields | `modifier_shader`         |
| CustomClipper modifier fields   | `modifier_clipper`        |
| `ContextVariantBuilder.fn`      | `context_variant_builder` |

### Styler registry

Separate from value registries. Maps `type` strings to Ack schemas with `.transform()`.

- Built-in stylers registered at package init.
- Custom stylers registered by the developer before freeze.
- Same lifecycle: `register → freeze → use`.
- `freeze()` auto-builds a discriminated schema from all registrations and asserts global `type` value uniqueness. This schema handles dispatch, validation, and unknown `type` detection in a single pass.

```dart
class StylerRegistry {
  final _branches = DiscriminatedBranchRegistry(
    discriminatorKey: 'type',
  );
  late final AckSchema _payloadSchema;
  bool _frozen = false;

  void register<T extends Object>(String type, AckSchema<T> stylerSchema) {
    if (_frozen) throw StateError('Registry is frozen');
    // Developer passes schema without 'type' literal.
    _branches.register(type, stylerSchema);
  }

  void freeze() {
    _frozen = true;
    _assertGlobalTypeUniqueness();
    _payloadSchema = _branches.freeze();
  }

  SchemaResult decode(Map<String, Object?> payload) {
    return _payloadSchema.safeParse(payload);
  }
}
```

`DiscriminatedBranchRegistry` is internal to `mix_schema`. It owns discriminator injection, preserves transform chains, and exposes the normalized schema map consumed by `Ack.discriminated()`. The public styler API stays schema-based; there is no public `fields + transform` registration signature.

## 7) Global Type Namespace

All `type` discriminator values share a single flat namespace. Every value must be unique across all discriminated schemas. `freeze()` scans all registered discriminated schemas and asserts uniqueness. Collision throws `StateError` with both conflicting categories.

| Category            | Values                                                                                                                                                                                  |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Stylers             | `box`, `text`, `flex`, `icon`, `image`, `stack`, `flex_box`, `stack_box`                                                                                                                |
| Variants            | `named`, `widget_state`, `context_brightness`, `context_breakpoint`, `context_not_widget_state`, `enabled`, `context_variant_builder`                                                   |
| Modifiers           | `blur`, `opacity`, `align`, `padding`, `visibility`, `scale`, `rotate`, `default_text_style`, `reset`, (registry-backed modifiers use registry IDs, not `type` values)                  |
| Gradients           | `linear_gradient`, `radial_gradient`, `sweep_gradient`                                                                                                                                  |
| Gradient transforms | `gradient_rotation`, `tailwind_css_angle_rect`                                                                                                                                          |
| Decorations         | `box_decoration`, `shape_decoration`                                                                                                                                                    |
| Borders             | `border`, `border_directional`                                                                                                                                                          |
| Edge Insets         | `edge_insets`, `edge_insets_directional`                                                                                                                                                |
| Border Radius       | `border_radius`, `border_radius_directional`                                                                                                                                            |
| Shape Borders       | `rounded_rectangle_border`, `circle_border`, `stadium_border`, `beveled_rectangle_border`, `continuous_rectangle_border`, `star_border`, `linear_border`, `rounded_superellipse_border` |
| Text Scalers        | `text_scaler_linear`                                                                                                                                                                    |

No collisions in current set. All wire values follow the "snake_case the Flutter class name" convention, which naturally avoids collisions (e.g., `LinearGradient` → `linear_gradient`, `LinearBorder` → `linear_border`, `TextScaler` linear variant → `text_scaler_linear`).

## 8) Metadata Policy (v1)

### Animation

`CurveAnimationConfig` only: duration, curve (enum/string key), delay, optional `onEnd` registry ID.

Phase, keyframe, and spring branches deferred to post-v1.

### Variants

**Supported:**

- `NamedVariant` (string name)
- `WidgetStateVariant` (enum name)
- `context_brightness`
- `context_breakpoint`
- `context_not_widget_state` (scoped, non-recursive, excludes `disabled`)
- `enabled` (canonical alias for `not(disabled)`)
- `ContextVariantBuilder` via registry ID only (stores a closure, can't be serialized)

All other variant forms rejected.

**Typing rules:** generic helpers use matching `Spec` + `Style` pair. Nested callbacks return style objects, not `Spec`. `ContextVariantBuilder` callback type enforced at runtime for the active styler family.

### Modifiers

v1 serializable allowlist: `blur`, `opacity`, `visibility`, `align`, `padding`, `scale`, `rotate`, `default_text_style`, `reset`. All other modifier forms (clip variants, shader mask, flexible, sized box, aspect ratio, intrinsic dimensions, fractionally sized box, rotated box, transform) require runtime callbacks or complex types and are supported only via registry-backed refs.

`orderOfModifiers` is an optional list of `type` strings controlling render order. If omitted, Mix's default order applies.

## 9) Locked Wire Shapes

### Variant branches

Implemented through the internal discriminated-branch registry, which normalizes each branch and then freezes to `Ack.discriminated(discriminatorKey: 'type', schemas: {...})`. Each branch still uses `.transform()`.

**named:**

```json
{"type": "named", "name": "<string>", "style": {...}}
```

**widget_state:**

```json
{"type": "widget_state", "state": "<WidgetState>", "style": {...}}
```

`state` is a `WidgetState` enum value (e.g., `pressed`, `hovered`, `focused`, `disabled`).

**enabled:**

```json
{"type": "enabled", "style": {...}}
```

Canonical alias for `not(disabled)`. No `state` field needed since the semantic is fixed.

**context_variant_builder:**

```json
{ "type": "context_variant_builder", "id": "<registry_id>" }
```

`id` is a registry-backed string resolved from scope `context_variant_builder`. The builder closure produces the style dynamically from `BuildContext` at runtime. No `style` field: the entire style comes from the closure, not the payload.

**context_brightness:**

```json
{"type": "context_brightness", "brightness": "dark|light", "style": {...}}
```

**context_breakpoint:**

```json
{
  "type": "context_breakpoint",
  "minWidth": "<double|null>",
  "maxWidth": "<double|null>",
  "minHeight": "<double|null>",
  "maxHeight": "<double|null>",
  "style": {...}
}
```

At least one dimension constraint must be non-null. Enforced via `.refine()`:

```dart
.refine(
  (data) =>
    data['minWidth'] != null || data['maxWidth'] != null ||
    data['minHeight'] != null || data['maxHeight'] != null,
  message: 'At least one dimension constraint required',
)
```

Token-backed breakpoint forms are not supported in v1. The wire shape only accepts literal dimension values.

**context_not_widget_state:**

```json
{"type": "context_not_widget_state", "state": "<WidgetState>", "style": {...}}
```

`state` excludes `disabled` in v1. Use `enabled` for `not(disabled)`.

### Modifier branches

Implemented through the same internal discriminated-branch registry on `type`. The `modifier` field on each styler accepts a modifier config object with `modifiers` (ordered list) and optional `orderOfModifiers`.

**Modifier config wire shape:**

```json
{
  "modifiers": [
    { "type": "blur", "sigma": 5.0 },
    { "type": "opacity", "value": 0.8 }
  ],
  "orderOfModifiers": ["opacity", "blur"]
}
```

`modifiers` is a list of discriminated modifier objects. `orderOfModifiers` is an optional list of modifier `type` strings controlling render order. If omitted, Mix's default order applies. Unknown entries in `orderOfModifiers` (values not matching any registered modifier `type`) are silently ignored, matching Mix's runtime behavior where `reorderModifiers` skips types not present in the active modifier list. No error is emitted for unknown entries since `orderOfModifiers` is a preference hint, not a strict contract.

**v1 serializable modifier allowlist:**

**reset:**

```json
{ "type": "reset" }
```

Clears all previously merged modifiers from the list. No fields. When encountered during merge, all modifiers before the reset are discarded. Derived from `ResetModifierMix`.

**blur:**

```json
{ "type": "blur", "sigma": "<double|null>" }
```

**opacity:**

```json
{ "type": "opacity", "value": "<double|null>" }
```

**visibility:**

```json
{ "type": "visibility", "visible": "<bool>" }
```

**align:**

```json
{
  "type": "align",
  "alignment": "<Alignment|null>",
  "widthFactor": "<double|null>",
  "heightFactor": "<double|null>"
}
```

**padding:**

```json
{ "type": "padding", "padding": "<EdgeInsets object|null>" }
```

**scale:**

```json
{
  "type": "scale",
  "x": "<double>",
  "y": "<double>",
  "alignment": "<Alignment|null>"
}
```

**rotate:**

```json
{ "type": "rotate", "radians": "<double>", "alignment": "<Alignment|null>" }
```

**default_text_style:**

```json
{
  "type": "default_text_style",
  "style": "<TextStyle object|null>",
  "textAlign": "<TextAlign|null>",
  "softWrap": "<bool|null>",
  "overflow": "<TextOverflow|null>",
  "maxLines": "<int|null>",
  "textWidthBasis": "<TextWidthBasis|null>",
  "textHeightBehavior": "<TextHeightBehavior object|null>"
}
```

### Text transform

```json
{ "textTransform": "uppercase|lowercase|capitalize|titleCase|sentenceCase" }
```

`textDirectives` is non-wire. Payloads containing `textDirectives` are rejected as `unknown_field`.

### Text style shadows

```json
{ "shadows": ["<shadow object>", "..."] }
```

### Gradient transform

```json
{
  "type": "tailwind_css_angle_rect",
  "direction": "to-r|to-l|to-t|to-b|to-tr|to-tl|to-br|to-bl"
}
```

Existing `gradient_rotation` also supported.

## 10) Locked Primitive Wire Formats

Each primitive type has exactly one canonical wire representation. Locked before M1 starts.

| Type                | Wire format                                                                              | Example                                              |
| ------------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `Color`             | Integer (0xAARRGGBB)                                                                     | `4294198070`                                         |
| `Offset`            | `{"dx": <double>, "dy": <double>}`                                                       | `{"dx": 1.0, "dy": 2.0}`                             |
| `Radius`            | `{"x": <double>, "y": <double>}`                                                         | `{"x": 8.0, "y": 8.0}`                               |
| `Radius` (circular) | `{"x": <double>}` (y defaults to x)                                                      | `{"x": 8.0}`                                         |
| `Rect`              | `{"left": <double>, "top": <double>, "right": <double>, "bottom": <double>}`             | `{"left": 0, "top": 0, "right": 100, "bottom": 100}` |
| `Alignment`         | `{"x": <double>, "y": <double>}`                                                         | `{"x": -1.0, "y": -1.0}`                             |
| `Size`              | `{"width": <double>, "height": <double>}`                                                | `{"width": 100, "height": 50}`                       |
| `BorderSide`        | `{"color": <int>, "width": <double>, "style": "<BorderStyle>", "strokeAlign": <double>}` | All fields optional                                  |
| `Shadow`            | `{"color": <int>, "offset": <Offset>, "blurRadius": <double>}`                           | All fields optional                                  |
| `BoxShadow`         | Shadow + `"spreadRadius": <double>`                                                      | All fields optional                                  |

Color uses integer format because it's unambiguous, round-trips without precision loss, and matches Flutter's `Color(int value)` constructor directly.

## 11) Tricky-Field Policy

| Field                        | v1 Rule                                                                                                                                                                           |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TextScaler`                 | Discriminated, linear-only in v1: `{"type":"text_scaler_linear","factor":<double>}`. Future scaler types (e.g., step) added as new branches using `text_scaler_{variant}` naming. |
| `Locale`                     | See Locale wire format below.                                                                                                                                                     |
| `TextStyler.textDirectives`  | Non-wire. Only `textTransform` enum mapped. Payload `textDirectives` rejected as `unknown_field`.                                                                                 |
| `IconStyler.icon` (IconData) | Rejected in v1 → `unsupported_value_type` with path.                                                                                                                              |
| `ImageStyler.image`          | Registry-backed, scope `image_provider`.                                                                                                                                          |
| Paint / GradientTransform    | Only `gradient_rotation` and `tailwind_css_angle_rect`. Others rejected → `unsupported_value_type`.                                                                               |
| Breakpoint (token-backed)    | Rejected in v1. Only literal dimension values supported.                                                                                                                          |

**Locale wire format:**

```json
{"languageCode": "en", "countryCode": "US"}
{"languageCode": "ja", "countryCode": null}
```

Both fields must be present in the payload. `languageCode` is a required string. `countryCode` is a required field that accepts null (Ack `.nullable()`). Omitting `countryCode` entirely is an error (Ack `.nullable()` is not the same as `.optional()`).

## 12) Styler Field Matrix

Reference sources: `packages/mix/lib/src/specs/**/_style.dart`

### BoxStyler

`alignment`, `padding`, `margin`, `constraints`, `decoration`, `foregroundDecoration`, `transform`, `transformAlignment`, `clipBehavior`, `animation`, `modifier`, `variants`

### TextStyler

`overflow`, `strutStyle`, `textAlign`, `textScaler`, `maxLines`, `style`, `textWidthBasis`, `textHeightBehavior`, `textDirection`, `softWrap`, `textDirectives`, `selectionColor`, `semanticsLabel`, `locale`, `animation`, `modifier`, `variants`

### FlexStyler

`direction`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, `verticalDirection`, `textDirection`, `textBaseline`, `clipBehavior`, `spacing`, `animation`, `modifier`, `variants`

### IconStyler

`color`, `size`, `weight`, `grade`, `opticalSize`, `shadows`, `textDirection`, `applyTextScaling`, `fill`, `semanticsLabel`, `opacity`, `blendMode`, `icon`, `animation`, `modifier`, `variants`

### ImageStyler

`image`, `width`, `height`, `color`, `repeat`, `fit`, `alignment`, `centerSlice`, `filterQuality`, `colorBlendMode`, `semanticLabel`, `excludeFromSemantics`, `gaplessPlayback`, `isAntiAlias`, `matchTextDirection`, `animation`, `modifier`, `variants`

### StackStyler

`alignment`, `fit`, `textDirection`, `clipBehavior`, `animation`, `modifier`, `variants`

### FlexBoxStyler

Box fields: `decoration`, `foregroundDecoration`, `padding`, `margin`, `alignment`, `constraints`, `transform`, `transformAlignment`, `clipBehavior`
Flex fields: `direction`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, `verticalDirection`, `textDirection`, `textBaseline`, `flexClipBehavior`, `spacing`
Metadata: `animation`, `modifier`, `variants`

### StackBoxStyler

Box fields: `decoration`, `foregroundDecoration`, `padding`, `margin`, `alignment`, `constraints`, `transform`, `transformAlignment`, `clipBehavior`
Stack fields: `stackAlignment`, `fit`, `textDirection`, `stackClipBehavior`
Metadata: `animation`, `modifier`, `variants`

## 13) Composite Styler Pattern

`FlexBoxStyler` composes a `BoxStyler` and a `FlexStyler` internally using `Prop.maybeMix(...)`. `StackBoxStyler` composes `BoxStyler` and `StackStyler` the same way.

### Wire key collision handling

Composite stylers have overlapping field names between their component groups. The wire schema uses prefixed keys matching the actual Mix constructors:

**FlexBoxStyler collisions:**

- `clipBehavior` → box clip
- `flexClipBehavior` → flex clip
- `textDirection` → flex only (BoxStyler has no `textDirection`)

**StackBoxStyler collisions:**

- `alignment` → box alignment
- `stackAlignment` → stack alignment
- `clipBehavior` → box clip
- `stackClipBehavior` → stack clip
- `textDirection` → stack only (BoxStyler has no `textDirection`)

### Decode: explicit composite schemas

Composite schemas are written explicitly with prefixed wire keys. Field group maps (`_boxFields`, `_flexFields`, `_stackFields`) are used only for standalone styler schemas where no collisions exist.

```dart
// Standalone: spreads work fine
final boxStylerSchema = Ack.object({
  ..._boxFields,
  ...buildMetadataFields(boxFieldsSchema),
}).transform<BoxStyler>((data) => BoxStyler(...));

// Composite: explicit, no spread collision risk
final flexBoxStylerSchema = Ack.object({
  // Box fields
  'padding': edgeInsetsSchema.optional(),
  'margin': edgeInsetsSchema.optional(),
  'decoration': decorationSchema.optional(),
  'clipBehavior': clipSchema.optional(),
  // Flex fields (prefixed where collision exists)
  'direction': axisSchema.optional(),
  'flexClipBehavior': clipSchema.optional(),
  'spacing': Ack.double().optional(),
  // Metadata
  ...buildMetadataFields(flexBoxFieldsSchema),
  // ... all fields listed explicitly
}).transform<FlexBoxStyler>((data) => FlexBoxStyler(
  padding: data?['padding'] as EdgeInsetsGeometryMix?,
  clipBehavior: data?['clipBehavior'] as Clip?,
  direction: data?['direction'] as Axis?,
  flexClipBehavior: data?['flexClipBehavior'] as Clip?,
  // ...
));
```

## 14) Variant Schema Cycle Resolution

Most variant branches contain a nested `style` field that itself must be validated as a styler schema (exception: `context_variant_builder`, which has no `style` field since the closure produces the style at runtime). This creates a dependency cycle for the branches that do: `variantSchema` → styler schema → metadata fields → `variantSchema`.

### Solution: two-phase construction with fields-only style schema

The cycle breaks by separating each styler into two schemas: a **fields-only schema** (visual properties only, no metadata) and the **full styler schema** (fields + metadata). Variant nested styles validate against the fields-only schema, making them leaf nodes that can't contain further variants, modifiers, or animation.

```dart
// Phase 1: fields-only schema (no metadata, no cycle)
final boxFieldsSchema = Ack.object({
  ..._boxFields,
}).transform<BoxStyler>((data) => BoxStyler(...));

// Phase 2: full styler schema (fields + metadata referencing fields-only)
final boxStylerSchema = Ack.object({
  ..._boxFields,
  ...buildMetadataFields(boxFieldsSchema),
}).transform<BoxStyler>((data) => BoxStyler(...));
```

The variant factory receives the fields-only schema as input:

```dart
/// Builds a variant discriminated schema for a specific styler.
/// Called once per styler during registration, breaking the static cycle.
AckSchema buildVariantSchema(AckSchema styleSchema) {
  final brightnessSchema = Ack.object({
    'brightness': Ack.enumValues(Brightness.values),
    'style': styleSchema,
  }).transform<ContextBrightnessVariant>((data) => ...);

  final breakpointSchema = Ack.object({
    'minWidth': Ack.double().nullable(),
    'maxWidth': Ack.double().nullable(),
    'minHeight': Ack.double().nullable(),
    'maxHeight': Ack.double().nullable(),
    'style': styleSchema,
  }).refine(
    (data) =>
      data['minWidth'] != null || data['maxWidth'] != null ||
      data['minHeight'] != null || data['maxHeight'] != null,
    message: 'At least one dimension constraint required',
  ).transform<ContextBreakpointVariant>((data) => ...);

  // ... other branches

  final registry = DiscriminatedBranchRegistry(
    discriminatorKey: 'type',
  );

  registry.register('named', namedSchema);
  registry.register('widget_state', widgetStateSchema);
  registry.register('enabled', enabledSchema);
  registry.register('context_variant_builder', contextVariantBuilderSchema);
  registry.register('context_brightness', brightnessSchema);
  registry.register('context_breakpoint', breakpointSchema);
  registry.register('context_not_widget_state', notWidgetStateSchema);

  return registry.freeze();
}
```

Each styler registration builds its own variant schema by passing its own style schema to `buildVariantSchema()`. The metadata field group uses this factory:

```dart
/// Builds metadata fields for a specific styler schema.
Map<String, AckSchema> buildMetadataFields(AckSchema styleSchema) => {
  'animation': animationConfigSchema.optional(),
  'modifier': modifierConfigSchema.optional(),
  'variants': Ack.list(buildVariantSchema(styleSchema)).optional(),
};
```

This means `_metadataFields` becomes `buildMetadataFields(styleSchema)` — a function call, not a constant. The cycle is broken because the variant schema doesn't exist until a specific styler schema is passed in. Modifiers, gradients, decorations, borders, edge insets, border radius, shape borders, and text scalers use the same internal branch registry pattern when their discriminated schemas are built.

## 15) Package Structure (Target)

```
packages/mix_schema/
  lib/
    mix_schema.dart
    src/
      contracts/
        payload_contract.dart
        error_mapping.dart
      registries/
        registry.dart
        registry_bundle.dart
        frozen_registry.dart
        styler_registry.dart
      schemas/
        enums.dart              # Layer 0: all enum schemas
        primitives.dart         # Layer 1: color, offset, radius, rect, alignment
        layout.dart             # Layer 2: edgeInsets, boxConstraints
        painting.dart           # Layer 2-4: borderSide → boxBorder → gradient → boxDecoration
        typography.dart         # Layer 2-3: textHeightBehavior, locale, textScaler, strutStyle, textStyle
        metadata.dart           # Layer 5: animation, modifier, variant schema factory
        field_groups.dart       # Layer 6: _boxFields, _flexFields, _stackFields
        stylers.dart            # Layer 7: all 8 styler schemas
        payload_schema.dart     # Payload types and decode entry point
  test/
    contracts/
    schemas/
    registries/
    integration/
```

Key structural decisions:

- **No `encode/` directory.** v1 is decode-only.
- Schema files organized by dependency layer from Section 17.
- `metadata.dart` exports `buildVariantSchema()` and `buildMetadataFields()` factory functions instead of constants (Section 14).
- `field_groups.dart` holds constant maps for standalone stylers. Composite stylers define fields explicitly in `stylers.dart`.

M1/M2 use a flatter layout. Migrate toward this in M3/M4 when boundaries are clear.

## 16) Implementation Patterns

### Pattern A — Every type ships as Schema-with-Transform + Tests

**Decode:** Ack schema with `.transform()` that produces the Mix type directly. No separate decode function. No intermediate types. Mix's main constructors handle `Prop` wrapping internally.

Nested Mix types (e.g., `EdgeInsetsMix`) transform to the Mix type:

```dart
final edgeInsetsSchema = Ack.object({
  'top': Ack.double().optional(),
  'bottom': Ack.double().optional(),
  'left': Ack.double().optional(),
  'right': Ack.double().optional(),
}).transform<EdgeInsetsMix>((data) => EdgeInsetsMix(
  top: data?['top'] as double?,
  bottom: data?['bottom'] as double?,
  left: data?['left'] as double?,
  right: data?['right'] as double?,
));
```

Styler-level schemas compose nested schemas (all from the reusable catalog in Section 17) and transform to the styler type. The schema itself contains only the styler's own fields; the internal discriminated-branch registry injects the `type` literal later when the schema is registered (see Sections 4 and 6):

```dart
final boxStylerSchema = Ack.object({
  ..._boxFields,
  ...buildMetadataFields(boxFieldsSchema),
}).transform<BoxStyler>((data) => BoxStyler(
  alignment: data?['alignment'] as AlignmentGeometry?,
  padding: data?['padding'] as EdgeInsetsGeometryMix?,
  margin: data?['margin'] as EdgeInsetsGeometryMix?,
  constraints: data?['constraints'] as BoxConstraintsMix?,
  decoration: data?['decoration'] as DecorationMix?,
  clipBehavior: data?['clipBehavior'] as Clip?,
));
```

**Tests:** valid input, `unknown_field`, `invalid_enum`, `type_mismatch`, transform errors, nested validation errors.

### Pattern B — Registry-backed field

Wire: `"field": "some_id"`.

Decode: schema validates the field as `Ack.string()`. The enclosing object's `.transform()` resolves the ID through the registry. Missing → throw error (Ack wraps as `SchemaTransformError` with path), mapped to `unknown_registry_id`.

### Pattern C — Discriminated unions (variants/modifiers)

Wire: `{"type": "...", ...}`.

Each branch is registered through the internal discriminated-branch registry, which injects the `type` literal and then freezes the family to `Ack.discriminated(discriminatorKey: 'type', schemas: {...})`. Branch definitions stay focused on their own fields and `.transform()` logic. Strict by default (unknown fields rejected per branch). Unknown type → Ack validation error.

Cross-field constraints use `.refine()` before `.transform()`.

For variants, the discriminated schema is built per-styler via `buildVariantSchema(styleSchema)` (Section 14).

### Pattern D — Variant decoding

Each variant branch has its own `.transform()` producing the appropriate variant type:

```dart
// named → NamedVariant(name)
// widget_state → WidgetStateVariant(state)
// enabled → ContextVariant.not(WidgetStateVariant(WidgetState.disabled))
// context_variant_builder → registry lookup → ContextVariantBuilder(fn) (no style from payload)
// context_brightness → ContextVariant.brightness(Brightness.dark)
// context_breakpoint → ContextVariant.breakpoint(Breakpoint(minWidth: 768))
// context_not_widget_state → ContextVariant.not(WidgetStateVariant(state))
```

`named` and `widget_state` are data-friendly (string name / enum name). `enabled` is a fixed semantic (no fields beyond `style`). `context_variant_builder` resolves via registry ID (scope `context_variant_builder`). The three `context_*` variants decode to `ContextVariant` instances via static factory methods.

Nested variant styles must match the active styler family (enforced by the factory function approach).

### Pattern E — Enum fields

All enum fields use `Ack.enumValues(DartEnum.values)`. Type-safe, validates against actual Dart enum values, gives meaningful errors automatically. No manual enum-to-string mapping.

```dart
'clipBehavior': clipSchema.optional(),
'textAlign': textAlignSchema.optional(),
'mainAxisAlignment': mainAxisAlignmentSchema.optional(),
```

### Pattern F — Custom styler registration

Developer provides: a `type` string and an Ack object-backed schema with `.transform()` (producing their custom styler type). The schema contains only the styler's own fields. `StylerRegistry.register<T>(String type, AckSchema<T> schema)` stores it, normalizes it internally, and injects the discriminator literal before freeze. Registers before freeze.

The built-in 8 stylers use the same registration path internally. No special treatment. The `.transform()` in the schema targets whatever Mix styler type the custom styler extends. No public `fields + transform` API is introduced.

## 17) Reusable Schema Catalog

Define each schema once, reference everywhere. Build in dependency order (primitives → values → nested objects → field groups → stylers).

### Enum schemas

Each defined once as `Ack.enumValues(Enum.values)`. Referenced by field name in styler and nested object schemas.

| Schema                          | Dart type                 | Used in                                                                        |
| ------------------------------- | ------------------------- | ------------------------------------------------------------------------------ |
| `clipSchema`                    | `Clip`                    | BoxStyler, FlexStyler, StackStyler, FlexBoxStyler, StackBoxStyler              |
| `textDirectionSchema`           | `TextDirection`           | TextStyler, FlexStyler, IconStyler, StackStyler, FlexBoxStyler, StackBoxStyler |
| `blendModeSchema`               | `BlendMode`               | IconStyler, ImageStyler, BoxDecorationMix                                      |
| `textBaselineSchema`            | `TextBaseline`            | FlexStyler, TextStyleMix, FlexBoxStyler                                        |
| `fontWeightSchema`              | `FontWeight`              | TextStyleMix, StrutStyleMix                                                    |
| `fontStyleSchema`               | `FontStyle`               | TextStyleMix, StrutStyleMix                                                    |
| `tileModeSchema`                | `TileMode`                | LinearGradientMix, RadialGradientMix, SweepGradientMix                         |
| `textOverflowSchema`            | `TextOverflow`            | TextStyler, default_text_style modifier                                        |
| `textAlignSchema`               | `TextAlign`               | TextStyler, default_text_style modifier                                        |
| `textWidthBasisSchema`          | `TextWidthBasis`          | TextStyler, default_text_style modifier                                        |
| `textLeadingDistributionSchema` | `TextLeadingDistribution` | TextHeightBehaviorMix                                                          |
| `textDecorationStyleSchema`     | `TextDecorationStyle`     | TextStyleMix                                                                   |
| `textDecorationSchema`          | `TextDecoration`          | TextStyleMix                                                                   |
| `axisSchema`                    | `Axis`                    | FlexStyler, FlexBoxStyler                                                      |
| `mainAxisAlignmentSchema`       | `MainAxisAlignment`       | FlexStyler, FlexBoxStyler                                                      |
| `crossAxisAlignmentSchema`      | `CrossAxisAlignment`      | FlexStyler, FlexBoxStyler                                                      |
| `mainAxisSizeSchema`            | `MainAxisSize`            | FlexStyler, FlexBoxStyler                                                      |
| `verticalDirectionSchema`       | `VerticalDirection`       | FlexStyler, FlexBoxStyler                                                      |
| `stackFitSchema`                | `StackFit`                | StackStyler, StackBoxStyler                                                    |
| `boxShapeSchema`                | `BoxShape`                | BoxDecorationMix                                                               |
| `boxFitSchema`                  | `BoxFit`                  | ImageStyler                                                                    |
| `imageRepeatSchema`             | `ImageRepeat`             | ImageStyler                                                                    |
| `filterQualitySchema`           | `FilterQuality`           | ImageStyler                                                                    |
| `borderStyleSchema`             | `BorderStyle`             | BorderSideMix                                                                  |

### Primitive value schemas

Each uses `.transform()` to produce the Flutter type. Wire formats locked in Section 10.

| Schema            | Dart type           | Used in                                                                                                                    |
| ----------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `colorSchema`     | `Color`             | IconStyler, ImageStyler, TextStyler, BoxDecorationMix, TextStyleMix, ShadowMix, BorderSideMix, GradientMix                 |
| `offsetSchema`    | `Offset`            | ShadowMix, BoxShadowMix                                                                                                    |
| `radiusSchema`    | `Radius`            | BorderRadiusMix, BorderRadiusDirectionalMix                                                                                |
| `rectSchema`      | `Rect`              | ImageStyler (centerSlice)                                                                                                  |
| `alignmentSchema` | `AlignmentGeometry` | BoxStyler, ImageStyler, StackStyler, LinearGradientMix, RadialGradientMix, SweepGradientMix, FlexBoxStyler, StackBoxStyler |

### Nested object schemas (with .transform())

Each produces a Mix type. Defined once, referenced by parent schemas.

**Layout:**

| Schema                        | Produces                   | Used in                                                    |
| ----------------------------- | -------------------------- | ---------------------------------------------------------- |
| `edgeInsetsSchema`            | `EdgeInsetsMix`            | BoxStyler (padding, margin), FlexBoxStyler, StackBoxStyler |
| `edgeInsetsDirectionalSchema` | `EdgeInsetsDirectionalMix` | Same (discriminated with edgeInsetsSchema)                 |
| `boxConstraintsSchema`        | `BoxConstraintsMix`        | BoxStyler, FlexBoxStyler, StackBoxStyler                   |

**Painting:**

| Schema                          | Produces                     | Used in                                                                                                                                     |
| ------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `borderSideSchema`              | `BorderSideMix`              | BoxBorderMix, BorderDirectionalMix                                                                                                          |
| `boxBorderSchema`               | `BoxBorderMix`               | BoxDecorationMix                                                                                                                            |
| `borderRadiusSchema`            | `BorderRadiusMix`            | BoxDecorationMix                                                                                                                            |
| `borderRadiusDirectionalSchema` | `BorderRadiusDirectionalMix` | BoxDecorationMix                                                                                                                            |
| `shadowSchema`                  | `ShadowMix`                  | TextStyleMix (shadows), IconStyler (shadows)                                                                                                |
| `boxShadowSchema`               | `BoxShadowMix`               | BoxDecorationMix (boxShadow)                                                                                                                |
| `linearGradientSchema`          | `LinearGradientMix`          | DecorationMix (gradient)                                                                                                                    |
| `radialGradientSchema`          | `RadialGradientMix`          | DecorationMix (gradient)                                                                                                                    |
| `sweepGradientSchema`           | `SweepGradientMix`           | DecorationMix (gradient)                                                                                                                    |
| `gradientSchema`                | `GradientMix`                | DecorationMix (discriminated on gradient `type`)                                                                                            |
| `boxDecorationSchema`           | `BoxDecorationMix`           | DecorationMix (discriminated branch `box_decoration`)                                                                                       |
| `shapeDecorationSchema`         | `ShapeDecorationMix`         | DecorationMix (discriminated branch `shape_decoration`)                                                                                     |
| `decorationSchema`              | `DecorationMix`              | BoxStyler (decoration, foregroundDecoration), FlexBoxStyler, StackBoxStyler (discriminated on `type`: `box_decoration`, `shape_decoration`) |

**Typography:**

| Schema                     | Produces                | Used in                                                            |
| -------------------------- | ----------------------- | ------------------------------------------------------------------ |
| `textStyleSchema`          | `TextStyleMix`          | TextStyler (style), default_text_style modifier                    |
| `strutStyleSchema`         | `StrutStyleMix`         | TextStyler                                                         |
| `textHeightBehaviorSchema` | `TextHeightBehaviorMix` | TextStyler, default_text_style modifier                            |
| `localeSchema`             | `Locale`                | TextStyler                                                         |
| `textScalerSchema`         | `TextScaler`            | TextStyler (discriminated, `text_scaler_linear` branch only in v1) |

**Metadata:**

| Schema                  | Produces               | Used in                                                                                   |
| ----------------------- | ---------------------- | ----------------------------------------------------------------------------------------- |
| `animationConfigSchema` | `CurveAnimationConfig` | All stylers (via `buildMetadataFields()`)                                                 |
| `modifierConfigSchema`  | `WidgetModifierConfig` | All stylers (via `buildMetadataFields()`, discriminated modifier list + orderOfModifiers) |
| `buildVariantSchema()`  | discriminated variant  | All stylers (via `buildMetadataFields()`, factory per styler)                             |

### Field group maps (for standalone styler spread)

Constant maps for standalone stylers only. Composite stylers define fields explicitly (Section 13).

```dart
final _boxFields = <String, AckSchema>{
  'alignment': alignmentSchema.optional(),
  'padding': edgeInsetsSchema.optional(),
  'margin': edgeInsetsSchema.optional(),
  'constraints': boxConstraintsSchema.optional(),
  'decoration': decorationSchema.optional(),
  'foregroundDecoration': decorationSchema.optional(),
  'transform': matrix4Schema.optional(),
  'transformAlignment': alignmentSchema.optional(),
  'clipBehavior': clipSchema.optional(),
};

final _flexFields = <String, AckSchema>{
  'direction': axisSchema.optional(),
  'mainAxisAlignment': mainAxisAlignmentSchema.optional(),
  'crossAxisAlignment': crossAxisAlignmentSchema.optional(),
  'mainAxisSize': mainAxisSizeSchema.optional(),
  'verticalDirection': verticalDirectionSchema.optional(),
  'textDirection': textDirectionSchema.optional(),
  'textBaseline': textBaselineSchema.optional(),
  'clipBehavior': clipSchema.optional(),
  'spacing': Ack.double().optional(),
};

final _stackFields = <String, AckSchema>{
  'alignment': alignmentSchema.optional(),
  'fit': stackFitSchema.optional(),
  'textDirection': textDirectionSchema.optional(),
  'clipBehavior': clipSchema.optional(),
};
```

Note: `_metadataFields` is replaced by `buildMetadataFields(styleSchema)` — a factory function, not a constant (Section 14).

**Consumed by standalone schemas:**

| Field group    | Used in             |
| -------------- | ------------------- |
| `_boxFields`   | `boxStylerSchema`   |
| `_flexFields`  | `flexStylerSchema`  |
| `_stackFields` | `stackStylerSchema` |

### Dependency order

Build schemas bottom-up.

**Layer 0 — Enums:** all 24 enum schemas (no dependencies).

**Layer 1 — Primitives:** `colorSchema`, `offsetSchema`, `radiusSchema`, `rectSchema`, `alignmentSchema` (depend on nothing or only on Ack primitives).

**Layer 2 — Simple objects:** `borderSideSchema`, `shadowSchema`, `boxShadowSchema`, `edgeInsetsSchema`, `boxConstraintsSchema`, `localeSchema`, `textScalerSchema`, `textHeightBehaviorSchema` (depend on Layer 0 + 1).

**Layer 3 — Compound objects:** `boxBorderSchema`, `borderRadiusSchema`, `gradientSchema`, `strutStyleSchema`, `textStyleSchema` (depend on Layer 0–2).

**Layer 4 — Decoration:** `boxDecorationSchema`, `shapeDecorationSchema`, `decorationSchema` (discriminated, depends on Layer 0–3).

**Layer 5 — Metadata factories:** `animationConfigSchema`, `modifierConfigSchema`, `buildVariantSchema()` factory (depend on Layer 0–4, variant factory receives styler schema as parameter).

**Layer 6 — Field groups:** `_boxFields`, `_flexFields`, `_stackFields` (depend on Layer 0–4, constants only for standalone stylers).

**Layer 7 — Stylers:** all 8 styler schemas. Each has a fields-only schema (Layer 7a) and a full schema with metadata (Layer 7b). The fields-only schema feeds into `buildMetadataFields()` to break the variant cycle (Section 14). Composite schemas written explicitly with prefixed wire keys.

## 18) Ack Integration Details

### Ack baseline for v1

M1 targets the `ack` git branch `feat/discrim-transformed-branches`. This branch solves the runtime blocker for transformed child branches inside `Ack.discriminated()`. It does **not** move discriminator literal ownership into Ack; `mix_schema` still owns that through its internal branch registry.

### What Ack handles (no custom code needed)

- **Unknown field rejection:** strict-by-default objects. No opt-in.
- **Type checking:** type mismatch errors with path context.
- **Enum validation:** `Ack.enumValues()` rejects invalid values.
- **Discriminated dispatch:** `Ack.discriminated()` routes to the already-normalized branch schema by `type` discriminator key at all levels (payload, variants, modifiers, gradients, decorations, borders, text scalers, etc.).
- **Cross-field validation:** `.refine()` runs after constraints pass.
- **Decode conversion:** `.transform()` produces Mix types directly (constructors handle `Prop` wrapping).
- **Error paths:** JSON Pointer (RFC 6901) from `SchemaContext`.
- **Nested validation:** errors from nested schemas bubble up with full path.
- **Optionality/nullability:** `.optional()`, `.nullable()`, `.withDefault()`.

### What stays custom

- **Registry system:** register/freeze lifecycle, forward lookup.
- **Styler registry:** register/freeze lifecycle, auto-builds discriminated schema at freeze.
- **Discriminated branch normalization:** internal registry/builder injects discriminator literals into object-backed branches and preserves transform chains before calling `Ack.discriminated()`.
- **Error code mapping:** translating Ack error types to stable v1 codes (complete mapping in Section 5).
- **Variant schema factory:** `buildVariantSchema()` (Section 14).
- **Global type uniqueness:** asserting that every registered `type` value is unique across stylers and static discriminated families.

### Internal discriminated branch registry

`mix_schema` owns discriminator injection through a shared internal registry/builder used by `StylerRegistry` and all static discriminated families.

```dart
final class DiscriminatedBranchRegistry {
  DiscriminatedBranchRegistry({
    required this.discriminatorKey,
  });

  final String discriminatorKey;
  final _schemas = <String, AckSchema>{};

  void register<T extends Object>(String type, AckSchema<T> schema) {
    _schemas[type] = normalizeDiscriminatedBranch(
      discriminatorKey: discriminatorKey,
      typeValue: type,
      schema: schema,
    );
  }

  AckSchema freeze() {
    return Ack.discriminated(
      discriminatorKey: discriminatorKey,
      schemas: _schemas,
    );
  }
}
```

`normalizeDiscriminatedBranch(...)` unwraps transformed schemas to the underlying object schema, injects `'type': Ack.literal(typeValue)`, then rebuilds the original transform chain. This keeps developer-authored schemas focused on their own fields while preserving the existing schema-based public API: `register<T extends Object>(String type, AckSchema<T> schema)`.

The same internal registry pattern is used for stylers, variants, modifiers, gradients, decorations, borders, edge insets, border radius, shape borders, and text scalers. Static families are registered internally at schema-construction time rather than hand-writing discriminator literals into branch bodies.

### Ack JSON schema/model export

Ack's JSON schema/model export path is not part of the v1 `mix_schema` decode contract. Runtime decode/validation is the contract boundary for v1. This avoids coupling the plan to Ack's current discriminator-ownership limitations in JSON schema/model export.

### Why no intermediate type layer

Mix already provides the right abstraction. Classes like `EdgeInsetsMix`, `BoxDecorationMix`, `BoxConstraintsMix`, and the styler classes (`BoxStyler`, `FlexStyler`, etc.) all have main constructors that accept plain values:

```dart
EdgeInsetsMix({double? top, double? bottom, double? left, double? right})
BoxDecorationMix({BoxBorderMix? border, Color? color, BoxShape? shape, ...})
BoxStyler({AlignmentGeometry? alignment, EdgeInsetsGeometryMix? padding, ...})
```

These constructors internally call `Prop.maybe()` / `Prop.maybeMix()` to wrap values. So `.transform()` targets these constructors directly, and mix_schema never touches `Prop` on the decode side.

### No @AckType usage

All schemas use `.transform()` to produce Mix types directly. The payload schema uses `Ack.discriminated()` for dispatch. No `@AckType` is needed anywhere in v1.

## 19) Milestones

### M0: Contract lock

Lock payload shape, error contract (complete code table with discriminator path promotion and custom transform exceptions), registry scopes, wire identifier naming convention, primitive wire formats (Section 10), variant schema factory pattern, composite wire key strategy, automated registry-driven discriminated schema construction, global `type` value uniqueness assertion, and the Ack branch baseline (`feat/discrim-transformed-branches`). Lock the internal discriminated-branch registry/builder from Section 18 and keep the public `register<T>(String type, AckSchema<T> schema)` surface unchanged.

### M1: Vertical slice

Styler registry with schema-based `register → freeze → decode` lifecycle. Discriminated payload schema auto-built at freeze with global `type` uniqueness assertion and internal branch normalization. One styler end-to-end (`box`) using schema-with-transform decode. One registry-backed field end-to-end. Error code mapping layer from Ack errors to v1 codes. Tests for: unknown fields, unknown registry ID, unknown `type` (via discriminated enum error), type mismatches, constraint violations, and transformed styler branch decode through `StylerRegistry`.

### M2: Reusable schemas

Build schemas following the dependency order from Section 17. Layer 0 (enums) and Layer 1 (primitives) first, then Layer 2–4 (objects through decoration). Each schema defined once, tested once, referenced everywhere. Strict nested validation tests. Variants via `buildVariantSchema()` factory and modifiers via the internal discriminated-branch registry plus `Ack.discriminated()` with `.transform()` branches and `.refine()` cross-field rules (Layer 5 metadata factories).

### M3: Full styler coverage

Build field groups (Layer 6) for standalone stylers. Build all 8 styler schemas (Layer 7). Composite stylers (`flex_box`, `stack_box`) written explicitly with prefixed wire keys — no field group spreading for composites. Custom styler registration tested with a non-built-in styler.

Gate each step: `cd packages/mix_schema && dart analyze && flutter test`

### M4: Hardening

Error stability tests (path + code ordering). Registry lifecycle tests (duplicate ID, freeze). Tricky-field rejection tests. Docs for rejected cases.

## 20) Commands

```bash
melos bootstrap
melos run gen:build
melos run ci
melos run analyze
```

Per-step gate during M3:

```bash
cd packages/mix_schema && dart analyze && flutter test
```

## 21) Guardrails

- Don't broaden into fluent or factory APIs.
- v1 is decode-only. Don't build encode infrastructure.
- Ack strict-by-default handles unknown-field rejection. Don't reimplement.
- Use `.transform()` targeting Mix constructors directly. No intermediate types.
- Use `.refine()` for cross-field constraints, not custom validation code.
- Use `Ack.discriminated()` for payload and nested dispatch via `type`, but route every branch through the internal discriminated-branch registry first. Don't manually read `type` and lookup schemas.
- Use `Ack.enumValues()` for all enum fields, not string-based enum mapping.
- Wire `type` values are derived from Flutter/Mix class names via snake_case (Section 2). JSON field names use camelCase. Semantic aliases (`enabled`, `context_not_widget_state`, etc.) are the only exceptions and are documented in Section 2.
- Define every schema (enum, value, object) exactly once. Reference by variable, never duplicate definitions.
- Composite stylers use explicit field definitions with prefixed wire keys. Don't spread field groups that have key collisions.
- Use `buildVariantSchema(styleSchema)` to break the variant/styler cycle. Don't use lazy initialization or `Ack.any()` workarounds.
- All `type` discriminator values occupy a single global namespace. No collisions between styler types, variant types, modifier types, gradient types, decoration types, border types, edge insets types, border radius types, shape border types, or text scaler types. Enforced by assertion at freeze time.
- Never touch `Prop` on the decode side. Mix constructors handle wrapping.
- Error code table is complete. Every Ack error type maps to exactly one v1 code. No gaps.
- If a field isn't safely representable in v1, reject with path and reason.
- Codegen for custom styler schemas is out of scope for v1.
- Styler registry uses the same register/freeze lifecycle as value registries. No special paths.
