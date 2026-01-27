# Mix AI Strategy: Unified Roadmap (v2.x)

## Why this exists
Mix is increasingly used as “design system infrastructure” for Flutter apps. AI introduces two distinct but related needs:

1) **Agent application UIs** (developer-authored): chat + tools + approvals + provenance surfaces, rendered predictably and consistently.
2) **AI-generated / ephemeral UIs** (runtime-authored): an agent produces a structured UI description that Mix can validate, theme, render, and evolve.

These are complementary. They should not be conflated in implementation, packaging, or scope.

## The two tracks (and where the existing docs fit)

### Track A — Agent UI patterns (developer-authored)
**Goal:** Make it easy to build *correct* agent experiences with Mix 2.0 primitives (and optional add-ons) without reinventing UI conventions per app.

**Primary doc:** `guides/ai-agent-ui-roadmap.md`

**Outputs (recommended):**
- Docs patterns + a runnable “Agent Playground” example app.
- Optional add-on package (suggested): `mix_agent_ui` (recipes, tokens, scopes, variants).

### Track B — Schema-driven UI generation (runtime-authored)
**Goal:** Enable agents to generate and evolve UIs safely via a structured schema that Mix can interpret.

**Primary doc:** `guides/ai-integration-vision.md`

**Outputs (recommended):**
- Separate package (suggested): `mix_schema` / `mix_runtime_ui` to avoid expanding `mix` core.
- Schema registry + validator + renderer, with explicit trust boundaries and safe defaults.

## Where the tracks meet (shared primitives)
Both tracks should converge on the same core “design system contracts”:
- Tokens (`MixScope`, `MixToken<T>`) for consistent theming and system portability.
- Variant semantics (hover/press/dark/breakpoints) for adaptive UI.
- A common “trust vocabulary” rendered via tokens (risk levels, provenance states).

Practical implications:
- Track A patterns should be expressible as **schema templates** in Track B (when Track B exists).
- Track B should reuse Track A’s **visual affordances** (tool cards, approvals, provenance) so generated UIs don’t invent new interaction languages.

## Packaging recommendation (keep Mix core small)
- `packages/mix` (core): styling primitives, tokens, variants, modifiers, debug tooling.
- `packages/mix_schema` (new): schema model + parser/validator + renderer + registry.
- `packages/mix_agent_ui` (new): agent UI tokens + scopes + recipe stylers (optionally widgets).
- `scripts/` (optional): token import/export tooling (if/when teams need it).

## 90-day actionable plan (suggested)

### 0–2 weeks (alignment + quick wins)
- Ensure AI guidance files (`AGENTS.md`, `CLAUDE.md`) reflect Mix 2.0 patterns.
- Publish 3 "Agent UI patterns" docs pages: streaming, tool calls, approvals.
- Create the minimal Agent Playground example app (fake streams + state machine).

### 2–6 weeks (make it reusable)
- Define a stable token set for agent affordances (provenance/risk/density).
- Cut `mix_agent_ui` v0.1 with 3 recipe stylers (message bubble, tool card, approval panel).

### 6–12 weeks (schema foundations, if still aligned)
- Decide schema direction: adopt/adapt an external UI schema protocol vs define a Mix-native schema with adapters.
- Implement `mix_schema` Phase 1 (parse/validate/render primitives with tokens + variants).
- Add trust model enforcement and error boundaries.
- Ensure schema-rendered UIs can reuse Track A patterns (templates).

## Key decisions to make early
- Naming to avoid confusion: keep Track A state scopes distinct (e.g., `AgentUiScope`) from Track B orchestration scopes.
- How opinionated recipes should be: “style-only” vs “widgets + styles”.
- Whether schema expresses responsive/adaptive values via variants vs separate value encodings (prefer variants for consistency with Mix).

