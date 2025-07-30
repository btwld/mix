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
  Style<S> get mix;

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
  List<Object?> get props => [mix, $animation, $modifierConfig, $variants];
}
