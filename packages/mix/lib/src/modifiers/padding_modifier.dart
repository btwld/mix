import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

/// Modifier that adds padding around its child.
///
/// Wraps the child in a [Padding] widget with the specified padding.
final class PaddingModifier extends Modifier<PaddingModifier>
    with Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingModifier([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  @override
  PaddingModifier copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingModifier(padding ?? this.padding);
  }

  @override
  PaddingModifier lerp(PaddingModifier? other, double t) {
    if (other == null) return this;

    return PaddingModifier(MixOps.lerp(padding, other.padding, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [padding];

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}

/// Mix class for applying padding modifications.
///
/// This class allows for mixing and resolving padding properties.
class PaddingModifierMix extends ModifierMix<PaddingModifier>
    with Diagnosticable {
  final Prop<EdgeInsetsGeometry>? padding;

  const PaddingModifierMix.create({this.padding});

  PaddingModifierMix({EdgeInsetsGeometryMix? padding})
    : this.create(padding: Prop.maybeMix(padding));

  @override
  PaddingModifier resolve(BuildContext context) {
    return PaddingModifier(MixOps.resolve(context, padding));
  }

  @override
  PaddingModifierMix merge(PaddingModifierMix? other) {
    if (other == null) return this;

    return PaddingModifierMix.create(
      padding: MixOps.merge(padding, other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [padding];
}

/// Utility class for applying padding modifications.
///
/// Provides convenient methods for creating PaddingModifierMix instances.
class PaddingModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, PaddingModifierMix> {
  /// Utility for defining [PaddingModifierMix.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => builder(PaddingModifierMix(padding: v)),
  );

  PaddingModifierUtility(super.builder);

  T call({EdgeInsetsGeometryMix? padding}) {
    return builder(PaddingModifierMix.create(padding: Prop.maybeMix(padding)));
  }
}
