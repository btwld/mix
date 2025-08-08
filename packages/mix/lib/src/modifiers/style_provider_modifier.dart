import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/providers/resolved_style_provider.dart';
import '../core/spec.dart';
import '../core/style.dart';

/// A modifier that provides a ResolvedStyle<S> to descendant widgets.
///
/// This modifier wraps its child with a ResolvedStyleProvider, making the
/// resolved style available to all descendants via ResolvedStyleProvider.of<S>(context).
///
/// Note: This provides resolved styles rather than unresolved ones, which enables
/// proper interpolation for animations while still supporting style inheritance.
final class StyleProviderWidgetModifier<S extends Spec<S>>
    extends Modifier<StyleProviderWidgetModifier<S>>
    with Diagnosticable {
  /// The resolved style to provide to descendants
  final ResolvedStyle<S> resolvedStyle;

  const StyleProviderWidgetModifier(this.resolvedStyle);

  @override
  StyleProviderWidgetModifier<S> copyWith({ResolvedStyle<S>? resolvedStyle}) {
    return StyleProviderWidgetModifier(resolvedStyle ?? this.resolvedStyle);
  }

  @override
  StyleProviderWidgetModifier<S> lerp(
    StyleProviderWidgetModifier<S>? other,
    double t,
  ) {
    if (other == null) return this;

    // Use the existing lerp implementation from ResolvedStyle
    return StyleProviderWidgetModifier(
      resolvedStyle.lerp(other.resolvedStyle, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('resolvedStyle', resolvedStyle));
  }

  @override
  List<Object?> get props => [resolvedStyle];

  @override
  Widget build(Widget child) {
    return ResolvedStyleProvider<S>(resolvedStyle: resolvedStyle, child: child);
  }
}

/// Mix attribute for StyleProvider.
///
/// This class stores a Style<S> and resolves it during the resolve phase,
/// creating a StyleProviderWidgetModifier with the resolved style.
///
/// The style is resolved at modifier resolution time, which ensures proper
/// context access for token and variant resolution.
class StyleProviderWidgetModifierMix<S extends Spec<S>>
    extends WidgetModifierMix<StyleProviderWidgetModifier<S>>
    with Diagnosticable {
  /// The unresolved style that will be resolved during resolve()
  final Style<S> style;

  const StyleProviderWidgetModifierMix(this.style);

  @override
  StyleProviderWidgetModifier<S> resolve(BuildContext context) {
    // Resolve the style at modifier resolution time
    // This ensures we have proper context for tokens and variants
    final resolvedStyle = style.build(context);

    return StyleProviderWidgetModifier(resolvedStyle);
  }

  @override
  StyleProviderWidgetModifierMix<S> merge(
    covariant StyleProviderWidgetModifierMix<S>? other,
  ) {
    if (other == null) return this;

    // Merge the unresolved styles
    return StyleProviderWidgetModifierMix(style.merge(other.style));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style));
  }

  @override
  List<Object?> get props => [style];
}
