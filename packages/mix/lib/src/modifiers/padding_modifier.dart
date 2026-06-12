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
@MixableModifier()
final class PaddingModifier with _$PaddingModifier {
  @override
  final EdgeInsetsGeometry padding;

  const PaddingModifier([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}
