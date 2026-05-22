# Phase 1 Ack Codec Migration — Review Notes

## Summary

Phase 1 mechanical Ack API migration for `mix_schema` is **structurally complete**.
The diff is **−364 lines net** across 46 files (1106 deletions, 742 insertions).

- `dart analyze` is **clean** (no issues).
- `flutter test` reports **130 passing, 8 failing** out of 138 tests.

## What changed

**Pubspec / Ack ref**

- `mix_schema/pubspec.yaml` switched to Ack branch `feat/codec-implementation` for `ack`, `ack_annotations`, `ack_generator`.

**Mechanical Ack API rename across the package**

- All `Ack.codec<B, R>(decoder:, encoder:)` rewritten to `Ack.codec<B, B, R>(decode:, encode:)` (new 3-type-param signature).
- All `AckSchema<T>` declarations rewritten to `AckSchema<Boundary, Runtime>` (the typedef `AnyAckSchema` is hidden in `package:ack/ack.dart`, so explicit `AckSchema<Object, Object>` is used where erasure is needed).
- Return types tightened to concrete codec/discriminated schema types where useful (`CodecSchema<...>`, `DiscriminatedObjectSchema<...>`).

**JsonMap consolidation**

- Deleted local `lib/src/core/json_map.dart` and re-exported `JsonMap` from `package:ack/ack.dart` via `mix_schema.dart` and `encode.dart`.
- All 24 local-`JsonMap` imports replaced with `package:ack/ack.dart` (or `show JsonMap` where ack wasn't already imported).

**Typed numeric schemas**

- `Ack.number()` replaced with `Ack.double()` / `Ack.integer()` across shared primitives, edge insets, constraints, typography, borders, gradients, decorations, shape borders, animation, modifiers.
- Decode-side `castDoubleOrNull(...)` / `castDouble(...)` calls dropped in favor of direct `as double?` / `as double` casts (Ack now guarantees the runtime type at the decode boundary).

**Union-owned discriminator (PR #107)**

- Branch input ObjectSchemas in value-level unions no longer declare `'type': Ack.literal(...)`. The discriminated union synthesizes the literal via `effectiveBranch` for parse and JSON-Schema export.
- Affected unions: `boxBorderCodec`, `borderRadiusCodec`, `shapeBorderCodec`, `gradientCodec`, `gradientTransformCodec`, `buildDecorationCodec` branches, `textScalerCodec`.
- Branch encoders **still emit** `'type': type.wireValue` because the effective ObjectSchema's discriminator property is required-not-default. Removing the emission would fail ObjectSchema runtime validation during encode (Phase 2 follow-up — see below).

**Discriminator literal kept where direct codec calls happen**

- `_modifierCodec` (called via `ModifierDefinition.encode → codec.encodeTyped`).
- `_leafCodec` for variant conditions (called via `VariantConditionDefinition.encodeLeaf → codec.encodeTyped`).
- These codecs are invoked **outside** their parent discriminated union, so their input ObjectSchema still has to declare the literal.

**Top-level styler schemas**

- `_buildStylerCodec` in `styler_definition.dart` no longer injects `'type': Ack.literal(...)` into the styler input ObjectSchema. The registry's discriminated union owns the discriminator.
- The `_hasTopLevelType` assertion in `built_in_styler_definitions.dart` was removed (it was checking for the literal in the styler input).
- The `_validateStylerRegistration` check that required a literal `'type'` property was relaxed to only require an ObjectSchema input.

**Variant top-level schema cleanup**

- `buildVariantSchema` (in `metadata/variant_schema.dart`) replaced its hand-rolled "discriminated input + custom decoder/encoder" wrapper with a straight `Ack.discriminated<VariantStyle<S>>(...)`. The custom `_decodeVariantStyle` / `_encodeVariantStyle` / `_variantTypeFromWireValue` helpers were deleted.
- For context variant branches, the `VariantConditionDefinition.buildVariantSchema(...)` codec inherits the leaf codec's input (which still has the literal restored above) plus the `style` field.

**Preserved helpers (deferred to Phase 2 review)**

Per the plan, the following helpers were left in place even where value-side callers disappeared:

- `lib/src/core/json_casts.dart` — `castListOrNull` is still used in a handful of decoders for `List<X>` runtime types.
- `lib/src/core/codec_typed_encode.dart` — still used by `ModifierDefinition.encode`, `VariantConditionDefinition.encodeLeaf`, `payloadColor`, `payloadAlignment`, `payloadOffset`, `payloadRadius`. `CodecSchema.encode()` is now typed in Ack, so `encodeTyped` is mostly redundant but the extension is preserved per the plan.
- `lib/src/encoder/primitive_payload_helpers.dart`.

**Tests updated**

- `test/styler_registry_test.dart`, `test/mix_schema_contract_test.dart`, `test/schema/metadata/variant_schema_round_trip_test.dart` migrated to the new Ack codec signature.
- One test (`'rejects custom schemas that are not JsonMap-backed codecs'`) was removed because strict typing on `register<T>(CodecSchema<JsonMap, T>)` now enforces the invariant at compile time.

## Remaining test failures (8)

### Category A — `Ack.double()` rejecting JSON integer literals (5 failures)

The Ack `feat/codec-implementation` branch's `DoubleSchema.validateRuntimeWithContext` rejects `int` values outright. Existing test payloads pass JSON integer literals (e.g. `'x': -1, 'y': 0`, `'padding': {'top': 8, 'left': 16}`) into fields that map to Dart `double`.

Failing tests:

1. `mix_schema_decoder_test.dart › decodes a box payload into Mix runtime objects`
2. `mix_schema_decoder_test.dart › returns validation_failed for invalid shared schema refinements` (depends on the same payload shape)
3. `mix_schema_full_coverage_test.dart › decodes modifier ordering and active context builder variants`
4. `shared_schema_catalog_test.dart › buildDecorationSchema decodes reusable painting objects`
5. `shared_schema_catalog_test.dart › boxConstraintsCodec enforces min/max ordering`
6. `shared_schema_catalog_test.dart › buildDecorationSchema decodes shape decorations and gradient transforms`

This matches the plan's Assumption #2 verbatim: the preferred fix is in Ack semantics (or a typed numeric handling helper), not reintroducing `castDouble*` broadly. **Phase 2 owns this.**

### Category B — JSON Schema export marker change (1 failure)

`mix_schema_contract_test.dart › exports the root Ack JSON Schema artifact` expects `boxBranch['x-ack-codec'] == true` in the exported JSON Schema. The new Ack `feat/codec-implementation` branch no longer emits this marker on discriminated branches (or emits it at a different path). Ack-side artifact change; not a `mix_schema` concern.

### Category C — Discriminated-union encode error wrapping (1 failure)

`variant_schema_round_trip_test.dart › fails clearly for unregistered context_variant_builder values` expects the failure message to contain `'No registry id found'`. The new Ack discriminated encode wraps individual branch errors inside `SchemaNestedError`, and the contract error mapper currently surfaces the wrapper message instead of the inner `RegistryValueLookupError` text. The error path still leads to the right diagnosis — just buried one layer deeper. Could be addressed either by refining `SchemaErrorMapper._prioritizedEncodeErrors` to unwrap nested registry errors, or by adjusting the test expectation.

## Phase 2 candidates (raised by this diff)

- **Ack numeric coercion**: decide whether `Ack.double()` should accept `int` JSON literals (Zod-style coercion) or whether `mix_schema` should introduce a single typed-numeric helper (e.g., `Ack.double().fromNum()`).
- **Discriminator-owned encode emission**: confirm whether Ack should auto-inject the discriminator key on encode for object/codec branches whose runtime value doesn't already carry it. If yes, the `'type': type.wireValue` emission in every branch encoder in `mix_schema` can disappear.
- **`encodeTyped` extension**: `CodecSchema.encode()` is now typed; review whether `codec_typed_encode.dart` still earns its keep.
- **`json_casts.dart`**: only `castListOrNull` remains in active use. Could fold into a tiny utility close to where lists of nested codecs are decoded, or drop entirely once Ack list-of-codec decodes return the right typed list.
- **Direct-call codecs vs. union-owned discriminator**: modifier and variant-leaf codecs are the only branches that still need `'type': Ack.literal(...)` in their input because they're invoked outside their discriminated union. Either funnel all direct callers through the union, or formalize a "standalone branch codec" helper.
- **Variant top-level schema**: the new `Ack.discriminated<VariantStyle<S>>` shape replaces a hand-rolled wrapper. The old wrapper + helpers are deleted, but `VariantConditionDefinition.buildVariantSchema` still re-wraps each leaf codec; that wrapping could move into the leaf definition itself.
- **`StylerRegistry._validateStylerRegistration`**: now only enforces "is ObjectSchema-backed". Could be tightened or relaxed depending on what shape we expect from external producers.
