# Current Goal

The current focus of this repo's schema work is `mix_schema`.

## Primary Goal

Make `mix_schema` a durable, schema-first contract for building Mix interfaces from structured input.

This work should optimize for the quality of the contract itself, not for preserving the current implementation shape.

## What Matters Most Right Now

- **Schema compatibility first:** It must be easy to build valid Mix interfaces through the schema and hard to produce invalid payloads.
- **`mix_tailwinds` is a proof of concept, not the source of truth:** It should validate the contract and fit cleanly, but it should not distort the contract into something Tailwind-specific.
- **Correctness over compatibility:** Breaking changes are acceptable while the schema contract is still forming if they produce a cleaner and more durable long-term design.
- **Ack is the contract center:** Use Ack as the single source of truth for transform, validation, and schema export.
- **No parallel contract layers:** Avoid duplicating wire names, field definitions, validation rules, or export logic across separate manual systems.
- **Do not under-engineer or over-engineer:** Add abstraction only when it improves correctness, clarity, reuse, or contract quality.
- **Follow conventions where they help:** Match Mix and Dart conventions when useful, but do not preserve incidental structure that fights the contract.

## Decision Filter

When evaluating `mix_schema` work, ask:

- Can a future producer build valid Mix interfaces from the schema without knowing Mix internals?
- Can AI tooling consume stable schema artifacts and diagnostics to generate correct payloads?
- Does `mix_tailwinds` still fit naturally as a proof of concept for the contract?
- Would we accept the change if it breaks compatibility now but produces a better long-term schema layer?

## Non-Goal For This Phase

The goal is not to preserve the current package architecture at all costs.
The goal is to shape the right schema contract first, then let the implementation follow it.