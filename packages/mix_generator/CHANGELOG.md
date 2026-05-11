## Unreleased

 - **BREAKING**: `@MixWidget` codegen now resolves generated wrapper
   parameters from the styler's concrete `call()` method. The
   `MixWidgetBuilder` adapter path, the `widgetBuilder:` field on
   `@MixWidget`, and the previous spec-side rendering annotation were
   removed.
 - **BREAKING**: Generic styler `call()` methods are rejected at codegen
   with an actionable error. Use concrete method parameters instead.
 - **FIX**: `@MixWidget` validation now compares element identity (not
   just name visibility) when checking that forwarded call parameter
   defaults are reachable from the annotated library. A same-named
   symbol that resolved to a different declaration in the annotated
   library would previously cause the generated wrapper to silently bind
   to the wrong constant.
 - **MIGRATION**: Move rendering parameters to the styler's `call()` method
   and drop `widgetBuilder:` from `@MixWidget`. Adapter classes that
   extended `MixWidgetBuilder` and spec-side rendering annotations should be
   deleted; the styler `call()` method is now the source of truth for
   wrapper parameters.

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
