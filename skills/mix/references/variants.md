# Variants

Context-aware and state-driven styling in Mix.

## Variant Hierarchy

**File:** `packages/mix/lib/src/variants/variant.dart`

```dart
sealed class Variant {
  String get key;
}
```

| Type | Activation | Use Case |
|------|-----------|----------|
| `NamedVariant` | Manual — via `namedVariants` set in `build()` | Design system: `primary`, `secondary`, `small`, `large` |
| `ContextVariant` | Auto — evaluates `bool Function(BuildContext)` | Environment: dark mode, orientation, breakpoint, platform |
| `WidgetStateVariant` | Auto — extends `ContextVariant` for `WidgetState` | Interaction: hovered, pressed, focused, disabled |
| `ContextVariantBuilder` | Auto — dynamically builds a Style from context | Dynamic: computed styles based on context |

## Priority Order

During `mergeActiveVariants()`, active variants are resolved and widget-state variants are applied last:

1. Resolve active `ContextVariant` and `NamedVariant` entries.
2. Sort matching entries so `WidgetStateVariant` entries run last.
3. Run `StyleVariation` values when their `variantType` is active; their results skip recursive variant resolution.

## Built-in Variant Methods

### VariantStyleMixin (context/platform/breakpoint)

Available on all Stylers via `VariantStyleMixin`:

| Method | Variant Type | Triggers When |
|--------|-------------|---------------|
| `onDark(style)` | ContextVariant | `Brightness.dark` |
| `onLight(style)` | ContextVariant | `Brightness.light` |
| `onPortrait(style)` | ContextVariant | Portrait orientation |
| `onLandscape(style)` | ContextVariant | Landscape orientation |
| `onMobile(style)` | ContextVariant | Mobile breakpoint |
| `onTablet(style)` | ContextVariant | Tablet breakpoint |
| `onDesktop(style)` | ContextVariant | Desktop breakpoint |
| `onBreakpoint(bp, style)` | ContextVariant | Custom breakpoint |
| `onLtr(style)` | ContextVariant | Left-to-right direction |
| `onRtl(style)` | ContextVariant | Right-to-left direction |
| `onIos(style)` | ContextVariant | iOS platform |
| `onAndroid(style)` | ContextVariant | Android platform |
| `onMacos(style)` | ContextVariant | macOS platform |
| `onWindows(style)` | ContextVariant | Windows platform |
| `onLinux(style)` | ContextVariant | Linux platform |
| `onFuchsia(style)` | ContextVariant | Fuchsia platform |
| `onWeb(style)` | ContextVariant | Web platform |
| `onNot(variant, style)` | ContextVariant | Negation of any ContextVariant |
| `onBuilder(fn)` | ContextVariantBuilder | Dynamic style from BuildContext |

### WidgetStateVariantMixin (interaction states)

Available on all Stylers via `WidgetStateVariantMixin`:

| Method | Widget State |
|--------|-------------|
| `onHovered(style)` | `WidgetState.hovered` |
| `onPressed(style)` | `WidgetState.pressed` |
| `onFocused(style)` | `WidgetState.focused` |
| `onDisabled(style)` | `WidgetState.disabled` |
| `onEnabled(style)` | Not disabled |

## Usage Patterns

### Basic Variant

```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(BoxStyler().color(Colors.grey.shade900));
```

### Composing Variants

```dart
final style = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .onDark(BoxStyler().color(Colors.black))
    .onHovered(BoxStyler().color(Colors.blue.shade100))
    .onPressed(BoxStyler().color(Colors.blue.shade300));
```

### Named Variants

```dart
// Define
const primary = NamedVariant('primary');
const small = NamedVariant('small');

// Apply in style
final style = BoxStyler()
    .paddingAll(16)
    .variant(primary, BoxStyler().color(Colors.blue))
    .variant(small, BoxStyler().paddingAll(8));

// Resolve with named variants where a BuildContext is available
final spec = style.build(context, namedVariants: {primary, small}).spec;
```

### Programmatic Variant Application

```dart
final style = BoxStyler()
    .paddingAll(16)
    .variant(primary, BoxStyler().color(Colors.blue));

// Apply named variants to a style
final resolved = style.applyVariants([primary]);
```

### Dynamic Context Builder

```dart
final style = BoxStyler()
    .onBuilder((context) {
      final size = MediaQuery.sizeOf(context);
      return BoxStyler().width(size.width * 0.5);
    });
```

## Pre-defined Named Variants

```dart
const primary   = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const outlined  = NamedVariant('outlined');
const solid     = NamedVariant('solid');
const danger    = NamedVariant('danger');
const small     = NamedVariant('small');
const large     = NamedVariant('large');
```

## ContextVariant Factory Methods

Create custom context variants:

```dart
ContextVariant.brightness(Brightness.dark)
ContextVariant.orientation(Orientation.portrait)
ContextVariant.platform(TargetPlatform.iOS)
ContextVariant.directionality(TextDirection.rtl)
ContextVariant.breakpoint(myBreakpoint)
ContextVariant.web()
ContextVariant.mobile()
ContextVariant.tablet()
ContextVariant.desktop()
ContextVariant.not(existingVariant)   // Negation
ContextVariant.size('compact', (size) => size.width < 600)
```

## StyleVariation

Interface for design system components that adapt styling based on active variants:

```dart
abstract class StyleVariation<S extends Spec<S>> {
  NamedVariant get variantType;
  Style<S> styleBuilder(
    covariant Style<S> style,
    Set<NamedVariant> activeVariants,
    BuildContext context,
  );
}
```

StyleVariation results skip recursive variant resolution to prevent infinite recursion.
