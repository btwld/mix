# Deep Research: matchedGeometryEffect & symbolEffect for Mix

## Executive Summary

This document provides a thorough technical analysis of SwiftUI's `matchedGeometryEffect` and `symbolEffect` features, evaluates their feasibility for implementation in Mix, and proposes concrete implementation strategies.

**Verdict:**
- **symbolEffect**: ✅ **Highly Feasible** - Can be implemented with existing infrastructure
- **matchedGeometryEffect**: ✅ **Feasible** - Requires new geometry tracking infrastructure

---

## Part 1: symbolEffect (Icon Animation System)

### 1.1 SwiftUI Technical Analysis

SwiftUI's `symbolEffect` provides declarative icon animations through three behavior protocols:

#### Effect Types & Behaviors

| Effect | Discrete | Indefinite | Transition | Purpose |
|--------|----------|------------|------------|---------|
| **bounce** | ✅ | - | - | Signal action completion |
| **pulse** | - | ✅ | - | Ongoing processes (recording) |
| **scale** | - | ✅ | - | Highlight/state indication |
| **wiggle** | ✅ | ✅ | - | Interactive hints |
| **rotate** | ✅ | ✅ | - | Loading/processing |
| **breathe** | - | ✅ | - | Active/alive states |
| **variableColor** | ✅ | ✅ | - | Changing states (signal) |
| **appear/disappear** | - | ✅ | ✅ | Show/hide symbols |
| **replace** | - | - | ✅ | Function changes (play→pause) |

#### Trigger Mechanisms

```swift
// 1. Discrete - triggered by value change
Image(systemName: "heart.fill")
    .symbolEffect(.bounce, value: likeCount)

// 2. Indefinite - continuous while active
Image(systemName: "mic.fill")
    .symbolEffect(.pulse, isActive: isRecording)

// 3. Transition - icon replacement
Image(systemName: isPlaying ? "pause" : "play")
    .contentTransition(.symbolEffect(.replace))
```

#### Configuration Options
- `.speed(Double)` - Animation speed multiplier
- `.repeat(Int)` - Repetition count for discrete effects
- `.repeatForever` - Infinite repetition
- `.iterative` / `.cumulative` - Variable color progression mode
- `.reversing` - Reverse direction

### 1.2 Mix Implementation Strategy

#### 1.2.1 Core Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    IconStyler API                        │
│  .symbolEffect(.bounce, value: count)                   │
│  .symbolEffect(.pulse, isActive: recording)             │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│              SymbolEffectConfig (sealed class)          │
│  - DiscreteSymbolEffect                                 │
│  - IndefiniteSymbolEffect                               │
│  - TransitionSymbolEffect                               │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│              IconSpec + SymbolEffectSpec                │
│  (stored in StyleSpec metadata or IconSpec extension)   │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│          SymbolEffectBuilder (StatefulWidget)           │
│  - Wraps StyledIcon with animation controllers          │
│  - Manages effect lifecycle                             │
│  - Triggers animations based on value/isActive          │
└─────────────────────────────────────────────────────────┘
```

#### 1.2.2 Proposed API

```dart
// File: packages/mix/lib/src/animation/symbol_effect.dart

/// Sealed class for symbol effect types
sealed class SymbolEffect {
  const SymbolEffect();

  // Discrete effects (triggered by value change)
  static const bounce = BounceSymbolEffect();
  static const wiggle = WiggleSymbolEffect();
  static const rotate = RotateSymbolEffect();

  // Indefinite effects (continuous while active)
  static const pulse = PulseSymbolEffect();
  static const scale = ScaleSymbolEffect();
  static const breathe = BreatheSymbolEffect();
  static const variableColor = VariableColorSymbolEffect();

  // Transition effects (for icon replacement)
  static const replace = ReplaceSymbolEffect();
  static const appear = AppearSymbolEffect();
  static const disappear = DisappearSymbolEffect();
}

/// Effect configuration with options
class SymbolEffectConfig<T> {
  final SymbolEffect effect;
  final SymbolEffectOptions options;
  final T? triggerValue;      // For discrete effects
  final bool? isActive;       // For indefinite effects

  const SymbolEffectConfig({
    required this.effect,
    this.options = const SymbolEffectOptions(),
    this.triggerValue,
    this.isActive,
  });
}

/// Configuration options
class SymbolEffectOptions {
  final double speed;
  final int? repeatCount;
  final bool repeatForever;

  const SymbolEffectOptions({
    this.speed = 1.0,
    this.repeatCount,
    this.repeatForever = false,
  });

  SymbolEffectOptions repeat(int count) => copyWith(repeatCount: count);
  SymbolEffectOptions get forever => copyWith(repeatForever: true);
  SymbolEffectOptions withSpeed(double s) => copyWith(speed: s);
}
```

#### 1.2.3 IconStyler Integration

```dart
// File: packages/mix/lib/src/specs/icon/icon_style.dart (extension)

extension SymbolEffectStyleMixin on IconStyler {
  /// Discrete symbol effect triggered by value change
  IconStyler symbolEffect<T>(
    SymbolEffect effect, {
    required T value,
    SymbolEffectOptions options = const SymbolEffectOptions(),
  }) {
    return _addSymbolEffect(SymbolEffectConfig(
      effect: effect,
      triggerValue: value,
      options: options,
    ));
  }

  /// Indefinite symbol effect active while condition is true
  IconStyler symbolEffectActive(
    SymbolEffect effect, {
    required bool isActive,
    SymbolEffectOptions options = const SymbolEffectOptions(),
  }) {
    return _addSymbolEffect(SymbolEffectConfig(
      effect: effect,
      isActive: isActive,
      options: options,
    ));
  }
}
```

#### 1.2.4 Effect Implementations

```dart
// Bounce Effect - scale down then up with overshoot
class BounceSymbolEffect extends SymbolEffect {
  Widget build(Widget child, AnimationController controller) {
    final animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return ScaleTransition(scale: animation, child: child);
  }
}

// Pulse Effect - opacity fade in/out
class PulseSymbolEffect extends SymbolEffect {
  Widget build(Widget child, AnimationController controller) {
    final animation = Tween<double>(begin: 1.0, end: 0.4)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    return FadeTransition(opacity: animation, child: child);
  }
}

// Wiggle Effect - rotation oscillation
class WiggleSymbolEffect extends SymbolEffect {
  Widget build(Widget child, AnimationController controller) {
    final animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0), weight: 25),
    ]).animate(controller);

    return RotationTransition(turns: animation, child: child);
  }
}

// Breathe Effect - subtle scale pulse
class BreatheSymbolEffect extends SymbolEffect {
  Widget build(Widget child, AnimationController controller) {
    final animation = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    return ScaleTransition(scale: animation, child: child);
  }
}

// Rotate Effect - continuous rotation
class RotateSymbolEffect extends SymbolEffect {
  Widget build(Widget child, AnimationController controller) {
    return RotationTransition(turns: controller, child: child);
  }
}
```

#### 1.2.5 SymbolEffectBuilder Widget

```dart
// File: packages/mix/lib/src/animation/symbol_effect_builder.dart

class SymbolEffectBuilder extends StatefulWidget {
  final Widget child;
  final List<SymbolEffectConfig> effects;

  @override
  State<SymbolEffectBuilder> createState() => _SymbolEffectBuilderState();
}

class _SymbolEffectBuilderState extends State<SymbolEffectBuilder>
    with TickerProviderStateMixin {
  final Map<SymbolEffect, AnimationController> _controllers = {};
  final Map<Object?, Object?> _previousTriggerValues = {};

  @override
  void didUpdateWidget(SymbolEffectBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final config in widget.effects) {
      if (config.triggerValue != null) {
        // Discrete effect - check if value changed
        final previous = _previousTriggerValues[config.effect];
        if (previous != config.triggerValue) {
          _triggerDiscreteEffect(config);
          _previousTriggerValues[config.effect] = config.triggerValue;
        }
      } else if (config.isActive != null) {
        // Indefinite effect - start/stop based on isActive
        _updateIndefiniteEffect(config);
      }
    }
  }

  void _triggerDiscreteEffect(SymbolEffectConfig config) {
    final controller = _getController(config);
    controller.forward(from: 0);

    if (config.options.repeatCount != null) {
      // Repeat N times
      controller.repeat(count: config.options.repeatCount!);
    }
  }

  void _updateIndefiniteEffect(SymbolEffectConfig config) {
    final controller = _getController(config);
    if (config.isActive!) {
      controller.repeat(reverse: true);
    } else {
      controller.stop();
      controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    for (final config in widget.effects) {
      final controller = _controllers[config.effect];
      if (controller != null) {
        result = config.effect.build(result, controller);
      }
    }

    return result;
  }
}
```

### 1.3 Integration with Existing Mix Architecture

The symbolEffect system integrates cleanly with Mix's existing architecture:

1. **IconSpec** already supports `lerp()` for size, color, opacity, shadows
2. **StyleAnimationBuilder** handles animation lifecycle
3. **WidgetModifier** pattern can wrap icons with effect builders
4. **Existing animation infrastructure** (CurveAnimationConfig, SpringAnimationConfig) provides timing

**New Files Required:**
- `packages/mix/lib/src/animation/symbol_effect.dart` - Effect definitions
- `packages/mix/lib/src/animation/symbol_effect_builder.dart` - Animation widget
- `packages/mix/lib/src/style/mixins/symbol_effect_style_mixin.dart` - Styler integration

### 1.4 Feasibility Assessment: ✅ HIGHLY FEASIBLE

| Criteria | Assessment |
|----------|------------|
| Infrastructure exists | ✅ Animation system, IconSpec, lerp support |
| API consistency | ✅ Follows existing fluent pattern |
| Complexity | Medium - new widget + effect implementations |
| Breaking changes | None - purely additive |
| Timeline | ~2-3 weeks implementation |

---

## Part 2: matchedGeometryEffect (Shared Element Transitions)

### 2.1 SwiftUI Technical Analysis

#### Core Mechanism

`matchedGeometryEffect` synchronizes geometry (size and/or position) between views during transitions:

```swift
// Define namespace
@Namespace private var animation

// Source view
Image("thumbnail")
    .matchedGeometryEffect(id: "photo", in: animation)

// Destination view (different location in hierarchy)
Image("fullsize")
    .matchedGeometryEffect(id: "photo", in: animation)
```

#### Key Parameters

1. **id** - Unique identifier for the geometry group
2. **namespace** - Prevents ID collisions between view groups
3. **properties** - What to match:
   - `.frame` (default) - Both size and position
   - `.size` - Only dimensions
   - `.position` - Only location
4. **anchor** - The point used for position matching
5. **isSource** - Whether this view defines the geometry (vs. follows it)

#### Two Use Cases

1. **Hero Animations** - One view removed, another inserted simultaneously
   - View A exits, View B enters
   - View B starts at View A's geometry, animates to its final position

2. **Geometry Synchronization** - Multiple concurrent views share geometry
   - Selector indicators
   - Morphing shapes
   - Connected elements

#### Flutter's Hero Widget Comparison

| Feature | SwiftUI matchedGeometryEffect | Flutter Hero |
|---------|-------------------------------|--------------|
| Scope | Any view hierarchy | Navigation routes only |
| Overlay | Not required | Uses Navigator overlay |
| Properties | Size, position, or both | Full widget flight |
| Multiple per screen | ✅ Yes | ⚠️ Complex with tags |
| Non-navigation use | ✅ Yes | ❌ No |

### 2.2 Technical Challenges for Mix

#### Challenge 1: Geometry Tracking Across Widget Tree

Mix currently has **no GlobalKey or RenderBox infrastructure**. We need to track:
- Widget position (global coordinates)
- Widget size
- Widget visibility state

#### Challenge 2: Cross-Widget Communication

SwiftUI's `@Namespace` provides implicit coordination. Flutter requires:
- Shared state management
- Geometry change notifications
- Animation synchronization

#### Challenge 3: Animation Interpolation

Need to interpolate:
- Position (Offset lerp)
- Size (Size lerp)
- Potentially other properties (border radius, color)

### 2.3 Implementation Strategy

#### 2.3.1 Core Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    MixGeometryScope (InheritedWidget)           │
│  - Manages geometry namespace                                    │
│  - Tracks registered geometries by ID                           │
│  - Notifies listeners on geometry changes                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    GeometryTracker (Modifier)                    │
│  - Registers widget with namespace                               │
│  - Reports geometry changes via GlobalKey + RenderBox           │
│  - Listens for matched geometry updates                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    MatchedGeometryAnimator                       │
│  - Interpolates between source and target geometry              │
│  - Applies transform/size to achieve visual match               │
│  - Handles enter/exit transitions                               │
└─────────────────────────────────────────────────────────────────┘
```

#### 2.3.2 MixGeometryScope

```dart
// File: packages/mix/lib/src/animation/matched_geometry/geometry_scope.dart

/// Creates a namespace for matched geometry effects
class MixGeometryScope extends StatefulWidget {
  final Widget child;

  const MixGeometryScope({required this.child, super.key});

  static MixGeometryScopeState of(BuildContext context) {
    return context.findAncestorStateOfType<MixGeometryScopeState>()!;
  }

  @override
  State<MixGeometryScope> createState() => MixGeometryScopeState();
}

class MixGeometryScopeState extends State<MixGeometryScope> {
  final Map<Object, GeometryData> _geometries = {};
  final Map<Object, Set<VoidCallback>> _listeners = {};

  /// Register a widget's geometry
  void registerGeometry(Object id, GeometryData geometry) {
    final previous = _geometries[id];
    _geometries[id] = geometry;

    if (previous != geometry) {
      _notifyListeners(id);
    }
  }

  /// Unregister when widget is disposed
  void unregisterGeometry(Object id) {
    _geometries.remove(id);
  }

  /// Get current geometry for an ID
  GeometryData? getGeometry(Object id) => _geometries[id];

  /// Listen for geometry changes
  void addListener(Object id, VoidCallback callback) {
    _listeners.putIfAbsent(id, () => {}).add(callback);
  }

  void removeListener(Object id, VoidCallback callback) {
    _listeners[id]?.remove(callback);
  }

  void _notifyListeners(Object id) {
    for (final callback in _listeners[id] ?? {}) {
      callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GeometryScopeProvider(state: this, child: widget.child);
  }
}

/// Immutable geometry data
class GeometryData {
  final Offset globalPosition;
  final Size size;
  final bool isVisible;

  const GeometryData({
    required this.globalPosition,
    required this.size,
    this.isVisible = true,
  });

  Rect get rect => globalPosition & size;

  GeometryData lerp(GeometryData other, double t) {
    return GeometryData(
      globalPosition: Offset.lerp(globalPosition, other.globalPosition, t)!,
      size: Size.lerp(size, other.size, t)!,
      isVisible: t < 0.5 ? isVisible : other.isVisible,
    );
  }
}
```

#### 2.3.3 GeometryTracker Widget

```dart
// File: packages/mix/lib/src/animation/matched_geometry/geometry_tracker.dart

/// Tracks and reports widget geometry to the scope
class GeometryTracker extends StatefulWidget {
  final Object id;
  final bool isSource;
  final MatchedGeometryProperties properties;
  final Widget child;

  const GeometryTracker({
    required this.id,
    required this.child,
    this.isSource = true,
    this.properties = MatchedGeometryProperties.frame,
    super.key,
  });

  @override
  State<GeometryTracker> createState() => _GeometryTrackerState();
}

class _GeometryTrackerState extends State<GeometryTracker> {
  final GlobalKey _key = GlobalKey();
  MixGeometryScopeState? _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = MixGeometryScope.of(context);
    _updateGeometry();
  }

  void _updateGeometry() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      _scope?.registerGeometry(
        widget.id,
        GeometryData(globalPosition: position, size: size),
      );
    });
  }

  @override
  void dispose() {
    _scope?.unregisterGeometry(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

enum MatchedGeometryProperties { frame, size, position }
```

#### 2.3.4 MatchedGeometryAnimator

```dart
// File: packages/mix/lib/src/animation/matched_geometry/matched_animator.dart

/// Animates widget to match target geometry
class MatchedGeometryAnimator extends StatefulWidget {
  final Object id;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const MatchedGeometryAnimator({
    required this.id,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.key,
  });

  @override
  State<MatchedGeometryAnimator> createState() => _MatchedGeometryAnimatorState();
}

class _MatchedGeometryAnimatorState extends State<MatchedGeometryAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GeometryData? _sourceGeometry;
  GeometryData? _targetGeometry;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listenToGeometryChanges();
  }

  void _listenToGeometryChanges() {
    final scope = MixGeometryScope.of(context);
    scope.addListener(widget.id, _onGeometryChanged);
  }

  void _onGeometryChanged() {
    final scope = MixGeometryScope.of(context);
    final targetGeometry = scope.getGeometry(widget.id);

    if (targetGeometry != null && targetGeometry != _targetGeometry) {
      _sourceGeometry = _getCurrentGeometry();
      _targetGeometry = targetGeometry;
      _controller.forward(from: 0);
    }
  }

  GeometryData? _getCurrentGeometry() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    return GeometryData(
      globalPosition: renderBox.localToGlobal(Offset.zero),
      size: renderBox.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_sourceGeometry == null || _targetGeometry == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        final t = widget.curve.transform(_controller.value);
        final current = _sourceGeometry!.lerp(_targetGeometry!, t);

        // Calculate transform to match target geometry
        final currentGeo = _getCurrentGeometry();
        if (currentGeo == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        final scaleX = current.size.width / currentGeo.size.width;
        final scaleY = current.size.height / currentGeo.size.height;
        final offsetX = current.globalPosition.dx - currentGeo.globalPosition.dx;
        final offsetY = current.globalPosition.dy - currentGeo.globalPosition.dy;

        return Transform(
          transform: Matrix4.identity()
            ..translate(offsetX, offsetY)
            ..scale(scaleX, scaleY),
          child: KeyedSubtree(key: _key, child: widget.child),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    MixGeometryScope.of(context).removeListener(widget.id, _onGeometryChanged);
    super.dispose();
  }
}
```

#### 2.3.5 Integration with Mix Styler API

```dart
// File: packages/mix/lib/src/style/mixins/matched_geometry_style_mixin.dart

mixin MatchedGeometryStyleMixin<T extends Style<Object?>> on Style<Object?> {
  /// Registers this widget for matched geometry animations
  T matchedGeometry({
    required Object id,
    MixGeometryScope? namespace,
    MatchedGeometryProperties properties = MatchedGeometryProperties.frame,
    bool isSource = true,
  }) {
    return _addModifier(MatchedGeometryModifierMix(
      id: id,
      properties: properties,
      isSource: isSource,
    )) as T;
  }
}

// Modifier implementation
final class MatchedGeometryModifier extends WidgetModifier<MatchedGeometryModifier> {
  final Object id;
  final MatchedGeometryProperties properties;
  final bool isSource;

  const MatchedGeometryModifier({
    required this.id,
    this.properties = MatchedGeometryProperties.frame,
    this.isSource = true,
  });

  @override
  Widget build(Widget child) {
    if (isSource) {
      return GeometryTracker(
        id: id,
        properties: properties,
        isSource: isSource,
        child: child,
      );
    } else {
      return MatchedGeometryAnimator(
        id: id,
        child: GeometryTracker(
          id: id,
          properties: properties,
          isSource: false,
          child: child,
        ),
      );
    }
  }
}
```

#### 2.3.6 Usage Example

```dart
// Wrap app section with geometry scope
MixGeometryScope(
  child: Column(
    children: [
      // Source widget (thumbnail)
      if (!isExpanded)
        Box(
          style: BoxStyler()
              .size(100, 100)
              .matchedGeometry(id: 'card-image', isSource: true),
          child: Image.asset('thumbnail.jpg'),
        ),

      // Target widget (full size)
      if (isExpanded)
        Box(
          style: BoxStyler()
              .size(300, 400)
              .matchedGeometry(id: 'card-image', isSource: false),
          child: Image.asset('thumbnail.jpg'),
        ),
    ],
  ),
)
```

### 2.4 Advanced Considerations

#### 2.4.1 Overlay-Based Hero Flights

For true "hero flight" behavior (widget flies above other content):

```dart
class HeroFlightOverlay extends StatefulWidget {
  // Uses Overlay.of(context) to render flying widget above everything
  // Similar to Flutter's Hero implementation
}
```

#### 2.4.2 Navigation Integration

```dart
// Custom page route with matched geometry support
class MatchedGeometryPageRoute<T> extends PageRoute<T> {
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Coordinate geometry animations with route transition
  }
}
```

#### 2.4.3 Performance Optimizations

1. **Lazy geometry tracking** - Only track when listeners exist
2. **Batched updates** - Use `SchedulerBinding.addPostFrameCallback`
3. **Geometry caching** - Cache until layout changes
4. **Scope isolation** - Separate scopes for independent groups

### 2.5 Feasibility Assessment: ✅ FEASIBLE (with effort)

| Criteria | Assessment |
|----------|------------|
| Infrastructure exists | ⚠️ Partial - needs GlobalKey/RenderBox integration |
| API consistency | ✅ Can follow modifier pattern |
| Complexity | High - cross-widget coordination |
| Breaking changes | None - purely additive |
| Timeline | ~4-6 weeks implementation |

**Key Risks:**
1. Performance with many tracked geometries
2. Edge cases with nested scrolling
3. Complexity of overlay-based flights

---

## Part 3: Implementation Roadmap

### Phase 1: symbolEffect (Weeks 1-3)

**Week 1:**
- [ ] Define `SymbolEffect` sealed class and effect types
- [ ] Implement `SymbolEffectConfig` and `SymbolEffectOptions`
- [ ] Create basic effect implementations (bounce, pulse, wiggle)

**Week 2:**
- [ ] Build `SymbolEffectBuilder` widget with controller management
- [ ] Integrate with `IconStyler` via mixin
- [ ] Implement discrete vs indefinite trigger logic

**Week 3:**
- [ ] Add remaining effects (rotate, breathe, scale, variableColor)
- [ ] Write comprehensive tests
- [ ] Create documentation and examples

### Phase 2: matchedGeometryEffect (Weeks 4-7)

**Week 4:**
- [ ] Implement `MixGeometryScope` with registration system
- [ ] Create `GeometryData` class with lerp support
- [ ] Build basic `GeometryTracker` widget

**Week 5:**
- [ ] Implement `MatchedGeometryAnimator` with interpolation
- [ ] Create `MatchedGeometryModifier` for styler integration
- [ ] Handle source/target coordination

**Week 6:**
- [ ] Add overlay-based hero flights (optional)
- [ ] Integrate with navigation transitions
- [ ] Performance optimization

**Week 7:**
- [ ] Edge case handling (nested scrolling, offscreen widgets)
- [ ] Comprehensive testing
- [ ] Documentation and examples

---

## Part 4: Conclusion

### symbolEffect
**Recommendation: IMPLEMENT**

This feature is highly valuable and relatively straightforward to implement using Mix's existing animation infrastructure. It will provide immediate value for micro-interactions and icon animations with minimal API surface addition.

### matchedGeometryEffect
**Recommendation: IMPLEMENT (with phased approach)**

While more complex, this feature addresses a significant gap in Flutter's declarative animation capabilities. A phased implementation starting with basic geometry synchronization, then adding hero flights, provides manageable milestones.

Both features align with Mix's philosophy of declarative, composable styling and will differentiate the library from alternatives.

---

## References

- [SwiftUI Lab - matchedGeometryEffect Part 1](https://swiftui-lab.com/matchedgeometryeffect-part1/)
- [Augmented Code - SF Symbol Animations](https://augmentedcode.io/2023/08/21/examples-of-animating-sf-symbols-in-swiftui/)
- [Flutter Hero Widget Documentation](https://api.flutter.dev/flutter/widgets/Hero-class.html)
- [Apple WWDC23 - Animate Symbols in Your App](https://developer.apple.com/videos/play/wwdc2023/10258/)
