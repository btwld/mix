import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
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
    super.modifiers,
    super.variants,
  });

  /// Access to the internal mutable StyleAttribute
  Style<S> get attribute;

  @override
  S resolve(BuildContext context) => attribute.resolve(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attribute', attribute));
  }

  /// Mutable animation configuration from internal attribute
  @override
  AnimationConfig? get $animation => attribute.$animation;

  /// Mutable modifiers from internal attribute
  @override
  List<ModifierAttribute>? get $modifiers => attribute.$modifiers;

  /// Mutable variants from internal attribute
  @override
  List<VariantStyleAttribute<S>>? get $variants => attribute.$variants;

  @override
  List<Object?> get props => [attribute, $animation, $modifiers, $variants];
}
