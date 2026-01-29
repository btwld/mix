# Research: matchedGeometryEffect for Mix

## Summary

This document explores whether SwiftUI-like `matchedGeometryEffect` can be implemented using Mix's Style/Styler API.

**Conclusion: It cannot.** The feature requires runtime geometry queries between widgets, which is fundamentally outside Mix's stateless Style → Spec → Widget pattern.

---

## The Problem matchedGeometryEffect Solves

**Scenario 1: Expandable Card**
User taps a card thumbnail → card smoothly expands to fill the screen → tap again → collapses back.

**Scenario 2: Segmented Control**
Selected indicator slides smoothly from one segment to another.

**Scenario 3: Tab Bar Indicator**
Active tab indicator moves to track the selected tab.

All share a pattern: **animate one widget's geometry to match another widget's geometry**.

---

## Why It Doesn't Fit Mix's Style API

### How Mix Styles Work

Mix styles are **stateless and geometry-unaware**:

```dart
// Styles resolve using only BuildContext
abstract class Style<S extends Spec<S>> {
  StyleSpec<S> resolve(BuildContext context);
}
```

- No access to widget positions, sizes, or GlobalKeys
- Animation drivers interpolate between known Spec values
- Transforms take static values: `.translate(100, 200)` not `.translateToMatch(otherWidget)`

### What Mix CAN Do

```dart
// Static, known transformations - works great
final style = BoxStyler()
  .translate(100, 200)  // ✅ Hardcoded offset
  .scale(1.5)           // ✅ Hardcoded scale
  .animate(400.ms, Curves.easeOut);
```

### What matchedGeometryEffect NEEDS

```dart
// Dynamic geometry-based transformations - not possible in Style
final style = BoxStyler()
  .matchGeometryOf('card')        // ❌ Can't query other widgets
  .animateFromRect(sourceRect)    // ❌ No runtime measurement
```

### The Fundamental Mismatch

| matchedGeometryEffect requires | Mix Style provides |
|-------------------------------|-------------------|
| Runtime geometry queries (GlobalKey → RenderBox) | Context-based resolution (BuildContext only) |
| Cross-widget coordination (shared registry) | Stateless composition (no shared state) |
| Dynamic animation targets | Static property values |

---

## SwiftUI Reference

For context, here's how SwiftUI does it:

```swift
@Namespace var namespace

Image("thumbnail")
    .matchedGeometryEffect(id: "photo", in: namespace)

Image("fullsize")
    .matchedGeometryEffect(id: "photo", in: namespace)
```

SwiftUI can do this because its view system has deeper integration with layout - views can communicate geometry through the framework itself.

---

## Alternatives for Mix Users

### 1. AnimatedPositioned / AnimatedContainer (single widget)

```dart
AnimatedPositioned(
  duration: Duration(milliseconds: 400),
  left: isExpanded ? 0 : 100,
  top: isExpanded ? 0 : 200,
  width: isExpanded ? 400 : 100,
  height: isExpanded ? 600 : 100,
  child: Card(),
)
```

### 2. Hero (cross-route)

```dart
Hero(
  tag: 'photo',
  child: Image(),
)
// + Navigator.push
```

### 3. Custom GlobalKey solution (same-route)

```dart
// Manual measurement and animation - the boilerplate this feature would eliminate
final sourceKey = GlobalKey();
final targetKey = GlobalKey();
// ... AnimationController, RenderBox queries, Transform widget
```

### 4. flutter_animate package

```dart
child.animate()
  .move(begin: Offset(0, 100), end: Offset.zero)
  .scale(begin: 0.5, end: 1.0);
```

---

## If We Built It Anyway

If there's strong user demand, matchedGeometryEffect could exist as a **separate widget wrapper**, not as part of the Styler API:

```dart
// Hypothetical - NOT a Style, just a widget
SharedGeometry(
  child: Column(
    children: [
      SharedGeometrySource(tag: 'card', child: SmallCard()),
      SharedGeometryTarget(tag: 'card', child: LargeCard()),
    ],
  ),
)
```

This would be ~200 LOC using GlobalKey, InheritedNotifier, and AnimationController. But it wouldn't use `BoxStyler().matchGeometry()` - that's not how Mix works.

---

## Conclusion

**matchedGeometryEffect is out of scope for Mix's Style API.**

The Style system is designed for:
- Describing widget properties (colors, sizes, padding)
- Responsive variants (dark mode, hover states)
- Interpolating between known values

It's **not** designed for:
- Querying other widgets' geometry
- Runtime coordinate calculations
- Cross-widget state coordination

This isn't a limitation - it's a design boundary. Mix styles are declarative property descriptions, not imperative geometry operations.

---

## Related

- [Discussion #842](https://github.com/leoafarias/mix/discussions/842) - RFC discussion
- [SwiftUI matchedGeometryEffect](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:))
- [Flutter Hero widget](https://api.flutter.dev/flutter/widgets/Hero-class.html)
