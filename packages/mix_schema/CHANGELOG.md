## Unreleased

- Tightened the wire contract for theme aliases, directive params, numeric
  constraints, token property terms, and single-item `$merge` payloads.
- Expanded theme text-style decoding/schema support to the documented canonical
  fields while keeping nested theme token refs invalid.
- Moved producer payload helpers to `package:mix_schema/testing.dart` and
  removed the unpublished `encode.dart` compatibility entry point.
- Filled the exported schema modifier and variant vocabulary so generated
  schema metadata matches supported discriminators.
- Documented the remaining stable public error codes in the wire contract.

## 0.0.1

- Initial unpublished `mix_schema` package.
- Added Ack-pinned contract builder, public result/error model, registries, schema export metadata, built-in styler codecs, modifiers, animation subset, and producer payload helpers.
