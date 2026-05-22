---
goal: Upgrade mix_schema value codecs to Ack typed codec schemas
version: 1.0
date_created: 2026-05-22
last_updated: 2026-05-22
owner: mix_schema maintainers
status: Planned
tags:
  - upgrade
  - mix_schema
  - ack
  - schema-contract
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

This plan upgrades `packages/mix_schema` to use Ack PR #109 / branch `feat/codec-implementation` for a focused Phase 1 cleanup of value-level codecs. The goal is to measure how much simpler the value tier becomes when Ack owns typed numeric decoding, discriminated-union discriminator injection, and typed codec encoding.

## 1. Requirements & Constraints

- **REQ-001**: Read `CURRENT_GOAL.md` before execution and preserve the active direction: Ack is the single source of truth for transform, validation, and schema export.
- **REQ-002**: Update `packages/mix_schema/pubspec.yaml` so `ack`, `ack_annotations`, and `ack_generator` point at GitHub branch `btwld/ack:feat/codec-implementation`.
- **REQ-003**: Use the latest branch ref, not a local path and not a pinned commit. On 2026-05-22, `git ls-remote https://github.com/btwld/ack.git refs/heads/feat/codec-implementation` resolved to `a1e876a630cecfcbc24bdd62e7473e87f58cd6cc`.
- **REQ-004**: Include the required mechanical `Ack.codec` API migration across `packages/mix_schema`, because the current Ack branch uses `decode:` / `encode:` and a three-parameter generic factory while local code still uses `decoder:` / `encoder:` with two explicit type arguments.
- **REQ-005**: Limit behavioral codec cleanup to value-level schema files: shared primitives, shared typography/constraints/insets/color, and painting values.
- **REQ-006**: Replace `Ack.number()` with `Ack.double()` or `Ack.integer()` where the Mix runtime field is typed as `double` or `int`.
- **REQ-007**: Remove value-tier `castDouble*` and avoid `castList*` where Ack can now provide typed runtime lists.
- **REQ-008**: Remove branch-authored discriminator literals and encoder tuples from value-level discriminated unions. The union-level `Ack.discriminated(...)` call must remain the owner of the `type` key.
- **REQ-009**: Preserve canonical external union payloads when encoding through the union codecs. Payloads such as `{'type': 'linear_gradient', ...}` and `{'type': 'box_decoration', ...}` must still round-trip through the public schema surfaces.
- **REQ-010**: Do not collapse or delete registry, styler, metadata, modifier, variant, error, widget tree, or producer-helper layers in this phase.
- **CON-001**: The workspace is `/Users/leofarias/Forks/mix/.conductor/sao-paulo-v4`. Do not read or write `/Users/leofarias/Forks/mix`.
- **CON-002**: The target branch is `origin/main`; use `git diff origin/main...` for final impact review.
- **CON-003**: This repo is Dart/Flutter. Run targeted `mix_schema` formatting, analysis, and tests before claiming implementation success.

Codebase findings that ground this plan:

- **FIND-001**: `packages/mix_schema/pubspec.yaml` currently pins Ack packages to commit `31fcd177acd5b92975505579c27d83916134c161` in both dependencies and dependency overrides.
- **FIND-002**: `packages/mix_schema` has 51 library `Ack.codec` call sites and 8 test fixture call sites that currently use the older `decoder:` / `encoder:` named arguments.
- **FIND-003**: The in-scope shared/painting value tier contains 55 `Ack.number()` calls: 4 in `border_schemas.dart`, 5 in `gradient_schemas.dart`, 9 in `shape_border_schemas.dart`, 4 in `box_constraints_schema.dart`, 14 in `edge_insets_schema.dart`, 9 in `primitive_schemas.dart`, and 10 in `typography_schemas.dart`.
- **FIND-004**: The in-scope shared/painting value tier contains 68 `castDouble*` or `castList*` usages: 22 in painting files and 46 in shared files.
- **FIND-005**: Value-level discriminators are duplicated inside branch codecs and encoders in `border_schemas.dart`, `decoration_schemas.dart`, `gradient_schemas.dart`, `shape_border_schemas.dart`, and `typography_schemas.dart` (`textScalerCodec`).
- **FIND-006**: `packages/mix_schema/lib/src/core/codec_typed_encode.dart` is still used only outside the in-scope value files: `primitive_payload_helpers.dart`, `modifier_definition.dart`, and `variant_condition_definition.dart`.
- **FIND-007**: Existing value round-trip coverage lives mainly in `packages/mix_schema/test/shared_schema_catalog_test.dart`, `packages/mix_schema/test/schema/shared/primitive_codec_encode_test.dart`, `packages/mix_schema/test/mix_schema_decoder_test.dart`, `packages/mix_schema/test/contract_hardening_test.dart`, and `packages/mix_schema/test/encode_api_contract_test.dart`.
- **FIND-008**: Ack PR #109 is draft on GitHub and targets `btwld/ack:main` from `btwld/ack:feat/codec-implementation`. The visible PR summary says it introduces typed codec/default/instance/wrapper schema infrastructure and restores union-owned discriminator parsing/encoding.
- **FIND-009**: The current branch source for Ack exposes `Ack.double()`, `Ack.integer()`, `Ack.discriminated(...)`, `Ack.instance<T>()`, and `CodecSchema<Boundary, Runtime>.encode()` returning `Boundary?`.

## 2. Implementation Steps

### Implementation Phase 1

- GOAL-001: Make the Ack branch available and keep the package compiling against the latest Ack codec API.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | In `packages/mix_schema/pubspec.yaml`, change all six Ack refs for `ack`, `ack_annotations`, and `ack_generator` from `31fcd177acd5b92975505579c27d83916134c161` to `feat/codec-implementation`. Keep the GitHub URL and package paths unchanged. |  |  |
| TASK-002 | Run dependency resolution from the repo root with `dart pub get`. If Flutter SDK resolution requires Flutter, run `flutter pub get` from `packages/mix_schema` and keep the resulting lockfile changes. |  |  |
| TASK-003 | Mechanically update every `Ack.codec` call in `packages/mix_schema/lib` and `packages/mix_schema/test`: rename `decoder:` to `decode:` and `encoder:` to `encode:`. |  |  |
| TASK-004 | Remove explicit two-argument generic annotations from `Ack.codec<Boundary, Runtime>(...)` call sites unless inference fails. If inference fails, supply the new three-argument form `Ack.codec<Boundary, InputRuntime, Runtime>(...)`. |  |  |
| TASK-005 | Run `dart format packages/mix_schema/lib packages/mix_schema/test` and `melos exec --scope=mix_schema -- dart analyze .`. Fix only compile/analyzer issues caused by the Ack API bump. |  |  |

### Implementation Phase 2

- GOAL-002: Replace manual numeric coercion with typed Ack numeric schemas in value codecs.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-006 | In `packages/mix_schema/lib/src/schema/shared/primitive_schemas.dart`, replace object fields and `matrix4Codec` list items using `Ack.number()` with `Ack.double()`. Replace `castDouble(...)` decoders with direct `as double` values. Rename `numListSchema` to `doubleListSchema` if it remains a gradient-stop helper. |  |  |
| TASK-007 | In `packages/mix_schema/lib/src/schema/shared/edge_insets_schema.dart`, replace all inset numeric fields with `Ack.double().optional()` and replace `castDoubleOrNull(...)` with `as double?`. Preserve the existing absolute-vs-directional refinement. |  |  |
| TASK-008 | In `packages/mix_schema/lib/src/schema/shared/box_constraints_schema.dart`, replace constraint numeric fields with `Ack.double().optional()` and compare typed `double?` values directly in both refinements and the decoder. |  |  |
| TASK-009 | In `packages/mix_schema/lib/src/schema/shared/typography_schemas.dart`, replace `ShadowMix`, `TextStyleMix`, `StrutStyleMix`, and `TextScaler` numeric fields with `Ack.double()` variants. Replace typed list casts for `shadows` and `fontFamilyFallback` where Ack already returns a typed list. |  |  |
| TASK-010 | In `packages/mix_schema/lib/src/schema/painting/border_schemas.dart`, replace `BorderSideMix` and `BoxShadowMix` numeric fields with `Ack.double()` variants and remove `castDoubleOrNull(...)`. |  |  |
| TASK-011 | In `packages/mix_schema/lib/src/schema/painting/gradient_schemas.dart`, replace rotation, radius, focal radius, start/end angles, and stops with `Ack.double()` / `doubleListSchema`. Remove `_gradientStops` element-by-element `castDouble(...)`. |  |  |
| TASK-012 | In `packages/mix_schema/lib/src/schema/painting/shape_border_schemas.dart`, replace `LinearBorderEdgeMix`, `CircleBorderMix`, and `StarBorderMix` numeric fields with `Ack.double()` variants and remove `castDoubleOrNull(...)`. |  |  |
| TASK-013 | After TASK-006 through TASK-012, run `rg -n "Ack\\.number\\(|castDouble|castList" packages/mix_schema/lib/src/schema/shared packages/mix_schema/lib/src/schema/painting` and resolve any remaining in-scope matches unless the remaining match is explicitly justified in code review notes. |  |  |

### Implementation Phase 3

- GOAL-003: Move discriminator ownership to `Ack.discriminated(...)` for value-level unions.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-014 | In `packages/mix_schema/lib/src/schema/painting/decoration_schemas.dart`, remove `'type': Ack.literal(...)` from `buildBoxDecorationCodec` and `buildShapeDecorationCodec` inputs. Remove `('type', SchemaDecoration.*.wireValue)` from branch encoders. Keep `buildDecorationCodec` branch keys unchanged. |  |  |
| TASK-015 | In `packages/mix_schema/lib/src/schema/painting/border_schemas.dart`, remove branch-authored `type` fields and encoder tuples from `_buildBoxBorderBranch` and `_buildBorderRadiusBranch`. Keep `boxBorderCodec` and `borderRadiusCodec` branch keys unchanged. |  |  |
| TASK-016 | In `packages/mix_schema/lib/src/schema/painting/gradient_schemas.dart`, remove branch-authored `type` fields and encoder tuples from `_buildGradientTransformBranch` and `_buildGradientBranch`. Keep `gradientTransformCodec` and `gradientCodec` branch keys unchanged. |  |  |
| TASK-017 | In `packages/mix_schema/lib/src/schema/painting/shape_border_schemas.dart`, remove branch-authored `type` fields and encoder tuples from every `_buildShapeBorderBranch` branch. Keep `shapeBorderCodec` branch keys unchanged. |  |  |
| TASK-018 | In `packages/mix_schema/lib/src/schema/shared/typography_schemas.dart`, remove the branch-authored `type` field and encoder tuple from `_buildTextScalerBranch`. Keep `textScalerCodec` branch keys unchanged. |  |  |
| TASK-019 | Run `rg -n "'type': Ack\\.literal|\\('type', type\\.wireValue\\)|\\{'type': type\\.wireValue" packages/mix_schema/lib/src/schema/shared packages/mix_schema/lib/src/schema/painting` and resolve remaining in-scope discriminator duplication. |  |  |

### Implementation Phase 4

- GOAL-004: Clean value-codec helper fallout without collapsing deferred layers.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-020 | Remove `../../core/json_casts.dart` imports from in-scope value files once their last cast helper usage is gone. Do not delete `json_casts.dart` in this phase. |  |  |
| TASK-021 | Replace `optionalJsonMap([...])` with a plain map literal only when every field is required and no `propValue(...)` / `propMix(...)` optional filtering remains. Preserve `optionalJsonMap` for sparse Mix prop encoders. |  |  |
| TASK-022 | Confirm no in-scope value file imports `../../core/codec_typed_encode.dart`. Do not edit `primitive_payload_helpers.dart`, `modifier_definition.dart`, or `variant_condition_definition.dart` beyond the Phase 1 mechanical Ack API migration. |  |  |
| TASK-023 | Run `git diff --stat origin/main...` and record the line-count impact for value-codec files versus mechanical Ack API migration files. |  |  |

### Implementation Phase 5

- GOAL-005: Verify the schema contract and decide Phase 2 scope from the actual diff.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-024 | Run `dart format packages/mix_schema/lib packages/mix_schema/test`. |  |  |
| TASK-025 | Run `melos exec --scope=mix_schema -- dart analyze .`. |  |  |
| TASK-026 | Run `melos exec --scope=mix_schema -- flutter test`. |  |  |
| TASK-027 | Run targeted tests if the full package test run is noisy: `flutter test test/shared_schema_catalog_test.dart test/schema/shared/primitive_codec_encode_test.dart test/mix_schema_decoder_test.dart test/contract_hardening_test.dart test/encode_api_contract_test.dart` from `packages/mix_schema`. |  |  |
| TASK-028 | Check that `gradientCodec.encode(...)`, `shapeBorderCodec.encode(...)`, and `catalog.decorationCodec.encode(...)` still emit payloads containing the correct `type` keys through their union codecs. |  |  |
| TASK-029 | Export JSON Schema through `MixSchemaContract.builtIn().exportJsonSchema()` and confirm root styler branch `type` consts are still present. Add or update tests only if the Ack branch changes export shape in a way that affects the public artifact. |  |  |
| TASK-030 | Write a short follow-up note in the PR or `.context` summarizing which helpers still have callers: `json_casts.dart`, `codec_typed_encode.dart`, `primitive_payload_helpers.dart`, and `variant_condition_encoder.dart`. Use that note to scope Phase 2. |  |  |

## 3. Alternatives

- **ALT-001**: Update only the value-level files and leave other `Ack.codec` call sites untouched. Rejected because the Ack branch changed the `Ack.codec` factory API, so out-of-scope files would fail analysis after the dependency bump.
- **ALT-002**: Preserve manual `type` fields inside branch codecs for compatibility. Rejected because it keeps a parallel contract layer that duplicates Ack's union-owned discriminator behavior.
- **ALT-003**: Delete `json_casts.dart`, `codec_typed_encode.dart`, and producer helpers during Phase 1. Rejected because current callers remain in styler, metadata, modifier, variant, and producer-helper layers that are explicitly deferred.
- **ALT-004**: Pin Ack to commit `a1e876a630cecfcbc24bdd62e7473e87f58cd6cc`. Rejected because the user specifically wants the latest feature branch behavior while Ack PR #109 is still moving.

## 4. Dependencies

- **DEP-001**: GitHub branch `https://github.com/btwld/ack/tree/feat/codec-implementation`.
- **DEP-002**: GitHub PR `https://github.com/btwld/ack/pull/109`.
- **DEP-003**: Flutter SDK 3.41.x and Dart SDK >=3.11.0 as configured by this repository.
- **DEP-004**: `melos` workspace scripts for targeted and full validation.

## 5. Files

- **FILE-001**: `packages/mix_schema/pubspec.yaml` - Ack branch dependency upgrade.
- **FILE-002**: `packages/mix_schema/lib/src/schema/shared/primitive_schemas.dart` - primitive value codecs, numeric lists, Matrix4.
- **FILE-003**: `packages/mix_schema/lib/src/schema/shared/edge_insets_schema.dart` - EdgeInsets numeric decode cleanup.
- **FILE-004**: `packages/mix_schema/lib/src/schema/shared/box_constraints_schema.dart` - constraint refinement cleanup.
- **FILE-005**: `packages/mix_schema/lib/src/schema/shared/typography_schemas.dart` - text style, shadows, strut style, text scaler.
- **FILE-006**: `packages/mix_schema/lib/src/schema/shared/color_schema.dart` - mechanical Ack codec API migration only unless analysis reveals a branch-specific issue.
- **FILE-007**: `packages/mix_schema/lib/src/schema/shared/enum_schemas.dart` - mechanical Ack codec API migration only.
- **FILE-008**: `packages/mix_schema/lib/src/schema/shared/image_provider_schema.dart` - audit only; registry-backed value codecs should remain semantically unchanged.
- **FILE-009**: `packages/mix_schema/lib/src/schema/painting/border_schemas.dart` - border values, border radius union, box border union.
- **FILE-010**: `packages/mix_schema/lib/src/schema/painting/decoration_schemas.dart` - decoration image, box decoration union, shape decoration union.
- **FILE-011**: `packages/mix_schema/lib/src/schema/painting/gradient_schemas.dart` - gradient transform union, gradient union, stop/radius numeric cleanup.
- **FILE-012**: `packages/mix_schema/lib/src/schema/painting/shape_border_schemas.dart` - shape border union and numeric cleanup.
- **FILE-013**: `packages/mix_schema/lib/src/core/json_casts.dart` - keep file; remove only now-dead value-side imports.
- **FILE-014**: `packages/mix_schema/lib/src/core/codec_typed_encode.dart` - keep file; out-of-scope callers remain.
- **FILE-015**: `packages/mix_schema/lib/src/schema/metadata/*`, `packages/mix_schema/lib/src/schema/builtins/*`, `packages/mix_schema/lib/src/registry/*`, and `packages/mix_schema/test/*` - mechanical Ack codec API migration only, except tests updated for value-codec behavior.

## 6. Testing

- **TEST-001**: `packages/mix_schema/test/schema/shared/primitive_codec_encode_test.dart` must continue proving primitive encode/decode round trips for color, alignment, offset, radius, rect, and Matrix4.
- **TEST-002**: `packages/mix_schema/test/shared_schema_catalog_test.dart` must continue proving decoration, gradient, shape border, and shared catalog round trips with canonical `type` keys.
- **TEST-003**: `packages/mix_schema/test/mix_schema_decoder_test.dart` must continue proving full BoxStyler decode with decoration, border, border radius, shadow, gradient, and animation.
- **TEST-004**: `packages/mix_schema/test/contract_hardening_test.dart` must continue proving strict enum rejection, payload limits, JSON Schema metadata, and neutral gradient transform naming.
- **TEST-005**: `packages/mix_schema/test/encode_api_contract_test.dart` must continue proving producer-facing encode helpers still return the same primitive payloads.
- **TEST-006**: Add a focused regression test only if current coverage misses union-owned discriminator encoding for an in-scope value union.

Acceptance criteria:

- **AC-001**: `packages/mix_schema/pubspec.yaml` uses `feat/codec-implementation` for all Ack package refs.
- **AC-002**: `melos exec --scope=mix_schema -- dart analyze .` passes.
- **AC-003**: `melos exec --scope=mix_schema -- flutter test` passes, or every failure is documented as unrelated to this plan.
- **AC-004**: `rg -n "Ack\\.number\\(|castDouble|castList" packages/mix_schema/lib/src/schema/shared packages/mix_schema/lib/src/schema/painting` returns no unjustified in-scope matches.
- **AC-005**: `rg -n "'type': Ack\\.literal|\\('type', type\\.wireValue\\)|\\{'type': type\\.wireValue" packages/mix_schema/lib/src/schema/shared packages/mix_schema/lib/src/schema/painting` returns no unjustified in-scope discriminator duplication.
- **AC-006**: Public union codec round trips for decoration, border radius, border, gradient transform, gradient, shape border, and text scaler still include the correct external `type` key.
- **AC-007**: `json_casts.dart`, `codec_typed_encode.dart`, `primitive_payload_helpers.dart`, and deferred styler/metadata/registry files are not deleted in Phase 1.
- **AC-008**: The final diff separates mechanical Ack API migration from value-codec simplification clearly enough to decide Phase 2 scope.

## 7. Risks & Assumptions

- **RISK-001**: Ack PR #109 is draft and moving. Mitigation: run `git ls-remote` before execution, resolve deps fresh, and inspect compile failures before changing schema behavior.
- **RISK-002**: The `Ack.codec` API change expands the touched-file count beyond value codecs. Mitigation: keep this as a mechanical compatibility pass and separate it in the diff review from behavior cleanup.
- **RISK-003**: Direct branch codec encoding may stop returning a `type` key after discriminator cleanup. Mitigation: treat branch codecs as implementation details and verify public union codecs still emit canonical payloads.
- **RISK-004**: JSON Schema export shape may change because Ack now synthesizes discriminator literals. Mitigation: run existing export tests and update expectations only when the public artifact is intentionally improved.
- **RISK-005**: Replacing `Ack.number()` with `Ack.double()` may reject integer JSON numbers if Ack's `DoubleSchema` is stricter than the contract wants. Mitigation: test representative integer inputs currently accepted by producers (`{'x': 1}`, `{'width': 2}`, `stops: [0, 1]`) and decide whether Ack should coerce JSON integers to doubles or whether `mix_schema` should keep selected `Ack.number()` fields.
- **ASSUMPTION-001**: The intended schema contract accepts JSON integer literals for double-valued fields because existing tests use values like `{'x': -1, 'y': 0}` and `{'width': 2}`.
- **ASSUMPTION-002**: `mix_tailwinds` remains a proof consumer and should not force Tailwind-specific names into the shared schema vocabulary.

## 8. Related Specifications / Further Reading

- `CURRENT_GOAL.md`
- `.context/attachments/SS2RoV/pasted_text_2026-05-22_10-14-30.txt`
- `packages/mix_schema/mix_schema_reference_architecture_plan.md`
- `https://github.com/btwld/ack/pull/109`
- `https://github.com/btwld/ack/tree/feat/codec-implementation`
