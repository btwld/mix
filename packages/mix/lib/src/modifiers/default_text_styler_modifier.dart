import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/providers/style_provider.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';
import '../specs/text/text_spec.dart';
import '../specs/text/text_style.dart';

/// Modifier that propagates a [TextStyler] to descendant [StyledText] widgets.
///
/// Wraps the child in a [StyleProvider] of [TextSpec] (also known as
/// [DefaultStyledText]) so descendants can merge their own [TextStyler] on top
/// of the inherited one. Unlike [DefaultTextStyleModifier], this preserves the
/// full unresolved [TextStyler] — including variants, modifiers, and merge
/// semantics — rather than a flattened [TextStyle].
final class DefaultTextStylerModifier
    extends WidgetModifier<DefaultTextStylerModifier>
    with Diagnosticable {
  final TextStyler style;

  const DefaultTextStylerModifier([TextStyler? style])
    : style = style ?? const TextStyler.create();

  @override
  DefaultTextStylerModifier copyWith({TextStyler? style}) {
    return DefaultTextStylerModifier(style ?? this.style);
  }

  @override
  DefaultTextStylerModifier lerp(DefaultTextStylerModifier? other, double t) {
    if (other == null) return this;

    return t < 0.5 ? this : other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style));
  }

  @override
  List<Object?> get props => [style];

  @override
  Widget build(Widget child) {
    return StyleProvider<TextSpec>(style: style, child: child);
  }
}

/// Mix class for [DefaultTextStylerModifier].
class DefaultTextStylerModifierMix
    extends ModifierMix<DefaultTextStylerModifier>
    with Diagnosticable {
  final TextStyler style;

  const DefaultTextStylerModifierMix(this.style);

  @override
  DefaultTextStylerModifier resolve(BuildContext context) {
    return DefaultTextStylerModifier(style);
  }

  @override
  DefaultTextStylerModifierMix merge(DefaultTextStylerModifierMix? other) {
    if (other == null) return this;

    return DefaultTextStylerModifierMix(style.merge(other.style));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style));
  }

  @override
  List<Object?> get props => [style];
}
