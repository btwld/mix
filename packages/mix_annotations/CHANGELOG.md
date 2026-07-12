## Unreleased

 - **FEAT**: Add `MixWidgetParameterSelection` and the
   `MixWidget.widgetParameters` default. `@MixWidget()` now concretely carries
   `.all()`, while `.only({...})` supports opt-in curation of generated widget
   parameters.

## 2.1.2

 - **DOCS**: Document that nested `StyleSpec<XSpec>` fields derive `XStyler`
   automatically by convention, so `@MixableField(setterType:)` is only needed
   to override the derived name (#961).

## 2.1.1

 - **DOCS**: Document `@MixableField(setterType:)` usage for `@MixableSpec` and `@MixableModifier` fields (#950, #951).

## 2.1.0

 - **FEAT**: Add `@MixableModifier` annotation. Annotate a `WidgetModifier` subclass to generate its modifier mixin and `ModifierMix` class via `mix_generator` (#924).
 - **FEAT**: Add `@MixWidget` annotation. Annotate a top-level styler variable or styler-returning function so `mix_generator` emits a matching `StatelessWidget` (#920).
 - **FEAT**: Add `extraStylerMixins` to control additional mixins applied to generated stylers, and related `generator_flags` updates (#923).
 - **DEPRECATED**: `GeneratedStylerMethods.call` and `GeneratedStylerMethods.skipCall`. Call generation has not been supported since the 2.0 styler API; the flags are now annotated `@Deprecated` and will be removed in a future major release. The bit (`0x20`) remains in `GeneratedStylerMethods.all` for source and value compatibility — the generator already ignores it.
 - **DOCS**: Spec authoring examples in the README now include `package:flutter/foundation.dart` and `package:flutter/widgets.dart` imports plus the `@immutable` annotation, matching the symbols the generated `_$<Name>` mixin references.
 - **DOCS**: Note that `GeneratedSpecMethods.skipEquals` suppresses only the generated `props` getter; the surrounding equality surface is always emitted so a user-authored `props` powers a working `==`/`hashCode`/`getDiff`/`stringify`.

## 2.0.0-rc.1

 - **BREAKING**: The Mix Generator was completely rebuilt to support the architecture and requirements of Mix V2.0.
 - **FEAT**: Add setterType parameter to MixableField annotation (#846).
 - **FEAT**: Add MixableSpec and MixableStyler annotations (#835).
 - **REFACTOR**: Widget modifier API and update to Dart 3.10 (#775).

## 1.7.0

 - **FEAT**: Add generated style-focused modifiers and specs (#652).

## 0.4.0

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574).
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569).

## 0.3.1

 - **FEAT**: Create code gen for design tokens (#521).

## 0.3.0

 - **FIX**: SpecModifiers were taking a long time to animate. (#457).

## 0.2.1

 - **FEAT**: MixableSpec now supports `withCopyWith`, `withEquality`, `withLerp`, and `skipUtility` (#396).

## 0.2.0+1

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).

## 0.2.0

- Added MixableEnumUtility, and MixableClassUtility annotations.

## 0.1.0

- Initial version.
