import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'visibility_modifier.g.dart';

/// Modifier that controls the visibility of its child.
///
/// Wraps the child in a [Visibility] widget to show or hide it while maintaining layout space.
@MixableModifier(lerp: false)
final class VisibilityModifier extends WidgetModifier<VisibilityModifier>
    with Diagnosticable, _$VisibilityModifierMethods {
  /// Whether the child widget should be visible.
  @override
  final bool visible;
  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  @override
  VisibilityModifier lerp(VisibilityModifier? other, double t) {
    if (other == null) return this;
    if (visible == other.visible) return this;
    if (t == 0) return this;
    if (t == 1) return other;

    return VisibilityModifier(true);
  }

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}
