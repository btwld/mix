import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

part 'padding_modifier.g.dart';

/// Modifier that adds padding around its child.
///
/// Wraps the child in a [Padding] widget with the specified padding.
@MixableModifier()
final class PaddingModifier extends WidgetModifier<PaddingModifier>
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

/// Utility class for applying padding modifications.
///
/// Provides convenient methods for creating PaddingModifierMix instances.
class PaddingModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, PaddingModifierMix> {
  /// Utility for defining [PaddingModifierMix.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => utilityBuilder(PaddingModifierMix(padding: v)),
  );

  PaddingModifierUtility(super.utilityBuilder);

  T call({EdgeInsetsGeometryMix? padding}) {
    return utilityBuilder(
      PaddingModifierMix.create(padding: Prop.maybeMix(padding)),
    );
  }
}
