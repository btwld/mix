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
| Schema direction | `adopt` / `adapt` / `mix-native` | `adapt` | Accept external wire format(s), map to Mix canonical AST to avoid lock-in while tracking A2UI evolution (`v0.9` draft latest + `v0.8` stable compat). |
| Canonical AST layer | `yes` / `no` | `yes` | Isolates wire-version churn to adapters and keeps renderer/tests/debug tooling stable. |
| Token reference format | `type-in-name` / `explicit object` | `explicit object` | Prefer typed `{type,name}` for validation; allow string shorthand only as ingress compatibility. |
| Token naming convention | `type.<name>` (name may contain dots) / `other` | `type.<name>` | Aligns naming across tools and avoids namespace collisions with lintable conventions. |
| Variant composition | `simple mapping only` / `allow expressions` | `simple mapping only` | Keep v1 deterministic and low-risk; revisit expression DSL only after strong demand. |
| Transform model | `closed registry` / `other` | `closed registry` | Trust-gated, host-registered pure transforms only; no arbitrary execution path. |
| Tooling MVP scope | `Part 9.6 as-is` / `smaller` / `bigger` | `Part 9.6 as-is` | Keep validator + inspector + trace + structured errors in MVP; phase delivery internally. |
| Perf budgets | `as proposed` / `needs change` | `needs change` | Split cold vs warm budgets, add p50/p95 targets, and tighten warm mobile updates toward <=16ms. |
| A11y contract | `as proposed` / `needs change` | `needs change` | Add interactive semantics (`checked/selected/expanded`), focus ordering, relationships, and richer live-region controls. |
| Patch/diff format | `json-patch` / `custom` / `undecided` | `json-patch` | Use RFC 6902 baseline; constrain allowed ops and prefer stable keyed nodes to reduce array-index fragility. |
| Streaming support | `phase 2` / `phase 3` / `undecided` | `phase 2` | Required for agent UX parity; minimum viable is stable `nodeId` + incremental apply + graceful placeholders. |
| Authoring validation | `meta-schema` / `validate API` / `both` | `both` | Meta-schema supports offline/LLM self-correction; runtime API enforces cross-field/catalog/runtime constraints. |
| Structural model | `child/children rules as written` / `needs change` | `needs change` | Keep `child/children` but introduce explicit repeat/template node shape instead of overloading `children`. |
| Animation keys | `durationMs` / `duration` / `other` | `durationMs` | Keep units explicit and unambiguous; validate as bounded integer milliseconds. |

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
