import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';

part 'padding_modifier.g.dart';

/// Modifier that adds padding around its child.
///
/// Wraps the child in a [Padding] widget with the specified padding.
@MixableModifier(lerp: false)
final class PaddingModifier with _$PaddingModifier {
  @override
  final EdgeInsetsGeometry padding;

  const PaddingModifier([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  @override
  PaddingModifier lerp(PaddingModifier? other, double t) {
    final value = MixOps.lerp(padding, other?.padding, t)!;
    if (value.isNonNegative) return PaddingModifier(value);

    // Geometry can contain both physical and directional insets. A physical
    // infinity alone would incorrectly cap start/end at zero.
    final upperBound = const EdgeInsets.all(
      .infinity,
    ).add(const EdgeInsetsDirectional.only(start: .infinity, end: .infinity));

    return PaddingModifier(value.clamp(EdgeInsets.zero, upperBound));
  }

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}
