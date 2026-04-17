# RFC Template

Fill out this template in step 7. Save as a `.md` file somewhere the user can reach. The user files it wherever they file RFCs — GitHub issue, Linear, Jira, Notion, a doc.

The template is intentionally not coupled to file paths. File paths are the most volatile part of a codebase; an RFC should describe responsibilities and contracts that survive a reorg.

---

## Title

A short, declarative title. "Deepen `<concept>` into a single module" works well.

## Problem

Describe the architectural friction in 3–5 sentences:

- Which modules are shallow and tightly coupled
- What integration risk lives in the seams between them
- Why this makes the codebase harder to navigate, test, or change

Be concrete. Name the modules. Quote one or two examples of the friction.

## Proposed Interface

The chosen interface design:

- Interface signature — types, methods, params
- A short usage example showing how callers use it
- What complexity the interface hides internally

If the interface is the result of a hybrid recommendation, say so and credit the elements you combined.

## Dependency Strategy

State which category applies and how the dependencies are handled:

- **In-process** — modules merged directly; no boundary
- **Local-substitutable** — tested with [name the specific substitute]
- **Ports & adapters** — port definition, production adapter, test adapter
- **Mock** — mock boundary for external services

If more than one category is in play, address each.

## Testing Strategy

- **New boundary tests to write** — describe the behaviors to verify at the interface
- **Old tests to delete** — list the shallow-module tests that become redundant
- **Test environment needs** — local substitutes, adapters, fixtures

Be specific enough that someone picking up the RFC can scope the work.

## Implementation Recommendations

Durable architectural guidance, not coupled to current file paths:

- **Owns** — what responsibilities the module takes on
- **Hides** — implementation details that no caller should need to know
- **Exposes** — the interface contract (link or restate)
- **Migration** — how callers move to the new interface; whether a deprecation period is needed

## Out of scope

List what this RFC explicitly does *not* cover. This is where you protect the refactor from scope creep.

## Open questions

Anything you flagged during exploration that the team needs to decide before implementation starts. Empty is fine if there are none.
