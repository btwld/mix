import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'sized_box_modifier.g.dart';

/// Modifier that constrains its child to a specific size.
///
/// Wraps the child in a [SizedBox] widget with the specified width and height.
@MixableModifier()
final class SizedBoxModifier extends WidgetModifier<SizedBoxModifier>
    with Diagnosticable, _$SizedBoxModifierMethods {
  @override
  final double? width;
  @override
  final double? height;

  const SizedBoxModifier({this.width, this.height});

  @override
  Widget build(Widget child) {
    return SizedBox(width: width, height: height, child: child);
  }
}
