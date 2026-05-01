# Mix JSON Schema

A public JSON contract for describing Mix widget trees declaratively.

Producers (AI agents, design tools, CMS, backends) emit JSON that conforms to this contract. Consumers (Mix-based Flutter runtimes) parse and render it.

## Files

| File | Role |
|---|---|
| [`spec.md`](./spec.md) | Normative specification — grammar, semantics, canonical form, versioning. |
| [`schema.v1.json`](./schema.v1.json) | Formal JSON Schema (Draft 2020-12). Machine-validatable contract. |
| [`registry.json`](./registry.json) | Prop registry — per-spec/per-modifier/per-directive/per-literal typing. |
| [`error-codes.json`](./error-codes.json) | Language-neutral registry of validator/parser/serializer error codes. |
| [`examples.md`](./examples.md) | 5 normative examples (sugar + canonical); double as conformance fixtures. |
| [`IMPLEMENTATION.md`](./IMPLEMENTATION.md) | Reference Dart implementation plan — package layout, module ownership, validator pipeline, build order. Non-normative. |
| [`SESSIONS.md`](./SESSIONS.md) | Append-only log of design iterations and progress. |

## Status

**v1.0 Draft.** Normative text and conformance examples exist; code deliverables (reference validator, canonicalizer, parser, serializer) in the forthcoming `packages/mix_schema/` Dart package are not yet written. Substantive changes to the contract are expected until those deliverables exist and at least one independent implementation validates the text.

## Quick orientation

Start with [`spec.md`](./spec.md) §Positioning and §v1.0 scope. Then:

- **Producers** → [`spec.md`](./spec.md) §Canonical form + [`examples.md`](./examples.md).
- **Validator/parser implementers** → [`schema.v1.json`](./schema.v1.json) + [`registry.json`](./registry.json) + [`error-codes.json`](./error-codes.json) + [`IMPLEMENTATION.md`](./IMPLEMENTATION.md).
- **Security policy (resource bounds, trust model, host-ref allowlists)** → [`spec.md`](./spec.md) §Security Considerations.
- **Reviewing the contract** → [`spec.md`](./spec.md) §Decisions (locked) + §Remaining open items.

## Versioning

- `schema` field is the version of this specification (semver).
- `mixRuntime` is the compatible Mix runtime range (advisory).
- MAJOR bumps ship with a migration document and CLI migrator.
