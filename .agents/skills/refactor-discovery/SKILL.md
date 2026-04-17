---
name: refactor-discovery
description: Explore a codebase, find architectural friction, and propose deepening refactors as RFCs. Use this whenever the user wants to improve architecture, refactor for testability, consolidate tightly-coupled modules, reduce shallow abstractions, find what to refactor, decide where to spend a refactor budget, make a codebase more AI-navigable, or asks "what's wrong with this codebase" / "where should I focus my refactoring" / "this code is hard to test" / "help me write a refactor RFC" — even if they don't say the words "deep module" or "RFC."
---

# Refactor Discovery

Explore a codebase, surface the places where the structure fights you, and propose refactors that deepen modules. The output is an RFC the user can file as a GitHub issue, Linear ticket, Jira story, or shared doc.

## What "deepening" means

A **deep module** (John Ousterhout, *A Philosophy of Software Design*) hides a large implementation behind a small interface. Shallow modules do the opposite — their interface is almost as complex as their guts, so callers end up coupled to internals.

Deepening matters because:

- Deep modules are easier to test at the boundary, not inside.
- Deep modules are easier for an AI (or a new engineer) to navigate, because one file answers one question.
- Bugs hide in the seams between shallow modules. Fewer seams, fewer bugs.

The friction you feel while reading the code is the signal. Trust it.

## What you need from your runtime

This skill is runtime-agnostic. It works in any environment where you can read source files, search across files (grep, glob, code search — whatever exists), and write a markdown file.

Two steps benefit from extra capabilities, but neither is required:

- **Step 1** is faster when the runtime exposes a sub-agent or background exploration tool. If it does, dispatch one. If it doesn't, just read the code yourself.
- **Step 5** asks for 3+ alternative interface designs. If the runtime can spawn sub-agents in parallel, do that and let them work concurrently. If it can't, generate the designs sequentially under the same constraints — the quality of the comparison matters more than the parallelism.

When in doubt, do the work yourself. Don't refuse a step because a specific tool isn't available.

## Process

Work through these steps in order. The user is in the loop at steps 2, 3, 4, and 6 — don't skip their input.

### 1. Explore the codebase

Read the codebase the way someone trying to understand it would. Don't run a checklist; let the structure reveal itself.

Note where you experience friction:

- Understanding one concept forces you to bounce between many small files.
- A module's interface is nearly as complex as its implementation.
- Pure functions have been extracted just for testability, but the real bugs hide in how they're called.
- Tightly-coupled modules create integration risk in the seams between them.
- Parts of the codebase are untested or hard to test.

Friction is the data. Capture what you find as you go.

### 2. Present candidates

Show the user a numbered list of deepening opportunities. For each candidate, include:

- **Cluster** — which modules and concepts are involved
- **Why they're coupled** — shared types, call patterns, co-ownership of one concept
- **Dependency category** — which of the four categories applies (see `references/dependency-categories.md`)
- **Test impact** — what existing tests would be replaced by boundary tests

Do **not** propose interfaces yet. End with: "Which of these would you like to explore?"

### 3. User picks a candidate

Wait for the choice. If they pick more than one, do them sequentially.

### 4. Frame the problem space

Before generating designs, write a short user-facing explanation of the problem space for the chosen candidate. Cover:

- The constraints any new interface needs to satisfy
- The dependencies it would rely on
- A rough illustrative code sketch to make the constraints concrete — this is grounding, not a proposal

Show this to the user, then immediately move to step 5. The user reads and thinks while you produce the designs.

### 5. Generate multiple interfaces

Produce 3 or more **radically different** interface designs for the deepened module. Each design is anchored to a different constraint:

- **Design 1 — Minimal surface**: Aim for 1–3 entry points. Force every caller through a narrow door.
- **Design 2 — Maximum flexibility**: Support many use cases and clean extension points.
- **Design 3 — Optimize for the common caller**: Make the default case trivial; advanced use is opt-in.
- **Design 4 (when applicable) — Ports & adapters**: Design around the ports & adapters pattern for cross-boundary dependencies.

If the runtime supports parallel sub-agents, dispatch one per design with its own brief — file paths, coupling details, dependency category, what's being hidden. If it doesn't, generate the designs sequentially. Either way, hold each design to its constraint independently; don't let them blur into the same shape.

Each design returns:

1. Interface signature (types, methods, params)
2. Usage example showing how callers use it
3. What complexity it hides internally
4. Dependency strategy (see `references/dependency-categories.md`)
5. Trade-offs

Present the designs to the user one at a time, then compare them in prose. After comparing, give your own recommendation: which design is strongest, and why. If two designs combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu.

### 6. User picks an interface

The user picks one design, accepts your recommendation, or asks for a hybrid. Wait for their choice.

### 7. Write the refactor RFC

Produce the RFC as a markdown file. Use the template in `references/rfc-template.md`. Save it somewhere the user can reach — a working folder, a shared doc, a downloads location.

The RFC is tracker-agnostic by design. Common ways to file it:

- **GitHub** — `gh issue create --title "..." --body-file rfc.md` if the repo uses GitHub and the user has the `gh` CLI installed. Confirm before running it.
- **Linear / Jira / Notion / docs** — hand the markdown to the user and tell them where it lives. They paste it where it needs to go.

Don't ask the user to review the RFC before writing it. Write it, share the file path, and offer to file it if they want.

## Reference material

Read these files when the situation calls for them — you don't need to load them all upfront.

- `references/dependency-categories.md` — the four categories (in-process, local-substitutable, ports & adapters, true external) and how each affects the deepening strategy. Read this in step 2 when classifying candidates.
- `references/testing-strategy.md` — how to think about replacing shallow-module tests with boundary tests. Read this when writing the test impact section of a candidate or filling out the testing section of the RFC.
- `references/rfc-template.md` — the RFC template you fill out in step 7.

## A few principles to hold

**Generalize, don't pattern-match.** The four dependency categories are a frame, not a checklist. If a real codebase doesn't fit cleanly, say so and reason from first principles.

**Replace tests, don't layer them.** Old unit tests on shallow modules become waste once boundary tests exist. Plan to delete them in the RFC.

**Be honest about what's hard.** Some candidates look great until you discover an entrenched dependency. Surface that instead of hiding it under a clean diagram.

**The user knows the codebase better than you do.** Your job is to surface friction and propose options. Their job is to know which trade-offs are acceptable in context.
