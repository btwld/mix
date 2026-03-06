# mix_schema Implementation Simulation Results

Date: 2026-03-05
Branch: `leoafarias/feat/mix_schema`
Scope: pre-flight integration through M4 hardening

## Goal

Run the `mix_schema` implementation as review-sized simulation checkpoints,
validate the contract against real Ack and Mix behavior, capture assumptions
that held or failed, and preserve the implementation and validation lessons
before the plan document is updated.

## Implemented

- Added package-local test/dev setup and workspace integration so `mix_schema`
  participates in the normal Flutter package test category.
- Added the first public package surface:
  - `RegistryBuilder<T>`
  - `FrozenRegistry<T>`
  - `StylerRegistry`
  - `MixSchemaDecoder`
  - stable decode error/result types
- Implemented the first end-to-end decode path for `box` payloads.
- Implemented registry-backed runtime lookup for `animation.onEnd`.
- Implemented strict error mapping from Ack errors into stable v1 codes.
- Added coverage for:
  - successful `box` decode
  - missing `type`
  - unknown `type`
  - unknown field
  - type mismatch
  - constraint violation
  - unknown registry id
  - nested path stability

## Validation Run

Commands executed:

```bash
dart format . --set-exit-if-changed
dart analyze --fatal-infos
flutter test
```

Results:

- `dart format . --set-exit-if-changed`: passed
- `dart analyze --fatal-infos`: passed
- `flutter test`: passed

Note:
- Tests were run through the Dart tooling integration, which executes the same
  package test suite required for this slice.

## Assumptions

Confirmed:

- The current `box` vertical slice can decode directly into Mix runtime types
  without an intermediate DTO layer.
- Registry-backed runtime lookups integrate cleanly through transform-time
  resolution and surface deterministic path-based errors.
- Nested Ack validation paths can be mapped into stable v1 error results.

Disproved:

- The selected Ack branch does not natively support transformed child branches
  inside `Ack.discriminated()`. The original plan assumed this worked.

Revised implementation decision:

- `mix_schema` now normalizes each discriminated branch into an object-backed
  schema for Ack dispatch, then applies the branch transform at the outer
  discriminated layer. This preserves transformed branch behavior without
  relying on unsupported Ack semantics.

Still unverified:

- String-to-`Type` mapping requirements for `modifierOrder`.
- Variant cycle-breaking requirements in `buildVariantSchema(styleSchema)`.

## Simplifications Applied

- Moved immutability enforcement into `FrozenRegistry` so the frozen type owns
  its own contract instead of relying on `RegistryBuilder` to provide an
  unmodifiable map implementation.
- Kept the discriminated-branch helper minimal:
  - raw object-backed branches
  - one transform layer over an object-backed schema
- Tightened color parsing to strict integers so invalid wire values fail as
  type mismatches instead of loose string-conversion validation errors.

## Risks

- The implementation is intentionally narrow and only proves the `box` path.
- Shared schema reuse is still minimal and should be expanded before adding more
  styler breadth.
- The revised discriminated-branch strategy should be treated as the new
  contract for later slices unless Ack behavior changes again.

## Recommendation Before M2

Do not widen styler coverage yet.

Next work should be:

1. Update the implementation plan to replace the invalid Ack assumption with
   the lifted-transform discriminated strategy.
2. Commit the current M1 checkpoint.
3. Start M2 by expanding reusable shared schemas and their tests before adding
   metadata breadth or more styler families.

## M2 Follow-up

### Implemented

- Expanded the reusable shared schema layer with:
  - enum schemas for clip, box shape, blend mode, border style, and tile mode
  - primitive schemas for offset, radius, alignment, and gradient color lists
  - layout schema for `BoxConstraintsMix`
  - painting schemas for `BorderSideMix`, `BoxBorderMix`,
    `BorderRadiusGeometryMix`, `BoxShadowMix`, `GradientMix`, and
    richer `BoxDecorationMix`
- Broadened the existing `box` path to use those shared schemas for:
  - `alignment`
  - `margin`
  - `constraints`
  - `foregroundDecoration`
  - `clipBehavior`
  - richer `decoration`
- Added direct shared-schema tests plus decoder integration coverage for the
  new layout and decoration fields.

### Validation Run

Commands executed again after the M2 changes:

```bash
dart format . --set-exit-if-changed
dart analyze --fatal-infos
flutter test
```

Results:

- `dart format . --set-exit-if-changed`: passed
- `dart analyze --fatal-infos`: passed
- `flutter test`: passed

### Lessons From M2

- Shared schemas are easier to validate when they are first exercised through a
  single existing styler path instead of adding another styler family too early.
- Object-level `.refine()` checks are necessary for real runtime constraints
  such as:
  - `minWidth <= maxWidth`
  - gradient stops length matching gradient colors length
  - `borderRadius` not being combined with circular `BoxDecoration`
- The current decoration foundation is useful, but it is still intentionally
  partial:
  - `shape_decoration` is not implemented yet
  - gradient transform support is still deferred
  - metadata/variants/modifiers are still outside this slice

### Ready State

The package is ready to continue, but the next slice should still avoid adding
styler breadth until the revised plan language is updated to match the actual
Ack/discriminated behavior proven by M1.

## M3 and M4 Follow-up

### Implemented

- Added the remaining built-in styler registrations and decode schemas:
  - `text`
  - `flex`
  - `icon`
  - `image`
  - `stack`
  - `flex_box`
  - `stack_box`
- Added the metadata factories required by the original plan:
  - `modifier` config with the v1 serializable allowlist
  - `variants` with cycle-breaking fields-only style schemas
  - `context_variant_builder` registry resolution
  - `modifierOrder` wire-to-runtime `Type` mapping
- Expanded the shared schema catalog with:
  - typography schemas (`TextStyleMix`, `StrutStyleMix`,
    `TextHeightBehaviorMix`, `Locale`, `TextScaler`)
  - shape decoration and shape border decoding
  - gradient transform decoding for `gradient_rotation` and
    `tailwind_css_angle_rect`
  - matrix and rect primitives needed by the built-in styler field matrix
- Proved custom styler registration through the public `StylerRegistry`
  registration surface.
- Added hardening coverage for:
  - all built-in styler ids
  - metadata decode/runtime behavior
  - unsupported icon payload handling
  - shape decoration and gradient transforms
  - developer-registered custom schemas

### Validation Run

Commands executed after the final implementation pass:

```bash
dart format . --set-exit-if-changed
dart analyze --fatal-infos
flutter test
melos run analyze
melos exec -c 4 -- dart analyze .
melos exec -c 4 --depends-on="dart_code_metrics_presets" -- dcm analyze . --fatal-style --fatal-warnings
melos exec --category=flutter_projects --dir-exists=test -- flutter test
```

Results:

- `dart format . --set-exit-if-changed`: passed
- `dart analyze --fatal-infos`: passed
- `flutter test`: passed
- `melos run analyze`: failed and printed `Can't load Kernel binary: Invalid SDK hash.`
- `melos exec -c 4 -- dart analyze .`: failed outside `mix_schema`
  - `examples`: unresolved Flutter and Mix package imports
  - `mix_generator`: unresolved `build`, `source_gen`, and `mix_annotations`
    imports
  - `mix_tailwinds`: existing analysis failures in tests and package code
- `melos exec -c 4 --depends-on="dart_code_metrics_presets" -- dcm analyze . --fatal-style --fatal-warnings`:
  failed outside `mix_schema`
  - `examples`: existing `avoid-unused-ignores` warnings
  - `mix_lint`: existing style and warning findings
  - `mix`: existing style and warning findings
- `melos exec --category=flutter_projects --dir-exists=test -- flutter test`:
  passed, including `mix`, `mix_lint`, and `mix_schema`
- Final package-local confirmation:
  - `dart format . --set-exit-if-changed`: passed again
  - Dart analyzer integration for `mix_schema`: no errors
  - Dart test integration for `mix_schema`: all tests passed

### Lessons From M3 and M4

- `modifierOrder` must map to runtime widget modifier classes
  (`OpacityModifier`, `BlurModifier`, etc.), not to `ModifierMix` types. The
  decoded config only works correctly once that mapping targets the resolved
  modifier layer used by Mix.
- A single strict edge-insets object schema is more stable than an `anyOf`
  union for absolute vs directional padding. The union produced duplicated
  type errors for invalid payloads, while the unified schema preserved the
  expected one-path failure behavior.
- `ContextVariantBuilder` decoding still needs a placeholder style value to
  satisfy `VariantStyle`, but that placeholder is ignored at runtime because
  Mix resolves the builder-produced style directly when variants are merged.
- Repo-level verification is more reliable through direct `melos exec` calls in
  non-interactive automation. `melos run` prompts for package selection in this
  environment and is not a stable validation path here.
- Running the underlying workspace analysis commands matters because the
  `melos run analyze` failure is not only wrapper noise. It does print an SDK
  hash warning, but the direct analyzer runs also expose unrelated existing
  failures in `examples`, `mix_generator`, `mix_tailwinds`, `mix_lint`, and
  `mix`.

### Final Ready State

- The `mix_schema` package-level implementation now covers the original v1
  execution plan through metadata, built-in stylers, custom registration, and
  hardening tests.
- `mix_schema` itself is validated:
  - format clean
  - analyzer clean
  - tests passing
- The remaining unresolved items are outside this package: repo-wide analysis
  is still red because of pre-existing failures in other workspace packages.

## Post-Implementation Architecture Review

### Review Scope

This review looked at the final `mix_schema` package as implemented, not just
the original plan. The lens used here was:

- Dart/Flutter reference-quality expectations:
  - explicit error modeling
  - small public API
  - type clarity
  - proof through tests
- code-simplifier expectations:
  - reduce avoidable duplication
  - keep composition explicit
  - prefer stable, reusable structure over ad hoc expansion

### Overall Verdict

The implementation is **functionally correct and package-valid**, but it is not
yet the cleanest version of itself.

The strongest parts of the design are the contract boundaries:

- small public package surface
- clear `register → freeze → decode` lifecycle
- isolated Ack-to-v1 error mapping
- decode directly into Mix runtime types without an intermediate DTO layer

The rougher parts are in composition and maintainability:

- repeated schema construction
- duplicated built-in field declarations
- dense mixed-responsibility schema files
- quality gates that did not fully enforce the repo's intended lint standard

If treated honestly, the current code is a **good v1 baseline** and a
**workable implementation**, but not yet the package's ideal reference
architecture.

### What Worked Well

1. The public API stayed small.

   `mix_schema.dart` exports only the contract surfaces that matter:
   decoder, errors, registries, and constants. Internal schema assembly stayed
   under `src/`, which was the right decision.

2. The lifecycle is easy to reason about.

   `RegistryBuilder`, `FrozenRegistry`, `StylerRegistry`, and
   `MixSchemaDecoder` establish a straightforward bootstrap flow. This is one
   of the clearest parts of the package.

3. Error handling is explicit and centralized.

   `SchemaErrorMapper` isolates the conversion from Ack error shapes into the
   stable v1 error contract. That separation prevented schema code from being
   polluted with response-format concerns.

4. The direct-to-Mix decode strategy was the right simplification.

   Decoding straight into Mix runtime objects avoided a DTO layer that would
   have added ceremony without improving correctness. This was one of the best
   architectural calls in the package.

5. The tests prove real runtime behavior, not just parse success.

   The suite does more than call `safeParse()`. It resolves Mix types in widget
   contexts, exercises variants and modifiers, and checks concrete runtime
   behavior. That is materially stronger than shallow schema smoke tests.

6. The internal discriminated-branch normalization contained the Ack mismatch.

   The Ack assumption was wrong, but the workaround stayed localized to
   `DiscriminatedBranchRegistry` instead of leaking across every schema file.
   That containment kept the rest of the package stable.

### What Went Wrong In The Pre-Redesign Implementation

The findings in this section describe the package state before the
2026-03-06 redesign completion work. They are kept as historical context and
were addressed by the redesign review later in this file.

1. The original Ack assumption was incorrect.

   The plan assumed transformed child branches could sit directly inside
   `Ack.discriminated()`. In practice, the implementation had to normalize
   branches to object schemas and lift the transform to the outer
   discriminated layer. This was the most important design correction in the
   package.

2. "Define once, reference everywhere" did not fully survive implementation.

   The plan called for a shared schema catalog, but the code mostly uses
   factory functions that rebuild schema graphs on demand. For example,
   `buildDecorationSchema()`, `buildTextScalerSchema()`, and metadata schemas
   are constructed repeatedly from multiple entrypoints instead of being held
   in one catalog object.

3. Built-in styler schemas duplicate field definitions.

   Each styler generally has both a fields-only schema and a full schema, and
   those often repeat the same `Ack.object({...})` field map twice. This kept
   cycle-breaking simple, but it introduced avoidable maintenance risk and
   made the package noisier than necessary.

4. Two files became complexity sinks.

   `metadata_schemas.dart` reached 318 lines and `decoration_schemas.dart`
   reached 306 lines. Both files are correct, but they mix too many concerns:
   branch registration, cross-field validation, transform assembly, and
   runtime-specific edge cases.

5. The package never opted into the repo's DCM rules.

   `mix_schema` has no local `analysis_options.yaml`, and DCM reported that the
   package had no enabled lint rules. That means part of the intended quality
   bar was not actually enforced while the implementation was being built.

6. Public API documentation is missing.

   The public surfaces are small enough to document well, but there is no
   Dartdoc in `lib/`. That is acceptable for a spike, but it is below the
   stated reference-quality bar for a package intended to define a contract.

7. Some helper shapes are correct but awkward.

   Two examples stand out:

   - `ContextVariantBuilder` needs an `emptyStyle` placeholder only to satisfy
     `VariantStyle`, even though Mix ignores that placeholder at merge time.
   - `ImageStyler` metadata support needs a private placeholder image provider
     for the same reason.

   These are valid adaptations, but they signal that the generic helper layer
   is carrying some domain mismatch.

8. The contract/reporting process lagged behind implementation reality.

   The critical design corrections were captured in simulation files, but the
   main plan did not evolve in lockstep. That made the implementation cleaner
   than the written plan in some places and rougher than the written plan in
   others.

### What Worked Better Than Expected

- The strict object-based edge-insets schema produced better error behavior
  than a union-based design.
- The registry-backed runtime lookup model integrated cleanly with Ack
  transform-time failures.
- The custom styler registration surface was sufficient without inventing a
  second public abstraction.
- Direct runtime assertions in tests were enough to validate variant and
  modifier behavior without building a larger harness.

### What Was Harder Than Expected

- Cycle-breaking between stylers and variants required more duplication than
  the plan suggested.
- Mapping `modifierOrder` into Mix's actual runtime ordering required
  targeting widget modifier classes, not the decoded modifier mix types.
- Supporting runtime-only values generically exposed places where the schema
  layer and the runtime layer are not perfectly aligned.
- Repo-wide validation results were easy to over-interpret because unrelated
  workspace failures obscured package-local truth.

### Cleanliness Assessment

As implemented today:

- contract design: strong
- runtime behavior: strong
- error modeling: strong
- test proof: strong
- schema reuse: moderate
- file organization: moderate
- documentation: weak
- lint enforcement: weak

### Recommendation

Treat the current package as the **correct functional baseline** and the
starting point for a **cleanup-oriented follow-up**, not as the final form of
the architecture.

The next pass should not chase more feature breadth. It should focus on:

1. consolidating repeated schema construction into a catalog
2. removing duplicated field declarations across built-in stylers
3. splitting the large shared schema files by responsibility
4. opting the package into the repo's actual lint configuration
5. documenting the public contract surfaces

The detailed action plan for that cleanup is now recorded in
`mix_schema_plan.md`.

## 2026-03-06 — Redesign Completion Review

### Scope Completed

- Replaced the exploratory plan in `mix_schema_plan.md` with the redesign plan
  that now matches the implemented contract.
- Rebuilt schema composition around `MixSchemaCatalog` so shared schemas are
  created once per decoder bootstrap flow instead of being reassembled ad hoc
  from built-in styler entrypoints.
- Replaced the old built-in-schema pattern with `StylerDefinition` plus one
  shared schema assembly path, which removed the repeated fields-vs-full-schema
  object declarations inside each built-in styler file.
- Flattened styler metadata on the wire to sibling fields:
  `animation`, `modifiers`, `modifierOrder`, and `variants`.
- Split metadata and painting decoding into smaller domain files and kept the
  Ack discriminated-branch workaround isolated in
  `DiscriminatedBranchRegistry`.
- Tightened failure modeling by introducing an explicit
  `RegistryTypeMismatchError` and mapping it through the stable public error
  contract as `transform_failed`.
- Added package-local DCM wiring and public Dartdoc for the exported package
  surface.

### Validation

- `dart format . --set-exit-if-changed`: passed
- `dart analyze --fatal-infos`: passed
- `dcm analyze . --fatal-style --fatal-warnings`: passed
- package tests: passed

The redesign is validated at the `packages/mix_schema` level. This checkpoint
does not claim a full workspace-green result because the validation run for this
phase was intentionally scoped to the package being redesigned.

### Architecture Review

What improved:

- The schema layer now has one clear source of truth in `MixSchemaCatalog`.
- The boundary between runtime registries, schema composition, and built-in
  styler definitions is explicit.
- The public API stayed small while the internal design became easier to follow.
- The metadata wire contract is clearer because modifier metadata is no longer
  nested under an extra `modifier` object.

What remains intentionally explicit:

- `flex_box` and `stack_box` still declare their own composite field maps.
  That duplication is deliberate because their wire contract is intentionally
  explicit and would become harder to read if over-abstracted.
- `ContextVariantBuilder` still needs a typed placeholder style and
  `ImageStyler` still uses a private placeholder image provider. Those are
  acceptable runtime-adaptation seams, not evidence of a broken contract.

### Code Simplifier Review

Changes that improved clarity:

- moved repeated list-cast logic into a tiny internal `json_casts.dart` helper
- removed duplicated full-schema field assembly from built-in styler files
- reduced metadata construction to one helper path fed by a typed variant schema
- replaced large multi-responsibility shared files with domain-focused modules

Lessons from the simplification pass:

- DCM surfaced real design friction, not just style noise. The final fixes for
  typed metadata and JSON list casts improved the architecture because they
  forced clearer type boundaries.
- Typed locals worked better than explicit generic calls in places where DCM and
  the analyzer pulled in opposite directions.

### Final Assessment

`mix_schema` is now in the state the redesign plan was aiming for:

- package-local contract: complete
- package-local validation: complete
- internal architecture: clean enough for v1
- follow-up cleanup required before feature expansion: low

The remaining work is documentation/maintenance scale work, not architecture
correction work.

## 2026-03-06 — Enum Surface and Drift Cleanup

### Scope Completed

- Replaced the exported string-holder constant surface with a public
  `MixSchemaScope` enum for built-in registry scopes.
- Added `RegistryBuilder.builtIn(...)` so Dart callers can use the public scope
  enum without falling back to string literals for built-in registries.
- Moved styler, modifier, variant, decoration, border, gradient, and text
  scaler discriminators to shorter internal `Schema*` enums with `wireValue`.
- Refactored built-in decoder bootstrap and discriminated branch registration
  to use exhaustive enum-driven switches instead of open-ended string groups.
- Updated public-facing tests to use literal wire payload values and the public
  scope enum.

### Validation

- `dart format . --set-exit-if-changed`: passed
- `dart analyze --fatal-infos`: passed
- `dcm analyze . --fatal-style --fatal-warnings`: passed
- package tests: passed

### Drift Result

No functional drift was found. This pass tightened the public API and internal
 modeling, but did not change payload wire behavior.

### API Decision

- public: `MixSchemaScope`, `MixSchemaErrorCode`
- public convenience: `RegistryBuilder.builtIn(scope: MixSchemaScope...)`
- internal-only by non-exported source convention: all other wire/discriminator
  enums

This keeps exhaustive handling where it matters in the implementation without
 widening the public package contract.
