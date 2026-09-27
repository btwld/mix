## 1.0.0-alpha.0

### New features

- Added the v1 `context_focus_visible` selector, including nested negation.
- Require Ack 1.6.1 for private codecs. Generated Mix stylers remain the runtime model.
- Share field, token, merge, directive, and variant declarations with schema export.
- Preserve literal types and directive families in exported Draft 7 schemas.
- Export the breakpoint width/token either-or as `oneOf` instead of
  `if`/`then`/`else`. The accepted documents are unchanged; the simpler
  spelling drops a nested negation and a duplicated `anyOf` block at each
  breakpoint site.
- Check in the exported style and theme schemas under `schema/` with the
  fixture documents that pin their acceptance boundary. `tool/schema-check`
  validates every checked-in suite with Ajv, replacing the Dart `json_schema`
  test dependency.
- Added `SchemaFixtureSuite` and `renderSchemaFixtures` to
  `package:mix_protocol/testing.dart` so contributed vocabularies can publish
  their own schema fixtures for the same check.

- Added additive v1 `{"type":"auto"}` Grid tracks for `rows`, `autoRows`, and
  constraint patches. Auto tracks have no token references.
- Added immutable, deterministic package-contributed styler vocabularies,
  namespaced versioned discriminators, explicit `MixProtocol.compose`, and an
  Ack-free codec-authoring façade.
- Made schema field declarations own token, literal, and lenient list-repair
  semantics, and added reusable package styler inventory discovery.
- Added a typed styler-codec helper that owns standard metadata and field
  inventory wiring for core and contributed vocabularies. Generated Styler
  metadata now replaces duplicate handwritten owner-field manifests while
  preserving explicit wire keys, with a manual fallback for handwritten and
  previously generated Stylers.
- Added style and theme document inspection APIs for schema tooling.
- Added canonical v1 `wrap` and `wrap_box` style branches, including complete
  Box/Wrap field fidelity, collision-safe composite names, spacing tokens,
  metadata, schema export, and token-reference walking.
- Added canonical v1 `grid_box` support for fixed/fractional tracks, gaps,
  clipping, ordered local-constraint branches, full style metadata, JSON Schema
  export, document inspection, and complete token-reference walking. Grid
  tracks and gaps accept canonical numeric token references.

### Fixes

- Prepare each nested composite styler once per encoding operation.
- Remove obsolete schema hints and schema reconstruction from generic Ack shapes.
- Export the breakpoint selector constraint from its runtime definition.

- Preserve unresolved numeric tokens when box constraints are encoded and
  decoded.

### Initial v1 contract

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
