## 2.0.3

 - **FEAT**: Emit a `@Deprecated typedef _$<Name>SpecMethods = _$<Name>;` alongside every `@MixableSpec` mixin so legacy `class X extends Spec<X> with Diagnosticable, _$XSpecMethods` declarations keep compiling against the 2.0+ generator. Removal scheduled for `mix_generator` 3.0.
 - **CHANGED**: Under the legacy declaration shape, `toString()` now routes through `Diagnosticable.toDiagnosticsNode`, replacing Equatable's `X(field: …)` format with Flutter's diagnostic-node format. Update any tests that pinned the old string.
 - **CHORE**: Drop unused direct dependencies (`collection`, `build_config`, `logging`, `path`); the generator no longer references them.

## 2.0.2

 - **FIX**: `GeneratedSpecMethods.skipEquals` now only suppresses `props` generation. The rest of the equality surface (`==`, `hashCode`, `getDiff`, `stringify`) is always emitted, preserving the supported "user authors `props`" flag semantic after the spec-shape refactor.
 - **FIX**: `Prop<T>` detection now uses a URL-based `TypeChecker` (`package:mix/src/core/prop.dart#Prop`) instead of matching on the simple name `Prop`. Prevents unrelated local classes named `Prop` from being mistaken for Mix's `Prop`.
 - **FIX**: `@Mixable` validation now requires the annotated class to extend `Mix<T>` (or a subclass) directly. Classes extending `Mixable<T>` without going through `Mix<T>` are rejected with a clear error — the generated mixin's `on Mix<T>` constraint would have failed at apply time anyway.
 - **TEST**: Consolidate generator test helpers (`partBuilder`, `styleStub`, `mixElementStub`, `propStub`, `mixAnnotationsSources`) into `test/core/test_helpers.dart`. Adds regression tests for `skipEquals`, fake-`Prop<T>` rejection, and `Mixable<T>`-direct-subclass rejection.

## 2.0.1

 - **REFACTOR**: Tighten field-model validation and shared type-helper extraction across mix/styler generators (#895).
 - **TEST**: Add generator smoke and validation integration tests plus broader builder coverage (#895).

## 2.0.0

 - Stable release matching the `2.0.0-rc.1` surface, with READMEs refreshed for the 2.0 generator API (#887, #888).

## 2.0.0-rc.1

 - **BREAKING**: The Mix Generator was completely rebuilt to support the architecture and requirements of Mix V2.0.
 - **FEAT**: Support Style class extensions in code generation (#845).
 - **FEAT**: Add MixableSpec, MixableStyler, and code generation for properties (#835).
 - **FIX**: Respect nullability in lerp resolver.
 - **FIX**: Make copyWith parameters nullable (#848).

## 1.7.0

 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **FIX**: update animated property handling to use null coalescing (#637).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: builder optimization (#629).

## 0.4.0

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

## 0.3.2

 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **FIX**: Shadow list animation (#445).
 - **FEAT**: Create code gen for design tokens (#521).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **DOCS**: improve mix theme data features explanations (#404).

## 0.3.1

 - **FEAT**: Fluent API (#475).

## 0.3.0

 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FIX**: Shadow list animation (#445).

## 0.2.2+1

 - **DOCS**: improve mix theme data features explanations (#404).

## 0.2.2

 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: Dto utility generation now adds constructor and static methods (#377).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **REFACTOR**: Code gen more lint friendly dart code (#399) and (#395).
 - **FIX**: Nullable merge expressions and updates debug properties (#392).

## 0.2.1

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).
 - **FEAT**: modifiers in spec (#333).


## 0.2.0

- Fixed: issue with getting correct type override from MixableDto
- Improved: Dto resolved type look up logic
- Added: generation List of value extension of a Dto
- Added: Class and Enum utility generation

## 0.1.2

- Fixed: Resolved conflict on generators when not configured on build.yaml

## 0.1.1

- Added: Support for Spec Attributes

## 0.1.0

- Initial release.
