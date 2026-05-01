# Mix JSON Schema — Session Log

Running log of design and implementation progress for the Mix JSON Schema.

Entries are append-only. Each session adds a dated block describing what changed, why, and what's next.

---

## 2026-04-20 — Design groundwork

**Goal:** establish a JSON contract that lets external tools (AI agents, design tools, CMS, backends) emit Mix widget trees declaratively.

**Outcomes**
- Positioned as a **public contract**, not internal serialization. Mix internals may refactor freely; the contract versions independently.
- Locked the first set of grammar decisions: canonical form normative, closed enums + `x:` extension, strict-by-default validation, `{host: "..."}` tagged objects for runtime indirection.
- Inventoried Mix source: 8 specs, 10 widgets, 30 modifiers, 27 directives, 8 token namespaces, 18 structured literals, 5 variant kinds.
- Chose hand-authored (no codegen) to keep the contract decoupled from Mix's Dart annotations.

**Iterations**
- v0.1 → v0.2: separated public contract from `Prop<V>` internals; tightened unions; added SubStyle restriction for composites.
- v0.2 → v1.0-rc: added machine-readable registry; dropped `onPressed`/`animation.onEnd` from v1.0 (deferred to v1.1); removed `style` from generic `Pressable`; canonicalized host refs to tagged objects; made structured literals leaf-expanded; decided round-trip guarantees use canonical structural equality (not byte-equal); made `x:` token namespaces explicit.

**State at end**
- Decisions table: 22 locked.
- Open: final enum value tables, compound variants (deferred), `Matrix4` shape (resolved to ordered transform-ops).

---

## 2026-04-20 — Lean v1 consolidation pass

**Goal:** apply peer-review recommendations without widening v1 scope.

**Changes**
- `Matrix4` locked as ordered transform-ops list (`{op, ...params}` form, same discriminator as directives). v1.0 ops: `identity`, `translate`, `scale`, `rotateZ`. Angles canonical in radians.
- Enum policy: mirror Flutter's public surface; pin per schema version; aliases (`FontWeight.normal`→`w400`, `bold`→`w700`) normalize at input.
- Token precedence: inline bundle → host `MixScope` → unresolved error. Override scope: exact fully qualified keys only.
- `x:` atom grammar: `[a-z][a-z0-9_-]*` (lowercase, starts with letter, no spaces/dots/uppercase inside an atom).
- Error codes: language-neutral `error-codes.json` is source of truth; language implementations mirror it.
- Single strict validation mode; no lenient fallback.
- Empty optional arrays omitted in canonical form.

**Decisions table grew:** 22 → 41 locked.

---

## 2026-04-20 — Folder consolidation + formal JSON Schema

**Goal:** put all spec artifacts in one place and ship a formal JSON Schema.

**Changes**
- Moved files into `guides/mix_schema/` and renamed: `spec.md`, `registry.json`, `error-codes.json`, `examples.md`. Added `README.md`.
- Wrote `schema.v1.json` — formal JSON Schema (Draft 2020-12), ~1500 lines, 133 `$defs`.
- Wrote 5 normative examples in `examples.md` (sugar + canonical): animated button, responsive grid, form input, themed card, composite flexbox.
- Validated via Python `jsonschema`: schema itself valid, all example envelopes pass, 21-test regression battery green.

**Scope boundary documented**
- Schema enforces **structural validity** (discriminated unions, token grammar, extension grammar, host-ref positions, animation discriminators, literal discriminators, directive op catalog).
- **Deferred to reference validator**: per-prop type shape (e.g. `padding` must be `EdgeInsets`-shaped), nested Value validation inside structured-literal bodies.

---

## 2026-04-20 — Consistency sweep

**Goal:** eliminate contradictions across the six files.

**Fixed**
1. `"namespace.path"` → `"namespace.name"` in Value example (was the only divergence from the rest of the doc).
2. Stale "Normative examples: to be written" section → pointer to `examples.md`.
3. Missing `schema/error-codes.json` in the Dart package deliverables list.
4. `Variant_box`/etc. in schema pointed to a generic `_Variant` — decision #25 (variant must match enclosing spec) wasn't actually enforced. Specialized each `Variant_<spec>` to reference its matching `Style_<spec>`.
5. Example 3 (form input) had a missing `}` breaking JSON parsing.
6. Schema's `Value` was canonical-only (rejected sugar). Since validator precedes canonicalizer in the pipeline, `Value` now accepts both sugar (`bare scalar`) and canonical (`object`).
7. Shared directive templates (`_NoArgStringDirective` etc.) broke `oneOf` discrimination (multiple specific directives matched the same shape). Inlined each directive with its unique `"op": {"const": ...}`.
8. Extension examples used uppercase (`x:MyCard`, `x:featureFlag`) — violated atom grammar. Corrected to `x:my-card`, `x:feature-flag`.
9. Context variant values shown as single examples → expanded to full closed sets.
10. `error-codes.json` used `host.unresolved` but `host` wasn't in declared `conventions.categories`.

**Validation after**: 21/21 regression, 6/6 examples valid.

---

## 2026-04-21 — Codex MCP peer review + fixes

**Goal:** spawn parallel codex agents to catch anything still pending.

Four read-only codex agents, each focused on a different angle:
1. Schema correctness (Draft 2020-12 best practices, unused defs, `oneOf` discrimination).
2. Registry vs Mix source alignment (`packages/mix/lib/src/`).
3. Spec normativity (ambiguities, edge cases, stale phrasing).
4. Error code coverage (rules without codes, codes without rules, category drift).

**Findings applied**
- **Schema.** Removed unused `StyleNode` $def. Tightened `TokenPath` — `x:` tokens now require lowercase atom grammar end-to-end (was permitting `x:brand.Foo` and `x:brand.a..b`). `TokenBundle` values now typed as `Value` (was unconstrained). `ValueObject.value` rejects null literal.
- **Registry.** Added missing props from Mix Dart source: `text.selectionColor`, `text.semanticsLabel`, `text.locale`; `icon.blendMode`; `image.centerSlice`. Added `Rect` structured literal.
- **Spec.** Clarified resolution order (directives apply exactly once, no double application). Added `animation` + `textDirectives` to merge rules. Documented modifier style-nested exceptions (`box.style`, `defaultTextStyler.style` are raw StyleNodes, not Values). Added explicit null-rejection canonical rule. Specified named/enum/breakpoint variant activation semantics. Clarified RowBox/ColumnBox `direction` precedence (widget-level is authoritative; explicit `direction` in flex sub-style triggers `variant.direction-ignored` warning). Defined directives-only-with-no-base as a resolution-time error (`directive.no-base`).
- **Error codes.** Added `envelope.field-missing`, `envelope.field-forbidden`, `value.null-forbidden`, `directive.no-base`, `variant.direction-ignored`. Replaced vague `resolve.render-failed` with specific `resolve.unresolved-leaf`.

**Validation after**
- ✓ All JSON parses; schema is valid Draft 2020-12.
- ✓ 6/6 example envelopes validate.
- ✓ 7/7 new tightening tests pass (uppercase in x:, double-dots, null values, bundle value shape).
- ✓ Error categories align (15 declared = 15 used).
- Totals: 8 specs, 19 literals (added Rect), 30 modifiers, 27 directives, 47 error codes.

---

## 2026-04-22 — Spec-guide audit + 12 conformance upgrades

**Goal:** run the contract against the "Working with Specs" guide (12 sections covering spec rigor, RFC language, conformance roles, security, machine-readable artifact rules, lifecycle). Apply all gap fixes step-by-step; delegate implementation to sonnet subagents after the first two.

**Audit — 4 parallel codex agents** (read-only) against guide §§2-3, §§4+6, §§8+10, §§11+9. Produced a consolidated list of real gaps. Presented each fix one-by-one for review before applying.

**12 changes applied**
1. **RFC 2119/8174 preface** in §Normative language. Formal keyword interpretation; lowercase "must/should" explicitly non-normative.
2. **§Conformance added** with 7 roles (Producer, Validator, Canonicalizer, Parser, Serializer, Consumer/runtime, Lint tool). Drift sweep: reclassified earlier "Reference validators MAY warn" as lint-tool obligations; clarified JSON Schema artifact vs validator actor.
3. **§Security Considerations** added: trust model, resource bounds (1 MB doc / depth 32 / array 1024 / directive chain 16 / token path 128), no external resolution, host refs as capabilities, fail-closed defaults. 5 new error codes.
4. **Canonical structural equality** defined algorithmically (objects by key set, ordered arrays by index, strings byte-equal, numbers after canonical coercion, nulls rejected, `x:` opaque). §Round-trip guarantees now references this algorithm.
5. **`x:` round-trip preservation** pinned in §Extensions: canonicalizers/parsers/serializers MUST preserve `x:` fields byte-for-structure; nested `x:` allowed inside payloads. Naming-rules bullet scoped to schema-visible positions.
6. **Validator terminology sweep**: unified "validator" as the combined JSON Schema + semantic actor; "schema-validation error" → "validation error"; singular canonical form.
7. **Inline examples marked non-normative** via one sentence in §Normative language; normative fixtures remain `examples.md` only.
8. **JSON Schema Draft 2020-12** pinned in §Envelope prose (not just the `$schema` URI).
9. **MUST rationale framework** in §Normative language (interop / safety / core-promise). 4 non-obvious MUSTs tagged inline.
10. **§Model and invariants** added before §Envelope: 9 concepts + 7 invariants. Concept-first framing per guide §3.
11. **Invalid examples** added to `examples.md` (§Invalid examples): 5 failing cases bound to §spec rules + `error-codes.json` codes. All 5 confirmed to reject under the schema.
12. **Lifecycle status reclassified** v1.0 Release Candidate → **v1.0 Draft** (honest per guide §9; reference implementation not yet written, no independent implementation from the text alone). Updated across `spec.md`, `examples.md`, `README.md`, `registry.json` (`1.0.0-rc` → `1.0.0-draft`), `error-codes.json`. Lifecycle rationale paragraph added to `spec.md`.

**Process**
- Each change reviewed conceptually before applying; Leo approved one-by-one.
- Implementation delegated to sonnet subagents from change #3 onward (structured prompts, read-only grep for drift, validation script).
- Validation script (`Draft202012Validator.check_schema` + all 3 JSON files parse) ran after every change. Green throughout.

**State at end**
- Contract now has all 12 conformance upgrades from the spec-guide audit.
- Error codes: 47 → 52 (5 security-related adds).
- Locked decisions: still 41; changes were rigor/clarity, not new policy.
- Status: **v1.0 Draft** — honestly set. Path to Candidate requires reference implementation + independent impl from text alone.

---

## Status snapshot

**Contract state:** v1.0 Draft.

**Files in `guides/mix_schema/`**
- `spec.md` — normative specification (~970 lines after conformance upgrades).
- `schema.v1.json` — formal JSON Schema Draft 2020-12 (~1500 lines, 130+ `$defs`).
- `registry.json` — prop/literal/enum/modifier/directive catalog (~520 lines).
- `error-codes.json` — 52 codes across 15 categories.
- `examples.md` — 5 normative valid examples + 5 invalid examples bound to rules/codes.
- `README.md` — entry point.
- `SESSIONS.md` — this file.

**Decisions locked:** 41.

**Remaining open items**
1. Enum consistency pass against current Flutter SDK — mechanical check; policy is locked.
2. Compound variant conditions (`and`/`or`) — deferred post-v1.0.

**Out of v1.0 scope (deferred to ≥ v1.1)**
- `$ref` / named styles, action/event binding, conditional children, iteration, phase/keyframe animations, multi-mode validation, `ContextVariantBuilder`, `Matrix4` full form, degree-input sugar, TypeScript companion, producer SDKs.

**Path to Candidate**
- Reference implementation in `packages/mix_schema/` (validator, canonicalizer, parser, serializer, Dart types, conformance tests).
- ≥1 independent implementation built from `spec.md` alone.
- Enum table sweep against current Flutter SDK.

---

## Next actions

### Contract work
- [ ] Final enum table sweep vs current Flutter SDK (mechanical — any new Flutter enum values get added as MINOR bumps).

### Reference implementation — `packages/mix_schema/`
Canonical mirror of the guides folder + Dart code:
- [ ] `schema/v1.json` (mirror of `guides/mix_schema/schema.v1.json`).
- [ ] `schema/prop-registry.json` (mirror of `registry.json`).
- [ ] `schema/error-codes.json` (mirror of `error-codes.json`).
- [ ] `lib/src/types/` — hand-written Dart types.
- [ ] `lib/src/validator.dart` — JSON Schema validator + semantic rules that the schema defers (per-prop type matching, directive target-type checking, directives-only with no base).
- [ ] `lib/src/canonicalizer.dart` — sugar → canonical normalization.
- [ ] `lib/src/parser.dart` — canonical JSON → typed model → Mix runtime objects.
- [ ] `lib/src/serializer.dart` — Mix objects → canonical JSON (deterministic).
- [ ] `lib/src/errors.dart` — mirror of `error-codes.json`.
- [ ] `test/conformance/` — golden JSON, canonical outputs, round-trip tests using canonical structural equality.

### Documentation
- [ ] Authoring guide for producer authors.
- [ ] Consider a small "first-document" tutorial for agents/producers.

---

## 2026-05-01 — Execution runbook landed in repo

**Goal:** make the locked architecture (`IMPLEMENTATION.md`) actionable by a fresh executing agent — without requiring access to the multi-round brainstorm history.

**Outcome**
- Added [`EXECUTION.md`](./EXECUTION.md) — a phased build runbook covering pre-flight, workspace integration (melos categories, pubspec contents for both new packages, analysis_options), and 7 implementation phases (Foundations → Types → Canonicalizer → Validator → Parser/Serializer pure → Parser/Serializer Flutter → Polish). Each phase lists files to create with absolute paths, scope per file, LOC estimates, acceptance criteria, and verification commands. Includes a verification matrix and per-phase risk callouts.
- Phase 2 carries the explicit ambiguity-surfacing note from `IMPLEMENTATION.md` plus 9 enumerated likely-ambiguity sites that should round-trip to `spec.md` review rather than be improvised.
- Validator strategy locked: hand-rolled Draft 2020-12 subset (~950 LOC core). Reasoning: `json_schema` (pub.dev) is Draft 7 only; `json_schema_builder` is Draft 2020-12 but its error model can't cleanly map to the 52 normative codes — wrapping a library's internal rule names is brittle.
- Asset-loading strategy locked: copy `schema.v1.json` + `registry.json` + `error-codes.json` into `packages/mix_schema/lib/src/assets/`; provide `MixSchemaAssets.embedded(...)` for embedded use and `MixSchemaAssets.fromFiles(...)` (CLI) for `dart:io`-backed loading. The pure core never imports `dart:io`.
- README updated to point implementers at both `IMPLEMENTATION.md` (architecture) and `EXECUTION.md` (runbook).

**State at end**
- Schema spec: v1.0 Draft, locked.
- Architecture: locked in `IMPLEMENTATION.md`.
- Runbook: in `EXECUTION.md`, ready for Phase 0 pre-flight.
- Total estimated work: ~16k–22k LOC, 13–20 days, with Phase 5 as the pure-package ship checkpoint.

**Next**
- Phase 0 pre-flight, then Phase 1 (Foundations).

---

## 2026-05-01 — Reference implementation architecture locked

**Goal:** settle the reference implementation plan for `packages/mix_schema/` before any Dart code is written. Output is a design doc the independent second implementation (Candidate promotion gate) can verify against.

**Process**
- Multi-agent brainstorm via SuperGrok Expert mode (4 agents).
- Two rounds of substantive pushback on the initial proposal:
  1. Single `models.dart` (3k+ lines) → **per-family split** mirroring spec sections (`document`, `nodes`, `values`, `modifiers`, `directives`, `variants`, `extensions`).
  2. Validator-before-canonicalizer build order → **canonicalizer-before-validator**, with the validator internally calling `canonicalize()` so sugar grammar lives in exactly one module (no drift between "what validator accepts" and "what canonicalizer produces").
- Verification pass via parallel codebase audits against `schema.v1.json` ($defs coverage, import-cycle check), `examples.md` (5 invalid fixtures traced through the proposed pipeline), the 41 locked decisions, and the existing `packages/mix/` runtime (dependency surface scan).
- Final pushback on parser/serializer split (defer-until-pain reversed; verification proved pure-layer needs zero `mix` imports) + 7 housekeeping items.

**Outcomes**
- **Two-package split.** `mix_schema` (pure Dart, zero Flutter dep) + `mix_schema_flutter` (depends on `mix_schema` + `mix`). Reasoning: tree-shaking does not remove a declared `package:mix` dep at pub resolution time; backend producers (CMS exporters, AI agents) must not pull Flutter.
- **Pure-layer round-trip ownership.** Decision #17 invariants (`canonicalize(canonicalize(x)) ≡ canonicalize(x)` and `serialize(parse(x)) ≡ x`) are proven without `flutter_test`. Runtime "renders identically" guarantee lives in the Flutter package.
- **4-stage validator pipeline:** bounds → schema-on-raw → internal canonicalize → semantic-on-canonical. Resource bounds (Decision #22, §Security) fail-closed before any deep walk.
- **Hand-written `types/` directory** (renamed from `models/` to match spec.md §Parser & Serializer Deliverables verbatim).
- **7 audit items resolved:** types/ naming, FontWeight aliases owner (#36), leaf expansion ownership (#15), empty array omission (#41), `test/conformance/` deliverable, HostRef placement (`types/values.dart`), `x:` byte-for-structure round-trip preservation.

**Captured**
- Full plan in [`IMPLEMENTATION.md`](./IMPLEMENTATION.md): module ownership tables (spec section → file, conformance role → file, decision → file), validator pipeline detail, build order with phase deliverables, audit resolutions, deferred implementation decisions.

**Next**
- Resolve open implementation decisions before each phase entry: JSON Schema validator strategy (off-the-shelf vs hand-roll, given normative error-code requirement), dual-source-of-truth coherence between `schema.v1.json` and `types/`, CI invariant hooks.
- Phase 1 (foundations) begins after validator-strategy decision lands.

---

## Conventions for this log

- Append only; do not rewrite past entries.
- Each session starts with date + goal.
- End state of the session in a short `State at end` or similar block.
- Keep entries concise; link to files/sections rather than inlining long excerpts.
- When a decision is taken, record **what** changed and **why** — future readers pick up faster that way.
