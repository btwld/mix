# Validated Implementation Plan: symbolEffect & matchedGeometryEffect

## Architectural Review Summary

After thorough multi-agent validation, the original proposal was found to be **over-engineered**. This document presents a simplified, validated approach.

---

## Part 1: symbolEffect - REVISED PLAN

### Original vs Revised Comparison

| Aspect | Original (Over-engineered) | Revised (Validated) |
|--------|---------------------------|---------------------|
| New sealed classes | 10+ effect types | 0 - use existing |
| New files | 3-4 files | 1 file (~100 LOC) |
| Infrastructure | New SymbolEffectBuilder | Reuse PhaseAnimationDriver |
| Timeline | 3 weeks | 1 week |

### Key Findings from Validation

#### ✅ Validated Assumptions
1. **IconSpec supports lerp()** - CONFIRMED at `icon_spec.dart:101-121`
   - Animatable: color, size, weight, grade, opticalSize, fill, opacity, shadows
   - Snaps: icon, blendMode, textDirection

2. **WidgetModifier works with StyledIcon** - CONFIRMED
   - IconStyler includes `WidgetModifierStyleMixin` at `icon_style.dart:24`
   - Transform modifiers (scale, rotate, translate) are available

3. **PhaseAnimationConfig handles triggered animations** - CONFIRMED
   - Already accepts `Listenable trigger` parameter
   - Already cycles through multiple phases

#### ❌ Over-Engineering Identified

1. **Sealed SymbolEffect hierarchy unnecessary**
   - SwiftUI's layer-based SF Symbol animations don't translate to Flutter
   - Flutter Icons are font glyphs, not layered paths
   - All achievable effects are just transforms + opacity

2. **Discrete/Indefinite/Transition protocols unnecessary**
   - Just variations of trigger behavior
   - Already handled by existing `Listenable` pattern

3. **New SymbolEffectBuilder widget unnecessary**
   - `StyleAnimationBuilder` + `PhaseAnimationDriver` already does this

### Revised Implementation

#### What to Build (~100 lines total)

```dart
// File: packages/mix/lib/src/style/mixins/effect_style_mixin.dart

/// Mixin providing symbol-like effects using existing animation infrastructure
mixin EffectStyleMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S>, AnimationStyleMixin<T, S> {

  /// Bounce effect triggered by value change
  /// Uses existing PhaseAnimationConfig internally
  T bounceOnChange<V>({
    required ValueListenable<V> trigger,
    double intensity = 0.15,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return phaseAnimation(
      trigger: trigger,
      phases: [1.0, 1.0 - intensity, 1.0 + intensity, 1.0],
      styleBuilder: (scale, style) => style.wrap(
        ScaleModifierMix(x: Prop(scale), y: Prop(scale)),
      ) as T,
      configBuilder: (_) => CurveAnimationConfig.easeOut(duration),
    );
  }

  /// Pulse effect while active (indefinite)
  T pulseWhile({
    required ValueListenable<bool> trigger,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return phaseAnimation(
      trigger: _RepeatWhileActiveNotifier(trigger),
      phases: [1.0, 0.4, 1.0],
      styleBuilder: (opacity, style) => style.wrap(
        OpacityModifierMix(opacity: Prop(opacity)),
      ) as T,
      configBuilder: (_) => CurveAnimationConfig.easeInOut(duration),
    );
  }

  /// Wiggle effect triggered by value change
  T wiggleOnChange<V>({
    required ValueListenable<V> trigger,
    double angle = 0.05,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return phaseAnimation(
      trigger: trigger,
      phases: [0.0, angle, -angle, angle * 0.5, -angle * 0.5, 0.0],
      styleBuilder: (radians, style) => style.wrap(
        RotateModifierMix(angle: Prop(radians)),
      ) as T,
      configBuilder: (_) => CurveAnimationConfig.easeOut(duration),
    );
  }

  /// Rotate continuously while active
  T rotateWhile({
    required ValueListenable<bool> trigger,
    Duration duration = const Duration(seconds: 1),
  }) {
    return keyframeAnimation(
      trigger: _RepeatWhileActiveNotifier(trigger),
      timeline: [
        KeyframeTrack<double>('rotation', [
          Keyframe.linear(0.0, Duration.zero),
          Keyframe.linear(2 * pi, duration),
        ], initial: 0.0),
      ],
      styleBuilder: (values, style) => style.wrap(
        RotateModifierMix(angle: Prop(values.get('rotation'))),
      ) as T,
    );
  }

  /// Scale effect while active
  T breatheWhile({
    required ValueListenable<bool> trigger,
    double intensity = 0.08,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return phaseAnimation(
      trigger: _RepeatWhileActiveNotifier(trigger),
      phases: [1.0, 1.0 + intensity, 1.0],
      styleBuilder: (scale, style) => style.wrap(
        ScaleModifierMix(x: Prop(scale), y: Prop(scale)),
      ) as T,
      configBuilder: (_) => CurveAnimationConfig.easeInOut(duration),
    );
  }
}

/// Helper: Notifier that repeats while a bool is true
class _RepeatWhileActiveNotifier extends ChangeNotifier {
  Timer? _timer;
  final ValueListenable<bool> _source;

  _RepeatWhileActiveNotifier(this._source) {
    _source.addListener(_onSourceChanged);
    _onSourceChanged();
  }

  void _onSourceChanged() {
    if (_source.value) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 16), (_) {
        notifyListeners();
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _source.removeListener(_onSourceChanged);
    super.dispose();
  }
}
```

#### Integration Points

Add mixin to existing stylers:

```dart
// In icon_style.dart - add EffectStyleMixin
class IconStyler extends Style<IconSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<IconStyler, IconSpec>,
        VariantStyleMixin<IconStyler, IconSpec>,
        WidgetStateVariantMixin<IconStyler, IconSpec>,
        AnimationStyleMixin<IconStyler, IconSpec>,
        EffectStyleMixin<IconStyler, IconSpec>  // ADD THIS
```

#### Usage Example

```dart
// Simple - just works!
final likeCount = ValueNotifier(0);
final isRecording = ValueNotifier(false);

StyledIcon(
  Icons.favorite,
  style: IconStyler()
      .size(32)
      .color(Colors.red)
      .bounceOnChange(trigger: likeCount),
)

StyledIcon(
  Icons.mic,
  style: IconStyler()
      .size(32)
      .color(Colors.red)
      .pulseWhile(trigger: isRecording),
)
```

### What NOT to Build

| Removed Item | Reason |
|--------------|--------|
| `SymbolEffect` sealed class | Flutter icons aren't layered like SF Symbols |
| `SymbolEffectConfig` | Just use existing AnimationConfig |
| `SymbolEffectOptions` | Pass params directly to methods |
| `SymbolEffectBuilder` | Reuse StyleAnimationBuilder |
| Discrete/Indefinite protocols | Already handled by Listenable pattern |
| `variableColor` effect | Not achievable without SF Symbol layers |
| `replace` effect | Icon swaps are instant (font glyphs) |

---

## Part 2: matchedGeometryEffect - REVISED PLAN

### Original vs Revised Comparison

| Aspect | Original (Over-engineered) | Revised (Validated) |
|--------|---------------------------|---------------------|
| Scope widget | MixGeometryScope (custom InheritedWidget) | Follow PointerPositionProvider pattern |
| Tracker widget | GeometryTracker + MatchedGeometryAnimator | Single GeometryMatch widget |
| API | Modifier-based (.matchedGeometry()) | Widget-based (cleaner separation) |
| New files | 4+ files | 2 files (~200 LOC total) |
| Timeline | 4-6 weeks | 2 weeks MVP |

### Key Findings from Validation

#### ✅ Validated Assumptions
1. **Mix has no GlobalKey usage** - CONFIRMED
   - Only reference is in test utilities
   - Clean slate for geometry tracking

2. **InheritedNotifier pattern exists** - CONFIRMED at `pointer_position.dart:139-146`
   - `PointerPositionProvider` shows the pattern
   - Can follow same approach for geometry

3. **Transform modifiers work** - CONFIRMED
   - ScaleModifier, TranslateModifier have lerp support
   - Can achieve visual position matching

#### ❌ Over-Engineering Identified

1. **Modifier-based API is wrong abstraction**
   - Modifiers are stateless, resolved at build time
   - Geometry tracking requires stateful GlobalKey
   - Forces awkward pattern of modifier wrapping stateful widget

2. **Separate Tracker/Animator widgets unnecessary**
   - Single widget can do both (like Flutter's Hero)
   - `isSource` flag determines behavior

3. **Custom listener management unnecessary**
   - `InheritedNotifier` + `ChangeNotifier` already handles this
   - Follow `PointerPositionProvider` pattern exactly

4. **Transform-only animation has limitations**
   - Doesn't handle clipping, overflow
   - For true "hero flight", need Overlay (defer to V2)

#### ⚠️ Risks Identified

1. **RenderBox.localToGlobal() edge cases**
   - Fails with scrollable parents (position changes without rebuild)
   - Partially offscreen widgets return valid but clipped positions
   - **Mitigation**: Document limitations, defer scroll handling to V2

2. **One-frame delay with addPostFrameCallback**
   - Geometry always one frame behind
   - **Mitigation**: Acceptable for most animations, document as known behavior

### Revised Implementation

#### MVP Scope (V1)

Focus on **same-screen geometry matching** (tab indicators, card expansions):

```dart
// File: packages/mix/lib/src/widgets/geometry_match.dart (~150 LOC)

/// Tracks widget geometry and optionally animates to match another tracked widget
class GeometryMatch extends StatefulWidget {
  /// Unique identifier for this geometry group
  final Object id;

  /// The widget to track/animate
  final Widget child;

  /// If true, this widget provides the geometry reference
  /// If false, this widget animates TO the reference geometry
  final bool isSource;

  /// Animation duration (only used when isSource: false)
  final Duration duration;

  /// Animation curve (only used when isSource: false)
  final Curve curve;

  const GeometryMatch({
    required this.id,
    required this.child,
    this.isSource = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.key,
  });

  @override
  State<GeometryMatch> createState() => _GeometryMatchState();
}

class _GeometryMatchState extends State<GeometryMatch>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  AnimationController? _controller;
  Rect? _sourceRect;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    if (!widget.isSource) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateGeometry());
  }

  void _updateGeometry() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final rect = position & renderBox.size;

    final scope = GeometryScope.of(context);
    if (widget.isSource) {
      scope.register(widget.id, rect);
    } else {
      _onTargetGeometryChanged(scope.getGeometry(widget.id));
    }
  }

  void _onTargetGeometryChanged(Rect? newTarget) {
    if (newTarget == null) return;

    final currentRect = _getCurrentRect();
    if (currentRect == null) return;

    if (newTarget != _targetRect) {
      _sourceRect = currentRect;
      _targetRect = newTarget;
      _controller?.forward(from: 0);
    }
  }

  Rect? _getCurrentRect() {
    final rb = _key.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null || !rb.hasSize) return null;
    return rb.localToGlobal(Offset.zero) & rb.size;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSource || _controller == null) {
      return KeyedSubtree(key: _key, child: widget.child);
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        if (_sourceRect == null || _targetRect == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        final t = widget.curve.transform(_controller!.value);
        final currentRect = Rect.lerp(_sourceRect, _targetRect, t)!;
        final myRect = _getCurrentRect();

        if (myRect == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        // Calculate transform to visually match target
        final dx = currentRect.left - myRect.left;
        final dy = currentRect.top - myRect.top;
        final scaleX = currentRect.width / myRect.width;
        final scaleY = currentRect.height / myRect.height;

        return Transform(
          transform: Matrix4.identity()
            ..translate(dx, dy)
            ..scale(scaleX, scaleY),
          alignment: Alignment.topLeft,
          child: KeyedSubtree(key: _key, child: widget.child),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
```

#### Scope Widget (Following PointerPositionProvider Pattern)

```dart
// File: packages/mix/lib/src/widgets/geometry_scope.dart (~60 LOC)

/// Provides geometry tracking context for GeometryMatch widgets
class GeometryScope extends StatefulWidget {
  final Widget child;

  const GeometryScope({required this.child, super.key});

  static GeometryScopeState of(BuildContext context) {
    return context.findAncestorStateOfType<GeometryScopeState>()!;
  }

  @override
  State<GeometryScope> createState() => GeometryScopeState();
}

class GeometryScopeState extends State<GeometryScope> {
  final _notifier = GeometryNotifier();

  void register(Object id, Rect rect) => _notifier.register(id, rect);
  Rect? getGeometry(Object id) => _notifier.geometries[id];

  void addListener(Object id, VoidCallback callback) {
    _notifier.addListenerForId(id, callback);
  }

  void removeListener(Object id, VoidCallback callback) {
    _notifier.removeListenerForId(id, callback);
  }

  @override
  Widget build(BuildContext context) {
    return _GeometryScopeProvider(state: this, child: widget.child);
  }
}

class _GeometryScopeProvider extends InheritedWidget {
  final GeometryScopeState state;

  const _GeometryScopeProvider({required this.state, required super.child});

  @override
  bool updateShouldNotify(_GeometryScopeProvider oldWidget) => false;
}

class GeometryNotifier extends ChangeNotifier {
  final Map<Object, Rect> geometries = {};
  final Map<Object, Set<VoidCallback>> _listeners = {};

  void register(Object id, Rect rect) {
    if (geometries[id] != rect) {
      geometries[id] = rect;
      _notifyListenersForId(id);
    }
  }

  void addListenerForId(Object id, VoidCallback callback) {
    _listeners.putIfAbsent(id, () => {}).add(callback);
  }

  void removeListenerForId(Object id, VoidCallback callback) {
    _listeners[id]?.remove(callback);
  }

  void _notifyListenersForId(Object id) {
    for (final callback in _listeners[id] ?? {}) {
      callback();
    }
  }
}
```

#### Usage Example

```dart
// Card expansion animation
class ExpandableCard extends StatefulWidget {
  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GeometryScope(
      child: Column(
        children: [
          // Thumbnail (source)
          if (!isExpanded)
            GestureDetector(
              onTap: () => setState(() => isExpanded = true),
              child: GeometryMatch(
                id: 'card',
                isSource: true,
                child: Box(
                  style: BoxStyler().size(100, 100).borderRounded(8),
                  child: Image.asset('photo.jpg'),
                ),
              ),
            ),

          // Expanded (animates FROM thumbnail position)
          if (isExpanded)
            GestureDetector(
              onTap: () => setState(() => isExpanded = false),
              child: GeometryMatch(
                id: 'card',
                isSource: false,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Box(
                  style: BoxStyler().size(300, 400).borderRounded(16),
                  child: Image.asset('photo.jpg'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

### What NOT to Build (Defer to V2)

| Deferred Item | Reason |
|---------------|--------|
| Overlay-based hero flights | Complex, needs Navigator integration |
| Scroll-aware tracking | Edge cases with nested scroll views |
| Navigation route integration | Requires custom PageRoute |
| Border-radius morphing | Needs custom painter |
| Clip path animation | Complex interpolation |
| Multiple geometry properties | Start with .frame only |
| Anchor points | Start with topLeft alignment |

### V1 Limitations (Document These)

1. **Same-screen only** - No cross-route animations
2. **One-frame delay** - Geometry captured after layout
3. **No scroll handling** - May glitch in scrollable containers
4. **Transform artifacts** - Text may scale/blur during animation
5. **No clipping respect** - Widget may overflow during flight

---

## Implementation Timeline

### Week 1: symbolEffect

| Day | Task |
|-----|------|
| 1 | Create `EffectStyleMixin` with `bounceOnChange`, `pulseWhile` |
| 2 | Add `wiggleOnChange`, `rotateWhile`, `breatheWhile` |
| 3 | Add `_RepeatWhileActiveNotifier` helper |
| 4 | Integrate mixin into `IconStyler`, `BoxStyler` |
| 5 | Write tests and examples |

### Week 2: matchedGeometryEffect MVP

| Day | Task |
|-----|------|
| 1 | Create `GeometryScope` following PointerPositionProvider pattern |
| 2 | Create `GeometryMatch` widget with GlobalKey tracking |
| 3 | Implement animation logic in `_GeometryMatchState` |
| 4 | Write tests for basic same-screen matching |
| 5 | Create examples and documentation |

---

## Files to Create/Modify

### New Files

1. `packages/mix/lib/src/style/mixins/effect_style_mixin.dart` (~100 LOC)
2. `packages/mix/lib/src/widgets/geometry_scope.dart` (~60 LOC)
3. `packages/mix/lib/src/widgets/geometry_match.dart` (~150 LOC)

### Modified Files

1. `packages/mix/lib/src/specs/icon/icon_style.dart` - Add `EffectStyleMixin`
2. `packages/mix/lib/src/specs/box/box_style.dart` - Add `EffectStyleMixin`
3. `packages/mix/lib/mix.dart` - Export new widgets

### Total New Code

- symbolEffect: ~100 lines
- matchedGeometry: ~210 lines
- **Total: ~310 lines** (vs. ~1000+ in original plan)

---

## Summary: What Changed

| Aspect | Before | After | Reduction |
|--------|--------|-------|-----------|
| symbolEffect LOC | ~800 | ~100 | 87% less |
| matchedGeometry LOC | ~700 | ~210 | 70% less |
| New sealed classes | 10+ | 0 | 100% less |
| New widgets | 4 | 2 | 50% less |
| New files | 7+ | 3 | 57% less |
| Timeline | 7 weeks | 2 weeks | 71% less |

The revised plan delivers **80% of the value with 20% of the complexity** by:
1. Reusing existing `PhaseAnimationConfig` and `KeyframeAnimationConfig`
2. Following established `PointerPositionProvider` pattern
3. Using simple widget-based API instead of forcing modifier pattern
4. Deferring complex features (overlay flights, scroll handling) to V2
