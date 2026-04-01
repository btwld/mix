# Proposal: Add `BorderSideMix` forwarding factories to `BoxBorderMix`

## Problem

Today, creating a simple uniform border requires two levels of nesting:

```dart
// Current — verbose
BoxStyler().border(.all(.color(Colors.red).width(2)))
```

Compare with shadow, which allows direct property chaining:

```dart
// Shadow — clean
BoxStyler().shadow(.color(Colors.black12).blurRadius(8))
```

The inconsistency exists because `.border()` expects `BoxBorderMix` (a container
for per-side configuration), while `.shadow()` expects `BoxShadowMix` (a single
value). For the common case of a uniform border on all sides, the extra `.all()`
wrapper adds ceremony without value.

## Proposed API

Add static forwarding factories on `BoxBorderMix` that create a `BorderMix.all()`
from a single `BorderSideMix` property:

```dart
// New — matches the shadow pattern
BoxStyler().border(.color(Colors.red).width(2))

// Directional equivalent
BoxStyler().border(.color(Colors.red).width(2))  // same — .all() is the default
```

### Before → After

| Before | After |
|--------|-------|
| `.border(.all(.color(Colors.red).width(2)))` | `.border(.color(Colors.red).width(2))` |
| `.border(.all(.color(Colors.blue)))` | `.border(.color(Colors.blue))` |
| `.border(.all(.width(1)))` | `.border(.width(1))` |

The existing `.all()`, `.top()`, `.left()`, `.symmetric()`, etc. all remain
unchanged. The new factories are purely additive shortcuts for the uniform case.

## Implementation

### Changes to `BoxBorderMix` in `packages/mix/lib/src/properties/painting/border_mix.dart`

Add four static forwarding factories to the `BoxBorderMix` sealed class:

```dart
sealed class BoxBorderMix<T extends BoxBorder> extends Mix<T> {
  // ... existing code ...

  // --- NEW: Forwarding factories for uniform "all sides" shorthand ---

  /// Creates a uniform border on all sides with the given [color].
  ///
  /// Equivalent to `BoxBorderMix.all(BorderSideMix.color(color))`.
  ///
  /// ```dart
  /// BoxStyler().border(.color(Colors.red))
  /// ```
  static BorderMix color(Color value) {
    return BorderMix.all(BorderSideMix.color(value));
  }

  /// Creates a uniform border on all sides with the given [width].
  ///
  /// Equivalent to `BoxBorderMix.all(BorderSideMix.width(width))`.
  ///
  /// ```dart
  /// BoxStyler().border(.width(2))
  /// ```
  static BorderMix width(double value) {
    return BorderMix.all(BorderSideMix.width(value));
  }

  /// Creates a uniform border on all sides with the given [style].
  ///
  /// Equivalent to `BoxBorderMix.all(BorderSideMix.style(style))`.
  ///
  /// ```dart
  /// BoxStyler().border(.style(.solid))
  /// ```
  static BorderMix style(BorderStyle value) {
    return BorderMix.all(BorderSideMix.style(value));
  }

  /// Creates a uniform border on all sides with the given [strokeAlign].
  ///
  /// Equivalent to `BoxBorderMix.all(BorderSideMix.strokeAlign(strokeAlign))`.
  static BorderMix strokeAlign(double value) {
    return BorderMix.all(BorderSideMix.strokeAlign(value));
  }

  // ... rest of existing code ...
}
```

### Instance methods on `BorderMix` and `BorderDirectionalMix`

To enable chaining like `.border(.color(Colors.red).width(2))`, the returned
`BorderMix` needs `.color()` and `.width()` instance methods that apply to all
sides uniformly. Add these to both concrete classes:

```dart
final class BorderMix extends BoxBorderMix<Border> {
  // ... existing code ...

  /// Returns a copy with the given [color] applied to all sides.
  BorderMix color(Color value) {
    return merge(BorderMix.all(BorderSideMix.color(value)));
  }

  /// Returns a copy with the given [width] applied to all sides.
  BorderMix width(double value) {
    return merge(BorderMix.all(BorderSideMix.width(value)));
  }

  /// Returns a copy with the given [style] applied to all sides.
  BorderMix style(BorderStyle value) {
    return merge(BorderMix.all(BorderSideMix.style(value)));
  }

  /// Returns a copy with the given [strokeAlign] applied to all sides.
  BorderMix strokeAlign(double value) {
    return merge(BorderMix.all(BorderSideMix.strokeAlign(value)));
  }
}
```

```dart
final class BorderDirectionalMix extends BoxBorderMix<BorderDirectional> {
  // ... existing code ...

  /// Returns a copy with the given [color] applied to all sides.
  BorderDirectionalMix color(Color value) {
    return merge(BorderDirectionalMix.all(BorderSideMix.color(value)));
  }

  /// Returns a copy with the given [width] applied to all sides.
  BorderDirectionalMix width(double value) {
    return merge(BorderDirectionalMix.all(BorderSideMix.width(value)));
  }

  /// Returns a copy with the given [style] applied to all sides.
  BorderDirectionalMix style(BorderStyle value) {
    return merge(BorderDirectionalMix.all(BorderSideMix.style(value)));
  }

  /// Returns a copy with the given [strokeAlign] applied to all sides.
  BorderDirectionalMix strokeAlign(double value) {
    return merge(BorderDirectionalMix.all(BorderSideMix.strokeAlign(value)));
  }
}
```

## How Dot-Shorthand Resolution Works

The `.border()` method on `BoxStyler` has the signature:

```dart
T border(BoxBorderMix value)
```

With Dart 3.11 dot-shorthand, `.border(.color(Colors.red))` resolves to
`BoxBorderMix.color(Colors.red)` — the new static factory on the sealed base
class. This returns a `BorderMix` with all four sides set to the given color.

Chaining then works via instance methods:

```dart
.border(.color(Colors.red).width(2))
//       ^^^^^^^^^^^^^^^^^^^          → BoxBorderMix.color(Colors.red) → BorderMix
//                          ^^^^^^^^^^ → BorderMix.width(2)            → BorderMix
```

## Usage Examples

```dart
// Simple colored border on all sides
BoxStyler().border(.color(Colors.red))

// Color + width
BoxStyler().border(.color(Colors.blue).width(2))

// Width only (uses default color)
BoxStyler().border(.width(1))

// Chained with per-side override
BoxStyler().border(.color(Colors.grey).width(1).top(BorderSideMix.color(Colors.red).width(3)))

// Still works — explicit .all() for clarity
BoxStyler().border(.all(.color(Colors.red).width(2)))

// Still works — per-side control
BoxStyler().border(.top(.color(Colors.red)).bottom(.color(Colors.blue)))

// In a variant context
BoxStyler()
    .border(.color(Colors.grey).width(1))
    .onHovered(.border(.color(Colors.blue).width(2)))
```

## Scope

### Files to modify

1. `packages/mix/lib/src/properties/painting/border_mix.dart`
   - Add 4 static factories to `BoxBorderMix`
   - Add 4 instance methods to `BorderMix`
   - Add 4 instance methods to `BorderDirectionalMix`

### No changes needed

- `border_mix.g.dart` — generated file, no manual edits
- `BorderSideMix` — unchanged (already has the right factories)
- `border_style_mixin.dart` — legacy `.borderAll()` etc. remain as-is
- `decoration_style_mixin.dart` — `.border(BoxBorderMix)` signature unchanged

### Tests to add

- Verify `BoxBorderMix.color(Colors.red)` creates a uniform `BorderMix`
- Verify chaining: `BoxBorderMix.color(Colors.red).width(2)` sets both properties on all sides
- Verify per-side override after uniform: `.color(Colors.red).top(.color(Colors.blue))` overrides only top
- Verify `BorderDirectionalMix.color()` and `.width()` instance methods work correctly

## Other `.all()` Patterns Reviewed

| Type | Current shorthand | Needs similar treatment? |
|------|-------------------|------------------------|
| `EdgeInsetsGeometryMix` | `.padding(.all(16))` | No — `.all()` takes a `double`, already minimal |
| `BorderRadiusGeometryMix` | `.borderRadius(.circular(12))` | No — `.circular()` is already on the base class |
| `BoxBorderMix` | `.border(.all(.color().width()))` | **Yes — this proposal** |
| `BoxShadowMix` | `.shadow(.color().blurRadius())` | No — already works this way |

Only `BoxBorderMix` has the extra nesting problem because it's the only sealed
type where the "default mode" (uniform all sides) requires an explicit wrapper.
