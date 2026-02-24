import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// Modifier that applies opacity to its child.
///
/// Wraps the child in an [Opacity] widget with the specified opacity value.
final class OpacityModifier extends WidgetModifier<OpacityModifier>
    with Diagnosticable {
  /// Opacity value between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;

  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity ?? this.opacity);
  }

  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    if (other == null) return this;

    return OpacityModifier(MixOps.lerp(opacity, other.opacity, t)!);
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

/// Mix class for applying opacity modifications.
///
/// This class allows for mixing and resolving opacity properties.
class OpacityModifierMix extends ModifierMix<OpacityModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityModifierMix.create({this.opacity});

  OpacityModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  @override
  OpacityModifier resolve(BuildContext context) {
    return OpacityModifier(MixOps.resolve(context, opacity));
  }

  @override
  OpacityModifierMix merge(OpacityModifierMix? other) {
    if (other == null) return this;

    return OpacityModifierMix.create(
      opacity: MixOps.merge(opacity, other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity));
  }

  @override
  List<Object?> get props => [opacity];
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
