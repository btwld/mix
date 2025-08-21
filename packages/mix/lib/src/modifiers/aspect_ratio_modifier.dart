import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// Modifier that constrains its child to a specific aspect ratio.
///
/// Wraps the child in an [AspectRatio] widget with the specified ratio.
final class AspectRatioModifier extends Modifier<AspectRatioModifier>
    with Diagnosticable {
  final double aspectRatio;

  const AspectRatioModifier([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  @override
  AspectRatioModifier copyWith({double? aspectRatio}) {
    return AspectRatioModifier(aspectRatio ?? this.aspectRatio);
  }

  @override
  AspectRatioModifier lerp(AspectRatioModifier? other, double t) {
    if (other == null) return this;

    return AspectRatioModifier(MixOps.lerp(aspectRatio, other.aspectRatio, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('aspectRatio', aspectRatio));
  }

  @override
  List<Object?> get props => [aspectRatio];

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Mix class for applying aspect ratio modifications.
///
/// This class allows for mixing and resolving aspect ratio properties.
class AspectRatioModifierMix extends ModifierMix<AspectRatioModifier>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioModifierMix.create({this.aspectRatio});

  AspectRatioModifierMix({double? aspectRatio})
    : this.create(aspectRatio: Prop.maybe(aspectRatio));

  @override
  AspectRatioModifier resolve(BuildContext context) {
    return AspectRatioModifier(aspectRatio?.resolveProp(context));
  }

  @override
  AspectRatioModifierMix merge(AspectRatioModifierMix? other) {
    if (other == null) return this;

    return AspectRatioModifierMix.create(
      aspectRatio: MixOps.merge(aspectRatio, other.aspectRatio),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('aspectRatio', aspectRatio));
  }

  @override
  List<Object?> get props => [aspectRatio];
}

/// Utility class for applying aspect ratio modifications.
///
/// Provides convenient methods for creating AspectRatioModifierMix instances.
final class AspectRatioModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AspectRatioModifierMix> {
  const AspectRatioModifierUtility(super.builder);

  T call(double value) {
    return builder(
      AspectRatioModifierMix.create(aspectRatio: Prop.value(value)),
    );
  }

  T token(MixToken<double> token) {
    return builder(
      AspectRatioModifierMix.create(aspectRatio: Prop.token(token)),
    );
  }
}
