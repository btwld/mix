## 0.1.0-dev.0

- Add the initial `mix_schema` package scaffold.
- Implement the first decode vertical slice for `box` payloads.
- Expand the shared schema foundation for box layout and decoration decoding.
- Add metadata decoding, full built-in styler coverage, custom styler
  registration support, and hardening tests.
- Redesign the internal schema architecture around `MixSchemaCatalog` and
  `StylerDefinition`.
- Flatten styler metadata to sibling `modifiers` and `modifierOrder` wire
  fields.
- Split metadata and painting schemas into smaller domain-focused files.
- Add package-local DCM configuration and public API Dartdoc.
- Replace exported string-holder constants with a public `MixSchemaScope` enum
  and internal wire/discriminator enums.
- Add `RegistryBuilder.builtIn(...)` for built-in scope registration and
  rename internal wire enums to shorter `Schema*` names.
