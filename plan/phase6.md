# Phase 6 — 1.0 protocol naming and public-surface subtraction

**Status:** Completed · **Depends on:** completed phases 0–5 · **Leaves:** a
publish-ready (but still unpublished) style protocol surface
**Scope:** rename the package around what it actually owns, remove extension
points and duplicate operations with no demonstrated consumer, and make
`mix_tailwinds` the broad reference-consumer contract suite.

## Objective

Turn the completed `mix_schema` implementation into the smallest credible 1.0
Mix style protocol without redesigning its proven wire grammar or codec engine.
The result has one fixed public façade, one result model, required versioned
documents, no legacy registry/custom-branch surface, and exhaustive-enough
Tailwinds contract coverage at test time.

## Clean-sheet verdict

**Simplify and rename.** Keep the JSON v1 grammar, Ack-backed bidirectional
codecs, direct decode into real Mix stylers, token/theme model, strict/lenient
policy, resource limits, canonical value forms, fail-loud encode, error paths,
inventory ratchet, and JSON Schema export. Rename the package to
`mix_protocol` because it owns a versioned trust boundary and compatibility
policy, then subtract the public builder/custom-branch/root-schema/validation
layers and the dead frozen-registry implementation.

The firewalled clean-sheet design independently recommended the same engine
boundary (Ack private, protocol semantics owned here), no runtime Tailwinds JSON
round-trip, no dynamic third-party codec registration, and a separate future
widget/document layer. It proposed a wholly new `$mix`/`$` wire grammar; this
plan rejects that part because the current `v`/`type`/`kind` grammar is already
specified, behavior-tested, readable, and no correctness or simplicity gain
justifies rewriting every producer fixture.

## Reference implementation canvas

### Semantic brief

- **Input:** decoded JSON-safe style or theme documents, and supported runtime
  Mix stylers/themes for encode.
- **Output:** real Mix stylers/themes or deterministic JSON-safe canonical maps.
- **Boundary:** per-node styles and token themes only. Widget trees, events,
  transport, persistence, signing, and arbitrary custom Dart types are outside
  this package.
- **Failure:** invalid/untrusted input and unsupported runtime values return
  stable, path-qualified protocol failures; no partial encode output.

### Important rules and one owner

| Rule | Owner |
|---|---|
| Top-level style/theme documents require supported integer `v`; nested styles inherit it. | protocol envelope preflight in the main façade |
| Built-in styler tags have one fixed mapping to Ack codec branches; v1 has no runtime registration. | private built-in root construction |
| A property has one canonical wire term (`literal`, `$token`, or `$merge`, with supported `apply`). | field/value codecs |
| Strict decode rejects unknowns; lenient decode removes only documented smallest granules and reports original paths within fixed limits. | protocol decode policy |
| Encode is atomic and fail-loud for unsupported values or inventory drift. | codec field owners plus error mapper |
| Icon/image names are resolved per call; supported value forms are data, never closures or arbitrary runtime objects. | identity codec and options |
| Theme aliases are same-kind, whole-value, acyclic, and resolve to a flat immutable token map. | private theme codec |
| Ack remains an implementation detail; JSON Schema is an exported artifact, not a second semantic authority. | public barrel and schema-export tests |
| Tailwinds constructs Mix stylers directly at runtime and proves protocol representability across a broad corpus in tests. | `mix_tailwinds` protocol contract test |

### Phase invariants

1. **Preflight:** input is JSON-safe, null-free, within fixed depth/node limits,
   and carries the supported top-level version.
2. **Parse/decode:** Ack owns structural validation and codec transforms; the
   façade maps every engine failure into protocol errors.
3. **Materialize:** successful style decode is a real requested Mix styler;
   successful theme decode is a flat immutable token map.
4. **Encode:** the runtime value is exhaustively accounted for, encoded once,
   and receives the authoritative version envelope last.
5. **Export:** JSON Schema describes the same accepted boundary grammar and
   carries protocol metadata without exposing Ack types.

## Resolved decisions

### D6.1 — Package name

Rename `mix_schema` to `mix_protocol` and public `MixSchema*` concepts to
`MixProtocol*`. “Schema” remains the right name for Ack definitions and the
exported JSON Schema artifact; the package itself owns version negotiation,
decode/encode semantics, recovery policy, identities, diagnostics, and wire
compatibility, which is a protocol. The future widget-tree layer remains a
separate package that embeds this per-node style grammar.

### D6.2 — Wire format and engine

Keep JSON, the existing `v: 1` + `type`/`kind` vocabulary, and Ack. Do not adopt
a new discriminator/envelope spelling and do not handwrite a parallel
validator. Ack 1.0 is explicitly built for boundary validation, bidirectional
codecs, recursive schemas, structured errors, and JSON Schema export; the local
325-test suite verifies those properties here. Pin the compatible stable range,
keep Ack out of the public API, and let protocol-specific preflight, lenient
repair, canonical forms, tokens, and identity policy remain locally owned.

### D6.3 — Public façade and results

Expose one fixed `mixProtocol` / `MixProtocol` façade with style/theme
decode/encode and style/theme JSON Schema export. Remove dynamic custom branch
registration, the mutable builder, root schema handle, registered-type list,
and duplicate `validate()` operations. They have no production consumer;
custom branches export only a loose arbitrary-object schema and weaken a stable
v1 vocabulary; `validate()` is exactly decode-with-the-value-discarded and is
misleading for resolver-backed identities. Use one generic sealed
`MixProtocolResult<T>` with success/failure variants for every fallible
operation.

The 1.0 signatures are:

```dart
final MixProtocol mixProtocol;

final class MixProtocol {
  MixProtocolResult<T> decodeStyle<T extends Object>(
    Object? input, {
    MixProtocolDecodeOptions options = const MixProtocolDecodeOptions(),
  });

  MixProtocolResult<JsonMap> encodeStyle(
    Object value, {
    MixProtocolEncodeOptions options = const MixProtocolEncodeOptions(),
  });

  MixProtocolResult<MixProtocolTheme> decodeTheme(Object? input);
  MixProtocolResult<JsonMap> encodeTheme(MixProtocolTheme theme);
  JsonMap exportStyleJsonSchema();
  JsonMap exportThemeJsonSchema();
}
```

Theme decode remains strict-only in v1; no theme leniency behavior exists to
preserve. Schema export is infallible and returns `JsonMap` directly. A success
owns a non-null `value` plus immutable `warnings`; a failure owns non-empty
immutable `errors` plus immutable `warnings`. Encode successes have no warnings.
`MixProtocolTheme.tokens` remains an immutable `Map<MixToken, Object>`.

### D6.4 — Identity registry

Delete `RegistryBuilder`, `FrozenRegistry`, `MixSchemaScope`, registry codecs,
registry errors, and their tests. Move the still-live resolver/value-form
identity codecs and identifier grammar to identity-owned files. Keeping a
tested but unreachable legacy implementation is abstraction rent, not safety.

### D6.5 — Version/publish posture

Flip missing top-level `v` from transition warning to fatal and set the renamed
package to `1.0.0`; this is the explicitly requested 1.0 checkpoint. Keep
`publish_to: none` until the repository owner chooses the release workflow.
No compatibility shim is needed because the old package is unpublished and the
user explicitly allows breaking changes.

### D6.6 — Tailwinds relationship

Keep `mix_protocol` as a `mix_tailwinds` dev dependency only. Runtime JSON
round-tripping was measured at roughly 4–9× the direct path in Phase 5 and adds
failure modes without user value. Replace the small representative handshake
with a broad, typed corpus covering box/flex/text/icon utilities, gradients,
variants, breakpoints, transforms, decoration, typography, and modifiers; each
case must encode and strictly decode through the public protocol façade.

### D6.7 — Rename vocabulary boundary

Rename the package/directory/import paths, public `MixSchema*` Dart names,
human-facing messages, JSON Schema `x-mix-protocol-*` metadata, and local
`mix_schema_*` JSON Schema definition identifiers to `mix_protocol` vocabulary.
Preserve all runtime wire keys and discriminators (`v`, `type`, `kind`,
`$token`, `$merge`, `apply`), their values, canonical payload shapes, and every
stable `MixSchemaErrorCode.wireValue` string (renamed Dart enum, unchanged wire
strings). Golden tests must assert both halves: no old branded metadata/defs and
byte/shape-equivalent canonical v1 fixtures apart from metadata outside the
payload.

## Task checklist

### R6.1 — Lock the 1.0 version behavior test-first

- [x] Change version tests so a missing top-level `v` is fatal for styles and
      themes; nested styles still inherit the root version.
- [x] Run the focused tests and confirm they fail by assertion on the old
      transition behavior before production edits. The package/type rename is
      a mechanical breaking migration, not a behavior suitable for a
      compile-error TDD red step.

### R6.2 — Rename and simplify the package façade

- [x] Rename the package/directory/import/config vocabulary from
      `mix_schema`/`MixSchema*` to `mix_protocol`/`MixProtocol*`, including
      Melos inventory wiring, Tailwinds dev dependency, exported schema
      metadata, docs, changelog, and active plan instructions.
- [x] Set `packages/mix_protocol/pubspec.yaml` and its public package-version
      constant to `1.0.0`, keep `publish_to: none`, and retain the existing
      version-lockstep test under the new names.
- [x] Run `melos bootstrap` immediately after the directory/pubspec/dependency
      rename before interpreting analyzer or test failures.
- [x] Rewrite the public API compile test around `package:mix_protocol`, the
      fixed `mixProtocol` façade, generic results, and the exact style/theme
      signatures above. Symbol absence is verified separately by R6.3 greps.
- [x] Replace public contract construction with one fixed built-in root owned
      by `MixProtocol`; expose `mixProtocol` as the shared instance.
- [x] Integrate theme operations under the façade and expose distinct
      `decodeStyle`, `encodeStyle`, `decodeTheme`, `encodeTheme`,
      `exportStyleJsonSchema`, and `exportThemeJsonSchema` methods.
- [x] Unify operation results into `MixProtocolResult<T>`,
      `MixProtocolSuccess<T>`, and `MixProtocolFailure<T>`; remove validation
      result types and methods.
- [x] Focused verification: public API, format/version, theme, resolver, schema
      export, and round-trip suites pass.

### R6.3 — Delete unused extension and registry machinery

- [x] Remove the public branch/builder/root-schema/registered-types machinery
      and its custom-branch-only tests.
- [x] Split the live identity codecs away from the registry-named file, delete
      the legacy frozen registry and registry codec/tests, and remove obsolete
      registry errors/mappings.
- [x] Prove the built-in styler vocabulary through the exported JSON Schema and
      `SchemaStyler` testing vocabulary rather than mutable registration
      introspection. Move `SchemaStyler`/`SchemaModifier`/`SchemaVariant` to
      `testing.dart`-only exposure and assert exact discriminator-set equality,
      not `containsAll`.
- [x] Replace the deleted registry tests with identity-owned boundary tests for
      empty, invalid-character, exactly 96-character, and 97-character names,
      plus icon/image resolver and value-form round trips.
- [x] Focused verification: identity, errors, schema export, all built-in
      stylers, and public API suites pass; exact forbidden-symbol searches find
      no `MixSchemaContractBuilder`, `MixSchemaBranch`,
      `MixSchemaRootSchema`, `MixProtocolContractBuilder`, `MixProtocolBranch`,
      `MixProtocolRootSchema`, `registeredTypes`, validation result types, or
      public `validate()` methods.

### R6.4 — Make Tailwinds the broad reference consumer

- [x] Consolidate the two small schema handshake tests into one protocol
      contract suite with an auditable labeled matrix: every target
      (box/flex/text/icon) plus decoration/borders/shadows, sizing/spacing,
      modifiers, transforms, typography, horizontal and default diagonal
      CSS-corner gradients, state variants, nested variants, and breakpoints.
- [x] For every corpus entry, encode the actual Tailwinds-produced styler and
      strictly decode it back as the expected Mix styler type, then require
      canonical re-encode equality; failures name the category and class string.
- [x] Retain and rename the runtime-import guard so `mix_protocol` remains
      absent from Tailwinds production code.
- [x] Focused Tailwinds contract, characterization, and public-API tests pass.

### R6.5 — Documentation, ratchets, and closeout

- [x] Rewrite README/GUIDE/WIRE_CONTRACT/REQUIREMENTS/CHANGELOG names and
      examples around the fixed façade; explicitly distinguish protocol,
      exported JSON Schema, and the future document layer.
- [x] Regenerate the coverage backlog from the renamed inventory tool and keep
      source/provenance headers accurate.
- [x] Update this phase, `plan/README.md`, `plan/lessons.md`, `plan/session.md`,
      and focused `AGENTS.md` instructions; historical phase/findings/session
      entries remain historical rather than being mechanically rewritten. On
      plan close, restore the repository's general `AGENTS.md` as instructed by
      the temporary focused file.
- [x] Run a final non-historical old-name/path grep covering `melos.yaml`,
      `AGENTS.md`, Tailwinds pubspec/overrides/tests/docs, the inventory tool,
      package docs/source/tests, and generated backlog provenance. Historical
      completed phase/findings/session text is the only allowed old vocabulary.
- [x] Run `melos run gen:build && melos run ci && melos run analyze`, Tailwinds
      visual parity goldens, `git diff --check origin/main...HEAD`, and a full
      fresh agent/code review over the complete phase diff.
- [x] Address all review findings, rerun affected focused tests plus the full
      gate, mark Phase 6 completed, and create exactly one local conventional
      commit for the phase.

## Compatibility, rollback, and stop conditions

- This is an intentional hard cut: package imports, public type names, result
  matching, and missing-version behavior break. There is no published or stored
  pre-1.0 commitment and therefore no compatibility façade.
- Existing canonical v1 payloads with `v: 1` remain byte/shape compatible. No
  data migration is required.
- Rollback is the single Phase 6 commit.
- Stop before implementation if the phase-entry review finds a real production
  consumer of custom branch registration or structural-only `validate()` that
  cannot migrate to JSON Schema/decode.
- Stop before committing if any fresh full gate, visual parity test, inventory
  ratchet, or closeout review finding remains unexplained.

## Verification commands

```bash
# focused package gates
(cd packages/mix_protocol && fvm flutter test --reporter compact)
(cd packages/mix_tailwinds && fvm flutter test \
  test/protocol_contract_test.dart \
  test/tw_parser_characterization_test.dart \
  test/public_api_compatibility_test.dart --reporter compact)

# repository gate
melos run gen:build && melos run ci && melos run analyze

# visual parity
(cd packages/mix_tailwinds/example && fvm flutter test \
  test/parity_golden_test.dart \
  test/shrink_golden_test.dart \
  test/duration_delay_golden_test.dart --reporter compact)

# final hygiene
git diff --check origin/main...HEAD
```

## Decision log & lessons

| Date | Decision / lesson | Notes |
|---|---|---|
| 2026-07-10 | Initial clean-sheet/reference-implementation synthesis recorded. | Baseline: `mix_schema` 325/325 and `mix_tailwinds` 465/465 tests passed before planning. Current production has no Tailwinds runtime schema import; builder/custom branch and frozen registry symbols have no production consumer. |
| 2026-07-10 | Phase-entry review adjustments applied before coding. | Locked exact façade signatures/result immutability, theme strictness, rename/preserve vocabulary, 1.0 metadata + bootstrap sequencing, forbidden-symbol greps, identity-name boundary tests, and an auditable Tailwinds corpus with canonical re-encode. No production consumer blocked the removals. |
| 2026-07-10 | Closeout review findings resolved. | Fresh review found a high-risk recursive/quadratic theme-alias traversal, medium JSON-unsafe diagnostic serialization, a medium missing exact modifier/variant schema-vocabulary ratchet, and a low resolver example without `v`. Alias resolution is now iterative/linear with a 4,900-hop regression, diagnostics omit runtime-only JSON values, discriminator sets are exact, the example is versioned, and the complete post-review gate passed. |
| 2026-07-10 | Phase 6 completed as one breaking unpublished-package cut. | The fixed façade, required version, private Ack engine, stable error wire strings, immutable result/theme collections, canonical Tailwinds corpus, generated backlog, and unchanged Mix/Mix Generator packages were verified together. |
