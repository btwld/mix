# StackSpecUtility API Reference

## Overview
The `StackSpecUtility` class provides a mutable utility for stack layout styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$stack..alignment.center()..fit.expand()`. This is the core utility class behind the global `$stack` accessor.

**Global Access:** `$stack` → `StackSpecUtility()`

## Core Utility Properties

### Child Positioning

#### $stack.alignment → MixUtility
Controls the default alignment of children within the stack:
- **$stack.alignment(AlignmentGeometry value)** → StackStyler - Sets default child alignment
- **$stack.alignment.topLeft()** → StackStyler - Align children to top-left
- **$stack.alignment.topCenter()** → StackStyler - Align children to top-center
- **$stack.alignment.topRight()** → StackStyler - Align children to top-right
- **$stack.alignment.centerLeft()** → StackStyler - Align children to center-left
- **$stack.alignment.center()** → StackStyler - Center children in the stack
- **$stack.alignment.centerRight()** → StackStyler - Align children to center-right
- **$stack.alignment.bottomLeft()** → StackStyler - Align children to bottom-left
- **$stack.alignment.bottomCenter()** → StackStyler - Align children to bottom-center
- **$stack.alignment.bottomRight()** → StackStyler - Align children to bottom-right

### Child Sizing

#### $stack.fit → MixUtility
Controls how non-positioned children are sized:
- **$stack.fit(StackFit value)** → StackStyler - Sets stack fit behavior
- **$stack.fit.loose()** → StackStyler - Children can be smaller than the stack
- **$stack.fit.expand()** → StackStyler - Children are forced to expand to stack size
- **$stack.fit.passthrough()** → StackStyler - Stack takes the size of its children

### Layout Direction

#### $stack.textDirection → MixUtility
Controls the text direction for positioned children:
- **$stack.textDirection(TextDirection value)** → StackStyler - Sets text direction
- **$stack.textDirection.ltr()** → StackStyler - Left-to-right direction
- **$stack.textDirection.rtl()** → StackStyler - Right-to-left direction

### Clipping Behavior

#### $stack.clipBehavior → MixUtility
Controls how content is clipped:
- **$stack.clipBehavior(Clip value)** → StackStyler - Sets clip behavior
- **$stack.clipBehavior.none()** → StackStyler - No clipping (children can overflow)
- **$stack.clipBehavior.hardEdge()** → StackStyler - Clip with hard edges
- **$stack.clipBehavior.antiAlias()** → StackStyler - Clip with anti-aliasing
- **$stack.clipBehavior.antiAliasWithSaveLayer()** → StackStyler - Clip with save layer (expensive)

### Modifiers & Animation

#### $stack.wrap → ModifierUtility
Provides widget modifiers:
- **$stack.wrap(Modifier value)** → StackStyler - Applies widget modifier
- **$stack.wrap.opacity(double value)** → StackStyler - Wraps with opacity modifier
- **$stack.wrap.padding(EdgeInsets value)** → StackStyler - Wraps with padding modifier
- **$stack.wrap.transform(Matrix4 value)** → StackStyler - Wraps with transform modifier
- **$stack.wrap.clipRect()** → StackStyler - Clips stack to rectangular bounds

## Core Methods

### animate(AnimationConfig animation) → StackStyler
Applies animation configuration to the stack styling.

### merge(Style<StackSpec>? other) → StackSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The StackSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, StackStyler style) → StackStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<StackSpec>> variants) → StackStyler
Applies multiple variant styles.

## Deprecated Methods

### $stack.on → OnContextVariantUtility (Deprecated)
**⚠️ Deprecated:** Use direct methods like `$stack.onHovered()` instead.
- **$stack.on.hover(StackStyler style)** → StackStyler - Apply style on hover
- **$stack.on.dark(StackStyler style)** → StackStyler - Apply style in dark mode
- **$stack.on.light(StackStyler style)** → StackStyler - Apply style in light mode

**Replacement Pattern:**
```dart
// Instead of:
$stack.on.hover($stack.alignment.topCenter())

// Use:
$stack.onHovered($stack.alignment.topCenter())
```

## Usage Examples

### Basic Stack Layouts
```dart
// Centered stack
final centeredStack = $stack
  .alignment.center()
  .fit.loose();

// Expanded stack with top-left alignment
final expandedStack = $stack
  .alignment.topLeft()
  .fit.expand()
  .clipBehavior.hardEdge();
```

### Overlay Layouts
```dart
// Image overlay with centered content
final imageOverlay = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.antiAlias();

// Badge overlay positioned at top-right
final badgeOverlay = $stack
  .alignment.topRight()
  .fit.loose()
  .textDirection.ltr();
```

### Responsive Stack Layouts
```dart
// Stack that changes alignment based on screen size
final responsiveStack = $stack
  .alignment.center()
  .fit.loose()
  .onBreakpoint(Breakpoint.md, $stack.alignment.topCenter())
  .onBreakpoint(Breakpoint.lg, $stack.fit.expand());

// Theme-aware stack
final themeStack = $stack
  .alignment.center()
  .onDark($stack.alignment.bottomCenter());
```

### Complex Positioning
```dart
// Multi-layer stack with different alignments
final layeredStack = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.antiAlias()
  .wrap.decoration(BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black54],
    ),
  ));
```

### Interactive Stacks
```dart
// Stack with hover effects
final interactiveStack = $stack
  .alignment.center()
  .fit.loose()
  .onHovered($stack.alignment.topCenter().animate(
    AnimationConfig(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    ),
  ));

// Animated stack transitions
final animatedStack = $stack
  .alignment.bottomCenter()
  .fit.expand()
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.elasticOut,
  ));
```

### Card Layouts with Overlays
```dart
// Product card with overlay information
final productCard = $stack
  .alignment.bottomLeft()
  .fit.expand()
  .clipBehavior.hardEdge()
  .wrap.borderRadius(BorderRadius.circular(12));

// Profile card with avatar overlay
final profileCard = $stack
  .alignment.topCenter()
  .fit.loose()
  .clipBehavior.none();
```

### Media Player Layouts
```dart
// Video player with controls overlay
final videoPlayer = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge();

// Audio player with floating controls
final audioPlayer = $stack
  .alignment.bottomCenter()
  .fit.loose()
  .wrap.padding(EdgeInsets.all(16));
```

### Navigation & UI Overlays
```dart
// Floating action button overlay
final fabOverlay = $stack
  .alignment.bottomRight()
  .fit.loose()
  .wrap.padding(EdgeInsets.all(16));

// Modal overlay stack
final modalOverlay = $stack
  .alignment.center()
  .fit.expand()
  .wrap.backgroundColor(Colors.black54);

// Drawer overlay
final drawerOverlay = $stack
  .alignment.centerLeft()
  .fit.expand()
  .textDirection.ltr();
```

### Hero Sections
```dart
// Hero banner with centered content
final heroBanner = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge()
  .wrap.decoration(BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/hero_bg.jpg'),
      fit: BoxFit.cover,
    ),
  ));

// Call-to-action overlay
final ctaOverlay = $stack
  .alignment.bottomCenter()
  .fit.loose()
  .wrap.padding(EdgeInsets.all(24));
```

### Loading & Status Overlays
```dart
// Loading overlay
final loadingOverlay = $stack
  .alignment.center()
  .fit.expand()
  .wrap.backgroundColor(Colors.white.withOpacity(0.8));

// Error state overlay
final errorOverlay = $stack
  .alignment.center()
  .fit.loose()
  .wrap.padding(EdgeInsets.all(32));
```

### RTL-Aware Layouts
```dart
// RTL-aware positioned stack
final rtlStack = $stack
  .alignment.centerStart()
  .textDirection.ltr()
  .fit.loose()
  .onLocale(Locale('ar'), $stack.textDirection.rtl());

// Directional overlay positioning
final directionalStack = $stack
  .alignment.topStart()
  .textDirection.ltr()
  .fit.expand();
```

## Performance Notes

- **Mutable State**: StackSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Clipping Performance**: Be mindful of clipping behavior impact on performance
- **Overlay Count**: Too many overlapping children can impact rendering performance

## Child Positioning Context

When using stacks, remember that:

- **Non-positioned children**: Use the stack's `alignment` property
- **Positioned children**: Use `Positioned` widget wrapper to override stack alignment
- **Stack sizing**: Determined by non-positioned children unless `fit` is set to `expand`
- **Z-order**: Later children in the children list appear on top

## Related Classes

- **StackStyler** - The immutable style class that StackSpecUtility builds
- **StackSpec** - The resolved specification used at runtime
- **Stack** (Flutter) - The underlying Flutter widget for stack layouts
- **Positioned** (Flutter) - Widget for absolute positioning within stacks
- **IndexedStack** (Flutter) - Stack that shows only one child at a time
- **ModifierUtility** - Utility for widget modifiers