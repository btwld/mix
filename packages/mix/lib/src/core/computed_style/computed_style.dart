import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../attributes/animation/animation_config.dart';
import '../factory/mix_context.dart';
import '../modifier.dart';
import '../spec.dart';
import 'computed_style_provider.dart';

/// Resolved styling specifications optimized for widget consumption.
///
/// Represents the computed result of a [Style] with all [SpecAttribute]s
/// resolved into concrete [Spec] objects. Provides O(1) spec lookup and
/// selective dependency tracking for optimal rebuild performance.
@immutable
class ComputedStyle with Diagnosticable {
  final Map<Type, Spec> _specs;
  final List<WidgetModifierSpec> _modifiers;
  final AnimationConfig? _animation;

  const ComputedStyle._({
    required Map<Type, Spec> specs,
    required List<WidgetModifierSpec> modifiers,
    AnimationConfig? animation,
  })  : _specs = specs,
        _modifiers = modifiers,
        _animation = animation;

  /// Creates an empty computed style with no specs or modifiers.
  /// This is used for cases where no style is applied.
  const ComputedStyle.empty()
      : _specs = const {},
        _modifiers = const [],
        _animation = null;

  /// Creates a [ComputedStyle] by resolving all styling attributes.
  ///
  /// Resolves [SpecAttribute]s from [mix] into concrete [Spec] objects
  /// for efficient widget access. The computation is performed once when the
  /// style changes, with results cached for performance.
  ///
  /// Example:
  /// ```dart
  /// final computedStyle = ComputedStyle.compute(mixData);
  /// ```
  factory ComputedStyle.compute(MixContext mix) {
    final specs = <Type, Spec>{};
    final modifiers = <WidgetModifierSpec>[];

    // Separate modifiers from regular specs for different processing
    for (final attribute in mix.whereType<SpecAttribute>()) {
      if (attribute is WidgetModifierSpecAttribute) {
        modifiers.add(attribute.resolve(mix) as WidgetModifierSpec);
      } else {
        final resolved = attribute.resolve(mix);
        specs[resolved.runtimeType] = resolved;
      }
    }

    return ComputedStyle._(
      specs: specs,
      modifiers: modifiers,
      animation: mix.animation,
    );
  }

  /// Returns a specific spec type with selective rebuild optimization.
  ///
  /// Widgets calling this method only rebuild when the specific spec type [T]
  /// changes, providing better performance than [of] or [maybeOf].
  static T? specOf<T extends Spec<T>>(BuildContext context) {
    final provider = InheritedModel.inheritFrom<ComputedStyleProvider>(
      context,
      aspect: T, // Only rebuild when T changes
    );

    return provider?.style.getSpec();
  }

  /// Returns the computed style, or null if no provider exists.
  static ComputedStyle? maybeOf(BuildContext context) {
    return InheritedModel.inheritFrom<ComputedStyleProvider>(context)?.style;
  }

  /// Returns the computed style, throwing if no provider exists.
  static ComputedStyle of(BuildContext context) {
    final computedStyle = maybeOf(context);
    assert(computedStyle != null,
        'ComputedStyleProvider not found in widget tree.');

    return computedStyle!;
  }

  /// Widget modifiers to apply during rendering.
  List<WidgetModifierSpec> get modifiers => _modifiers;

  /// Animation configuration, if any.
  AnimationConfig? get animation => _animation;

  /// Whether this style includes animation data.
  bool get isAnimated => animation != null;

  /// Debugging view of all resolved specs.
  @visibleForTesting
  Map<Type, Spec> get debugSpecs => Map.unmodifiable(_specs);

  /// Gets a specific spec by type, or null if not found.
  T? getSpec<T extends Spec<T>>() => _specs[T] as T?;

  /// Gets a spec by runtime type for internal provider use.
  @internal
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
  int get hashCode => Object.hash(
        Object.hashAllUnordered(
          _specs.entries.map((e) => Object.hash(e.key, e.value)),
        ),
        Object.hashAll(_modifiers),
        _animation,
      );
}
