import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/modifier_config.dart';
import 'spec.dart';
import 'style.dart';
import 'style_spec.dart';

/// Mutable builder for StyleAttribute with cascade notation support.
///
/// Provides mutable internal state where utilities can update the internal
/// StyleAttribute and return the same instance for cascade notation.
abstract class StyleAttributeBuilder<S extends Spec<S>> extends Style<S>
    with Diagnosticable {
  const StyleAttributeBuilder({
    super.animation,
    super.widgetModifier,
    super.variants,
  });

  /// Access to the internal mutable StyleAttribute
  @protected
  Style<S> get style;

  @override
  StyleSpec<S> resolve(BuildContext context) => style.resolve(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attribute', style));
  }

  /// Mutable animation configuration from internal attribute
  @override
  AnimationConfig? get $animation => style.$animation;

  @override
  WidgetModifierConfig? get $widgetModifier => style.$widgetModifier;

  /// Mutable variants from internal attribute
  @override
  List<VariantStyle<S>>? get $variants => style.$variants;

  @override
  List<Object?> get props => [style];
}

/// Mutable builder for Style with accumulation support.
///
/// Provides mutable internal state where utilities can accumulate
/// multiple style operations into a single internal style instance.
abstract class StyleMutableBuilder<S extends Spec<S>> extends Style<S>
    with Diagnosticable {
  const StyleMutableBuilder({super.animation, super.widgetModifier, super.variants});

  /// Internal mutable wrapper
  @protected
  Mutable<S, Style<S>> get mutable;

  /// Access to the actual accumulated style
  @visibleForTesting
  Style<S> get value => mutable.value;

  @override
  StyleSpec<S> resolve(BuildContext context) => value.resolve(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attribute', value));
  }

  /// Mutable animation configuration from internal attribute
  @override
  AnimationConfig? get $animation => value.$animation;

  @override
  WidgetModifierConfig? get $widgetModifier => value.$widgetModifier;

  /// Mutable variants from internal attribute
  @override
  List<VariantStyle<S>>? get $variants => value.$variants;

  @override
  List<Object?> get props => [mutable];
}

/// Mixin that provides mutable behavior for style accumulation.
///
/// Enables styles to accumulate merge operations into an internal value,
/// providing error handling and type safety for merge operations.
mixin Mutable<S extends Spec<S>, T extends Style<S>> on Style<S> {
  late T value;

  // Intercept merge calls
  @override
  T merge(covariant T? other) {
    if (other == null) return this as T;

    try {
      final otherValue = other is Mutable<S, T> ? other.value : other;
      // Accumulate merges - use super.merge to avoid recursion
      value = value.merge(otherValue) as T;

      return value;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        StateError(
          'Failed to merge ${other.runtimeType} with $runtimeType: $e. '
          'This may indicate incompatible types or a bug in the merge implementation.',
        ),
        stackTrace,
      );
    }
  }

  @override
  StyleSpec<S> resolve(BuildContext context) {
    return value.resolve(context);
  }
}
