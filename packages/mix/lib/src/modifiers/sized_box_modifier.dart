import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

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

/// Utility class for applying sized box modifications.
///
/// Provides convenient methods for creating SizedBoxModifierMix instances.
final class SizedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, SizedBoxModifierMix> {
  const SizedBoxModifierUtility(super.utilityBuilder);

  T width(double v) => only(width: v);

  T height(double v) => only(height: v);

  /// Creates a square-sized box with the same width and height
  T square(double size) => only(width: size, height: size);

  T only({double? width, double? height}) =>
      utilityBuilder(SizedBoxModifierMix(width: width, height: height));

  T call({double? width, double? height}) {
    return only(width: width, height: height);
  }

  /// Utility for defining [SizedBoxModifierMix.width] and [SizedBoxModifierMix.height]
  /// from [Size]
  T as(Size size) => call(width: size.width, height: size.height);
}
