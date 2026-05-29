import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'align_modifier.g.dart';

/// Modifier that aligns its child within the available space.
///
/// Wraps the child in an [Align] widget with the specified alignment and size factors.
@MixableModifier()
final class AlignModifier extends WidgetModifier<AlignModifier>
    with Diagnosticable, _$AlignModifierMethods {
  @override
  final AlignmentGeometry alignment;
  @override
  final double? widthFactor;
  @override
  final double? heightFactor;

  const AlignModifier({
    AlignmentGeometry? alignment,
    this.widthFactor,
    this.heightFactor,
  }) : alignment = alignment ?? Alignment.center;

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
