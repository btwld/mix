# mix_schema

`mix_schema` is an Ack-backed contract package for JSON style payloads that decode into representable Mix stylers and encode representable stylers back to payloads.

The package is schema-first: Ack owns validation, decode, encode, and JSON Schema export. `mix_schema` only adapts those Ack results into a stable public Mix contract surface.

## Current Surface

- Full built-in contract branches: `box`, `text`, `flex`, `stack`, `icon`, `image`, `flex_box`, `stack_box`.
- The shared `builtInMixSchemaContract` is registry-free and intentionally exposes only `box`, `text`, `flex`, `stack`, `flex_box`, and `stack_box`. Use `MixSchemaContractBuilder().builtIn()` with a populated registry for icon/image payloads.
- Variants use `Ack.lazy` for nested styles.
- Modifiers support opacity, blur, flexible, and default text style.
- Animation support is limited to named-curve `CurveAnimationConfig`; optional callbacks use the `animation_on_end` registry.
- App-owned identity values use registries for `IconData` and `ImageProvider`.

Unsupported runtime values fail encode explicitly instead of being dropped.

See `WIRE_CONTRACT.md` for the canonical wire format. `REQUIREMENTS.md` is a
short orientation note and no longer contains process-governance requirements.
