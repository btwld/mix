import 'package:flutter/widgets.dart';

import '../attributes/border_radius_mix.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'clip_modifier.dart';
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'internal/reset_modifier.dart';
import 'intrinsic_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

/// Utility class that provides access to all widget modifier utilities.
///
/// This class combines all the individual modifier utilities into a single
/// convenient interface. It's used to create the global `$with` utility.
///
/// Example usage:
/// ```dart
/// Style(
///   $with.opacity(0.5),
///   $with.scale(1.2),
///   $with.rotate(45),
///   $with.visibility(true),
///   $with.aspectRatio(16/9),
/// )
/// ```
final class ModifierUtility<T extends StyleAttribute<Object?>>
    extends MixUtility<T, ModifierAttribute> {
  /// Utility for opacity modifiers
  late final opacity = OpacityModifierUtility<T>(builder);

  /// Utility for transform modifiers (scale, rotate, translate, etc.)
  late final transform = TransformModifierUtility<T>(builder);

  /// Utility for visibility modifiers
  late final visibility = VisibilityModifierUtility<T>(builder);

  /// Utility for aspect ratio modifiers
  late final aspectRatio = AspectRatioModifierUtility<T>(builder);

  /// Utility for align modifiers
  late final align = AlignModifierUtility<T>(builder);

  /// Utility for padding modifiers
  late final padding = PaddingModifierUtility<T>(builder);

  /// Utility for sized box modifiers
  late final sizedBox = SizedBoxModifierUtility<T>(builder);

  /// Utility for flexible modifiers
  late final flexible = FlexibleModifierUtility<T>(builder);

  /// Utility for fractionally sized box modifiers
  late final fractionallySizedBox = FractionallySizedBoxModifierUtility<T>(
    builder,
  );

  /// Utility for rotated box modifiers
  late final rotatedBox = RotatedBoxModifierUtility<T>(builder);

  ModifierUtility(super.builder);

  /// Scales the widget by the given [value].
  ///
  /// A value of 1.0 means no scaling, values greater than 1.0 make the widget larger,
  /// and values less than 1.0 make it smaller.
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  ///
  /// Positive values rotate clockwise, negative values rotate counter-clockwise.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => builder(const IntrinsicWidthModifierAttribute());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => builder(const IntrinsicHeightModifierAttribute());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectModifierAttribute.only(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return builder(
      ClipTriangleModifierAttribute.only(clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Resets all modifiers.
  T reset() => builder(const ResetModifierAttribute());
}
