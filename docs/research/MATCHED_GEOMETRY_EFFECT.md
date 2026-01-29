# Research: matchedGeometryEffect for Mix

## Summary

This document explores adding SwiftUI-like `matchedGeometryEffect` to Mix for same-route shared element transitions.

The goal: make "expand card to detail" and "shared element" transitions as easy as adding a single wrapper widget.

---

## The Problem

**Scenario 1: Expandable Card**
User taps a card thumbnail → card smoothly expands to fill the screen → tap again → collapses back. Think: App Store Today tab, photo galleries, product cards.

**Scenario 2: Segmented Control Animation**
Selected indicator slides smoothly from one segment to another. The indicator "follows" the selection.

**Scenario 3: Tab Bar Indicator**
Active tab indicator moves to track the selected tab.

All of these share a pattern: **one widget needs to animate its position/size to match another widget's geometry**.

### What users do today

```dart
// ~50+ lines of boilerplate for a simple expand animation
class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  final _sourceKey = GlobalKey();
  final _targetKey = GlobalKey();
  late AnimationController _controller;
  Rect? _sourceRect;
  Rect? _targetRect;

  void _expand() {
    // 1. Measure source geometry with GlobalKey
    final sourceBox = _sourceKey.currentContext?.findRenderObject() as RenderBox?;
    _sourceRect = sourceBox?.localToGlobal(Offset.zero) & sourceBox!.size;

    setState(() => _isExpanded = true);

    // 2. Wait for layout, measure target
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetBox = _targetKey.currentContext?.findRenderObject() as RenderBox?;
      _targetRect = targetBox?.localToGlobal(Offset.zero) & targetBox!.size;
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Complex transform interpolation
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final rect = Rect.lerp(_sourceRect, _targetRect, _controller.value)!;
        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: _isExpanded ? LargeCard() : SmallCard(),
        );
      },
    );
  }
}
```

The pain points:
- Manual GlobalKey management
- PostFrameCallback timing gymnastics
- Custom transform/position math
- State management boilerplate
- No automatic reverse animation
- Hard to reuse across different transitions

---

## Why not Hero?

Flutter's `Hero` widget solves this... but only across routes:

```dart
// Hero requires Navigator.push/pop
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DetailPage(hero: Hero(tag: 'photo', child: Image())),
));
```

For **same-route** animations (card expands in-place, overlay slides up, indicator moves), Hero doesn't work. You're back to manual animation boilerplate.

---

## SwiftUI Reference

SwiftUI's `matchedGeometryEffect` coordinates shared element transitions:

```swift
@Namespace var namespace

// Source (thumbnail)
Image("thumbnail")
    .matchedGeometryEffect(id: "photo", in: namespace)

// Target (when expanded) - same id, same namespace
Image("fullsize")
    .matchedGeometryEffect(id: "photo", in: namespace)
```

When one appears and the other disappears, SwiftUI automatically animates between their geometries.

---

## Proposed API Options

### Option A: Widget-based (like Hero)

```dart
SharedGeometry(
  child: Column(
    children: [
      if (!isExpanded)
        SharedGeometrySource(
          tag: 'card',
          child: SmallCard(),
        ),
      if (isExpanded)
        SharedGeometryTarget(
          tag: 'card',
          duration: 400.ms,
          curve: Curves.easeOutCubic,
          child: LargeCard(),
        ),
    ],
  ),
)
```

- `SharedGeometry` - Scope that tracks geometry by tag
- `SharedGeometrySource` - Registers position/size
- `SharedGeometryTarget` - Animates FROM source TO its own position

### Option B: Fluent API (more Mix-like)

```dart
// Define the geometry group
final geometryScope = SharedGeometryScope();

// In widget tree
Column(
  children: [
    if (!isExpanded)
      SmallCard().sharedGeometry(
        scope: geometryScope,
        tag: 'card',
        isSource: true,
      ),
    if (isExpanded)
      LargeCard().sharedGeometry(
        scope: geometryScope,
        tag: 'card',
        duration: 400.ms,
        curve: Curves.easeOutCubic,
      ),
  ],
)
```

### Option C: Style-based (integrate with Mix styles)

```dart
final style = BoxStyler()
  .sharedGeometry(tag: 'card', isSource: !isExpanded)
  .animation(400.ms, Curves.easeOutCubic);

Box(style: style, child: isExpanded ? LargeCard() : SmallCard())
```

This option would integrate with Mix's existing animation system but is more complex to implement.

---

## Implementation Notes

Core components (~200 LOC total):

### TrackedGeometry (data class)

```dart
@immutable
class TrackedGeometry {
  final Rect rect;
  final bool isVisible;

  const TrackedGeometry({required this.rect, this.isVisible = true});

  TrackedGeometry lerp(TrackedGeometry other, double t) {
    return TrackedGeometry(
      rect: Rect.lerp(rect, other.rect, t)!,
      isVisible: t < 0.5 ? isVisible : other.isVisible,
    );
  }
}
```

### GeometryNotifier

```dart
class GeometryNotifier extends ChangeNotifier {
  final Map<Object, TrackedGeometry> _geometries = {};
  final Map<Object, Set<VoidCallback>> _tagListeners = {};

  TrackedGeometry? operator [](Object tag) => _geometries[tag];

  void register(Object tag, TrackedGeometry geometry) {
    if (_geometries[tag] != geometry) {
      _geometries[tag] = geometry;
      _notifyTagListeners(tag);
      notifyListeners();
    }
  }

  void unregister(Object tag) => _geometries.remove(tag);

  void addTagListener(Object tag, VoidCallback callback) {
    _tagListeners.putIfAbsent(tag, () => {}).add(callback);
  }

  void removeTagListener(Object tag, VoidCallback callback) {
    _tagListeners[tag]?.remove(callback);
  }
}
```

### SharedGeometry (scope widget)

Uses `InheritedNotifier` pattern (same as `PointerPositionProvider` in Mix):

```dart
class SharedGeometry extends StatefulWidget {
  final Widget child;

  static GeometryNotifier of(BuildContext context) { ... }
  static GeometryNotifier? maybeOf(BuildContext context) { ... }
}
```

### Source/Target widgets

- Use `GlobalKey` to read `RenderBox` geometry after layout
- **Source**: registers geometry on first frame and rebuilds
- **Target**: reads source geometry, animates from source → own position

---

## V1 Limitations

| Limitation | Reason |
|------------|--------|
| Same-route only | Cross-route requires Navigator integration (use Hero) |
| One-frame delay | Target needs post-layout pass to measure destination |
| No scroll awareness | May glitch if container scrolls during animation |
| Transform-based | Text may appear soft during scale |
| No border-radius morphing | Would need custom painter |

---

## Open Questions

1. **API style**: Widget-based (A), extension-based (B), or style-based (C)?
2. **Naming**: `SharedGeometry`, `MatchedGeometry`, `GeometryMatch`?
3. **Should this be in Mix core or a standalone package?**
4. **Both widgets mounted simultaneously?** Current design assumes one-at-a-time
5. **Is there actual user demand?** Hero covers cross-route; same-route might be niche

---

## Estimated Scope

| Component | LOC |
|-----------|-----|
| `TrackedGeometry` | ~20 |
| `GeometryNotifier` | ~40 |
| `SharedGeometry` | ~50 |
| `Source/Target` | ~100 |
| **Total** | ~210 |

---

## Related

- [SwiftUI matchedGeometryEffect](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:))
- [Flutter Hero widget](https://api.flutter.dev/flutter/widgets/Hero-class.html)
- [Discussion #842](https://github.com/leoafarias/mix/discussions/842) - RFC discussion
- Discussion #809 (symbolEffect - separate feature for icon micro-animations)
