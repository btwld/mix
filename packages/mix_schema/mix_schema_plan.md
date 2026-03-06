# mix_schema v1 Redesign Plan

**Version:** 15.0.0  
**Date:** 2026-03-06  
**Owner:** Mix 2.0 team

## 1) Purpose

`mix_schema` decodes external UI payloads into Mix runtime styling objects
 through a strict, deterministic pipeline:

`payload -> Ack validation -> transform -> Mix types`

The redesign keeps the package decode-only and keeps the built-in styler set
 fixed, but replaces the internal schema architecture with a cleaner
 catalog-backed design.

## 2) Contract Decisions

- The package remains decode-only.
- The built-in stylers remain:
  - `box`
  - `text`
  - `flex`
  - `icon`
  - `image`
  - `stack`
  - `flex_box`
  - `stack_box`
- The public package surface remains intentionally small:
  - `MixSchemaDecoder`
  - `RegistryBuilder`
  - `FrozenRegistry`
  - `StylerRegistry`
  - `MixSchemaScope`
  - decode result types
  - error types and codes
- The redesign replaces the previous plan in place.
- No backward-compat shim is added for old payload shapes introduced during
  exploratory implementation.
- No `schemaVersion` field is added in this redesign.

## 3) Wire Contract

### Root payload

```json
{
  "type": "box",
  "padding": { "top": 8, "left": 12 },
  "animation": { "duration": 200, "curve": "easeIn" },
  "modifiers": [
    { "type": "opacity", "value": 0.8 }
  ],
  "modifierOrder": ["opacity"],
  "variants": [
    {
      "type": "named",
      "name": "primary",
      "style": { "clipBehavior": "hardEdge" }
    }
  ]
}
```

### Metadata fields

Metadata now uses four sibling fields on every styler:

- `animation`
- `modifiers`
- `modifierOrder`
- `variants`

The previous nested shape is removed:

```json
{
  "modifier": {
    "modifiers": [...],
    "orderOfModifiers": [...]
  }
}
```

### Registry-backed values

Registry-backed references stay as plain string ids on the wire. No ref object
 is introduced.

Built-in registry scopes are exposed in Dart via `MixSchemaScope`, but the wire
 format remains the same string ids.

Built-in scope registration should use
`RegistryBuilder.builtIn(scope: MixSchemaScope...)`. Custom scopes continue to
use the string-based constructor.

Examples:

- `ImageStyler.image`: `"hero-image"`
- `AnimationConfig.onEnd`: `"fade-done"`
- `ContextVariantBuilder.id`: `"screen-size"`

## 4) Errors

The public error vocabulary remains stable unless implementation proves a new
 public code is necessary. Current target codes:

- `type_mismatch`
- `required_field`
- `unknown_field`
- `invalid_enum`
- `constraint_violation`
- `validation_failed`
- `transform_failed`
- `unknown_type`
- `unknown_registry_id`
- `unsupported_value_type`

Errors stay:

- aggregated
- path-based
- deterministically sorted by `path`, then `code`

Internal exception typing may expand, but public error codes should not grow
 unless the redesign produces a strong contract reason.

## 5) Ack Integration

Ack remains the validation and transform engine.

Ack is responsible for:

- strict object validation
- unknown-field rejection
- enum validation
- discriminated dispatch
- nested path reporting
- `.refine()` cross-field validation
- `.transform()` object conversion

`mix_schema` owns:

- runtime registry lookup
- error mapping
- styler registration lifecycle
- discriminated-branch normalization

Critical baseline:

- transformed child branches are **not** consumed directly by
  `Ack.discriminated()` for this package
- `mix_schema` normalizes each branch to an object-backed schema, injects the
  discriminator literal, and applies the branch transform at the outer
  discriminated layer

That behavior is the package contract and must be reflected in both code and
 tests.

## 6) Internal Architecture

### 6.1 Schema catalog

Introduce one `MixSchemaCatalog` instance per decoder/bootstrap flow. It owns
 shared schema construction via `late final` fields.

The catalog owns:

- enums
- primitives
- layout schemas
- painting schemas
- typography schemas
- animation schema
- modifier schema
- metadata field builders
- decoration families

`RegistryCatalog` remains separate and handles runtime lookup only.

### 6.2 Styler definitions

Each styler family is described by one internal definition type:

```dart
final class StylerDefinition<S extends Spec<S>, T extends Style<S>> {
  final SchemaStyler type;
  final T emptyStyle;
  final Map<String, AckSchema> fields;
  final T Function(
    Map<String, Object?> data, {
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<S>>? variants,
  }) build;
}
```

Rules:

- standalone stylers declare their field map once
- one helper composes:
  - fields-only schema
  - full schema with metadata
- composite stylers remain explicit where key collisions exist
- no built-in file may duplicate the same `Ack.object({...})` field list twice
- closed discriminator sets use internal enhanced enums with `wireValue`
- those internal enums are not exported from the package root
- the current drift review found no functional divergence between plan and code;
  remaining cleanup work is naming and ergonomics only

### 6.3 File layout

Shared schemas are split by domain:

- `schema/metadata/`
  - `animation_schema.dart`
  - `modifier_schema.dart`
  - `variant_schema.dart`
  - `metadata_field_schemas.dart`
- `schema/painting/`
  - `border_schemas.dart`
  - `gradient_schemas.dart`
  - `decoration_schemas.dart`
  - `shape_border_schemas.dart`

The discriminated branch registry stays as a dedicated internal helper under
 `schema/`.

## 7) Metadata Rules

### Modifiers

- `modifiers` is a list of discriminated modifier objects.
- `modifierOrder` is an optional list of modifier wire ids.
- `modifierOrder` resolves to Mix runtime widget modifier types, not
  `ModifierMix` types.
- Unknown entries in `modifierOrder` are ignored to match Mix runtime behavior.

### Variants

- Variants remain a discriminated list.
- Variant nested styles validate against the fields-only schema for the active
  styler family.
- `ContextVariantBuilder` remains registry-backed.
- Placeholder values required by Mix internals must be hidden behind internal
  helpers and not leak into multiple styler files.

### Animation

- Animation remains a separate object field.
- The supported animation subset remains the existing v1 subset.

## 8) Implementation Sequence

### Phase 1 — Contract rewrite

- Replace the previous plan with this one.
- Align constants and tests with the flattened modifier metadata contract.
- Add package-level lint wiring.

### Phase 2 — Schema architecture rebuild

- Add `MixSchemaCatalog`.
- Split metadata and painting modules.
- Move shared schema creation into the catalog.
- Keep `RegistryCatalog` focused on runtime lookup.

### Phase 3 — Built-in styler rebuild

- Replace ad hoc built-in schema functions with `StylerDefinition`-based
  composition.
- Rebuild all eight built-in stylers on top of the catalog and shared helper.
- Preserve runtime behavior already proven by tests unless the redesigned wire
  contract intentionally changes it.

### Phase 4 — Hardening and docs

- Add explicit Dartdoc for all exported types.
- Strengthen error-contract and metadata tests.
- Update simulation results and lessons learned with the redesign outcome.

## 9) Validation Gates

Package-local gates after each phase:

```bash
dart format . --set-exit-if-changed
dart analyze --fatal-infos
dcm analyze . --fatal-style --fatal-warnings
flutter test
```

Definition of done:

- format clean
- analyzer clean
- DCM active and clean for `mix_schema`
- tests green
- plan, simulation results, and lessons learned updated together

## 10) Review Workflow

Every phase ends with two reviews.

### Code Simplifier review

Check for:

- repeated schema construction
- duplicated field maps
- helpers used only once
- unnecessary generics
- placeholder hacks leaking outside internal helpers
- files that combine multiple responsibilities

### Architecture review

Check for:

- one source of truth for shared schemas
- clear separation between catalog, runtime registry, and styler definitions
- stable, intentional public API
- wire choices justified by clarity
- tests proving runtime behavior, not just parse success

## 11) Test Plan

### Built-in styler contract tests

For every built-in styler:

- one valid payload
- one invalid payload

### Regression coverage

- transformed discriminated branches
- unknown `type`
- unknown field
- type mismatch
- constraint violation
- transform failure
- unknown registry id
- registry type mismatch
- deterministic error ordering

### Metadata coverage

- `modifiers`
- `modifierOrder`
- `variants`
- `ContextVariantBuilder`
- runtime modifier ordering

### Shared-schema coverage

- edge insets absolute vs directional exclusivity
- box constraints ordering
- gradient stop count validation
- shape decoration
- gradient transform decoding

## 12) Guardrails

- No encode path.
- No fluent API work.
- No factory-compatibility work.
- No migration shim for the old `modifier` payload shape.
- No new built-in styler breadth beyond the current eight.
- Do not re-introduce duplicate field declarations after the rebuild.
- Do not let DCM remain disabled for the package.
