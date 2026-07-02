# Mix — mix_schema Evolution Plan (focused context)

> **Temporary, plan-focused instructions.** While the `plan/` work is active, this file
> replaces the general project doc (restore it afterwards: `git show 344ae3c86:AGENTS.md`).
> `CLAUDE.md` is a symlink to this file — edit here only.

## Mission

Execute the **mix_schema evolution plan** in [`plan/`](plan/README.md): make
`packages/mix_schema` a complete, elegant wire contract for Mix styles — serving preset
packages (`mix_tailwinds`), server-driven styling, and shared design tokens, and composing
under a future widget-tree layer.

Everything derives from the clean-sheet review at
`.context/reviews/mix_schema-clean-sheet-review.md` — verdict: **keep the skeleton**
(Ack codecs decoding into real Mix stylers, fail-loud encode, canonical forms),
**replace the policies** (tokens, versioning, single-source encode, frozen registry),
and realign the tailwinds consumer.

## How to work the plan (every session)

1. **Orient** — read `plan/README.md` (status board), then `plan/session.md` (latest
   entry), then the active `plan/phaseN.md`.
2. **Decide before doing** — resolve the phase's *Open decisions* (D-items) first and
   record outcomes in its Decision log. Don't start tasks gated on an open decision.
3. **Execute** — work the task checklist in order, checking items off in the doc as they
   land. Requirements carry `[review A1]`-style tags — read the tagged finding in the
   review before implementing.
4. **Verify** — meet the phase's exit criteria; the standard gate is
   `melos run gen:build && melos run ci && melos run analyze`.
   Never check off an item without fresh passing output.
5. **Hand off** — append a `plan/session.md` entry (did / decisions / blocked / next) and
   update the README status board. On phase close: fill the phase's *Decision log &
   lessons* and roll cross-cutting insights into `plan/lessons.md`.

Phase order: **0 → 1 → 2 → 3 → 4 → 5**. Phase 2's inventory run generates phase 4's
backlog (`plan/coverage-backlog.md`); phase 4's gradient codec gates phase 5's bypass
removal; phase 5 starts with a benchmark before deciding.

## Key references

| What | Where |
|---|---|
| Plan, status, session log, lessons | `plan/` |
| Review behind the plan (finding IDs `A*`/`B*`/`C*`) | `.context/reviews/mix_schema-clean-sheet-review.md` |
| Wire format spec — keep in lockstep with code | `packages/mix_schema/WIRE_CONTRACT.md` |
| Earlier code-level review (`S*`/`C*` item IDs) | `.context/review-mix-schema/REVIEW.md` |
| Packages in scope | `packages/mix_schema`, `packages/mix_tailwinds`; `packages/mix` for minimal core asks only |

## Environment & commands

- Flutter **3.41.7 via FVM** (`fvm flutter …`), Dart ≥3.11. If flutter is missing: `bash setup.sh`.
- `melos bootstrap` · `melos run gen:build` · `melos run ci` · `melos run analyze` · `melos run fix`

## Critical rules

- `mix.dart` and `*.g.dart` are generated — never hand-edit. `melos run gen:build` after
  spec changes; `melos run exports` for the barrel.
- Specs are immutable; Styler fields are `$`-prefixed `Prop<V>?`.
- Tests assert **behavior**, never requirement IDs (`packages/mix_schema/REQUIREMENTS.md`
  convention — the plan's R-IDs are planning artifacts only).
- `packages/mix` is a **published stable package** (≥2.0.3): core changes must be
  minimal, separately committed, and CHANGELOG'd.
- Conventional Commits `type(scope): description` — scopes: `mix`, `mix_schema`,
  `mix_tailwinds`, `mix_generator`, `mix_annotations`, `mix_lint`.
  Branch: `feat/mix_schema`; PRs target `main`.

## Skills (invoke before the matching work)

| Skill | When |
|---|---|
| `dev-tools:executing-plans` | Working a phase checklist task-by-task |
| `dart-flutter-kit:mix` | Touching any `packages/mix*` code (Prop, Styler, tokens, variants) |
| `dart-flutter-kit:dart-codegen` | Phase 2's analyzer inventory tool; any generator work |
| `dev-tools:test-driven-development` | New codec/grammar behavior — write the round-trip test first |
| `dev-tools:code-review` + `dev-tools:verification-before-completion` | Before closing a phase |
| `dev-tools:systematic-debugging` | Test failures — root cause, not guesses |
| `dart-flutter-kit:dart-flutter` | General Dart/Flutter questions |
