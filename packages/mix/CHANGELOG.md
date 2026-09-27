## 2.2.0

Stable release of the 2.2.0 line, cumulative over the `2.2.0-beta.0` through
`2.2.0-beta.6` prereleases. This release adds the `GridBox` and `WrapBox` layout
families, a typed and extensible context-variant system with focus-visible
support, a fuller `Pressable` input and semantics surface, and complete
`WidgetModifierConfig` convenience APIs; it fixes variant merge priority and
nested widget-state discovery, and it carries breaking changes to `Pressable`
and to `GridBox` implicit rows.

### New features

- **GridBox:** Added the public `GridTrack`, `GridBoxSpec`, `GridBoxStyler`, and
  `GridBox` API with fixed/fractional tracks, explicit and repeated rows, gaps,
  row-major placement, clipping, and local `Breakpoint`-based constraint
  branches. Equal fractional columns use `equalColumns`; numeric tracks and
  gaps support Mix tokens; compatible geometry participates in implicit style
  animation. `GridTrack.auto()` adds content-sized row tracks for `rows` and
  `autoRows`: an auto row sizes to its tallest child's natural height at the
  resolved column width, then stretches shorter children to fill the row. `auto`
  is vertical-only; `columns` rejects it.
- **WrapBox:** Added the public `WrapSpec`, `WrapStyler`, `WrapBoxSpec`,
  `WrapBoxStyler`, and `WrapBox` family with flattened fluent Wrap styling,
  collision-safe Box/Wrap names, generated constructors and factories, and a
  runnable gallery example.
- **Complete `WidgetModifierConfig` convenience APIs:** `mouseCursor` and
  `scrollView` are now available as factories and chain methods, and `skew`,
  `defaultIcon`, `iconTheme`, `box`, and `reset` gained the chain methods their
  factories were missing. Every built-in modifier can now be reached without
  `.modifier(SomeModifierMix(...))`, for example
  `BoxStyler().wrap(.mouseCursor(SystemMouseCursors.click))`. The chained
  `reset()` clears the modifiers accumulated in that configuration only; use the
  `WidgetModifierConfig.reset()` factory when the reset must also clear the
  configuration it is merged into.
- **`ContextVariant.widgetStateDependencies`:** Context variants now declare the
  widget states they read, so custom variants participate in nested dependency
  discovery instead of relying on the framework recognizing a specific variant
  type. Automatic self-tracking is limited to pointer-driven hover and press;
  other states still require an ancestor scope or external controller.
- **Typed focus-visible variants:** Added `FocusVisibleVariant`,
  `ContextVariant.focusVisible()`, and `onFocusVisible(...)`, which apply while
  focus is highlighted in Flutter's traditional (keyboard/directional) mode.
- **Pressable semantics roles:** Added `PressableSemanticsRole` with button,
  link, and neutral roles. `PressableBox` now forwards the full Pressable
  focus, keyboard, controller, feedback, cursor, action, and semantics surface.
- **Typed context variants:** `BrightnessVariant`, `BreakpointVariant`,
  `OrientationVariant`, `DirectionalityVariant`, `PlatformVariant`,
  `WebVariant`, and `NotVariant` are now public value objects behind their
  `ContextVariant` factories, giving schema and tooling code stable typed data
  to inspect instead of parsing keys.
- **Style-state override scope:** `WidgetStateStyleOverride` lets tooling and
  tests force widget-state variants through normal `style` resolution, taking
  precedence over controllers and nested interaction providers without
  changing component behavior.
- **Generated Styler field metadata:** Every generated Styler now exposes its
  complete source-field inventory through
  `StylerFieldMetadata.$stylerFieldNames`, allowing schema tooling to validate
  coverage without maintaining duplicate string manifests. Handwritten and
  previously generated Stylers do not implement this capability until they opt
  in or are regenerated.
- **`CssKeywordLinearTransform`:** Adds a reusable bounds-aware
  `GradientTransform` for CSS linear-gradient keyword directions, so Tailwind
  corner gradients can round-trip through schema tooling without losing visual
  parity.

### Breaking changes

- **Pressable input and semantics:** Replaced `semanticButtonLabel` with
  `semanticsLabel`, added `semanticsRole`, and removed the deprecated `onKey`
  callback. Use `onKeyEvent` for custom keyboard handling.
- **Reserved activation keys:** While it holds primary focus and can activate,
  Pressable owns unmodified Space, Enter, numpad Enter, select, and game button
  A so it can model held-key state consistently. Override those direct key
  bindings with `onKeyEvent`. `onPress` still honors `ActivateIntent` dispatched
  by remapped shortcuts or programmatic invocation, and custom `actions` can
  override that binding or handle other intents. Only those five reserved keys
  are claimed raw; they are left untouched when a descendant holds focus, and
  modified chords are left to application shortcuts. A link-role Pressable
  activates with Enter but leaves Space available for scrolling.
- **Omitted GridBox `autoRows` no longer throws:** Children needing more rows
  than were declared previously required an explicit `autoRows` track, or the
  Grid threw. Omitted `autoRows` now defaults to `GridTrack.auto()`, so
  implicit rows size to their tallest child — both when no rows are declared
  and when explicit rows run out. Fractional rows still require a bounded
  height, and fixed tracks remain hard constraints. If you relied on the throw
  to catch an under-declared Grid, declare `rows` explicitly or set `autoRows`
  to the track you want repeated.

### Fixes

- **Variant merge priority follows declared state dependencies:** Priority now
  groups active variants by whether they declare
  `ContextVariant.widgetStateDependencies` rather than by whether they are a
  `WidgetStateVariant`, so `onFocusVisible(...)` competes by declaration order
  instead of always losing to any widget-state variant sharing a property, which
  had been silently replacing focus rings. Variants built on
  `ContextVariant.not(...)` move with their inner variant, so `onEnabled(...)`
  now outranks an ambient variant such as `onDark(...)` declared after it.
- **Declaration order within a priority group is reliable:** Grouping is a
  stable partition rather than a `List.sort`, which fell back to an unstable
  quicksort at 32 elements and could reorder equal-priority variants in styles
  that large.
- **Nested widget-state discovery:** `Style.widgetStates` now discovers state
  requirements recursively through nested and negated context-variant branches
  with identity-based cycle protection, so variants like
  `onDark(BoxStyler().onHovered(...))` and `onEnabled(...)` are tracked instead
  of silently never activating. Branches under un-applied named variants are
  deliberately not tracked because they cannot activate until `applyVariants`
  hoists them to the top level.
- **Interaction detector is mounted only when it can help:** `StyleBuilder` now
  installs its pointer-interaction detector only for the states that detector
  actually drives (`hovered`/`pressed`). States such as `disabled` and `focused`
  can only come from an external `WidgetStatesController` or an ancestor scope,
  so styles depending solely on those no longer gain an opaque hit-test target
  that swallowed pointer events aimed at widgets beneath them, and no longer
  hijack the state scope of descendants that do track hover.
- **Pressable lifecycle:** Pointer and keyboard press sources are combined
  without clearing each other, keyboard activation fires once on key-up,
  cancellation clears held state, focus-visible follows Flutter input modality,
  and disabled controls ignore custom key handling and expose neither semantic
  nor custom actions.
- **Press state ends with the gesture:** A pointer that drifts past the tap slop
  stops counting as a press, so items no longer stay visually pressed while a
  list scrolls under the finger.
- **Focus-visible scope:** The focus-highlight scope is now provided wherever
  widget states are, so `onFocusVisible` also resolves — and repaints on input
  modality changes — outside a `Pressable`. A `WidgetStateStyleOverride` forcing
  `focused` now applies it too, matching `onFocused`.
- **Variant merge-key collisions:** Variant styles now merge by an opaque,
  semantic identity instead of the human-readable `Variant.key`. Equivalent
  named, enum-backed, and built-in context variants still coalesce, while
  unrelated variants with the same label retain their own predicates. Dynamic
  builders keep their existing build-then-merge behavior and use function
  equality instead of a hash string for merge identity.
- **Context variant equality:** `ContextVariant.brightness`,
  `ContextVariant.breakpoint`, `ContextVariant.orientation`,
  `ContextVariant.directionality`, `ContextVariant.platform`,
  `ContextVariant.web`, and `ContextVariant.not` now compare by their typed
  values instead of identity, so equivalent variants deduplicate and
  round-trip predictably.
- **Default text style modifier merge:** Partial `DefaultTextStyleModifierMix`
  overrides now merge with the ambient `DefaultTextStyle` instead of replacing
  inherited text style fields.
- **Box shadow blur styles:** `BoxShadowMix` now preserves non-default
  `BoxShadow.blurStyle` values across construction, conversion, merging,
  resolution, diagnostics, equality, and its fluent and factory APIs (#992).

### API changes

- **`tokenFromReferenceValue`** is now public for schema/tooling code that needs
  to identify unresolved token references, including sentinel-backed
  `DoubleRef` values, without importing Mix internals.

## 2.2.0-beta.6

### New features

- **Complete `WidgetModifierConfig` convenience APIs:** `mouseCursor` and
  `scrollView` are now available as factories and chain methods, and `skew`,
  `defaultIcon`, `iconTheme`, `box`, and `reset` gained the chain methods their
  factories were missing. Every built-in modifier can now be reached without
  `.modifier(SomeModifierMix(...))`, for example
  `BoxStyler().wrap(.mouseCursor(SystemMouseCursors.click))`. The chained
  `reset()` clears the modifiers accumulated in that configuration only; use the
  `WidgetModifierConfig.reset()` factory when the reset must also clear the
  configuration it is merged into. Existing factories and chain methods are
  unchanged, and `.modifier(...)`/`.modifiers([...])` remain the entry points
  for custom modifiers.

## 2.2.0-beta.5

### New features

- **`GridTrack.auto()`:** Content-sized row tracks for `rows` and `autoRows`.
  An auto row sizes to its tallest child's natural height at the resolved
  column width, then stretches shorter children to fill the row. Use it — or
  omit `autoRows` — when child heights are unknown, such as a card grid in a
  scroll view. `auto` is vertical-only; `columns` rejects it. Grids built only
  from fixed and `fr` tracks are unaffected and still lay each child out once.
- **Generated Styler field metadata:** Every generated Styler now exposes its
  complete source-field inventory through
  `StylerFieldMetadata.$stylerFieldNames`, allowing schema tooling to validate
  coverage without maintaining duplicate string manifests. Handwritten and
  previously generated Stylers do not implement this capability until they opt
  in or are regenerated.

### Breaking changes

- **Omitted GridBox `autoRows` no longer throws:** Children needing more rows
  than were declared previously required an explicit `autoRows` track, or the
  Grid threw. Omitted `autoRows` now defaults to `GridTrack.auto()`, so
  implicit rows size to their tallest child — both when no rows are declared
  and when explicit rows run out. Fractional rows still require a bounded
  height, and fixed tracks remain hard constraints. If you relied on the throw
  to catch an under-declared Grid, declare `rows` explicitly or set `autoRows`
  to the track you want repeated.

## 2.2.0-beta.4

### Fixes

- **Variant merge priority follows declared state dependencies:** Priority now
  groups active variants by whether they declare
  `ContextVariant.widgetStateDependencies` rather than by whether they are a
  `WidgetStateVariant`, so `onFocusVisible(...)` competes by declaration order
  instead of always losing to any widget-state variant sharing a property, which
  had been silently replacing focus rings. Variants built on
  `ContextVariant.not(...)` move with their inner variant, so `onEnabled(...)`
  now outranks an ambient variant such as `onDark(...)` declared after it.
- **Declaration order within a priority group is reliable:** Grouping is a
  stable partition rather than a `List.sort`, which fell back to an unstable
  quicksort at 32 elements and could reorder equal-priority variants in styles
  that large.

## 2.2.0-beta.3

### New features

- **`ContextVariant.widgetStateDependencies`:** Context variants now declare the
  widget states they read, so custom variants participate in nested dependency
  discovery instead of relying on the framework recognizing a specific variant
  type. Automatic self-tracking is limited to pointer-driven hover and press;
  other states still require an ancestor scope or external controller.
- **Typed focus-visible variants:** Added `FocusVisibleVariant`,
  `ContextVariant.focusVisible()`, and `onFocusVisible(...)`, which apply while
  focus is highlighted in Flutter's traditional (keyboard/directional) mode.
- **Pressable semantics roles:** Added `PressableSemanticsRole` with button,
  link, and neutral roles. `PressableBox` now forwards the full Pressable
  focus, keyboard, controller, feedback, cursor, action, and semantics surface.

### Breaking changes

- **Pressable input and semantics:** Replaced `semanticButtonLabel` with
  `semanticsLabel`, added `semanticsRole`, and removed the deprecated `onKey`
  callback. Use `onKeyEvent` for custom keyboard handling.
- **Reserved activation keys:** While it holds primary focus and can activate,
  Pressable owns unmodified Space, Enter, numpad Enter, select, and game button
  A so it can model held-key state consistently. Override those direct key
  bindings with `onKeyEvent`. `onPress` still honors `ActivateIntent` dispatched
  by remapped shortcuts or programmatic invocation, and custom `actions` can
  override that binding or handle other intents. Only those five reserved keys
  are claimed raw; they are left untouched when a descendant holds focus, and
  modified chords are left to application shortcuts. A link-role Pressable
  activates with Enter but leaves Space available for scrolling.

### Fixes

- **Nested widget-state discovery:** `Style.widgetStates` now discovers state
  requirements recursively through nested and negated context-variant branches
  with identity-based cycle protection, so variants like
  `onDark(BoxStyler().onHovered(...))` and `onEnabled(...)` are tracked instead
  of silently never activating. Branches under un-applied named variants are
  deliberately not tracked because they cannot activate until `applyVariants`
  hoists them to the top level.
- **Interaction detector is mounted only when it can help:** `StyleBuilder` now
  installs its pointer-interaction detector only for the states that detector
  actually drives (`hovered`/`pressed`). States such as `disabled` and `focused`
  can only come from an external `WidgetStatesController` or an ancestor scope,
  so styles depending solely on those no longer gain an opaque hit-test target
  that swallowed pointer events aimed at widgets beneath them, and no longer
  hijack the state scope of descendants that do track hover.
- **Pressable lifecycle:** Pointer and keyboard press sources are combined
  without clearing each other, keyboard activation fires once on key-up,
  cancellation clears held state, focus-visible follows Flutter input modality,
  and disabled controls ignore custom key handling and expose neither semantic
  nor custom actions.
- **Press state ends with the gesture:** A pointer that drifts past the tap slop
  stops counting as a press, so items no longer stay visually pressed while a
  list scrolls under the finger.
- **Focus-visible scope:** The focus-highlight scope is now provided wherever
  widget states are, so `onFocusVisible` also resolves — and repaints on input
  modality changes — outside a `Pressable`. A `WidgetStateStyleOverride` forcing
  `focused` now applies it too, matching `onFocused`.

## 2.2.0-beta.2

### New features

- **GridBox:** Added the public `GridTrack`, `GridBoxSpec`, `GridBoxStyler`, and
  `GridBox` API with fixed/fractional tracks, explicit and repeated rows, gaps,
  row-major placement, clipping, and local `Breakpoint`-based constraint
  branches. Equal fractional columns use `equalColumns`; numeric tracks and
  gaps support Mix tokens; compatible geometry participates in implicit style
  animation.
- **WrapBox:** Added the public `WrapSpec`, `WrapStyler`, `WrapBoxSpec`,
  `WrapBoxStyler`, and `WrapBox` family with flattened fluent Wrap styling,
  collision-safe Box/Wrap names, generated constructors and factories, and a
  runnable gallery example.

## 2.2.0-beta.1

### Fixes

- **Box shadow blur styles:** `BoxShadowMix` now preserves non-default
  `BoxShadow.blurStyle` values across construction, conversion, merging,
  resolution, diagnostics, equality, and its fluent and factory APIs (#992).

## 2.2.0-beta.0

### New features

- **Style-state override scope:** `WidgetStateStyleOverride` lets tooling and
  tests force widget-state variants through normal `style` resolution, taking
  precedence over controllers and nested interaction providers without
  changing component behavior.
- **`CssKeywordLinearTransform`:** Adds a reusable bounds-aware
  `GradientTransform` for CSS linear-gradient keyword directions, so Tailwind
  corner gradients can round-trip through schema tooling without losing visual
  parity.
- **Typed context variants:** `BrightnessVariant`, `BreakpointVariant`,
  `OrientationVariant`, `DirectionalityVariant`, `PlatformVariant`,
  `WebVariant`, and `NotVariant` are now public value objects behind their
  `ContextVariant` factories, giving schema and tooling code stable typed data
  to inspect instead of parsing keys.

### Fixes

- **Variant merge-key collisions:** Variant styles now merge by an opaque,
  semantic identity instead of the human-readable `Variant.key`. Equivalent
  named, enum-backed, and built-in context variants still coalesce, while
  unrelated variants with the same label retain their own predicates. Dynamic
  builders keep their existing build-then-merge behavior and use function
  equality instead of a hash string for merge identity.
- **Context variant equality:** `ContextVariant.brightness`,
  `ContextVariant.breakpoint`, `ContextVariant.orientation`,
  `ContextVariant.directionality`, `ContextVariant.platform`,
  `ContextVariant.web`, and `ContextVariant.not` now compare by their typed
  values instead of identity, so equivalent variants deduplicate and
  round-trip predictably.
- **Default text style modifier merge:** Partial `DefaultTextStyleModifierMix`
  overrides now merge with the ambient `DefaultTextStyle` instead of replacing
  inherited text style fields.

### API changes

- **`tokenFromReferenceValue`** is now public for schema/tooling code that needs
  to identify unresolved token references, including sentinel-backed
  `DoubleRef` values, without importing Mix internals.

## 2.1.0

This release adds context-derived token resolution and richer animation
configuration, fixes variant resolution in nested styles and animation
interpolation edge cases, and hardens the token-reference system while
tightening the public API around the internal token registry.

### New features

- **`ContextToken`:** Zero-config token whose value is derived directly from
  the build context, so context-dependent values resolve without first
  registering a token in a scope (#938).
- **Spring animation helpers:** `AnimationConfig` statics are now factories,
  with added spring-curve wrappers for configuring physics-based transitions
  (#937).

### Fixes

- **Variants in nested styles:** A `Style` nested inside another style's `Prop`
  (a component sub-style) now applies its own context variants — widget states,
  brightness, breakpoints. Previously `Prop.resolveProp` resolved the merged
  nested style via `resolve()`, which skips variants. No-op for nested styles
  without variants (#926).
- **`Matrix4` interpolation:** Tween a transform against the identity matrix
  when one endpoint is null, instead of producing a degenerate result (#931).
- **Animation config fallback:** Fall back to the previous animation config
  when a transition resolves to null, rather than dropping the animation (#930).
- **`DoubleRef` sentinel collisions:** Two distinct `MixToken<double>`
  instances whose hashes landed in the same bucket previously aliased to the
  same sentinel. The registry now hands out sentinels from a monotonic
  counter, so sentinels are unique among registered tokens; a reverse cache
  re-issues the same sentinel for the same token.
- **`BreakpointToken.resolve` no longer masks type errors:** the built-in
  `mobile`/`tablet`/`desktop` defaults are only used when the scope is
  absent or omits the entry. A scope entry of the wrong type now surfaces
  the underlying `StateError` from `MixScope.getToken`.
- **Numeric directives on multi-source props:** `Prop.value(x).mergeProp(
  Prop.token(t)).multiply(2)` and similar chains now resolve instead of
  throwing — `_asPropNum` rebuilds every source as `Prop<num>` and merges
  in order.
- **`Prop.value` null safety:** the token-ref detection branch no longer
  crashes when `V` is nullable and the supplied value is `null`.

### API changes

- **`ValueRef.noSuchMethod` throws `UnsupportedError`** (was
  `UnimplementedError`). The detailed message is unchanged; only the error
  type differs. Any user code that catches the specific class needs to
  switch.
- **`getReferenceValue` no longer silently casts** an unsupported token
  type — it now throws `UnsupportedError` naming the token and `T`. All
  concrete `MixToken` subclasses override `call()` and never hit this path;
  the change only affects custom `MixToken` authors who relied on the cast.
- **Removed from the public API:** `clearTokenRegistry` and
  `getTokenFromValue` are no longer re-exported from `package:mix/mix.dart`
  (both are now `@internal`; tests reach them via `package:mix/src/...`).
  The public `DoubleRef(double)` constructor was removed — `DoubleRef`
  instances are only ever obtained through `MixToken<double>.call()`.
  For an explicit, type-safe handle to a double token, use
  `Prop.token(token)`.
- **`isAnyTokenRef`** drops the brittle `runtimeType.toString().endsWith(...)`
  check; a `Prop` carrying a `TokenSource` is now the sole class-based
  invariant.

### Other changes

- **`StyleWidget` defaults to `IdentityStyle<Spec>`**, giving widgets a
  well-defined no-op style when none is supplied (#921).

## 2.0.3

This release adds finer-grained control over scope inheritance and theming, and restores compatibility with newer Flutter SDKs.

### New features

- **`MixScope.inherit`:** Opt into merging with the nearest ancestor `MixScope` instead of replacing it, so nested scopes can extend tokens and breakpoints without re-declaring them (#914).
- **`ColorRef` directive overrides:** Non-deprecated `Color` methods on `ColorRef` (e.g. `withValues`) are now overridden to return a ref carrying a directive, keeping color tokens unresolved until rendering (#908).

### Fixes

- **Flutter SDK compatibility:** Removed `TextDecorationRef` so Mix builds against newer Flutter SDKs where `TextDecoration` is no longer extendable (#913).

## 2.0.2

This release completes the 2.0 Styler migration by removing the remaining legacy utility surface, and adds new ergonomic shorthands and variant tooling.

### Removals

- **Legacy utility classes and mutable stylers:** All remaining deprecated utility classes and mutable stylers were removed, finishing the transition to the Styler-first API (#901).

### New features

- **EnumVariant mixin:** Define type-safe enum-based variants without hand-written boilerplate (#894).
- **DefaultTextStylerModifier:** Propagate default `TextStyler` values down the widget tree via a modifier, matching the pattern used by other default stylers (#905).
- **Text shadow shorthand:** Dot-shorthand entry point for configuring text shadows (#890).
- **Uniform border shorthand:** Dot-shorthand for applying a uniform border in one call (#889).
- **`MixStyler` export:** `MixStyler` is now exported from the public API, matching the documentation (#900).

### Fixes

- **RotateModifier lerp:** Interpolate the rotation angle directly instead of the transform matrix, producing smoother rotation transitions (#898).

## 2.0.1

This patch release improves day-to-day styling ergonomics and makes looping animations more reliable in edge cases.

### New features

- **Dot shorthand coverage expanded:** Static factory constructors are now available for all Styler instance methods, making Dart 3.11 shorthand syntax available across the full styling surface (#884).

### Fixes

- **Looping animations:** Loop driver updates now use the latest configured duration so repeated animations stay in sync with configuration changes (#885).
- **Matrix interpolation stability:** Matrix lerp now safely handles null endpoints to prevent snapping artifacts during transitions (#882).

## 2.0.0

Mix 2.0 is a ground-up rethink of how styling works in Flutter. This release introduces **Styler-first APIs** with fluent chaining, leverages **Dart 3.11+ dot shorthands** for concise syntax, modernizes the **widget modifier** model, and adds full **code generation** for specs and stylers via `mix_annotations` / `mix_generator`.

### Breaking changes

- **Styler APIs replace legacy `$` utilities.** `BoxStyler()`, `TextStyler()`, `IconStyler()`, and related stylers are the primary styling surface. All deprecated spec utilities, legacy widget/style entry points, and unused enum/color helpers have been removed (#806, #870).
- **Widget modifiers** now use `WidgetModifierConfig` construction instead of older patterns (#775).
- **Internal resolver usage:** `resolveProp` is `@internal`; use `MixOps.resolve` where you relied on the previous surface (#833).
- **Minimum SDK:** Dart `>=3.11.0`, Flutter `>=3.41.0`.
- **Styled widget naming:** Legacy `Styled*` widget names deprecated in favor of new naming conventions (#619).
- **NestedStyleAttribute removed:** Migrate to direct `Style` usage (#644).
- **SpecConfiguration/SpecStyle removed** from environment (#656).
- **MixWidgetState renamed** to `MixWidgetStateModel` (#698); `MixWidgetStateController` deprecated (#586).

### New features

- **Fluent Styler API:** Build styles with chained method calls — `BoxStyler().color(Colors.blue).size(100, 100).paddingAll(16)`.
- **Styler dot shorthands:** Static factory constructors on stylers for Dart 3.11 dot-notation syntax (#857).
- **Named variants:** `applyVariants()` for applying `NamedVariant` sets in one place (#801).
- **Style lookup:** `Style.of()` and `Style.maybeOf()` for reading resolved styles from the widget tree (#784).
- **Layout widgets:** Callable `Stack` / `FlexBox` (and related) for concise composition; `Stack` / `StackBox` restructured for the 2.0 model (#779).
- **Widget builder pattern:** Ergonomic Mix API through widget builders (#754).
- **Default widget styles:** Mix widgets ship with sensible defaults out of the box (#759).
- **Numeric styling:** Number directives and extensions for numeric transforms in styles (#785).
- **Defaults:** `DefaultStyledText` and `DefaultStyledIcon` typedefs for consistent defaults (#767).
- **Codegen:** `MixableSpec` / `MixableStyler` generation, `MixableField.setterType`, and Style-class extension support in `mix_generator` (#835, #846, #845).
- **Animation loops:** Loop support for Phase and Keyframe animations (#824).
- **Unified attributes:** `SpecUtility`, `Style`, and `Attributes` unified as compatible values (#643).
- **Style-focused modifiers and specs:** Generated modifiers and specs for streamlined styling (#652).
- **Builder optimization:** Improved style builder performance (#629).

### Improvements

- Widget state variant mixins split into focused files; unsupported widget state variants removed (#768, #769).
- `StyleSpecBuilder` build path simplified (#825).
- Specs standardized with `@immutable`; clearer equality behavior (#821).
- `BaseStyle` utility class introduced for improved styling architecture (#659).
- Widget state handling moved from `MixBuilder` to `SpecBuilder` (#651).
- Docs, examples, and codebase updated to dot-shorthand / Styler syntax throughout.

### Fixes

- **Variants:** More reliable `VariantStyle` merge and widget state handling in `StyleBuilder` (#774, #765).
- **copyWith / lerp:** Nullable `copyWith` parameters; lerp respects nullability (including generator fixes) (#848, #849).
- **Stylers:** `chain` getter on `StackStyler`; `AnimationStyleMixin` on `FlexBoxStyler` and `StackBoxStyler` (#818, #819).
- **Animations:** Visibility stays correct through the end of exit animations (#771). Animation drivers no longer reset when animation configuration is unchanged (#859).
- **Equality:** `Mixable` now extends `EqualityMixin` instead of `StyleElement` (#648).
- **CopyWith:** Overriding bug fixed (#622).
- **Breakpoints:** Breakpoint utility merge exception resolved (#758).

## 1.7.0

 - **REFACTOR**: Implement BaseStyle utility class and improve styling architecture #659
 - **REFACTOR**: Remove SpecConfiguration and SpecStyle from environment (#656)
 - **REFACTOR**: Move widget state handling from MixBuilder to SpecBuilder (#651).
 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **REFACTOR**: Remove NestedStyleAttribute and migrate to direct Style usage (#644).
 - **REFACTOR**: Deprecate `MixWidgetStateController` (#586).
 - **REFACTOR**: Use WidgetState instead of MixWidgetState (#582).
 - **FIX**: Change Mixable to extend EqualityMixin instead of StyleElement (#648).
 - **FIX**: CopyWith overriding bug (#622).
 - **FEAT**: builder optimization (#629).
 - **FEAT**: deprecate styled widgets in favor of new naming conventions (#619).
 - **FEAT**: Implementing duration extension for int  (#634).
 - **FEAT**: Create MixBuilder (#581).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: Unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: Add utilities for animatedData (#660).
 - **FEAT**: Add focused style classes for spec utilities (#677)

## 1.6.0

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

## 1.5.4

 - **FEAT**: Accordion interaction based on open variable (#546).

## 1.5.3

 - **REFACTOR**: Solve dcm lint issues (#519).
 - **FIX**: Order of modifiers implementation on Box, Image and Text (#529).
 - **FIX**: reset modifiers and modifiers when using fluentAPI (#482).
 - **FEAT**: Add spring curve (#503).
 - **FEAT**: Create StrokeAlignUtility (#496).
 - **FEAT**: Utilities for text height behavior (#495).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Add `SpecConfiguration` (#483).
 - **DOCS**: Add section for `TokenResolver` (#537).

#### `mix` - `v1.5.2`

 - **REFACTOR**: ShapeBorder merge (#490).
 - **FEAT**: Improve error messages (#491).
 - **FEAT**: add error state to MixWidgetState (#489).
 
#### `mix` - `v1.5.1`

 - **FEAT**: Add MixOutlinedBorder (#487).

## 1.5.0

 - **FIX**: Update OnBrightnessVariant to use `MediaQuery` instead of `Theme` (#471).
 - **FIX**: Style when merged with an AnimatedStyle should generate an AnimatedStyle (#472).
 - **FEAT**: Create a specific utility to Transform.translate (#484).
 - **FEAT**: Add more modifiers to Colors (#477).
 - **FEAT**: implement a way to clear inline modifiers (#478).
 - **FEAT**: Fluent API (#475).

## 1.4.6

 - **FIX**(docs): fix fn level docs for Style::applyVariants (#460).
 - **FIX**: Shadow list animation (#445).
 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FEAT**: Create mouse cursor Decorator (#263).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: `SingleChildScrollView` widget modifier (#427).
 - **FEAT**: Remix improvements and further improvements (#410).

## 1.4.5

 - **FIX**: HitTestBehavior when there is an Interectable in the tree (#437).
 - **FEAT**: Create a specific utility to Transform.rotate (#434).
 - **FEAT**: TargetPlatform and web variants (#431).

## 1.4.4

 - **FIX**: Pressable disposes controller only if it creates it (#424).

## 1.4.3

 - **FIX**: Breakpoint utility merge exception (#421).

## 1.4.2

 - **FIX**: FlexSpecWidget prioritizes the direction in spec (#414).

## 1.4.1

 - **FIX**: Added missing widget state utilities (#411).
 - **FIX**: Correct handling of individual border sides (#408).
 - **DOCS**: improve mix theme data features explanations (#404).

## 1.4.0

 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: Ability to pass MixWidgetStateController to SpecBuilder (#391).
 - **FEAT**: Interactive widget state by default (#384).
 - **FEAT**: MixThemeData can alter default order of modifiers (#380).
 - **FEAT**: Dto utility generation now adds constructor and static methods (#377).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **REFACTOR**: Code gen more lint friendly dart code (#399).
 - **FIX**: Gestures propagation for GestureMixStateWidget (#394).
 - **FIX**: Normalization of order of modifier when applied to a Styled Widget (#389).
 - **FIX**: Animations of Stack and Flex (#388).
 - **FIX**: Review the order of modifiers adding FlexibleModifier, PaddingModifier, and RotatedModifier (#379).

## 1.3.0

 - **REFACTOR**: unpressDelay uses timer instead of future<void> now (#374).
 - **REFACTOR**: bump min flutter version to 3.19.0 (#365).
 - **FEAT**: added modifiers per spec (#333).
 - **FEAT**: add attribute to fontVariantion (#371).

## 1.2.0

 - **FIX**: Exception when there is no children on flex (#345).
 - **FIX**: Added remaining params to callable specs and modifiers (#332).
 - **FIX**: Gap resolve SpaceToken in flex attribute (#327).
 - **FIX**: mix - Improved merge behavior between ShapeDecoration and BoxDecoration (#316).
 - **FEAT**: pressable supports keyboard events (#346).

## 1.1.3

- Improved merge behavior between ShapeDecoration and BoxDecoration
- Fixed space token resolve on gap in flex attribute
- Added remaining params to callable specs and modifiers

## 1.1.2

- Chore: Changed the class modifier of the Spec class for code generation.

## 1.1.1

- Fixed some specs not respecting nested animated.
- Added call build method to specs.

## 1.1.0

- Mix now uses mix_generator for Spec and Dto generation.
- Added missing utilities for IconSpec and ImageSpec.
- Added missing ShapeBorders.
- Improved ShapeBorderDto merge behavior.
- Bumped minimum Dart SDK to 3.0.6.
- Added animated utility to Spec.

## 1.0.0

- Revamped Mix API for improved functionality and developer experience.
- Enhanced performance and system responsiveness.
- Broadened test coverage for greater reliability.
- Extensive bug fixes for increased stability.
- Too many things to list; view our docs for more info.

Visit our documentation site for more information [https://www.fluttermix.com](https://www.fluttermix.com)

## 0.0.7

- Performance improvements.
- Bug fixes [#59](https://github.com/conceptadev/mix/issues/59) by @bdlukaa.
- InheritedAttribute - Custom Mix attributes [#94](https://github.com/conceptadev/mix/pull/94) by @pbissonho.

## 0.0.6

- Refactored MixTheme & Context Tokens.
- ZBox Widget by @.
- Headless Widgets (Experimental).
- Lots of bug fixes and performance improvements.

## 0.0.5

- Adjustments on Mix helper for applying variants and attributes.

## 0.0.4

- Optimization improvements.
- Added clip decorator.
- Fixed some bugs.

## 0.0.3

- Global Mix for reusability of design tokens and mixes across DS.
- `withMix` utility to add nested mixes and combine them.
- Attribute modifiers, create attributes that modify a widget value.

## 0.0.2

- Added screen size dynamic attribute.
- Added device orientation dynamic attribute.

## 0.0.1

- Initial release.
