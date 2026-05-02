# Changelog

## 1.0.0-draft

Initial reference implementation of the Mix JSON Schema (v1.0 Draft).

- Foundation: constants, JSON Pointer, structural equality, asset loaders, error catalog (52 codes), typed registry view.
- Typed model (7 files) covering 11 widgets, 8 styles, 30 modifiers, 27 directives, 19 structured literals, 5 variant kinds × 7 contexts, host refs, x: extensions.
- Canonicalizer (5 idempotent passes) — owns Decisions #15 / #36 / #41.
- Hand-rolled JSON Schema validator (Draft 2020-12 subset) wired into the 4-stage pipeline (bounds → schema → canonicalize → semantic).
- Pure Parser / Serializer with structural round-trip.
- 186 tests covering each layer plus full-pipeline conformance.
