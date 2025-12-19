import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../variants/variant.dart';
import '../spec.dart';
import '../style.dart';
import '../style_spec.dart';

/// Internal wrapper that carries pre-applied named variants.
///
/// When [build] is called, the stored variants are passed to the
/// base style's build method for resolution.
class AppliedVariantsStyle<S extends Spec<S>> extends Style<S> {
  final Style<S> _baseStyle;
  final Set<NamedVariant> _appliedVariants;

  const AppliedVariantsStyle(this._baseStyle, this._appliedVariants)
      : super(variants: null, modifier: null, animation: null);

  @override
  List<Object?> get props => [_baseStyle, _appliedVariants];

  @override
  List<VariantStyle<S>>? get $variants => _baseStyle.$variants;

  @override
  WidgetModifierConfig? get $modifier => _baseStyle.$modifier;

  @override
  AnimationConfig? get $animation => _baseStyle.$animation;

  @override
  Set<WidgetState> get widgetStates => _baseStyle.widgetStates;

  @override
  StyleSpec<S> resolve(BuildContext context) => _baseStyle.resolve(context);

  @override
  Style<S> merge(covariant Style<S>? other) {
    if (other == null) return this;

    if (other is AppliedVariantsStyle<S>) {
      return AppliedVariantsStyle(
        _baseStyle.merge(other._baseStyle),
        {..._appliedVariants, ...other._appliedVariants},
      );
    }

    return AppliedVariantsStyle(_baseStyle.merge(other), _appliedVariants);
  }

  @override
  StyleSpec<S> build(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) {
    final combined = {..._appliedVariants, ...namedVariants};

    return _baseStyle.build(context, namedVariants: combined);
  }
}
