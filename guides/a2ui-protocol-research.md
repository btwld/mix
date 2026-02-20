# A2UI Protocol Research Notes (for Mix Track B)

Date: 2026-02-06
Status: Working research notes for architecture decisions in `guides/ai-integration-review-checklist.md`.

## 1) Why this document exists

We need a high-signal summary of A2UI before choosing:
- whether Mix should adopt/adapt/make-native schema choices
- how to handle transport, validation, binding, and migration risk
- where A2UI aligns (and does not align) with Mix Track B (`guides/ai-integration-vision.md`)

## 2) Canonical sources

Primary sources used:
- A2UI docs home: <https://a2ui.org/>
- A2UI v0.8 spec (stable): <https://a2ui.org/specification/v0.8-a2ui/>
- A2UI v0.9 spec (draft): <https://a2ui.org/specification/v0.9-a2ui/>
- A2UI v0.9 evolution guide: <https://a2ui.org/specification/v0.9-evolution-guide/>
- A2UI v0.8 A2A extension: <https://a2ui.org/specification/v0.8-a2a-extension/>
- A2UI roadmap: <https://a2ui.org/roadmap/>
- A2UI renderers: <https://a2ui.org/renderers/>
- A2UI release notes: <https://a2ui.org/release-notes/>
- Official GitHub repository: <https://github.com/google/A2UI>
- Google announcement post: <https://developers.googleblog.com/en/introducing-a2ui-an-open-project-for-agent-driven-interfaces/>

Related ecosystem context (primary docs):
- A2A official docs: <https://a2a-protocol.org/latest/>
- AG-UI docs (protocol relationship pages): <https://docs.ag-ui.com/agentic-protocols>

Note:
- There are many non-official or mirror-style pages using A2UI branding/domains. Treat those as secondary marketing context, not normative protocol references.

## 3) Current state snapshot

### 3.1 Version and maturity

- A2UI is still positioned as "Early Stage Public Preview".
- As of 2026-02-06, the latest published spec line is `v0.9` (draft).
- `v0.8` remains marked stable/recommended for production in spec docs.
- `v0.9` includes substantial protocol/API evolution and is the active forward path.
- Roadmap currently targets protocol `v1.0` in Q4 2026.

Interpretation:
- Usable now, but not yet at long-term stability guarantees.
- Any hard dependency should assume near-term migration work.

### 3.2 What is production-ready today (from docs)

- Renderers: Lit (stable), Angular (stable), Flutter/GenUI (stable), React (in progress).
- Transports: A2A and AG-UI shown as complete/stable in roadmap docs.

## 4) Core protocol model

### 4.1 Core design principles

A2UI repeatedly emphasizes:
- declarative JSON (not executable UI code)
- client-owned trusted component catalog
- flat adjacency-list component graph for LLM-friendly generation
- progressive/streaming rendering
- explicit structure vs data-model separation

### 4.2 v0.8 message model

Server->Client core messages are described as:
- `surfaceUpdate`
- `dataModelUpdate`
- `beginRendering`
- `deleteSurface`

This model is JSONL/stream-first and surface-scoped.

### 4.3 v0.9 message model (draft)

v0.9 shifts naming and envelope shape toward:
- `createSurface`
- `updateComponents`
- `updateDataModel`
- `deleteSurface`

It also formalizes:
- transport-decoupled envelope concepts
- path/scoping cleanup
- client capability metadata and data-model sync behavior
- function-based client logic and validation

## 5) Data model and binding semantics

### 5.1 Data path model

- JSON Pointer style paths are used for binding and updates.
- Relative path scoping is supported inside templated list rendering.
- Two-way input binding is part of the model (input changes update data model).

### 5.2 Structure/state separation

- Layout/structure updates and data updates are intentionally decoupled.
- This enables reactivity without full component re-send.

### 5.3 Sync behavior

- v0.9 introduces explicit synchronization behavior via `sendDataModel` on surface creation.
- Upsert semantics are clearly defined for `updateDataModel`.

## 6) Catalogs, custom components, and security

### 6.1 Catalog negotiation

- Client advertises supported catalog IDs and optional inline catalogs.
- Agent selects catalog per surface.

### 6.2 Security posture

- Security model is "data not code": no arbitrary executable UI payload.
- Trust boundary control is delegated to client allowlisting and renderer implementation.

### 6.3 Custom components

- Protocol is component-agnostic beyond schema conventions.
- Teams can extend with custom catalogs and custom component renderers.

## 7) A2A and AG-UI relationship

### 7.1 A2A

- A2UI can ride over A2A transport.
- v0.8 includes explicit A2A extension details (`application/json+a2ui`, extension URI, metadata placement).

### 7.2 AG-UI

- A2UI docs position AG-UI as complementary transport/runtime layer.
- AG-UI docs similarly describe A2UI as a generative UI spec, not a replacement for AG-UI protocol runtime.

## 8) v0.8 -> v0.9 migration pressure (important)

The evolution guide indicates non-trivial renames and behavior shifts, including:
- `beginRendering` -> `createSurface`
- `dataModelUpdate` -> `updateDataModel`
- `userAction` -> `action`
- simplification of bound value encodings
- path terminology unification
- component property renames (`usageHint` -> `variant`, etc.)

Implication:
- If we align with A2UI, we should budget for version adapters and compatibility layers rather than binding Mix internals directly to one shape.

## 9) Gaps/risks to account for

Observed from docs:
- some docs remain v0.8-style while v0.9 draft introduces renamed concepts
- several guide sections still include TODO placeholders
- ecosystem and transport integration is advancing quickly

Implication for Mix:
- treat A2UI as a high-value upstream to interoperate with, but not a frozen contract
- keep Mix canonical AST internal and versioned

## 10) Decision impact on Mix checklist

The checklist is already present at `guides/ai-integration-review-checklist.md`.

How this research should influence each key decision:

| Checklist decision | A2UI-informed guidance |
|---|---|
| Schema direction | Prefer `adapt` or `mix-native + adapters` over strict `adopt`, due v0.8/v0.9 churn and Mix-specific semantics. |
| Canonical AST layer | Strong `yes` signal. Needed to absorb A2UI version changes safely. |
| Token reference format | Keep explicit, strongly-typed references in Mix AST even if A2UI wire format is looser. |
| Variant composition | Keep simple mapping for v1; avoid expression explosion. |
| Transform model | Use closed function registry only (matches A2UI no-executable-code principle). |
| Tooling MVP | Need schema inspector + structured validation errors early if using generated UI at scale. |
| Patch/diff format | Favor standard patch semantics at adapter boundary; avoid bespoke where possible. |
| Streaming support | Phase 2 is reasonable; A2UI is stream-oriented, so delaying too long harms parity. |
| Authoring validation | "both" (schema-level + runtime validate API) aligns with A2UI prompt-generate-validate loop. |

## 11) Recommended strategy for Mix Track B (research conclusion)

1. Keep Mix internal canonical AST and renderer pipeline as source of truth.
2. Build A2UI adapter(s) at package boundary (`mix_schema`), not in `packages/mix` core.
3. Target the latest wire line (`v0.9` draft) while preserving `v0.8` stable compatibility via explicit adapter IDs.
4. Preserve strict trust boundaries in Mix regardless of transport (A2A, AG-UI, SSE, etc.).
5. Track upstream A2UI releases and automate compatibility tests against fixture streams.

## 12) What to do next

- Step 1: Fill `guides/ai-integration-review-checklist.md` with explicit decisions.
- Step 2: Freeze an internal canonical AST for Mix v0.1 (`mix_schema`).
- Step 3: Define adapter contracts (`a2ui_v0_9_draft_latest`, `a2ui_v0_8_stable`) and validation strategy.
- Step 4: Implement golden fixtures for stream examples, binding scopes, and action round-trips.
