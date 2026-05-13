# mix_schema Lessons Learned

## 2026-05-13 — Codec-Owned Contract Migration

- Ack should own the contract boundary. Each styler contract wraps one
  object-backed `Ack.codec<JsonMap, T>` that defines validation, decode, encode,
  and JSON Schema export.
- `MixSchemaContract.rootSchema`, `validate`, `decode`, `encode`, and
  `exportJsonSchema()` are the durable public contract surfaces.
  `exportMetadata()` and manual field/type metadata were removed because they
  duplicated Ack state.
- Custom styler registration should accept only object-backed codecs. Field
  shape is derived from the codec input schema, not a parallel `fields` list.
- Built-in styler branches should use the same codec builder for top-level
  payloads and nested variant styles. Unsupported runtime-only values should
  fail through mapped encode errors instead of being represented by lossy wire
  placeholders.
- Shared field encoders belong next to the built-in schema definitions. That
  keeps box, flex, stack, text, image, icon, and compound styler payloads
  consistent without creating a mirrored contract tree.
- Variant encoding is intentionally partial and explicit: named variants,
  shared context variants, and `context_all_of` can encode; registry-backed
  `context_variant_builder` values cannot encode until reverse lookup support
  exists for that boundary.
- `IconStyler.icon` remains out of the wire schema until there is a stable
  producer-representable icon value.
- `mix_tailwinds` should prove the contract by using `MixSchemaContract` decode
  and encode seams. It should not own public schema shape or depend on public
  wire enum builders.
- `encode.dart` is still useful as a narrow producer helper surface for
  primitive payload fragments and shared variant conditions. It should not grow
  into a second schema DSL.
- Raw Ack `toJsonSchema()` is the schema artifact of record for now. Ack
  `toJsonSchemaModel()` remains follow-up work because the current
  discriminated codec export shape has a discriminator/model conflict.
- Historical markdown plans that described AST adapters, metadata-first export,
  explicit custom field lists, or decode-only styler transforms are harmful once
  they stop matching the branch. Keep the active decisions in `CURRENT_GOAL.md`,
  `packages/mix_schema/README.md`, the changelog, and this file.
