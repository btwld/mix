# mix_schema

`mix_schema` is an Ack-backed contract package for JSON style payloads that decode into representable Mix stylers and encode representable stylers back to payloads.

The package is schema-first: Ack owns validation, decode, encode, and JSON Schema export. `mix_schema` only adapts those Ack results into a stable public Mix contract surface.

## Current Surface

- Full built-in contract branches: `box`, `text`, `flex`, `stack`, `icon`, `image`, `flex_box`, `stack_box`.
- Top-level style documents use wire format `v: 1`; nested styles inherit the
  enclosing document version.
- Explicit JSON `null` is forbidden; unbounded max constraints use the
  `"infinity"` sentinel.
- Decode is strict by default. `MixSchemaDecodeOptions(mode:
  MixSchemaDecodeMode.lenient)` skips forward-compatible unknown fields,
  variant entries, and modifier entries with warnings.
- The shared `builtInMixSchemaContract` is registry-free and exposes every
  built-in branch, including `icon` and `image`.
- Icon and image identities decode through per-call
  `MixSchemaDecodeOptions(resolveIcon:, resolveImage:)` callbacks when the
  wire uses a string name. Common value forms decode without app state:
  icon `codePoint` objects, image `url` objects, and image `asset` objects.
  Prefer resolver names for app icons when Flutter icon tree-shaking matters.
- Encoding can emit per-call names with `MixSchemaEncodeOptions(iconNames:,
  imageNames:)`; otherwise icons encode as value forms and unsupported image
  providers fail with resolver-flavored diagnostics.
- Variants use `Ack.lazy` for nested styles.
- Modifiers support opacity, blur, flexible, and default text style.
- Animation support is limited to data-only `CurveAnimationConfig` and
  `SpringAnimationConfig`; `onEnd` callbacks are not represented in v1 and fail
  encode explicitly.

Unsupported runtime values fail encode explicitly instead of being dropped.

See `WIRE_CONTRACT.md` for the canonical wire format. `REQUIREMENTS.md` is a
short orientation note and no longer contains process-governance requirements.
