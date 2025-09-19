# IconSpecUtility API Reference

## Overview
The `IconSpecUtility` class provides a mutable utility for icon styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$icon..color.blue()..size(24)`. This is the core utility class behind the global `$icon` accessor.

**Global Access:** `$icon` → `IconSpecUtility()`

## Core Utility Properties

### Icon Appearance

#### $icon.color → ColorUtility
Controls icon color with comprehensive color utilities:
- **$icon.color(Color value)** → IconStyler - Sets icon color directly
- **$icon.color.red()** → IconStyler - Sets red color
- **$icon.color.green()** → IconStyler - Sets green color
- **$icon.color.blue()** → IconStyler - Sets blue color
- **$icon.color.white()** → IconStyler - Sets white color
- **$icon.color.black()** → IconStyler - Sets black color
- **$icon.color.transparent()** → IconStyler - Sets transparent color
- **$icon.color.grey()** → IconStyler - Sets grey color (with shade utilities)
- **$icon.color.amber()** → IconStyler - Sets amber color
- **$icon.color.purple()** → IconStyler - Sets purple color

#### $icon.size → MixUtility
Controls icon size:
- **$icon.size(double value)** → IconStyler - Sets icon size in logical pixels
- **$icon.size.small()** → IconStyler - Sets small icon size (typically 16)
- **$icon.size.medium()** → IconStyler - Sets medium icon size (typically 24)
- **$icon.size.large()** → IconStyler - Sets large icon size (typically 32)

#### $icon.weight → MixUtility
Controls icon weight (for variable fonts):
- **$icon.weight(double value)** → IconStyler - Sets icon weight (100-900)
- **$icon.weight.thin()** → IconStyler - Sets thin weight (100)
- **$icon.weight.light()** → IconStyler - Sets light weight (300)
- **$icon.weight.regular()** → IconStyler - Sets regular weight (400)
- **$icon.weight.medium()** → IconStyler - Sets medium weight (500)
- **$icon.weight.semiBold()** → IconStyler - Sets semi-bold weight (600)
- **$icon.weight.bold()** → IconStyler - Sets bold weight (700)

#### $icon.grade → MixUtility
Controls icon grade (for variable fonts):
- **$icon.grade(double value)** → IconStyler - Sets icon grade (-50 to 200)
- **$icon.grade.low()** → IconStyler - Sets low grade (-25)
- **$icon.grade.normal()** → IconStyler - Sets normal grade (0)
- **$icon.grade.high()** → IconStyler - Sets high grade (200)

#### $icon.opticalSize → MixUtility
Controls icon optical size:
- **$icon.opticalSize(double value)** → IconStyler - Sets optical size in logical pixels
- **$icon.opticalSize.small()** → IconStyler - Sets small optical size (20)
- **$icon.opticalSize.medium()** → IconStyler - Sets medium optical size (24)
- **$icon.opticalSize.large()** → IconStyler - Sets large optical size (40)

### Icon Effects

#### $icon.shadows → ShadowUtility
Controls icon shadows:
- **$icon.shadows(List<Shadow> value)** → IconStyler - Sets custom shadows
- **$icon.shadows.none()** → IconStyler - Removes all shadows
- **$icon.shadows.small()** → IconStyler - Applies small shadow
- **$icon.shadows.medium()** → IconStyler - Applies medium shadow
- **$icon.shadows.large()** → IconStyler - Applies large shadow

#### $icon.opacity → MixUtility
Controls icon opacity:
- **$icon.opacity(double value)** → IconStyler - Sets opacity (0.0 to 1.0)
- **$icon.opacity.transparent()** → IconStyler - Sets fully transparent
- **$icon.opacity.quarter()** → IconStyler - Sets 25% opacity
- **$icon.opacity.half()** → IconStyler - Sets 50% opacity
- **$icon.opacity.threeQuarter()** → IconStyler - Sets 75% opacity
- **$icon.opacity.opaque()** → IconStyler - Sets fully opaque

#### $icon.blendMode → MixUtility
Controls icon blend mode:
- **$icon.blendMode(BlendMode value)** → IconStyler - Sets blend mode
- **$icon.blendMode.normal()** → IconStyler - Normal blend mode
- **$icon.blendMode.multiply()** → IconStyler - Multiply blend mode
- **$icon.blendMode.screen()** → IconStyler - Screen blend mode
- **$icon.blendMode.overlay()** → IconStyler - Overlay blend mode

### Icon Behavior

#### $icon.textDirection → MixUtility
Controls icon text direction:
- **$icon.textDirection(TextDirection value)** → IconStyler - Sets text direction
- **$icon.textDirection.ltr()** → IconStyler - Left-to-right direction
- **$icon.textDirection.rtl()** → IconStyler - Right-to-left direction

#### $icon.applyTextScaling → MixUtility
Controls text scaling application:
- **$icon.applyTextScaling(bool value)** → IconStyler - Sets whether to apply text scaling
- **$icon.applyTextScaling.enabled()** → IconStyler - Enable text scaling
- **$icon.applyTextScaling.disabled()** → IconStyler - Disable text scaling

#### $icon.fill → MixUtility
Controls icon fill (for outlined icons):
- **$icon.fill(double value)** → IconStyler - Sets fill amount (0.0 to 1.0)
- **$icon.fill.none()** → IconStyler - No fill (outline only)
- **$icon.fill.quarter()** → IconStyler - 25% fill
- **$icon.fill.half()** → IconStyler - 50% fill
- **$icon.fill.full()** → IconStyler - 100% fill

### Icon Content

#### $icon.icon → MixUtility
Sets the actual icon data:
- **$icon.icon(IconData value)** → IconStyler - Sets icon data
- **$icon.icon.home()** → IconStyler - Material home icon
- **$icon.icon.star()** → IconStyler - Material star icon
- **$icon.icon.favorite()** → IconStyler - Material favorite icon

### Accessibility & Labels

#### $icon.semanticsLabel → MixUtility
Controls accessibility semantics:
- **$icon.semanticsLabel(String value)** → IconStyler - Sets semantic label for screen readers

### Modifiers & Animation

#### $icon.wrap → ModifierUtility
Provides widget modifiers:
- **$icon.wrap(Modifier value)** → IconStyler - Applies widget modifier
- **$icon.wrap.opacity(double value)** → IconStyler - Wraps with opacity modifier
- **$icon.wrap.padding(EdgeInsets value)** → IconStyler - Wraps with padding modifier
- **$icon.wrap.transform(Matrix4 value)** → IconStyler - Wraps with transform modifier

## Core Methods

### animate(AnimationConfig animation) → IconStyler
Applies animation configuration to the icon styling.

### merge(Style<IconSpec>? other) → IconSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The IconSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, IconStyler style) → IconStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<IconSpec>> variants) → IconStyler
Applies multiple variant styles.

## Deprecated Methods

### $icon.on → OnContextVariantUtility (Deprecated)
**⚠️ Deprecated:** Use direct methods like `$icon.onHovered()` instead.
- **$icon.on.hover(IconStyler style)** → IconStyler - Apply style on hover
- **$icon.on.dark(IconStyler style)** → IconStyler - Apply style in dark mode
- **$icon.on.light(IconStyler style)** → IconStyler - Apply style in light mode

**Replacement Pattern:**
```dart
// Instead of:
$icon.on.hover($icon.color.blue())

// Use:
$icon.onHovered($icon.color.blue())
```

## Usage Examples

### Basic Icon Styling
```dart
// Simple colored icon
final basicIcon = $icon
  .color.blue()
  .size(24);

// Large icon with weight
final styledIcon = $icon
  .size(32)
  .color.red()
  .weight.bold();
```

### Material Design Icons
```dart
// Material design icon with proper sizing
final materialIcon = $icon
  .icon(Icons.favorite)
  .color.red()
  .size(24)
  .weight.regular()
  .grade.normal();

// Variable font icon with effects
final variableIcon = $icon
  .icon(Icons.star_outlined)
  .color.amber()
  .size(32)
  .weight.medium()
  .fill.half()
  .shadows.medium();
```

### Icon States and Effects
```dart
// Icon with opacity and blend mode
final effectIcon = $icon
  .color.blue()
  .size(24)
  .opacity.threeQuarter()
  .blendMode.multiply();

// Interactive icon with hover effects
final interactiveIcon = $icon
  .color.grey()
  .size(20)
  .onHovered($icon.color.blue().scale(1.1));
```

### Accessibility & Semantic Icons
```dart
// Icon with semantic label
final accessibleIcon = $icon
  .icon(Icons.home)
  .color.black()
  .size(24)
  .semanticsLabel('Navigate to home');

// Icon with text scaling support
final scalableIcon = $icon
  .color.blue()
  .size(20)
  .applyTextScaling.enabled();
```

### Animated Icons
```dart
// Icon with animation
final animatedIcon = $icon
  .color.green()
  .size(24)
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  ));

// Icon with transform animation
final transformIcon = $icon
  .color.purple()
  .size(28)
  .animate(AnimationConfig.rotation(
    duration: Duration(seconds: 2),
    repeat: true,
  ));
```

### Theme-Aware Icons
```dart
// Icon that changes with theme
final themeIcon = $icon
  .size(24)
  .color.black()
  .onDark($icon.color.white())
  .onBreakpoint(Breakpoint.md, $icon.size(28));

// Icon with context-based styling
final contextIcon = $icon
  .color.primary()
  .size(20)
  .onPressed($icon.color.primary().shade700())
  .onDisabled($icon.color.grey().opacity.half());
```

### Complex Icon Compositions
```dart
// Badge-style icon with background
final badgeIcon = $icon
  .icon(Icons.notifications)
  .color.white()
  .size(18)
  .wrap.padding(EdgeInsets.all(8))
  .wrap.decoration(BoxDecoration(
    color: Colors.red,
    shape: BoxShape.circle,
  ));

// Icon with custom shadows
final shadowIcon = $icon
  .color.white()
  .size(32)
  .shadows([
    Shadow(
      color: Colors.black26,
      offset: Offset(2, 2),
      blurRadius: 4,
    ),
    Shadow(
      color: Colors.black12,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ]);
```

## Performance Notes

- **Mutable State**: IconSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Icon Rendering**: Optimized for Flutter's icon rendering pipeline
- **Vector Graphics**: Icons scale without quality loss

## Related Classes

- **IconStyler** - The immutable style class that IconSpecUtility builds
- **IconSpec** - The resolved specification used at runtime
- **ColorUtility** - Utility for color configuration
- **ShadowUtility** - Utility for shadow effects
- **ModifierUtility** - Utility for widget modifiers