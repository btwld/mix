# Mix Agent UI Roadmap (Track A)

This document covers **Track A**: developer-authored agent application UI patterns (streaming, tool calls, approvals, provenance) built with Mix 2.0.

- Strategy overview (single source of truth): `guides/ai-roadmap.md`
- Track B (schema-generated/ephemeral UIs): `guides/ai-integration-vision.md`

## Purpose

This section proposes concrete, scoped additions to **Mix 2.0** (and adjacent packages/docs) to make Mix an excellent foundation for **AI-agent UIs**: conversational + GUI hybrids, multi-step tool runs, approvals, streaming updates, and trust/provenance surfaces.

It is intentionally **actionable**: each proposal includes scope boundaries, deliverables, and suggested validation.

## Current Context (What Mix 2.0 Already Has)

Mix 2.0 is already well-positioned for agent UIs because it provides:
- **Fluent stylers** (`BoxStyler`, `TextStyler`, `FlexBoxStyler`, `StackBoxStyler`, etc.) that are explicit and IDE-friendly.
- **Context-aware variants** (`.onHovered`, `.onPressed`, `.onDark`, breakpoints, platform variants, etc.) for dynamic/adaptive styling.
- **Design tokens + theming** via `MixScope` and `MixToken<T>` for system-wide consistency.
- **Deferred resolution and transformations** with `Prop<T>` + directives (numeric/text) for parameterized styles and responsive transforms.
- **Modifiers** via `.wrap()` for consistent wrapper effects and predictable composition.

## Goals (AI-Agent Focused)

### G1: Standardize interaction contracts visually
Make it easy for teams to consistently render:
- streaming and partial results
- progress and long-running tool calls
- approvals/permissions with clear gating
- recoverable failures (retry / edit / continue)
- provenance (citations, source badges, "generated vs verified" affordances)

### G2: Keep Mix core small and stable
Avoid bloating `mix` with product-specific semantics. Prefer:
- documentation + examples
- optional add-on packages
- small targeted core improvements that improve **debuggability**, **composition**, or **token interoperability**

### G3: Make agent UIs easy to build correctly
Optimize for developer experience:
- clear patterns
- reusable recipes
- good defaults
- lints/templates that steer people away from footguns

## Non-Goals

- Implementing agent runtimes, tool execution, memory systems, retrieval, or model orchestration.
- Building a full component library in `mix` itself (that belongs in Remix/Naked or an add-on package).
- Encoding "trust policies" in styling (we can render the affordances, not enforce product policy).

## Problem Statements (Translated Into Mix-Shaped Requirements)

### P1: Nondeterministic content needs stable UI affordances
Agent outputs vary in content/structure; users must always have consistent controls:
- "Stop / Retry / Refine / Undo"
- "View steps / View sources"
- "Approve / Deny / Edit inputs"

**Mix requirement:** a small set of canonical *visual + interactive patterns* that can be reused across apps without copying bespoke styling.

### P2: Hybrid NL + GUI needs "parameter surfaces"
Natural language is great for intent; GUIs are needed for review and safe execution.

**Mix requirement:** patterns for "editable parameters", "generated forms", "diff + apply", "confirmations", and "preview before execute".

### P3: Orchestration is a first-class UI state machine
Multi-step tasks require a timeline: queued → running → awaiting approval → completed/failed.

**Mix requirement:** a standard "run timeline" styling model and tokens for states.

### P4: Trust requires consistent provenance + risk affordances
Agent experiences need standardized, easy-to-scan trust surfaces.

**Mix requirement:** a tokenized system of provenance/risk UI surfaces (badges, emphasis, warnings, citation chips).

## Proposals

### A) Update "AI usage" guidance to Mix 2.0 (fast, high leverage)
**Why:** `packages/mix/ai.txt` currently describes v1.x patterns; coding agents and humans will generate outdated code.

**Deliverables**
- Add a v2-focused AI guidance file (suggested path: `packages/mix/ai_v2.txt`).
- Keep `packages/mix/ai.txt` but clearly mark it as `mix: 1.x` and point to the v2 file.
- Include "golden snippets" covering:
  - tokens (`MixScope`, `$token()` usage)
  - variants (`.onHovered`, `.onDark`, `.onBuilder`)
  - modifiers (`.wrap(.opacity(...))`, transforms)
  - common agent UI patterns (tool card, streaming state, approval CTA row)

**Acceptance criteria**
- A codegen agent can produce a correct Mix 2.0 example app without using `$box/$on/$with` namespaces.

---

### B) Add an "Agent UI Patterns" section to the docs site (no core changes)
**Why:** Mix can be *the styling substrate* for agent apps, but teams need canonical patterns they can copy.

**Deliverables (docs)**
- A new docs folder under `website/src/content/documentation/agent-ui/` with pages like:
  - `overview.mdx` — mental model and pattern inventory
  - `message-layouts.mdx` — user/assistant/tool message structures
  - `streaming.mdx` — skeletons, incremental rendering, "stop" affordance
  - `tool-calls.mdx` — running/success/failure tool cards
  - `approvals.mdx` — permission gates, irreversible actions, "review inputs"
  - `provenance.mdx` — citations, source chips, "verified vs generated"
  - `error-recovery.mdx` — retry/edit/continue patterns
  - `parameter-surfaces.mdx` — generated forms and sliders (GUI + NL)
- Each page includes:
  - a minimal "recipe" style (tokens + stylers)
  - a variant map (which states exist and how they look)
  - dos/don'ts and accessibility notes

**Acceptance criteria**
- A developer can implement the 5 core flows (streaming, tool running, approval, failure/retry, citations) using only Mix primitives + recipes from docs.

---

### C) Publish a reference Flutter app: "Mix Agent Playground"
**Why:** Patterns become real when there's a runnable implementation.

**Deliverables (repo)**
- Add an example under `examples/agent_playground/` that simulates:
  - streaming messages
  - tool calls with progress + output
  - approval gating
  - error states with retry
  - citations/provenance UI
- The example should be "agent-runtime agnostic": it uses fake streams and state machines.

**Acceptance criteria**
- A contributor can change the visual language by editing tokens/styles in one place and see consistent updates across the playground.

---

### D) Create an optional add-on package: `mix_agent_ui` (recommended)
**Why:** Some needs are reusable but product-specific. Package boundaries keep `mix` clean.

**Scope boundaries**
- **In scope:** stylers/recipes, tokens, small state scopes, helper variants.
- **Out of scope:** networking, model calls, retrieval, storage, safety policy enforcement.

**Proposed API surface**
- `AgentUiScope` (InheritedWidget) providing:
  - `AgentRunPhase` (idle, streaming, toolRunning, needsApproval, done, failed)
  - `AgentRiskLevel` (low/medium/high) for affordance styling
  - `AgentProvenanceMode` (none/citations/verified)
- `AgentTokens` (default token set) for:
  - message bubble surfaces (bg/fg/border/shadow)
  - timeline states (running/success/fail)
  - provenance badges and citation chips
  - density/typography scale (compact/comfortable)
- Variant helpers:
  - `ContextVariant.agentPhase(...)` (reads from `AgentUiScope`)
  - `ContextVariant.risk(...)` (reads from `AgentUiScope`)
- Recipe stylers:
  - `MessageBubbleStyler`
  - `ToolCardStyler`
  - `ApprovalPanelStyler`
  - `CitationChipStyler`
  - `ActionBarStyler`

**Acceptance criteria**
- Teams can import the package and get a coherent, customizable agent UI baseline by overriding tokens (not rewriting widget trees).

---

### E) Targeted Mix core improvements (small but meaningful)
These are the *few* changes worth considering inside `packages/mix` because they improve general debugging and composition for dynamic UIs.

#### E1) Style resolution "trace" (debug-only)
**Problem:** When variants are nested and tokenized, it's hard to know *why* a property resolved a certain way.

**Proposal**
- Add an opt-in debug flag (assert-only) that records:
  - which variants were active
  - which tokens were resolved
  - final merged order (base → variants → widget-state)
- Surface via something like:
  - `StyleSpec.debug` metadata
  - `Style.debugDump(context)` or `style.build(...).debugDump()`

**Acceptance criteria**
- A developer can answer "why is this hovered color used?" without stepping through merge logic.

#### E2) First-class "density" token conventions
**Problem:** Agent apps often need a "compact vs comfortable" toggle (think logs/timelines).

**Proposal**
- Provide a recommended token convention and helpers (docs-first; core only if needed):
  - `$density` token with enum values
  - `Prop` directives to scale spacing/typography based on density

**Acceptance criteria**
- A single toggle changes spacing/typography consistently across message lists and tool cards.

---

### F) Token interoperability (longer-term, strategic)
**Why:** Cross-platform design systems increasingly depend on token portability across tools and runtimes.

**Proposal options**
1) A small CLI script in `scripts/` that:
   - imports a standardized token JSON format → generates Dart token declarations + default values
   - exports current Mix tokens → JSON
2) A "token registry" doc and naming conventions to keep tokens stable and discoverable.

**Acceptance criteria**
- A design token update can be applied via a single regen step with minimal manual edits.

## Suggested Roadmap (Phased)

### Phase 0 (1–2 days): Alignment + decisions
- Confirm desired scope: docs-only vs add-on package vs core changes.
- Choose naming: `mix_agent_ui` vs `mix_ai_ui` vs `mix_patterns`.
- Decide on a single reference app structure and state machine.

### Phase 1 (1–2 weeks): Quick wins
- A) v2 AI guidance file + update existing `ai.txt`.
- B) Agent UI docs section (initial 3 pages: streaming, tool calls, approvals).
- C) Minimal playground example (fake streams + tool cards).

### Phase 2 (2–6 weeks): Package + polish
- D) `mix_agent_ui` initial release with tokens, scope, variants, and 3 recipes.
- Expand docs to cover provenance and error recovery.
- Add golden screenshots and a lightweight design checklist.

### Phase 3 (6–12 weeks): Debug + interoperability
- E1) Debug trace for style resolution (assert-only).
- F) Token import/export tooling if there is real demand from teams.

## Internal Validation Plan (How We Prove This Works)

### Product-level checks (qualitative)
- Heuristic evaluation against Human-AI UX guidance:
  - expectations and system status
  - user control and permission gating
  - error recovery and correction loops
  - provenance clarity and trust affordances

### Developer experience checks (quantitative)
- Time-to-implement tasks in the playground:
  1) add a new tool card type
  2) add "needs approval" gating
  3) add a new risk/provenance style
  4) add density toggle
- Measure:
  - lines changed
  - number of files touched
  - time-to-first-working

### Technical checks
- Accessibility pass on the playground (semantics for streaming updates, focus order, contrast via tokens).
- Performance sanity (no jank while streaming; avoid excessive rebuilds).

## Open Questions (Decisions Needed)

- Should agent UI patterns live under `website/` only, or also mirrored in `examples/` as a runnable playground?
- Do we want `mix_agent_ui` to depend on Remix/Naked, or stay purely Mix-primitive?
- How opinionated should the recipes be: "style-only" vs "widgets + styles"?
- Do we want to define a standardized provenance model (citations, verified sources), or keep it purely visual/tokenized?
