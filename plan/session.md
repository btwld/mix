# Session Log

Running log so any human or agent can pick up this work with full context.
Append entries at the top. Keep entries short: what happened, decisions, next step.

Template:

```
## YYYY-MM-DD — <who/agent> — <phase(s)>
**Did:** …
**Decisions:** …
**Blocked/open:** …
**Next:** …
```

---

## 2026-07-02 — Claude (Fable, clean-sheet review session) — planning

**Did:**
- Completed a clean-sheet review of `feat/mix_schema` (multi-agent: 3 explorers,
  baseline verification, 4 evidence probes on Sonnet, 1 isolated clean-sheet
  designer on Fable, synthesis by lead). Findings snapshot committed to
  `plan/findings.md` (the working session's original scratch copy lived in a
  gitignored `.context/` path and is not otherwise available).
- Baseline verified green before judging: mix_schema 163/163, mix_tailwinds
  477/477, mix scoped 199/199, mix_generator 257/257; `dart analyze` + DCM clean.
- Verdict: **Redesign at the contract level** — keep skeleton/engine/tests,
  replace policies (tokens, versioning, single-source encode, frozen registry),
  realign tailwinds' runtime payload round-trip to test-time.
- Created this `plan/` folder: README, findings.md, phase0–phase5 requirement
  docs with checklists, lessons.md, session.md.

**Decisions (from the review, carried into the plan):**
- Keep ack as the engine (stable 1.0.0 exists on pub.dev; swap the git-SHA pin);
  hide `AckSchema` from the public extension API instead of replacing the engine.
- Keep existing wire spellings (`w100`, `scrolled_under`, …); apply
  "wire names = Dart names" only to new vocabulary.
- Build the drift ratchet (phase 2) **before** coverage expansion (phase 4) —
  its first run generates the coverage backlog.
- Calibrated targets (Leo): anchor = preset packages (tailwinds); design targets
  = server-driven styling + shared tokens (defined separately, referenced on the
  wire, resolved via MixScope inheritance); extensibility check = future widget-
  tree document layer (separate package, composes on top).

**Blocked/open:**
- Upstream coordination with btwld/ack `flutter_codec` (overlaps
  `common_codecs.dart`) — decide before phase 4 grows that file further.
- Tailwinds runtime decode cost unmeasured — phase 5 starts with a benchmark.
- Publishing intent/timing for mix_schema — affects whether phase 1 moves first.

**Next:** Phase 0 — resolve its open decisions (singleton icon/image fix shape),
then execute its checklist.
