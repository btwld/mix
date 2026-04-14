import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

part 'opacity_modifier.g.dart';

/// Modifier that applies opacity to its child.
///
/// Wraps the child in an [Opacity] widget with the specified opacity value.
@MixableModifier()
final class OpacityModifier extends WidgetModifier<OpacityModifier>
    with Diagnosticable {
  /// Opacity value between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityModifier({double? opacity}) : opacity = opacity ?? 1.0;

  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity: opacity ?? this.opacity);
  }

  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    if (other == null) return this;

    return OpacityModifier(opacity: MixOps.lerp(opacity, other.opacity, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('opacity', opacity));
  }

  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Utility class for applying opacity modifications.
///
/// Provides convenient methods for creating OpacityModifierMix instances.
final class OpacityModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, OpacityModifierMix> {
  const OpacityModifierUtility(super.utilityBuilder);

  T call(double value) =>
      utilityBuilder(OpacityModifierMix.create(opacity: Prop.value(value)));

  T token(MixToken<double> token) =>
      utilityBuilder(OpacityModifierMix.create(opacity: Prop.token(token)));
}
