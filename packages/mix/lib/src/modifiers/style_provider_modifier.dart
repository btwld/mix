import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/providers/widget_spec_provider.dart';
import '../core/style.dart';
import '../core/widget_spec.dart';

/// A modifier that provides a WidgetSpec<S> to descendant widgets.
///
/// This modifier wraps its child with a WidgetSpecProvider, making the
/// resolved spec available to all descendants via WidgetSpecProvider.of<S>(context).
///
/// Note: This provides resolved specs rather than unresolved ones, which enables
/// proper interpolation for animations while still supporting style inheritance.
final class StyleProviderModifier<S extends WidgetSpec<S>>
    extends Modifier<StyleProviderModifier<S>>
    with Diagnosticable {
  /// The resolved spec to provide to descendants
  final S spec;

  const StyleProviderModifier(this.spec);

  @override
  StyleProviderModifier<S> copyWith({S? spec}) {
    return StyleProviderModifier(spec ?? this.spec);
  }

  @override
  StyleProviderModifier<S> lerp(StyleProviderModifier<S>? other, double t) {
    if (other == null) return this;

    // Use the existing lerp implementation from the spec
    return StyleProviderModifier(spec.lerp(other.spec, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spec', spec));
  }

  @override
  List<Object?> get props => [spec];

  @override
  Widget build(Widget child) {
    return WidgetSpecProvider<S>(spec: spec, child: child);
  }
}

/// Mix attribute for StyleProvider.
///
/// This class stores a Style<S> and resolves it during the resolve phase,
/// creating a StyleProviderModifier with the resolved spec.
///
/// The style is resolved at modifier resolution time, which ensures proper
/// context access for token and variant resolution.
class StyleProviderModifierMix<S extends WidgetSpec<S>>
    extends ModifierMix<StyleProviderModifier<S>>
    with Diagnosticable {
  /// The unresolved style that will be resolved during resolve()
  final Style<S> style;

  const StyleProviderModifierMix(this.style);

  @override
  StyleProviderModifier<S> resolve(BuildContext context) {
    // Resolve the style at modifier resolution time
    // This ensures we have proper context for tokens and variants
    final spec = style.build(context);

    // Note: style.build() now returns a spec directly
    // The spec includes animation, modifiers, and inherit metadata

    return StyleProviderModifier(spec);
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
