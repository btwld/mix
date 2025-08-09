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
final class StyleProviderModifier<S extends Spec<S>>
    extends Modifier<StyleProviderModifier<S>>
    with Diagnosticable {
  /// The resolved style to provide to descendants
  final ResolvedStyle<S> resolvedStyle;

  const StyleProviderModifier(this.resolvedStyle);

  @override
  StyleProviderModifier<S> copyWith({ResolvedStyle<S>? resolvedStyle}) {
    return StyleProviderModifier(resolvedStyle ?? this.resolvedStyle);
  }

  @override
  StyleProviderModifier<S> lerp(
    StyleProviderModifier<S>? other,
    double t,
  ) {
    if (other == null) return this;
    
    // Use the existing lerp implementation from ResolvedStyle
    return StyleProviderModifier(
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
/// creating a StyleProviderModifier with the resolved style.
///
/// The style is resolved at modifier resolution time, which ensures proper
/// context access for token and variant resolution.
class StyleProviderModifierMix<S extends Spec<S>>
    extends ModifierMix<StyleProviderModifier<S>>
    with Diagnosticable {
  /// The unresolved style that will be resolved during resolve()
  final Style<S> style;

  const StyleProviderModifierMix(this.style);

  @override
  StyleProviderModifier<S> resolve(BuildContext context) {
    // Resolve the style at modifier resolution time
    // This ensures we have proper context for tokens and variants
    final resolvedStyle = style.build(context);
    
    // Note: style.build() always returns a ResolvedStyle object
    // The spec field within it may be null if the style has no attributes
    // This is valid and consumers should handle null specs appropriately
    
    return StyleProviderModifier(resolvedStyle);
  }

  @override
  StyleProviderModifierMix<S> merge(
    covariant StyleProviderModifierMix<S>? other,
  ) {
    if (other == null) return this;

    // Merge the unresolved styles
    return StyleProviderModifierMix(style.merge(other.style));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style));
  }

  @override
  List<Object?> get props => [style];
}
