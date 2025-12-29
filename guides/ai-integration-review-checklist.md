# AI Integration Vision: Review Worksheet

## Purpose
Capture decisions and feedback for Track B: schema-generated / ephemeral UIs in `guides/ai-integration-vision.md`.

This file is intentionally short; it should not duplicate the vision doc. It exists so reviews produce actionable outputs (decisions + notes).

## How to use
- For each row in the decision log, pick a value and add a short rationale.
- For feedback, reference the relevant section in `guides/ai-integration-vision.md` (links below) and write “yes/no/needs work” notes.

## Decision log

| Decision | Options | Selected | Notes |
|---|---|---|---|
| Schema direction | `adopt` / `adapt` / `mix-native` |  |  |
| Canonical AST layer | `yes` / `no` |  |  |
| Token reference format | `type-in-name` / `explicit object` |  |  |
| Token naming convention | `type.<name>` (name may contain dots) / `other` |  |  |
| Variant composition | `simple mapping only` / `allow expressions` |  |  |
| Transform model | `closed registry` / `other` |  |  |
| Tooling MVP scope | `Part 9.6 as-is` / `smaller` / `bigger` |  |  |
| Perf budgets | `as proposed` / `needs change` |  |  |
| A11y contract | `as proposed` / `needs change` |  |  |
| Patch/diff format | `json-patch` / `custom` / `undecided` |  |  |
| Streaming support | `phase 2` / `phase 3` / `undecided` |  |  |
| Authoring validation | `meta-schema` / `validate API` / `both` |  |  |
| Structural model | `child/children rules as written` / `needs change` |  |  |
| Animation keys | `durationMs` / `duration` / `other` |  |  |

## Review prompts (where to comment)
- Strategy/packaging: `guides/ai-roadmap.md`, `Part 9.5`.
- Interoperability decision: `Part 3.0`.
- Canonical AST architecture: `Part 2.5`.
- Token model + resolver: `Part 3.4`.
- Variant mapping: `Part 3.5`.
- Events/actions: `Part 3.6`.
- Binding + safe transforms: `Part 3.7`.
- Animations mapping: `Part 3.8`.
- Handler/rendering pipeline alignment: `Part 4.2`.
- Trust/security model: `Part 8`.
- Tooling/testing/perf/a11y requirements: `Part 9.6`.
- Remaining open questions: `Part 10`.
