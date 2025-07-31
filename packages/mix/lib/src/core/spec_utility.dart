import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/modifier_config.dart';
import 'spec.dart';
import 'style.dart';

/// Mutable builder for StyleAttribute with cascade notation support.
///
/// Provides mutable internal state where utilities can update the internal
/// StyleAttribute and return the same instance for cascade notation.
abstract class StyleAttributeBuilder<S extends Spec<S>> extends Style<S>
    with Diagnosticable {
  const StyleAttributeBuilder({
    super.animation,
    super.modifierConfig,
    super.variants,
    super.inherit,
  });

  /// Access to the internal mutable StyleAttribute
  @protected
  Style<S> get style;

  @override
  S resolve(BuildContext context) => style.resolve(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attribute', style));
  }

  /// Mutable animation configuration from internal attribute
  @override
  AnimationConfig? get $animation => style.$animation;

  @override
  ModifierConfig? get $modifierConfig => style.$modifierConfig;

  /// Mutable variants from internal attribute
  @override
  List<VariantStyleAttribute<S>>? get $variants => style.$variants;

  @override
  List<Object?> get props => [style];
}

abstract class StyleMutableBuilder<S extends Spec<S>> extends Style<S>
    with Diagnosticable {
  const StyleMutableBuilder({
    super.animation,
    super.modifierConfig,
    super.variants,
    super.inherit,
  });

  /// Access to the internal mutable StyleAttribute
  @protected
  Mutable<S, Style<S>> get mix;

  @override
  S resolve(BuildContext context) => mix.resolve(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attribute', mix));
  }

  /// Mutable animation configuration from internal attribute
  @override
  AnimationConfig? get $animation => mix.$animation;

  @override
  ModifierConfig? get $modifierConfig => mix.$modifierConfig;

  /// Mutable variants from internal attribute
  @override
  List<VariantStyleAttribute<S>>? get $variants => mix.$variants;

  @override
  List<Object?> get props => [mix];
}

mixin Mutable<S extends Spec<S>, T extends Style<S>> on Style<S> {
  T? _accumulated;

  T get accumulated => _accumulated ?? this as T;

  // Intercept merge calls
  @override
  T merge(covariant T? other) {
    if (other == null) return this as T;

    try {
      // Accumulate merges - use super.merge to avoid recursion
      final merged = accumulated == this 
          ? super.merge(other) 
          : accumulated.merge(other);
      
      _accumulated = merged as T;

      // Return this for chaining
      return this as T;
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
  S resolve(BuildContext context) {
    return accumulated.resolve(context);
  }
}
