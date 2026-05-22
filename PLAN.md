# `mix_schema` Plan

## Goal

`mix_schema` is the schema-first contract for building Mix UI from structured input. It exists so that producers — AI tooling, design systems like Tailwind, future authoring surfaces — can build valid Mix interfaces from a stable, exportable schema **without knowing Mix internals**.

The contract has to optimize for:

- **Schema compatibility first.** It should be easy to produce a valid Mix payload through the schema, and hard to produce an invalid one.
- **Correctness over compatibility.** Breaking changes are acceptable while the contract is still forming if they produce a cleaner, more durable long-term shape.
- **AI-facing artifacts.** Exported JSON Schema and diagnostics should be stable enough for a model to consume and generate correct payloads against.
- **`mix_tailwinds` is a validation target, not the source of truth.** It should fit naturally as a proof of concept; it must not distort the contract into something Tailwind-specific.

## Simplicity targets

We are deliberately optimizing for a small surface that's easy to audit and easy to reason about:

- **One contract definition per Mix concept.** A styler, a modifier, a variant, a value-level codec — each has exactly one place that names its wire shape, decodes it to a runtime, and encodes it back. No parallel manual lists of fields, no separate wire-name maps, no separate JSON Schema templates.
- **Producers see one root entry point.** `MixSchemaContract` is the only surface a caller needs to know. It exposes `validate`, `decode`, `encode`, and `exportJsonSchema`. Internal machinery — registries, branches, helpers — stays behind that wall.
- **No backwards-compatibility carveouts in the contract layer.** While the schema is taking shape, the wire format and the API are free to break. Once shipped, the wire format becomes the stable thing and the implementation can keep evolving underneath it.
- **Deletion is the default.** Helpers, casts, and wrappers earn their keep on every pass. If a Phase-N change drops the last caller, the helper goes away in the same pass. The package should shrink as Ack grows.

## Ack as the contract center

Ack is the single source of truth. Every part of the contract is expressed as an Ack schema, and we **reuse Ack's codec features as much as possible** rather than building parallel layers in `mix_schema`.

What that means in practice:

- **`Ack.codec(input, output, decode, encode)` owns every leaf transform.** Color strings, alignments, gradients, modifiers, stylers — all of them are codecs. We do not write decoders or encoders that bypass an Ack schema. The codec is the contract for that field, end to end: parse, validate, encode, and JSON-Schema export.
- **`Ack.discriminated(...)` owns every union.** Borders, gradients, decorations, shape borders, text scalers, modifiers, variants, top-level stylers — every place we used to hand-roll a `type:`-switch becomes a discriminated codec. The union owns the discriminator literal (PR #107 in Ack), so branches don't carry duplicate `type: Ack.literal(...)` declarations in their input schema. We rely on Ack to enforce branch selection on parse and to emit a clean `anyOf` artifact on export.
- **`Ack.object(...).model(...)` is the typed-decoder pattern we follow.** Object fields are declared once in an `Ack.object({...})` shape; the codec decodes the parsed map into the typed Mix value and encodes the typed value back. We do not maintain a second parallel field list.
- **`Ack.enumString(...)` / enum codecs replace handwritten string maps.** Every enum has one canonical wire name. Decode and JSON Schema export both come from the same `aliasedEnumCodec` definition.
- **`Ack.list(...)`, `Ack.instance<T>()`, refinements, `nullable()`, `optional()`, `withDefault(...)` are first-class building blocks.** We compose them. We do not re-implement them.
- **JSON Schema export comes from Ack.** `AckSchema.toJsonSchema()` is the artifact pipeline. The contract layer only adds top-level metadata (contract version, structural limits) — never per-field schema authoring.

The goal is that **anything Ack can express, we express in Ack**. The amount of code in `mix_schema` should be the irreducible minimum needed to map Mix's specific types (`BoxStyler`, `EdgeInsetsMix`, `GradientMix`, …) into Ack codecs. Everything else — parse semantics, validation diagnostics, JSON Schema export, discriminator routing — is Ack's job.

## Test for any future change

When adding to, removing from, or refactoring `mix_schema`, ask:

1. Can a producer build a valid Mix interface from the schema without knowing Mix internals?
2. Can AI tooling consume the exported JSON Schema and generate correct payloads?
3. Does `mix_tailwinds` still fit naturally as a proof of concept?
4. Are we using an Ack feature, or recreating one in `mix_schema`? If recreating, why?
5. Would we accept a breaking change here if it produced a better long-term contract?

If a change makes any of (1)–(4) worse, it's the wrong change.

## Where Ack still owes us features

Some things we want from Ack that the current branch (`feat/codec-implementation`) doesn't fully ship yet. These are the only places where `mix_schema` carries a workaround instead of leaning on Ack directly:

- **Numeric coercion from JSON int to Dart `double`.** JSON does not distinguish int from double, so wire payloads commonly use integer literals for double-valued fields. Ack's `Ack.double()` rejects ints strictly. `mix_schema` carries a single tiny `doubleFromNum()` codec helper that accepts either literal and produces a `double`. When Ack ships native int-to-double coercion (either by relaxing `Ack.double()` or by exporting `NumberSchema` to JSON Schema), this helper goes away in one delete.
- **`x-ack-codec` JSON-Schema annotation on codec-backed branches.** Older Ack versions emitted this marker so producer tooling could tell that a branch was codec-backed. The current Ack branch doesn't emit it. Either Ack restores the marker or `mix_schema` updates its expectations — we won't add it on the contract side.
- **Discriminator-error message unwrapping.** Ack's discriminated encode wraps individual branch errors inside a `SchemaNestedError`. `mix_schema`'s error mapper currently surfaces the wrapper, which hides the inner cause (e.g., `RegistryValueLookupError`'s "no registry id found" text). Either Ack exposes a flatter error path or the mapper learns to unwrap — both are options; we'll pick one when we revisit the diagnostic surface.

These are the only known carveouts. Everything else in `mix_schema` should be a thin shim over Ack.
