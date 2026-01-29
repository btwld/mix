# Research: matchedGeometryEffect for Mix

## Summary

This document explores adding SwiftUI-like `matchedGeometryEffect` to Mix for same-route shared element transitions (e.g., thumbnail → full image, card → detail view).

---

## Problem

Animating a widget from one position/size to another on the same screen requires significant boilerplate:

```dart
// Current approach: ~50+ lines of manual setup
class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  final _sourceKey = GlobalKey();
  final _targetKey = GlobalKey();
  late AnimationController _controller;
  Rect? _sourceRect;
  Rect? _targetRect;

  void _expand() {
    // Measure source geometry
    final sourceBox = _sourceKey.currentContext?.findRenderObject() as RenderBox?;
    _sourceRect = sourceBox?.localToGlobal(Offset.zero) & sourceBox!.size;

    setState(() => _isExpanded = true);

    // Wait for layout, measure target, animate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetBox = _targetKey.currentContext?.findRenderObject() as RenderBox?;
      _targetRect = targetBox?.localToGlobal(Offset.zero) & targetBox!.size;
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Complex transform interpolation...
      },
    );
  }
}
```

---

## SwiftUI Reference

SwiftUI's `matchedGeometryEffect` coordinates shared element transitions:

```swift
@Namespace var namespace

// Source
Image("thumbnail")
    .matchedGeometryEffect(id: "photo", in: namespace)

// Target (when expanded)
Image("fullsize")
    .matchedGeometryEffect(id: "photo", in: namespace)
```

Key behaviors:
- Views with same `id` in same `namespace` share geometry
- When one appears and other disappears, transition animates automatically
- Works within the same view hierarchy (same-route)

---

## Flutter Context

**Existing solutions:**
- `Hero`: Cross-route only (requires Navigator push/pop)
- `AnimatedContainer`: Same-route, but only for property changes on a single widget
- `animations` package: Various transitions, but not geometry matching

**Gap:** No declarative same-route geometry matching in Flutter.

---

## Proposed API

### GeometryScope

Provides a namespace for geometry tracking:

```dart
GeometryScope(
  child: MyWidget(),
)
```

### GeometryMatch

Tracks or animates geometry within a scope:

```dart
GeometryMatch(
  id: 'card',           // Unique identifier
  isSource: true,       // true = register geometry, false = animate to it
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOutCubic,
  child: MyCard(),
)
```

### Full Example

```dart
class ExpandableCard extends StatefulWidget {
  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GeometryScope(
      child: GestureDetector(
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: isExpanded
            ? GeometryMatch(
                id: 'card',
                isSource: false,  // Animate FROM source TO here
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: LargeCard(),
              )
            : GeometryMatch(
                id: 'card',
                isSource: true,   // Register this geometry
                child: SmallCard(),
              ),
      ),
    );
  }
}
```

---

## Implementation Approach

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
  final Map<Object, Set<VoidCallback>> _idListeners = {};

  TrackedGeometry? operator [](Object id) => _geometries[id];

  void register(Object id, TrackedGeometry geometry) {
    if (_geometries[id] != geometry) {
      _geometries[id] = geometry;
      _notifyIdListeners(id);
      notifyListeners();
    }
  }

  void unregister(Object id) => _geometries.remove(id);

  void addIdListener(Object id, VoidCallback callback) {
    _idListeners.putIfAbsent(id, () => {}).add(callback);
  }

  void removeIdListener(Object id, VoidCallback callback) {
    _idListeners[id]?.remove(callback);
  }
}
```

### GeometryScope

Uses `InheritedNotifier` pattern (same as `PointerPositionProvider` in Mix):

```dart
class GeometryScope extends StatefulWidget {
  final Widget child;

  static GeometryNotifier of(BuildContext context) { ... }
  static GeometryNotifier? maybeOf(BuildContext context) { ... }
}
```

### GeometryMatch

- Uses `GlobalKey` to read `RenderBox` geometry after layout
- **Source**: registers geometry on first frame and rebuilds
- **Target**: reads source geometry, animates from source → own position

---

## V1 Limitations

| Limitation | Reason |
|------------|--------|
| Same-route only | Cross-route requires Navigator integration (use Hero) |
| One-frame delay | Target needs post-layout pass to measure destination |
| No scroll awareness | May glitch if container scrolls during animation |
| No scale clamping | Extreme size ratios produce extreme transforms |
| Transform-based | Text may appear soft during scale |
| No border-radius morphing | Would need custom painter |
| Uses GlobalKey | Required for RenderBox measurement |

---

## Alternatives

1. **Document Hero patterns** - Explain same-route Hero workarounds
2. **Recommend packages** - Point to `animations` or `flutter_animate`
3. **Don't build it** - Wait for user demand

---

## Open Questions

1. **Should this be in Mix core or a separate package?**
   - It's widget-based, not style-based
   - Doesn't fit Mix's Style → Spec → Widget pattern

2. **API shape**
   - `isSource: bool` vs `role: GeometryRole.source/target`
   - Auto-detection based on widget lifecycle?

3. **Both widgets mounted simultaneously?**
   - Current design: one at a time (if/else pattern)
   - Could support overlay-based flight for simultaneous

4. **Custom flight widgets?**
   - Like Hero's `flightShuttleBuilder`
   - V2 enhancement if needed

---

## Estimated Scope

| Component | LOC |
|-----------|-----|
| `TrackedGeometry` | ~20 |
| `GeometryNotifier` | ~40 |
| `GeometryScope` | ~50 |
| `GeometryMatch` | ~100 |
| **Total** | ~210 |

---

## Related

- [SwiftUI matchedGeometryEffect](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:))
- [Flutter Hero widget](https://api.flutter.dev/flutter/widgets/Hero-class.html)
- Discussion #809 (symbolEffect - separate feature)
