import 'package:flutter/widgets.dart';

import '../core/style.dart';
import '../core/utility.dart';
import '../properties/painting/border_radius_mix.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'clip_modifier.dart';
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'icon_theme_modifier.dart';
import 'internal/reset_modifier.dart';
import 'intrinsic_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

/// Provides utilities for applying modifiers to styles.
final class ModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, ModifierMix> {
  /// Opacity modifier utility.
  late final opacity = OpacityModifierUtility<T>(utilityBuilder);

  /// Transform modifier utility.
  late final transform = TransformModifierUtility<T>(utilityBuilder);

  /// Visibility modifier utility.
  late final visibility = VisibilityModifierUtility<T>(utilityBuilder);

  /// Aspect ratio modifier utility.
  late final aspectRatio = AspectRatioModifierUtility<T>(utilityBuilder);

  /// Align modifier utility.
  late final align = AlignModifierUtility<T>(utilityBuilder);

  /// Padding modifier utility.
  late final padding = PaddingModifierUtility<T>(utilityBuilder);

  /// Sized box modifier utility.
  late final sizedBox = SizedBoxModifierUtility<T>(utilityBuilder);

  /// Flexible modifier utility.
  late final flexible = FlexibleModifierUtility<T>(utilityBuilder);

  /// Fractionally sized box modifier utility.
  late final fractionallySizedBox = FractionallySizedBoxModifierUtility<T>(
    utilityBuilder,
  );

  /// Rotated box modifier utility.
  late final rotatedBox = RotatedBoxModifierUtility<T>(utilityBuilder);

  /// Icon theme modifier utility.
  late final iconTheme = IconThemeModifierUtility<T>(utilityBuilder);

  ModifierUtility(super.utilityBuilder);

  /// Scales the widget by the given [value].
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => utilityBuilder(const IntrinsicWidthModifierMix());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => utilityBuilder(const IntrinsicHeightModifierMix());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return utilityBuilder(
      ClipOvalModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return utilityBuilder(
      ClipRRectModifierMix(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return utilityBuilder(
      ClipRectModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return utilityBuilder(ClipTriangleModifierMix(clipBehavior: clipBehavior));
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return utilityBuilder(
      ClipPathModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Resets all modifiers.
  T reset() => utilityBuilder(const ResetModifierMix());
}

