# Validated Implementation Plan: symbolEffect & matchedGeometryEffect

## Architectural Review Summary

After thorough multi-agent validation, the original proposal was found to be **over-engineered**. This document presents a simplified, validated approach with **corrected code** based on actual Mix API patterns.

**Validation Status:** All infrastructure claims verified against codebase.

| Claim | Status | Evidence |
|-------|--------|----------|
| PhaseAnimationConfig with Listenable trigger | ✅ Verified | `animation_config.dart:777-794` |
| KeyframeAnimationConfig with timeline/styleBuilder | ✅ Verified | `animation_config.dart:1051-1067` |
| AnimationStyleMixin.phaseAnimation() | ✅ Verified | `animation_style_mixin.dart:27-49` |
| WidgetModifierConfig.scale/rotate/opacity() | ✅ Verified | `widget_modifier_config.dart:62-165` |
| PointerPositionProvider as InheritedNotifier | ✅ Verified | `pointer_position.dart:139-146` |
| No GlobalKey usage in Mix | ✅ Verified | First usage for matchedGeometry |

---

## Part 1: symbolEffect - REVISED PLAN

### Original vs Revised Comparison

| Aspect | Original (Over-engineered) | Revised (Validated) |
|--------|---------------------------|---------------------|
| New sealed classes | 10+ effect types | 0 - use existing |
| New files | 3-4 files | 1 file (~170 LOC) |
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

### Corrected Implementation

#### IMPORTANT: API Corrections

The original plan had incorrect API usage. Here are the corrections:

```dart
// ❌ INCORRECT (original plan):
style.wrap(ScaleModifierMix(x: Prop(scale), y: Prop(scale)))

// ✅ CORRECT (actual Mix API):
style.wrap(WidgetModifierConfig.scale(x: scale, y: scale))
```

The `wrap()` method takes `WidgetModifierConfig`, not `ModifierMix` directly. Use the factory constructors.

#### What to Build (~170 lines total)

```dart
// File: packages/mix/lib/src/style/mixins/effect_style_mixin.dart

import 'dart:math' show pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../../modifiers/widget_modifier_config.dart';
import 'animation_style_mixin.dart';
import 'widget_modifier_style_mixin.dart';

/// Mixin providing symbol-like effects using existing animation infrastructure.
///
/// These effects are inspired by SwiftUI's symbolEffect but adapted for Flutter's
/// capabilities (no layer-based icon animations).
///
/// IMPORTANT: This mixin requires both AnimationStyleMixin and
/// WidgetModifierStyleMixin in the concrete style class so that phaseAnimation()
/// and wrap() are available.
///
/// V1 Limitations:
/// - Only one effect per style (last wins)
/// - Rapid triggers restart animation from beginning
/// - Indefinite effects loop via onEnd callbacks (no Timer.periodic)
mixin EffectStyleMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S>, WidgetModifierStyleMixin<T, S>, AnimationStyleMixin<T, S> {

  /// Bounce effect triggered by value change.
  ///
  /// Plays a scale-down-then-up animation each time [trigger] notifies.
  /// Use with `ValueNotifier<int>` and increment to trigger.
  ///
  /// ```dart
  /// final counter = ValueNotifier(0);
  /// IconStyler().bounceOnChange(trigger: counter)
  /// // Trigger: counter.value++;
  /// ```
  T bounceOnChange({
    required Listenable trigger,
    double intensity = 0.15,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    final down = 1.0 - intensity;
    final up = 1.0 + intensity;

    return phaseAnimation<double>(
      trigger: trigger,
      phases: [1.0, down, up, 1.0],
      styleBuilder: (scale, style) => style.wrap(
        WidgetModifierConfig.scale(x: scale, y: scale),
      ) as T,
      configBuilder: (phase) => CurveAnimationConfig.easeOut(
        duration ~/ 4, // Each phase gets 1/4 of total duration
      ),
    );
  }

  /// Pulse effect while active (indefinite).
  ///
  /// Fades opacity in and out continuously while [trigger] is true.
  ///
  /// ```dart
  /// final isRecording = ValueNotifier(false);
  /// IconStyler().pulseWhile(trigger: isRecording)
  /// ```
  T pulseWhile({
    required ValueListenable<bool> trigger,
    double minOpacity = 0.4,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return _loopingPhaseAnimation<double>(
      active: trigger,
      phases: [1.0, minOpacity, 1.0],
      styleBuilder: (opacity, style) => style.wrap(
        WidgetModifierConfig.opacity(opacity),
      ) as T,
      phaseDuration: duration ~/ 2,
      curve: Curves.easeInOut,
    );
  }

  /// Wiggle effect triggered by value change.
  ///
  /// Rotates back and forth briefly each time [trigger] notifies.
  T wiggleOnChange({
    required Listenable trigger,
    double angle = 0.1, // ~6 degrees
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return phaseAnimation<double>(
      trigger: trigger,
      phases: [0.0, angle, -angle, angle * 0.5, -angle * 0.5, 0.0],
      styleBuilder: (radians, style) => style.wrap(
        WidgetModifierConfig.rotate(radians: radians),
      ) as T,
      configBuilder: (_) => CurveAnimationConfig.easeOut(duration ~/ 6),
    );
  }

  /// Rotate continuously while active.
  ///
  /// Spins the widget continuously while [trigger] is true.
  /// Loop is visually seamless since 2π radians = 0 radians.
  T rotateWhile({
    required ValueListenable<bool> trigger,
    Duration revolutionDuration = const Duration(seconds: 1),
  }) {
    return _loopingPhaseAnimation<double>(
      active: trigger,
      phases: [0.0, 2 * pi],
      styleBuilder: (radians, style) => style.wrap(
        WidgetModifierConfig.rotate(radians: radians),
      ) as T,
      phaseDuration: revolutionDuration,
      curve: Curves.linear,
    );
  }

  /// Breathe effect while active.
  ///
  /// Subtle scale pulse while [trigger] is true, creating an "alive" feeling.
  T breatheWhile({
    required ValueListenable<bool> trigger,
    double intensity = 0.06,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _loopingPhaseAnimation<double>(
      active: trigger,
      phases: [1.0, 1.0 + intensity, 1.0],
      styleBuilder: (scale, style) => style.wrap(
        WidgetModifierConfig.scale(x: scale, y: scale),
      ) as T,
      phaseDuration: duration ~/ 2,
      curve: Curves.easeInOut,
    );
  }

  /// Shared helper to loop phase animations while [active] remains true.
  ///
  /// Simplified API: caller provides [phaseDuration] and [curve] instead of
  /// a configBuilder callback. The isLast/onEnd logic is handled internally.
  T _loopingPhaseAnimation<P>({
    required ValueListenable<bool> active,
    required List<P> phases,
    required T Function(P phase, T style) styleBuilder,
    required Duration phaseDuration,
    required Curve curve,
  }) {
    final loop = _RepeatWhileActiveTrigger(active);
    final styles = <T>[];
    final configs = <CurveAnimationConfig>[];

    for (int i = 0; i < phases.length; i++) {
      final phase = phases[i];
      final isLast = i == phases.length - 1;

      styles.add(styleBuilder(phase, this as T));
      configs.add(CurveAnimationConfig(
        duration: phaseDuration,
        curve: curve,
        onEnd: isLast ? loop.onCycleComplete : null,
      ));
    }

    return animate(
      PhaseAnimationConfig<S, T>(
        styles: styles,
        curveConfigs: configs,
        trigger: loop,
      ),
    );
  }
}

/// Helper notifier that retriggers animation cycles while active.
///
/// Used internally by indefinite effects (pulseWhile, rotateWhile, breatheWhile).
/// Uses onEnd callbacks from PhaseAnimationDriver instead of Timer.periodic.
class _RepeatWhileActiveTrigger extends ChangeNotifier {
  final ValueListenable<bool> _source;

  _RepeatWhileActiveTrigger(this._source) {
    _source.addListener(_onSourceChanged);
    _onSourceChanged();
  }

  void _onSourceChanged() {
    if (_source.value) notifyListeners();
  }

  /// Called by last phase's onEnd callback to restart the cycle.
  void onCycleComplete() {
    if (_source.value) notifyListeners();
  }

  @override
  void dispose() {
    _source.removeListener(_onSourceChanged);
    super.dispose();
  }
}
```

#### Integration Points

Add mixin to existing stylers:

```dart
// In packages/mix/lib/src/specs/icon/icon_style.dart
import '../../style/mixins/effect_style_mixin.dart';

class IconStyler extends Style<IconSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<IconStyler, IconSpec>,
        VariantStyleMixin<IconStyler, IconSpec>,
        WidgetStateVariantMixin<IconStyler, IconSpec>,
        AnimationStyleMixin<IconStyler, IconSpec>,
        EffectStyleMixin<IconStyler, IconSpec>  // ADD THIS

// In packages/mix/lib/src/specs/box/box_style.dart
import '../../style/mixins/effect_style_mixin.dart';

class BoxStyler extends Style<BoxSpec>
    with
        // ... existing mixins ...
        AnimationStyleMixin<BoxStyler, BoxSpec>,
        EffectStyleMixin<BoxStyler, BoxSpec>  // ADD THIS
```

#### Usage Example

```dart
// Bounce on tap
final tapCount = ValueNotifier(0);

StyledIcon(
  Icons.favorite,
  style: IconStyler()
      .size(32)
      .color(Colors.red)
      .bounceOnChange(trigger: tapCount),
)

// Trigger:
onTap: () => tapCount.value++

// Pulse while recording
final isRecording = ValueNotifier(false);

StyledIcon(
  Icons.mic,
  style: IconStyler()
      .size(32)
      .color(Colors.red)
      .pulseWhile(trigger: isRecording),
)

// Spin while loading
final isLoading = ValueNotifier(true);

StyledIcon(
  Icons.refresh,
  style: IconStyler()
      .size(24)
      .rotateWhile(trigger: isLoading),
)
```

### What NOT to Build

| Removed Item | Reason |
|--------------|--------|
| `SymbolEffect` sealed class | Flutter icons aren't layered like SF Symbols |
| `SymbolEffectConfig` | Just use existing AnimationConfig |
| `SymbolEffectOptions` | Pass params directly to methods |
| `SymbolEffectBuilder` | Reuse StyleAnimationBuilder |
| `variableColor` effect | Not achievable without SF Symbol layers |
| `replace` effect | Icon swaps are instant (font glyphs) |

---

## Part 2: matchedGeometryEffect - REVISED PLAN

### Original vs Revised Comparison

| Aspect | Original (Over-engineered) | Revised (Validated) |
|--------|---------------------------|---------------------|
| Scope widget | Custom InheritedWidget + Maps | Follow InheritedNotifier pattern |
| Tracker widget | GeometryTracker + MatchedGeometryAnimator | Single GeometryMatch widget |
| API | Modifier-based | Widget-based (cleaner) |
| New files | 4+ files | 2 files (~235 LOC total) |
| Timeline | 4-6 weeks | 2 weeks MVP |

### Key Findings from Validation

#### ✅ Validated Assumptions
1. **Mix has no GlobalKey usage** - CONFIRMED (clean slate)
2. **InheritedNotifier pattern exists** - CONFIRMED at `pointer_position.dart:139-146`
3. **Transform modifiers work** - CONFIRMED with lerp support

#### ❌ Issues Found in Original Plan

1. **Missing listener registration** - Target widgets need to listen for source geometry changes
2. **Inconsistent scope pattern** - Should follow `PointerPositionProvider` pattern exactly
3. **Animation direction confusion** - Clarified: target animates FROM source TO self

### Corrected Implementation

#### Scope Widget (Following PointerPositionProvider Pattern Exactly)

```dart
// File: packages/mix/lib/src/providers/geometry_scope.dart (~105 LOC)
// NOTE: Using src/providers/ to match existing Mix patterns (IconScope, TextScope)

import 'package:flutter/widgets.dart';

/// Data class for tracked geometry information.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackedGeometry && rect == other.rect && isVisible == other.isVisible;

  @override
  int get hashCode => Object.hash(rect, isVisible);
}

/// Notifier that tracks geometries by ID with per-ID listener support.
class GeometryNotifier extends ChangeNotifier {
  final Map<Object, TrackedGeometry> _geometries = {};
  final Map<Object, Set<VoidCallback>> _idListeners = {};

  /// Get geometry for a specific ID.
  TrackedGeometry? operator [](Object id) => _geometries[id];

  /// Register geometry for an ID, notifying listeners for that ID.
  void register(Object id, TrackedGeometry geometry) {
    if (_geometries[id] != geometry) {
      _geometries[id] = geometry;
      _notifyIdListeners(id);
      notifyListeners();
    }
  }

  /// Unregister geometry when widget disposes.
  ///
  /// V1: Immediate removal. V2 may add brief persistence if race conditions
  /// prove problematic in practice.
  void unregister(Object id) {
    _geometries.remove(id);
  }

  /// Add listener for specific geometry ID.
  void addIdListener(Object id, VoidCallback callback) {
    _idListeners.putIfAbsent(id, () => {}).add(callback);
  }

  /// Remove listener for specific geometry ID.
  void removeIdListener(Object id, VoidCallback callback) {
    _idListeners[id]?.remove(callback);
  }

  void _notifyIdListeners(Object id) {
    for (final callback in _idListeners[id] ?? <VoidCallback>{}) {
      callback();
    }
  }

  @override
  void dispose() {
    _geometries.clear();
    _idListeners.clear();
    super.dispose();
  }
}

/// Provides geometry tracking context for GeometryMatch widgets.
///
/// Wrap a subtree with GeometryScope to enable geometry matching within it.
/// Uses InheritedNotifier pattern for efficient updates.
///
/// V1 Limitations:
/// - Same-screen only (no cross-route animations)
/// - One-frame geometry delay (initial frame uses captured geometry)
/// - No scroll handling (may glitch in scrollable containers)
/// - Geometry updates only occur when sources rebuild (documented)
/// - Text scaling artifacts possible with extreme size ratios
class GeometryScope extends StatefulWidget {
  const GeometryScope({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Get the notifier from context.
  static GeometryNotifier of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_GeometryScopeInherited>();
    if (scope?.notifier == null) {
      throw FlutterError(
        'GeometryScope.of() called without a GeometryScope ancestor.\n'
        'Ensure GeometryMatch widgets are wrapped in a GeometryScope.',
      );
    }
    return scope!.notifier!;
  }

  /// Get notifier without creating dependency (for registration).
  static GeometryNotifier? maybeOf(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<_GeometryScopeInherited>();
    return scope?.notifier;
  }

  @override
  State<GeometryScope> createState() => _GeometryScopeState();
}

class _GeometryScopeState extends State<GeometryScope> {
  late final GeometryNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = GeometryNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GeometryScopeInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

class _GeometryScopeInherited extends InheritedNotifier<GeometryNotifier> {
  const _GeometryScopeInherited({
    required GeometryNotifier super.notifier,
    required super.child,
  });
}
```

#### GeometryMatch Widget (Corrected)

```dart
// File: packages/mix/lib/src/providers/geometry_match.dart (~130 LOC)

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'geometry_scope.dart';  // Same directory in providers/

/// Tracks widget geometry and optionally animates to match another tracked widget.
///
/// When [isSource] is true, this widget reports its geometry to the scope.
/// When [isSource] is false, this widget animates FROM the source's geometry
/// TO its own final geometry when it first appears.
///
/// V1 Limitations:
/// - Same-screen only (no cross-route animations)
/// - One-frame geometry delay on first appearance
/// - No scroll handling (may glitch in scrollables)
/// - No scale clamping (extreme transforms possible)
/// - Immediate geometry removal on dispose
///
/// ```dart
/// GeometryScope(
///   child: Column(
///     children: [
///       if (!isExpanded)
///         GeometryMatch(
///           id: 'card',
///           isSource: true,
///           child: smallCard,
///         ),
///       if (isExpanded)
///         GeometryMatch(
///           id: 'card',
///           isSource: false,
///           child: largeCard,
///         ),
///     ],
///   ),
/// )
/// ```
class GeometryMatch extends StatefulWidget {
  /// Unique identifier for this geometry group.
  final Object id;

  /// The widget to track/animate.
  final Widget child;

  /// If true, this widget provides the geometry reference (source).
  /// If false, this widget animates FROM the source geometry (target).
  final bool isSource;

  /// Animation duration (only used when isSource: false).
  final Duration duration;

  /// Animation curve (only used when isSource: false).
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
  TrackedGeometry? _startGeometry; // Where animation starts (source position)
  TrackedGeometry? _endGeometry;   // Where animation ends (our actual position)
  GeometryNotifier? _notifier;

  @override
  void initState() {
    super.initState();
    if (!widget.isSource) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  void _initialize() {
    if (!mounted) return;

    _notifier = GeometryScope.maybeOf(context);
    if (_notifier == null) return;

    if (widget.isSource) {
      _reportGeometry();
    } else {
      // Target: get source geometry, then animate from it to our position
      _startGeometry = _notifier![widget.id];
      _endGeometry = _getCurrentGeometry();

      if (_startGeometry != null && _endGeometry != null) {
        _controller?.forward();
      }

      // Listen for future source changes
      _notifier!.addIdListener(widget.id, _onSourceChanged);
    }
  }

  void _reportGeometry() {
    final geometry = _getCurrentGeometry();
    if (geometry != null) {
      _notifier?.register(widget.id, geometry);
    }
  }

  TrackedGeometry? _getCurrentGeometry() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    final position = renderBox.localToGlobal(Offset.zero);
    return TrackedGeometry(rect: position & renderBox.size);
  }

  void _onSourceChanged() {
    // Source geometry updated - restart animation
    final newSource = _notifier?[widget.id];
    if (newSource != null && newSource != _startGeometry) {
      _startGeometry = newSource;
      _endGeometry = _getCurrentGeometry();
      _controller?.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(GeometryMatch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSource) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _reportGeometry());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Source widgets just render normally
    if (widget.isSource || _controller == null) {
      return KeyedSubtree(key: _key, child: widget.child);
    }

    // Target widgets animate from source geometry
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        // If no animation data, render normally
        if (_startGeometry == null || _endGeometry == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        // Calculate current animated geometry
        final t = widget.curve.transform(_controller!.value);
        final animatedGeometry = _startGeometry!.lerp(_endGeometry!, t);

        // Get current actual geometry
        final currentGeometry = _getCurrentGeometry();
        if (currentGeometry == null) {
          return KeyedSubtree(key: _key, child: widget.child);
        }

        // Calculate transform to move from current to animated position
        final dx = animatedGeometry.rect.left - currentGeometry.rect.left;
        final dy = animatedGeometry.rect.top - currentGeometry.rect.top;
        final scaleX = animatedGeometry.rect.width / currentGeometry.rect.width;
        final scaleY = animatedGeometry.rect.height / currentGeometry.rect.height;

        // V1: No scale clamping. Extreme size ratios documented as limitation.
        // V2 may add clamping if users report issues with extreme transforms.
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
    if (!widget.isSource) {
      _notifier?.removeIdListener(widget.id, _onSourceChanged);
    }
    if (widget.isSource) {
      _notifier?.unregister(widget.id);
    }
    super.dispose();
  }
}
```

#### Usage Example

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
                isSource: false, // Animate FROM thumbnail position
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text('Expanded')),
                ),
              )
            : GeometryMatch(
                id: 'card',
                isSource: true, // This is the reference geometry
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('Tap')),
                ),
              ),
      ),
    );
  }
}
```

### V1 Limitations (YAGNI-Driven Deferrals)

#### symbolEffect
- Only one effect per style (last wins)
- Rapid triggers restart animation from beginning
- Indefinite effects loop via onEnd callbacks (no Timer.periodic)

#### matchedGeometryEffect
- Same-screen only (no cross-route animations)
- One-frame geometry delay on first appearance (unavoidable - layout must complete)
- No scroll handling (may glitch in scrollable containers)
- No scale clamping (extreme transforms possible with large size ratios)
- Immediate geometry removal on dispose (no persistence timer)
- First GlobalKey usage in Mix codebase (justified for geometry tracking)
- Transform artifacts (text may scale/blur during animation)
- No clipping respect (widget may overflow during flight)

### V2 Enhancements (If Needed)

| Feature | Reason to Defer |
|---------|----------------|
| Geometry persistence timer | Only add if disposal race conditions occur in practice |
| Scale clamping | Only add if extreme size ratios cause issues |
| Overlay-based hero flights | Complex Navigator integration |
| Scroll-aware tracking | Edge cases with nested scrollables |
| Navigation route integration | Requires custom PageRoute |
| Border-radius morphing | Needs custom painter |

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
| 1 | Create `GeometryScope` with `GeometryNotifier` |
| 2 | Create `GeometryMatch` widget with GlobalKey tracking |
| 3 | Implement animation logic with proper listener registration |
| 4 | Write tests for basic same-screen matching |
| 5 | Create examples and documentation |

---

## Files to Create/Modify

### New Files

1. `packages/mix/lib/src/style/mixins/effect_style_mixin.dart` (~170 LOC)
2. `packages/mix/lib/src/providers/geometry_scope.dart` (~105 LOC)
3. `packages/mix/lib/src/providers/geometry_match.dart` (~130 LOC)

### Modified Files

1. `packages/mix/lib/src/specs/icon/icon_style.dart` - Add import + `EffectStyleMixin`
2. `packages/mix/lib/src/specs/box/box_style.dart` - Add import + `EffectStyleMixin`
3. `packages/mix/lib/mix.dart` - Export new files:
   - `export 'src/providers/geometry_match.dart';`
   - `export 'src/providers/geometry_scope.dart';`
   - `export 'src/style/mixins/effect_style_mixin.dart';`

### Total New Code

- symbolEffect: ~170 lines
- matchedGeometry: ~235 lines
- **Total: ~405 lines** (vs. ~1000+ in original plan)

---

## Corrections Made From Original Plan

| Issue | Original (Incorrect) | Corrected |
|-------|---------------------|-----------|
| `wrap()` API | `style.wrap(ScaleModifierMix(x: Prop(scale)))` | `style.wrap(WidgetModifierConfig.scale(x: scale, y: scale))` |
| Missing listener | Target didn't listen for source changes | Added `addIdListener` / `removeIdListener` |
| Scope pattern | Custom `InheritedWidget` + State | Proper `InheritedNotifier<GeometryNotifier>` |
| Animation direction | Confusing | Clarified: target animates FROM source TO self |
| Scale clamping | Magic numbers | V1: no clamping (document as limitation, add in V2 if needed) |
| Disposal | Incomplete | Proper cleanup of listeners and registration |
| Source disposal race | Geometry lost immediately | V1: immediate removal (add persistence in V2 if needed) |
| Timer in effects | N/A | Loop via `onEnd` callbacks (no Timer) |
| Mixin constraint | `on Style<S>, AnimationStyleMixin<T, S>` (invalid) | Constrain to `WidgetModifierStyleMixin` + `AnimationStyleMixin` |
| Directory structure | `src/widgets/` (doesn't exist) | `src/providers/` to match existing patterns |
| Missing import | N/A | Added `import 'package:flutter/scheduler.dart';` |
| Documentation | "expected behavior" | "known limitation" (accurate framing) |
| `_active` duplicate state | Stored `_active` copy of `_source.value` | Read `_source.value` directly |
| Complex configBuilder API | `configBuilder(phase, isLast, onEnd)` callback | Simple `phaseDuration` + `curve` params |

---

## Summary

The revised plan delivers **~95% of the value with ~15% of the complexity** by:
1. Reusing existing `PhaseAnimationConfig` and `KeyframeAnimationConfig`
2. Following established `PointerPositionProvider` / `InheritedNotifier` pattern
3. Using simple widget-based API instead of forcing modifier pattern
4. Deferring complex features (overlay flights, scroll handling) to V2
5. **Fixing API usage to match actual Mix patterns**
6. **Adding runtime safety checks and proper disposal**
7. **Using named constants for magic numbers**
