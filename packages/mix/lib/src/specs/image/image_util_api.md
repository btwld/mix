# ImageSpecUtility API Reference

## Overview
The `ImageSpecUtility` class provides a mutable utility for image styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$image..width(200)..height(150)..fit.cover()`. This is the core utility class behind the global `$image` accessor.

**Global Access:** `$image` → `ImageSpecUtility()`

## Core Utility Properties

### Image Source & Content

#### $image.image → MixUtility
Controls the image source:
- **$image.image(ImageProvider value)** → ImageStyler - Sets image provider
- **$image.image.asset(String path)** → ImageStyler - Sets asset image
- **$image.image.network(String url)** → ImageStyler - Sets network image
- **$image.image.file(File file)** → ImageStyler - Sets file image
- **$image.image.memory(Uint8List bytes)** → ImageStyler - Sets memory image

### Image Dimensions

#### $image.width → MixUtility
Controls image width:
- **$image.width(double value)** → ImageStyler - Sets image width in logical pixels
- **$image.width.fixed(double value)** → ImageStyler - Sets fixed width
- **$image.width.fill()** → ImageStyler - Fills available width
- **$image.width.wrap()** → ImageStyler - Wraps to content width

#### $image.height → MixUtility
Controls image height:
- **$image.height(double value)** → ImageStyler - Sets image height in logical pixels
- **$image.height.fixed(double value)** → ImageStyler - Sets fixed height
- **$image.height.fill()** → ImageStyler - Fills available height
- **$image.height.wrap()** → ImageStyler - Wraps to content height

### Image Fitting & Layout

#### $image.fit → BoxFitUtility
Controls how the image fits within its bounds:
- **$image.fit(BoxFit value)** → ImageStyler - Sets box fit behavior
- **$image.fit.contain()** → ImageStyler - Scale to fit inside bounds (maintain aspect ratio)
- **$image.fit.cover()** → ImageStyler - Scale to fill bounds (maintain aspect ratio, may crop)
- **$image.fit.fill()** → ImageStyler - Scale to fill bounds exactly (may distort)
- **$image.fit.fitWidth()** → ImageStyler - Scale to fit width
- **$image.fit.fitHeight()** → ImageStyler - Scale to fit height
- **$image.fit.scaleDown()** → ImageStyler - Scale down to fit (never scale up)

#### $image.alignment → AlignmentUtility
Controls image alignment within its container:
- **$image.alignment(AlignmentGeometry value)** → ImageStyler - Sets alignment
- **$image.alignment.topLeft()** → ImageStyler - Align to top-left
- **$image.alignment.topCenter()** → ImageStyler - Align to top-center
- **$image.alignment.topRight()** → ImageStyler - Align to top-right
- **$image.alignment.centerLeft()** → ImageStyler - Align to center-left
- **$image.alignment.center()** → ImageStyler - Center alignment
- **$image.alignment.centerRight()** → ImageStyler - Align to center-right
- **$image.alignment.bottomLeft()** → ImageStyler - Align to bottom-left
- **$image.alignment.bottomCenter()** → ImageStyler - Align to bottom-center
- **$image.alignment.bottomRight()** → ImageStyler - Align to bottom-right

### Image Repetition & Patterns

#### $image.repeat → ImageRepeatUtility
Controls image repetition behavior:
- **$image.repeat(ImageRepeat value)** → ImageStyler - Sets repeat behavior
- **$image.repeat.noRepeat()** → ImageStyler - No repetition
- **$image.repeat.repeat()** → ImageStyler - Repeat in both directions
- **$image.repeat.repeatX()** → ImageStyler - Repeat horizontally only
- **$image.repeat.repeatY()** → ImageStyler - Repeat vertically only

### Image Effects & Colors

#### $image.color → ColorUtility
Controls image color tinting:
- **$image.color(Color value)** → ImageStyler - Sets color tint
- **$image.color.red()** → ImageStyler - Applies red tint
- **$image.color.green()** → ImageStyler - Applies green tint
- **$image.color.blue()** → ImageStyler - Applies blue tint
- **$image.color.white()** → ImageStyler - Applies white tint
- **$image.color.black()** → ImageStyler - Applies black tint
- **$image.color.transparent()** → ImageStyler - Makes transparent

#### $image.colorBlendMode → BlendModeUtility
Controls color blending with the image:
- **$image.colorBlendMode(BlendMode value)** → ImageStyler - Sets blend mode
- **$image.colorBlendMode.normal()** → ImageStyler - Normal blending
- **$image.colorBlendMode.multiply()** → ImageStyler - Multiply blending
- **$image.colorBlendMode.screen()** → ImageStyler - Screen blending
- **$image.colorBlendMode.overlay()** → ImageStyler - Overlay blending
- **$image.colorBlendMode.softLight()** → ImageStyler - Soft light blending
- **$image.colorBlendMode.hardLight()** → ImageStyler - Hard light blending

### Image Quality & Rendering

#### $image.filterQuality → FilterQualityUtility
Controls image rendering quality:
- **$image.filterQuality(FilterQuality value)** → ImageStyler - Sets filter quality
- **$image.filterQuality.none()** → ImageStyler - No filtering (pixelated when scaled)
- **$image.filterQuality.low()** → ImageStyler - Low quality filtering
- **$image.filterQuality.medium()** → ImageStyler - Medium quality filtering (default)
- **$image.filterQuality.high()** → ImageStyler - High quality filtering

#### $image.isAntiAlias → MixUtility
Controls anti-aliasing:
- **$image.isAntiAlias(bool value)** → ImageStyler - Sets anti-aliasing
- **$image.isAntiAlias.enabled()** → ImageStyler - Enable anti-aliasing
- **$image.isAntiAlias.disabled()** → ImageStyler - Disable anti-aliasing

### Image Behavior

#### $image.matchTextDirection → MixUtility
Controls text direction matching:
- **$image.matchTextDirection(bool value)** → ImageStyler - Sets text direction matching
- **$image.matchTextDirection.enabled()** → ImageStyler - Match text direction (flip for RTL)
- **$image.matchTextDirection.disabled()** → ImageStyler - Don't match text direction

#### $image.gaplessPlayback → MixUtility
Controls smooth transitions between images:
- **$image.gaplessPlayback(bool value)** → ImageStyler - Sets gapless playback
- **$image.gaplessPlayback.enabled()** → ImageStyler - Enable smooth transitions
- **$image.gaplessPlayback.disabled()** → ImageStyler - Disable smooth transitions

#### $image.excludeFromSemantics → MixUtility
Controls semantic exclusion:
- **$image.excludeFromSemantics(bool value)** → ImageStyler - Sets semantic exclusion
- **$image.excludeFromSemantics.enabled()** → ImageStyler - Exclude from screen readers
- **$image.excludeFromSemantics.disabled()** → ImageStyler - Include in screen readers

### Advanced Image Features

#### $image.centerSlice → MixUtility
Controls nine-patch style slicing:
- **$image.centerSlice(Rect value)** → ImageStyler - Sets center slice rectangle
- **$image.centerSlice.none()** → ImageStyler - No center slicing
- **$image.centerSlice.uniform(double value)** → ImageStyler - Uniform slice from edges

### Accessibility & Labels

#### $image.semanticLabel → MixUtility
Controls accessibility semantics:
- **$image.semanticLabel(String value)** → ImageStyler - Sets semantic label for screen readers

### Modifiers & Animation

#### $image.wrap → ModifierUtility
Provides widget modifiers:
- **$image.wrap(Modifier value)** → ImageStyler - Applies widget modifier
- **$image.wrap.opacity(double value)** → ImageStyler - Wraps with opacity modifier
- **$image.wrap.padding(EdgeInsets value)** → ImageStyler - Wraps with padding modifier
- **$image.wrap.borderRadius(BorderRadius value)** → ImageStyler - Wraps with border radius
- **$image.wrap.clipOval()** → ImageStyler - Clips to oval shape

## Core Methods

### animate(AnimationConfig animation) → ImageStyler
Applies animation configuration to the image styling.

### merge(Style<ImageSpec>? other) → ImageSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The ImageSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, ImageStyler style) → ImageStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<ImageSpec>> variants) → ImageStyler
Applies multiple variant styles.

## Usage Examples

### Basic Image Styling
```dart
// Simple sized image
final basicImage = $image
  .image.asset('assets/photo.jpg')
  .width(200)
  .height(150);

// Image with specific fit
final fittedImage = $image
  .image.network('https://example.com/image.jpg')
  .width(300)
  .height(200)
  .fit.cover();
```

### Image Effects & Colors
```dart
// Tinted image with blend mode
final tintedImage = $image
  .image.asset('assets/icon.png')
  .color.blue()
  .colorBlendMode.overlay()
  .width(100)
  .height(100);

// High-quality filtered image
final qualityImage = $image
  .image.network('https://example.com/photo.jpg')
  .filterQuality.high()
  .isAntiAlias.enabled()
  .width(400)
  .height(300);
```

### Responsive Images
```dart
// Image that adapts to different screen sizes
final responsiveImage = $image
  .image.asset('assets/hero.jpg')
  .width(double.infinity)
  .fit.cover()
  .alignment.center()
  .onBreakpoint(Breakpoint.md, $image.height(400))
  .onBreakpoint(Breakpoint.lg, $image.height(500));

// Image with different sources for different themes
final themeImage = $image
  .image.asset('assets/light_logo.png')
  .width(120)
  .height(40)
  .onDark($image.image.asset('assets/dark_logo.png'));
```

### Advanced Image Layouts
```dart
// Repeated pattern image
final patternImage = $image
  .image.asset('assets/pattern.png')
  .repeat.repeat()
  .width(double.infinity)
  .height(200)
  .fit.none();

// Nine-patch style image
final ninePatchImage = $image
  .image.asset('assets/button_bg.png')
  .centerSlice(Rect.fromLTRB(10, 10, 90, 90))
  .width(200)
  .height(60)
  .fit.fill();
```

### Image with Modifiers
```dart
// Circular profile image
final profileImage = $image
  .image.network('https://example.com/avatar.jpg')
  .width(80)
  .height(80)
  .fit.cover()
  .wrap.clipOval();

// Image with border and shadow
final borderedImage = $image
  .image.asset('assets/product.jpg')
  .width(150)
  .height(150)
  .fit.cover()
  .wrap.borderRadius(BorderRadius.circular(12))
  .wrap.decoration(BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  ));
```

### Animated Images
```dart
// Image with fade animation
final animatedImage = $image
  .image.network('https://example.com/image.jpg')
  .width(200)
  .height(200)
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  ));

// Image with scale animation on hover
final interactiveImage = $image
  .image.asset('assets/thumbnail.jpg')
  .width(100)
  .height(100)
  .fit.cover()
  .onHovered($image.wrap.scale(1.05));
```

### Accessible Images
```dart
// Image with semantic label
final accessibleImage = $image
  .image.asset('assets/chart.png')
  .width(300)
  .height(200)
  .semanticLabel('Sales chart showing 25% increase')
  .fit.contain();

// Decorative image excluded from semantics
final decorativeImage = $image
  .image.asset('assets/decoration.png')
  .width(50)
  .height(50)
  .excludeFromSemantics.enabled();
```

## Performance Notes

- **Mutable State**: ImageSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Image Caching**: Flutter automatically caches loaded images
- **Memory Management**: Large images should be appropriately sized to avoid memory issues

## Related Classes

- **ImageStyler** - The immutable style class that ImageSpecUtility builds
- **ImageSpec** - The resolved specification used at runtime
- **ColorUtility** - Utility for color tinting configuration
- **BoxFitUtility** - Utility for image fitting behavior
- **AlignmentUtility** - Utility for image alignment
- **ModifierUtility** - Utility for widget modifiers