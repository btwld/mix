## 0.1.0-dev.0

- Add contract-facing `MixSchemaContract`, `MixSchemaContractBuilder`,
  `MixSchemaValidationResult`, `MixSchemaEncodeResult`, and Ack JSON Schema
  export through `MixSchemaContract.exportJsonSchema()`.
- Keep only low-level payload helpers on `encode.dart`, and keep internal wire
  identifiers and `StylerRegistry` off the root contract export.
- Remove the parallel export metadata surface; producer schema artifacts now
  come from the Ack root schema.
- Add the `IconStyler.icon` wire field as registry-backed `IconData`.
- Add registry-backed `IconData`, reverse registry encode for supported
  registry values, and stable `unknown_registry_value` encode errors.
- Add strict string enum codecs so integer enum indexes are rejected.
- Rename the core CSS directional gradient transform wire type to
  `css_linear_keyword_transform`.
- Add `MixSchemaLimits` and exported JSON Schema artifact metadata.
- Add `StylerRegistry.builtIn(...)` for extending the built-in styler set with
  custom branches, and decode language-only locales plus decoration images.
- Add public compound context variant decoding with the `context_all_of`
  branch and nested condition parsing.
- Preserve deep nested condition error paths during transform failures and
  keep compound variants aligned with Mix widget-state priority ordering.
- Allow sparse `context_breakpoint` payloads by treating omitted dimensions as
  absent instead of required-null fields.
- Add the initial `mix_schema` package scaffold.
- Implement the first decode vertical slice for `box` payloads.
- Expand the shared schema foundation for box layout and decoration decoding.
- Add metadata decoding, full built-in styler coverage, custom styler
  registration support, and hardening tests.
- Redesign the internal schema architecture around `MixSchemaCatalog` and
  codec-owned `StylerContract`.
- Flatten styler metadata to sibling `modifiers` and `modifierOrder` wire
  fields.
- Split metadata and painting schemas into smaller domain-focused files.
- Add package-local DCM configuration and public API Dartdoc.
- Replace exported string-holder constants with a public `MixSchemaScope` enum
  and internal wire/discriminator enums.
- Add `RegistryBuilder.builtIn(...)` for built-in scope registration and
  rename internal wire enums to shorter `Schema*` names.
