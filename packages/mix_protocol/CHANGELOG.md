## Unreleased

### New features

- Added style and theme document inspection APIs for schema tooling.

### Fixes

- Preserve unresolved numeric tokens when box constraints are encoded and
  decoded.

## 1.0.0

- Renamed the unpublished package from `mix_schema` to `mix_protocol` to match
  its versioned wire-compatibility responsibilities.
- Replaced public contract construction with the fixed `mixProtocol` façade
  for style/theme decode, encode, and JSON Schema export.
- Unified fallible operations under `MixProtocolResult<T>` and removed the
  duplicate validate-only API.
- Removed unused custom-branch, mutable-builder, registered-type, and frozen
  registry machinery; identity names are now resolved per call.
- Made top-level `v` mandatory and retained the established v1 payload keys,
  discriminators, canonical forms, and stable error-code strings.
- Added broad `mix_tailwinds` representability and canonical round-trip tests
  while keeping the protocol out of Tailwinds runtime dependencies.
- Tightened the wire contract for theme aliases, directive params, numeric
  constraints, token property terms, and single-item `$merge` payloads.
- Expanded theme text-style decoding/schema support to the documented canonical
  fields while keeping nested theme token refs invalid.
- Moved producer payload helpers to `package:mix_protocol/testing.dart` and
  removed the unpublished `encode.dart` compatibility entry point.
- Filled the exported schema modifier and variant vocabulary so generated
  schema metadata matches supported discriminators.
- Documented the remaining stable public error codes in the wire contract.

## 0.0.1 (unpublished prototype)

- Initial unpublished `mix_schema` prototype.
- Added Ack-backed codecs, schema export metadata, built-in stylers, modifiers,
  an animation subset, and producer payload helpers.
