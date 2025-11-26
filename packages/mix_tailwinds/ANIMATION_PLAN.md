# Animation Support Plan for mix_tailwinds

## Overview

This document outlines the implementation plan for adding Tailwind CSS transition/animation support to mix_tailwinds, mapping Tailwind's transition utilities to Mix's animation system.

## Tailwind CSS Transition Classes

### 1. Transition Property (`transition-*`)
| Class | CSS Property | Notes |
|-------|--------------|-------|
| `transition` | `transition-property: color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter` | Default transition |
| `transition-all` | `transition-property: all` | Transitions all properties |
| `transition-colors` | `transition-property: color, background-color, border-color, text-decoration-color, fill, stroke` | Color properties only |
| `transition-opacity` | `transition-property: opacity` | Opacity only |
| `transition-shadow` | `transition-property: box-shadow` | Shadow only |
| `transition-transform` | `transition-property: transform` | Transform only |
| `transition-none` | `transition-property: none` | Disable transitions |

### 2. Duration (`duration-*`)
| Class | Value |
|-------|-------|
| `duration-0` | 0ms |
| `duration-75` | 75ms |
| `duration-100` | 100ms |
| `duration-150` | 150ms |
| `duration-200` | 200ms |
| `duration-300` | 300ms |
| `duration-500` | 500ms |
| `duration-700` | 700ms |
| `duration-1000` | 1000ms |

### 3. Timing Function (`ease-*`)
| Class | Curve | Flutter Equivalent |
|-------|-------|-------------------|
| `ease-linear` | `linear` | `Curves.linear` |
| `ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | `Curves.easeIn` |
| `ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | `Curves.easeOut` |
| `ease-in-out` | `cubic-bezier(0.4, 0, 0.2, 1)` | `Curves.easeInOut` |

### 4. Delay (`delay-*`)
| Class | Value |
|-------|-------|
| `delay-0` | 0ms |
| `delay-75` | 75ms |
| `delay-100` | 100ms |
| `delay-150` | 150ms |
| `delay-200` | 200ms |
| `delay-300` | 300ms |
| `delay-500` | 500ms |
| `delay-700` | 700ms |
| `delay-1000` | 1000ms |

---

## Mix Animation System

### How Mix Animations Work

Mix provides the `AnimationConfig` class which is applied to styles via `.animate()`:

```dart
// Curve-based animation
BoxStyler().animate(AnimationConfig.ease(Duration(milliseconds: 150)))

// With delay
BoxStyler().animate(AnimationConfig.curve(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  delay: Duration(milliseconds: 100),
))
```

### Key Characteristics

1. **Animates ALL properties**: Mix doesn't support animating specific properties like CSS. When `animate()` is applied, all style changes animate together.

2. **Automatic on state change**: When a variant (hover, pressed, etc.) activates, the animation automatically plays.

3. **Supports curves and springs**: Both traditional curves and physics-based spring animations.

---

## Implementation Strategy

### Phase 1: Extend TwConfig

Add animation configuration maps to `TwConfig`:

```dart
class TwConfig {
  // Existing fields...

  /// Duration values in milliseconds
  final Map<String, int> durations;

  /// Delay values in milliseconds
  final Map<String, int> delays;

  /// Easing curves
  final Map<String, Curve> easings;
```

**Default values:**
```dart
durations: {
  '0': 0,
  '75': 75,
  '100': 100,
  '150': 150,
  '200': 200,
  '300': 300,
  '500': 500,
  '700': 700,
  '1000': 1000,
},
delays: {
  '0': 0,
  '75': 75,
  '100': 100,
  '150': 150,
  '200': 200,
  '300': 300,
  '500': 500,
  '700': 700,
  '1000': 1000,
},
easings: {
  'linear': Curves.linear,
  'in': Curves.easeIn,
  'out': Curves.easeOut,
  'in-out': Curves.easeInOut,
},
```

### Phase 2: Parse Animation Tokens

Create a structure to accumulate animation configuration from tokens:

```dart
class _AnimationDirective {
  final bool enabled;
  final int? durationMs;
  final int? delayMs;
  final Curve? curve;

  const _AnimationDirective({
    this.enabled = false,
    this.durationMs,
    this.delayMs,
    this.curve,
  });

  _AnimationDirective merge(_AnimationDirective other) {
    return _AnimationDirective(
      enabled: other.enabled || enabled,
      durationMs: other.durationMs ?? durationMs,
      delayMs: other.delayMs ?? delayMs,
      curve: other.curve ?? curve,
    );
  }

  AnimationConfig? toConfig() {
    if (!enabled) return null;

    final duration = Duration(milliseconds: durationMs ?? 150);
    final delay = Duration(milliseconds: delayMs ?? 0);
    final easingCurve = curve ?? Curves.ease;

    return AnimationConfig.curve(
      duration: duration,
      curve: easingCurve,
      delay: delay,
    );
  }
}
```

### Phase 3: Token Parsing Logic

Add handlers for animation tokens in parser:

```dart
_AnimationDirective? _parseAnimationToken(String token, TwConfig cfg) {
  // transition / transition-all / transition-none
  if (token == 'transition' || token == 'transition-all') {
    return _AnimationDirective(enabled: true);
  }
  if (token == 'transition-none') {
    return _AnimationDirective(enabled: false);
  }

  // duration-*
  if (token.startsWith('duration-')) {
    final key = token.substring(9);
    final ms = cfg.durationOf(key);
    if (ms != null) {
      return _AnimationDirective(durationMs: ms);
    }
  }

  // delay-*
  if (token.startsWith('delay-')) {
    final key = token.substring(6);
    final ms = cfg.delayOf(key);
    if (ms != null) {
      return _AnimationDirective(delayMs: ms);
    }
  }

  // ease-*
  if (token.startsWith('ease-')) {
    final key = token.substring(5);
    final curve = cfg.easingOf(key);
    if (curve != null) {
      return _AnimationDirective(curve: curve);
    }
  }

  return null;
}
```

### Phase 4: Integrate into Parsing Pipeline

Modify `parseBox` and `parseFlex` to:

1. **First pass**: Collect all animation tokens
2. **Second pass**: Parse style tokens normally
3. **Apply animation**: If animation directive exists, call `.animate()`

```dart
BoxStyler parseBox(String classNames) {
  final tokens = listTokens(classNames);

  // Collect animation directive
  var animDirective = const _AnimationDirective();
  for (final token in tokens) {
    final anim = _parseAnimationToken(token, config);
    if (anim != null) {
      animDirective = animDirective.merge(anim);
    }
  }

  // Parse style tokens (existing logic)
  var styler = BoxStyler();
  for (final token in tokens) {
    styler = _applyBoxToken(styler, token);
  }

  // Apply animation if enabled
  final animConfig = animDirective.toConfig();
  if (animConfig != null) {
    styler = styler.animate(animConfig);
  }

  return styler;
}
```

### Phase 5: Handle Transition Property Types

**Important limitation**: Mix animates ALL properties, so `transition-colors` vs `transition-transform` cannot be distinguished. We have two options:

**Option A: Treat all as `transition-all`**
```dart
// All these become equivalent:
'transition' => enabled: true
'transition-all' => enabled: true
'transition-colors' => enabled: true  // Same behavior
'transition-opacity' => enabled: true // Same behavior
```
*Pros*: Simple, works out of the box
*Cons*: Not exactly like Tailwind

**Option B: Only support `transition` and `transition-all`**
```dart
// Only these are supported:
'transition' => enabled: true
'transition-all' => enabled: true
'transition-colors' => warn: "Not supported, use transition"
```
*Pros*: Honest about limitations
*Cons*: Users might expect CSS-like behavior

**Recommendation**: Option A with documentation noting the limitation.

---

## File Changes Required

### 1. `tw_config.dart`
- Add `durations`, `delays`, `easings` maps
- Add `durationOf()`, `delayOf()`, `easingOf()` accessors
- Update `TwConfig.standard()` with default values

### 2. `tw_parser.dart`
- Add `_AnimationDirective` class
- Add `_parseAnimationToken()` function
- Modify `parseBox()` to handle animation
- Modify `parseFlex()` to handle animation
- Modify `parseText()` to handle animation
- Update `wantsFlex()` to ignore animation tokens
- Add animation tokens to known tokens (avoid unsupported warnings)

### 3. `tw_widget.dart`
- No changes needed (animation is applied at style level)

---

## Usage Examples

### Basic Transition
```dart
Div(
  classNames: 'bg-blue-500 hover:bg-red-500 transition duration-300',
  child: Text('Hover me'),
)
```

### With Easing
```dart
Div(
  classNames: 'p-4 hover:p-8 transition duration-500 ease-in-out',
  child: Text('Padding animates'),
)
```

### With Delay
```dart
Div(
  classNames: 'opacity-100 hover:opacity-50 transition duration-200 delay-100',
  child: Text('Delayed fade'),
)
```

### Complex Example
```dart
Div(
  classNames: '''
    bg-white rounded-lg shadow-md p-6
    hover:bg-blue-50 hover:shadow-xl hover:scale-105
    transition duration-300 ease-out
  ''',
  children: [
    Span(text: 'Card Title', classNames: 'text-xl font-bold'),
    Span(text: 'Card content here', classNames: 'text-gray-600'),
  ],
)
```

---

## Testing Plan

### Unit Tests
1. `_parseAnimationToken` correctly parses all token types
2. `_AnimationDirective.merge()` correctly combines directives
3. `_AnimationDirective.toConfig()` produces correct `AnimationConfig`
4. Default values are applied when not specified
5. `transition-none` disables animation

### Integration Tests
1. `parseBox()` returns styled with animation when `transition` present
2. `parseFlex()` returns styled with animation when `transition` present
3. Animation tokens don't trigger `onUnsupported` callback
4. Variant styles (hover:) animate when transition applied

### Widget Tests
1. Visual regression tests with golden files
2. Verify animation plays on state change (may require pump timing)

---

## Limitations & Trade-offs

### 1. No Property-Specific Transitions
Mix animates all properties together. `transition-colors` behaves the same as `transition-all`.

**Workaround**: Document this limitation. Users who need property-specific transitions should use Mix's native API.

### 2. No `motion-safe` / `motion-reduce`
Tailwind's accessibility variants for reduced motion are not implemented.

**Future consideration**: Could be implemented via `MediaQuery.disableAnimations` check.

### 3. Spring Animations Not Exposed
Mix supports spring-based animations, but Tailwind CSS doesn't have equivalent classes.

**Future consideration**: Could add custom classes like `spring-bouncy`, `spring-smooth`.

### 4. Transform Animations
Tailwind's transform utilities (`scale-*`, `rotate-*`, `translate-*`) would need separate implementation as Mix uses modifiers for transforms.

**Status**: Not in initial scope, but could be Phase 2.

---

## Implementation Timeline

### Phase 1: Core Animation Support (MVP)
- [ ] Extend `TwConfig` with animation maps
- [ ] Implement `_AnimationDirective` and parsing
- [ ] Integrate into `parseBox()` and `parseFlex()`
- [ ] Add unit tests
- [ ] Update README

### Phase 2: Polish & Documentation
- [ ] Add widget tests
- [ ] Add golden tests for animated states
- [ ] Document limitations in README
- [ ] Add example app showcasing animations

### Phase 3: Extended Features (Future)
- [ ] Transform utilities (`scale-*`, `rotate-*`)
- [ ] `motion-safe` / `motion-reduce` variants
- [ ] Custom spring animation classes

---

## References

- [Tailwind CSS - Transition Duration](https://tailwindcss.com/docs/transition-duration)
- [Tailwind CSS - Transition Delay](https://tailwindcss.com/docs/transition-delay)
- [Tailwind CSS - Transition Timing Function](https://tailwindcss.com/docs/transition-timing-function)
- [Tailwind CSS - Transition Property](https://tailwindcss.com/docs/transition-property)
- Mix Animation API: `packages/mix/lib/src/animation/`
