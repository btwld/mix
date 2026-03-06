## 0.1.0-dev.0

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
  `StylerDefinition`.
- Flatten styler metadata to sibling `modifiers` and `modifierOrder` wire
  fields.
- Split metadata and painting schemas into smaller domain-focused files.
- Add package-local DCM configuration and public API Dartdoc.
- Replace exported string-holder constants with a public `MixSchemaScope` enum
  and internal wire/discriminator enums.
- Add `RegistryBuilder.builtIn(...)` for built-in scope registration and
  rename internal wire enums to shorter `Schema*` names.
