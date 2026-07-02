# Phase 1 — Format v1 charter (versioning, null policy, strict/lenient, limits)

**Status:** Not started · **Depends on:** phase 0 · **Blocks:** credible server-driven use; publishing
**Scope:** the wire format's *rules of evolution* — envelope, null semantics,
decode modes, input limits, and the written policy. No new styling coverage.

## Objective

Give the wire format a constitution: a version field, a uniform null policy, a
deliberate old-client/new-data story, and untrusted-input resource limits — all
written into `WIRE_CONTRACT.md` and enforced by tests. After this phase, "what
happens when the schema changes" has an answer other than "everything breaks."

## Context

Confirmed by probe `[review B2, A3, A6]`: payloads carry no version; unknown
fields are rejected at every nesting depth, so **any additive change is a hard
breaking change for every older decoder**, and the failure carries no version-skew
signal; explicit `null` is rejected everywhere except `constraints.maxWidth/maxHeight`
(where it is *required* to mean infinity); payload size/depth limits were deleted
mid-branch (`mix_schema_limits.dart`, commit `9239a75e8`) with no replacement.

## Requirements

### R1.1 — Versioned envelope `[review B2]`
- Top-level style documents carry a required integer `"v"`. Current format
  version: `1`.
- Nested style objects (inside variants, flex_box/stack_box parts) do **not**
  carry `v` — governed by their document's version.
- Decoding a document with an unsupported `v` fails with a dedicated error code
  (`unsupportedVersion`) whose message names both the payload's and the
  decoder's supported version(s).
**Acceptance:**
- [ ] `v` accepted/required per D1.1's transition rule; tests for: valid `v:1`,
      unsupported `v:2`, missing `v` (per decision), non-integer `v`.
- [ ] `exportJsonSchema()` reflects the envelope; golden updated.
- [ ] Format version is a distinct constant from the package version (supersedes
      phase 0's R0.8 test with: format-version-in-schema-export test).

### R1.2 — Uniform null semantics `[review A3]`
- Explicit JSON `null` is **forbidden** in every field position; absent key is
  the only "unset." Violation → dedicated error code (`nullForbidden` or
  equivalent) with path.
- The constraints infinity exception is eliminated per D1.2 (either `"infinity"`
  string sentinel, or documented as the single sanctioned null with rationale).
**Acceptance:**
- [ ] Probe-style tests: `{"padding": null}`, `{"decoration": {"color": null}}`,
      nested-in-variant null — all fail with the dedicated code and precise path.
- [ ] Round-trip for unbounded max constraints under the D1.2 representation.
- [ ] WIRE_CONTRACT.md "Null semantics" section written.

### R1.3 — Strict / lenient decode modes `[review B2]`
- **Strict (default):** current behavior — unknown key/kind/enum anywhere fails
  the document. Fail-closed for untrusted input.
- **Lenient (explicit opt-in):** unknown keys, unknown discriminator kinds,
  unknown enum values cause the *smallest enclosing named property* (one styler
  field, one variant entry, one modifier entry) to be skipped and recorded as a
  path-qualified **warning**; structural problems (bad `v`, unknown root `type`,
  forbidden null, malformed term) remain fatal; a composite value is never
  partially applied.
**Acceptance:**
- [ ] Decode API accepts a mode (options object or parameter — D1.3).
- [ ] Result type carries warnings distinct from errors (severity or separate
      list) without breaking existing `MixSchemaDecodeSuccess/Failure` matching.
- [ ] Tests per issue class × mode: unknown top-level field, unknown nested
      field, unknown variant `kind`, unknown enum value, unknown modifier `type`
      — lenient skips exactly the right granule and reports it; strict fails.

### R1.4 — Written evolution policy `[review B2]`
WIRE_CONTRACT.md gains a normative "Versioning & Evolution" section:
- Additive within v1 (new fields, new `kind`/enum values, new token kinds later);
  meaning/unit/type changes of an existing key **never** — that is `v: 2`.
- What producers may rely on; what old strict clients do (reject, correctly);
  what old lenient clients do (degrade with warnings).
- Deprecation notation for renamed keys.
**Acceptance:**
- [ ] Section exists, reviewed against R1.1–R1.3 behavior; no code/doc conflict.

### R1.5 — Untrusted-input resource limits `[review A6]`
- Restore explicit caps: maximum nesting depth and maximum node count (defaults
  informed by real payloads — e.g. depth 64, nodes 10k; tune in D1.4).
- Exceeding a cap fails with a dedicated code (`limitExceeded`) and path.
**Acceptance:**
- [ ] First verify whether ack already enforces caps (probe with a deep-nesting
      bomb through `Ack.lazy` variants); implement only what's missing.
- [ ] Tests: depth bomb via nested variants, wide-array bomb; decoder returns a
      typed failure (never a stack overflow / hang) within the caps.

### R1.6 — Error model additions
- New codes introduced above (`unsupportedVersion`, `nullForbidden`,
  `limitExceeded`, warning-severity carrier) added to `MixSchemaErrorCode` +
  error-mapper coverage test (every code reachable).
**Acceptance:**
- [ ] `error_mapper_test.dart` extended; each new code has a reaching test.

## Non-goals (this phase)

Token grammar, `$merge`/`apply`, new styling coverage, consumer changes.
Unknown-field *preservation* (proxy mode) is permanently out of scope — this
codec is an endpoint; preserved-unvalidated bytes would tunnel the trust boundary.

## Open decisions

**D1.1 — Missing-`v` transition rule.** (a) absent → treated as `v:1` with a
warning, for one transition window (existing fixtures keep working); (b) absent
→ fatal immediately (clean, breaks current payload producers at once).
Recommendation: (a) during this branch's life, flip to (b) before any publish.
**Decision:** _(record)_

**D1.2 — Infinity representation for constraints max bounds.** (a) keep
`null`-means-infinity as the single documented null exception; (b) replace with
`"infinity"` string sentinel and forbid null uniformly. Recommendation: (b) —
one rule beats one exception; migration is mechanical.
**Decision:** _(record)_

**D1.3 — Where the mode lives.** Options parameter on `decode()` vs a
`DecodeOptions` object (extensible for resolvers in phase 5 — recommendation:
introduce `DecodeOptions` now with `mode` only; resolvers slot in later without
another signature change).
**Decision:** _(record)_

**D1.4 — Cap values.** Measure the largest realistic tailwinds-produced payload
and the parity fixtures before picking numbers.
**Decision:** _(record)_

## Verification / exit criteria

- Full gate green; golden schema export updated and reviewed.
- WIRE_CONTRACT.md has Versioning & Evolution + Null semantics sections that
  match tested behavior exactly.
- A malicious-input test group exists (bombs, nulls, bad versions) and passes.

## Decision log & lessons (fill during execution)

| Date | Decision / lesson | Notes |
|------|-------------------|-------|
| | | |
