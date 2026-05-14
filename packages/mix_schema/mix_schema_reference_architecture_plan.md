# mix_schema Reference Architecture Plan

## Contract Model

`mix_schema` is a codec-owned contract. Ack is the source of truth for
validation, decode, encode, and JSON Schema export.

The durable public contract surface is:

- `MixSchemaContract.rootSchema`
- `MixSchemaContract.validate(JsonMap payload)`
- `MixSchemaContract.decode(JsonMap payload)`
- `MixSchemaContract.encode(Object value)`
- `MixSchemaContract.exportJsonSchema()`

No parallel metadata export, field list registry, or public wire enum builder
should duplicate Ack state.

## Styler Contracts

Each styler contract wraps one object-backed `Ack.codec<JsonMap, T>`.
Top-level styler payloads and nested variant styles are built from the same
field map and encode/decode callbacks.

Custom styler registration accepts object-backed codecs only. Field names and
JSON Schema are derived from the codec input schema.

## Registry-Backed Runtime Values

Runtime values that need app-owned identity use registries.

Built-in registry scopes:

- `animation_on_end`
- `icon_data`
- `image_provider`
- `context_variant_builder`

Decode looks up ids from payload strings. Missing ids produce
`unknown_registry_id`. Encode performs reverse lookup for runtime values.
Unregistered runtime values produce `unknown_registry_value`.

Type mismatches currently remain `transform_failed`.

## Wire Vocabulary

Enums are strict string wire values based on Dart enum `.name`, except
intentional aliases such as `FontWeight`. Integer enum indexes are invalid.

Core schema terminology must stay producer-neutral. CSS directional gradient
keywords use `css_linear_keyword_transform`; Tailwind-specific names belong
only in `mix_tailwinds`.

## Payload Limits

`MixSchemaLimits` runs before validation and decode.

Defaults:

- `maxDepth = 32`
- `maxListLength = 256`
- `maxStringLength = 4096`
- `maxRegistryIdLength = 256`
- `maxVariantsPerStyler = 64`
- `maxModifiersPerStyler = 64`

Limit failures use `constraint_violation`.

## Error Vocabulary

Stable public codes include:

- `type_mismatch`
- `required_field`
- `unknown_field`
- `invalid_enum`
- `constraint_violation`
- `validation_failed`
- `transform_failed`
- `unsupported_encode_value`
- `unknown_type`
- `unknown_registry_id`
- `unknown_registry_value`

Unsupported non-registry encode cases use `unsupported_encode_value`.

## JSON Schema Artifact

`exportJsonSchema()` emits raw Ack JSON Schema with artifact metadata:

- `$schema`
- `x-mix-schema-contract`
- `x-mix-schema-version`

Ack `toJsonSchemaModel()` is still follow-up work because the current
discriminated codec export shape conflicts with model conversion.

## mix_tailwinds

`mix_tailwinds` is a proof consumer. It should validate the contract by
decoding through `MixSchemaContract` and, where useful, encoding runtime styles
back to canonical payloads. It should not own public schema shape.
