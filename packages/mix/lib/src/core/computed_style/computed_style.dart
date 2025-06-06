import 'package:flutter/foundation.dart';

import '../../attributes/animated/animated_data.dart';
import '../factory/mix_data.dart';
import '../modifier.dart';
import '../spec.dart';

/// Resolved specs from a [Style] definition optimized for widget access.
///
/// Represents the final form of a [Style] where all [SpecAttribute]s have been
/// resolved into concrete [Spec] objects. Provides O(1) lookup performance for
/// widgets accessing styling information.
@immutable
class ComputedStyle with Diagnosticable {
  final Map<Type, Spec> _specs;
  final List<WidgetModifierSpec> _modifiers;
  final AnimatedData? _animation;

  const ComputedStyle._({
    required Map<Type, Spec> specs,
    required List<WidgetModifierSpec> modifiers,
    AnimatedData? animation,
  })  : _specs = specs,
        _modifiers = modifiers,
        _animation = animation;

  /// Creates an empty computed style with no specs or modifiers.
  /// This is used for cases where no style is applied.
  const ComputedStyle.empty()
      : _specs = const {},
        _modifiers = const [],
        _animation = null;

  /// Creates a [ComputedStyle] by resolving all [SpecAttribute]s in [mixData].
  ///
  /// Processes the [mixData] and resolves all [SpecAttribute]s into their final
  /// [Spec] objects. The resulting [ComputedStyle] contains:
  ///
  /// - A map of resolved specs indexed by type for O(1) lookup
  /// - A list of widget modifiers to be applied
  /// - Animation data if the style is animated
  ///
  /// This computation is performed once when the style changes, and the
  /// resulting [ComputedStyle] is cached for performance. Widgets can then
  /// selectively depend on specific spec types through [ComputedStyleProvider]
  /// for surgical rebuilds.
  ///
  /// Example:
  /// ```dart
  /// final mixData = MixData.create(context, style);
  /// final computedStyle = ComputedStyle.compute(mixData);
  /// ```
  factory ComputedStyle.compute(MixData mixData) {
    final specs = <Type, Spec>{};
    final modifiers = <WidgetModifierSpec>[];

    // Dynamically resolve ALL SpecAttributes using existing MixData method
    for (final attribute in mixData.whereType<SpecAttribute>()) {
      if (attribute is WidgetModifierSpecAttribute) {
        modifiers.add(attribute.resolve(mixData) as WidgetModifierSpec);
      } else {
        final resolved = attribute.resolve(mixData);
        specs[resolved.runtimeType] = resolved;
      }
    }

    return ComputedStyle._(
      specs: specs,
      modifiers: modifiers,
      animation: mixData.animation,
    );
  }

  /// Widget modifiers to be applied to the styled widget.
  List<WidgetModifierSpec> get modifiers => _modifiers;

  /// Animation configuration for this style.
  AnimatedData? get animation => _animation;

  /// Whether this style contains animation data.
  bool get isAnimated => animation != null;

  /// Unmodifiable view of all registered specs for debugging.
  /// Returns an unmodifiable view of the internal specs map
  @visibleForTesting
  Map<Type, Spec> get debugSpecs => Map.unmodifiable(_specs);

  /// Returns the spec of type [T], or null if not found.
  T? specOf<T extends Spec<T>>() => _specs[T] as T?;

  /// Returns the spec of the given [type], or null if not found.
  ///
  /// Used internally by [ComputedStyleProvider] for type-based lookup.
  Spec? specOfType(Type type) => _specs[type];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComputedStyle &&
        mapEquals(_specs, other._specs) &&
        listEquals(_modifiers, other._modifiers) &&
        _animation == other._animation;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('specs', _specs));
    properties.add(DiagnosticsProperty('modifiers', _modifiers));
    properties.add(DiagnosticsProperty('animation', _animation));
  }

  @override
  int get hashCode => Object.hash(_specs, _modifiers, _animation);
}
