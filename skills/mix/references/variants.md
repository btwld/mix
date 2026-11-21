# Variants

Variants apply conditional style patches. Inspect the installed version's
`variants/variant.dart` and `core/style.dart` before extending activation.

## Kinds and priority

- `NamedVariant`: selected explicitly through `namedVariants` or `applyVariants`.
- `ContextVariant`: evaluates a condition against `BuildContext`.
- `WidgetStateVariant`: a ContextVariant for an interaction state.
- `ContextVariantBuilder`: computes a style from context.

Active entries without declared `widgetStateDependencies` merge first, then
entries declaring state dependencies. Declaration order is stable **within**
each group; later patches win shared replacement properties. This is not a
class sort: `FocusVisibleVariant` is state-dependent without being a
`WidgetStateVariant`, and `NotVariant` forwards its inner dependencies.
`StyleVariation` is not a third priority tier.

## Context and interaction

```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(.color(Colors.black))
    .onHovered(.color(Colors.blue.shade100))
    .onPressed(.color(Colors.blue.shade300));
```

Environment methods cover brightness, orientation, direction, platform, web,
and viewport breakpoints. `onMobile`, `onTablet`, and `onDesktop` use canonical
breakpoint tokens; `onBreakpoint` accepts a custom breakpoint. Grid's
`onConstraints` uses local layout constraints instead; see [Layout](layout.md).

Interaction methods include hover, press, focus, focus-visible, enabled and
disabled. `onFocusVisible` stops matching after pointer press until keyboard
input; pointer-focused text inputs do not match. Use `onFocused` for any focus.
Use `Pressable` / `PressableBox` for a shared interaction owner.

## Custom state dependencies

Context variants that read widget state must declare `widgetStateDependencies`,
including when delegating to another variant. Discovery is static; nested
ContextVariant branches contribute dependencies even while inactive.
Plain context closures and context builders are not executed to discover reads.
Focused and disabled states still need an ancestor state scope or external
controller; dependency discovery does not synthesize them.

```dart
final compact = ContextVariant.size('compact', (size) => size.width < 600);
final notCompact = ContextVariant.not(compact);
```

A diagnostic key is not guaranteed unique across kinds. Use structured equality
and the supported factory, not key-string comparisons, when matching variants.

## Named variants

```dart
const primary = NamedVariant('primary');
const small = NamedVariant('small');

final style = BoxStyler()
    .padding(.all(16))
    .variant(primary, .color(Colors.blue))
    .variant(small, .padding(.all(8)));

final spec = style.build(context, namedVariants: {primary, small}).spec;
final selected = style.applyVariants([primary]);
```

Built-in names include primary, secondary, outlined, solid, danger, small and
large. An enum can mix in `EnumVariant` to act as named runtime variants. This
is separate from `@MixWidget`'s plain enum recipe switch, which needs no mixin.

## Context builders

```dart
final responsive = BoxStyler().onBuilder((context) {
  return BoxStyler().width(MediaQuery.sizeOf(context).width * 0.5);
});
```

Use a builder for computed values; use declared variants when state tracking
must be discoverable before activation.

## StyleVariation

A component implementing `StyleVariation<S>` supplies `variantType` and
`styleBuilder(style, activeVariants, context)`. Its result is used when its
named variant is active and skips recursive variant resolution to avoid cycles.
Do not rely on variants attached to that result being merged again.
