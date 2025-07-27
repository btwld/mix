import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/typography/text_style_mix.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'clip_modifier.dart';
import 'default_text_style_modifier.dart';
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'internal/reset_modifier.dart';
import 'intrinsic_modifier.dart';
import 'mouse_cursor_modifier.dart';
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

/// Mixin that provides convenient modifier methods for spec attributes.
///
/// This mixin follows the same pattern as BorderRadiusMixin, providing
/// a fluent API for applying modifiers to spec attributes.
mixin ModifierMixin<T extends StyleAttribute<S>, S extends Spec<S>>
    on StyleAttribute<S> {
  /// Must be implemented by the class using this mixin
  T modifiers(List<ModifierAttribute> modifiers);

  /// Wraps the widget with an opacity modifier
  T wrapOpacity(double opacity) {
    return modifiers([OpacityModifierAttribute.only(opacity: opacity)]);
  }

  /// Wraps the widget with a padding modifier
  T wrapPadding(EdgeInsetsGeometry padding) {
    return modifiers([
      PaddingModifierAttribute.only(
        padding: EdgeInsetsGeometryMix.value(padding),
      ),
    ]);
  }

  /// Wraps the widget with a clip oval modifier
  T wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return modifiers([
      ClipOvalModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a clip rect modifier
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return modifiers([
      ClipRectModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a clip path modifier
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return modifiers([
      ClipPathModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a clip triangle modifier
  T wrapClipTriangle({Clip? clipBehavior}) {
    return modifiers([
      ClipTriangleModifierAttribute.only(clipBehavior: clipBehavior),
    ]);
  }

  /// Wraps the widget with a clip rounded rectangle modifier
  T wrapClipRRect({
    required BorderRadius borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return modifiers([
      ClipRRectModifierAttribute.only(
        borderRadius: BorderRadiusMix.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a visibility modifier
  T wrapVisibility(bool visible) {
    return modifiers([VisibilityModifierAttribute.only(visible: visible)]);
  }

  /// Wraps the widget with an aspect ratio modifier
  T wrapAspectRatio(double aspectRatio) {
    return modifiers([
      AspectRatioModifierAttribute.only(aspectRatio: aspectRatio),
    ]);
  }

  /// Wraps the widget with a flexible modifier
  T wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return modifiers([FlexibleModifierAttribute.only(flex: flex, fit: fit)]);
  }

  /// Wraps the widget with an expanded modifier
  T wrapExpanded({int flex = 1}) {
    return modifiers([
      FlexibleModifierAttribute.only(flex: flex, fit: FlexFit.tight),
    ]);
  }

  /// Wraps the widget with a scale transform modifier
  T wrapScale(double scale, {Alignment alignment = Alignment.center}) {
    return modifiers([
      TransformModifierAttribute.only(
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        alignment: alignment,
      ),
    ]);
  }

  /// Wraps the widget with a rotate transform modifier
  T wrapRotate(double angle, {Alignment alignment = Alignment.center}) {
    return modifiers([
      TransformModifierAttribute.only(
        transform: Matrix4.rotationZ(angle),
        alignment: alignment,
      ),
    ]);
  }

  /// Wraps the widget with a translate transform modifier
  T wrapTranslate({double x = 0, double y = 0}) {
    return modifiers([
      TransformModifierAttribute.only(
        transform: Matrix4.translationValues(x, y, 0),
      ),
    ]);
  }

  /// Wraps the widget with a transform modifier
  T wrapTransform(Matrix4 transform, {Alignment? alignment}) {
    return modifiers([
      TransformModifierAttribute.only(
        transform: transform,
        alignment: alignment,
      ),
    ]);
  }

  /// Wraps the widget with a sized box modifier
  T wrapSizedBox({double? width, double? height}) {
    return modifiers([
      SizedBoxModifierAttribute.only(width: width, height: height),
    ]);
  }

  /// Wraps the widget with constrained box modifier
  T wrapConstrainedBox(BoxConstraints constraints) {
    // Convert BoxConstraints to SizedBox for simplicity
    return modifiers([
      SizedBoxModifierAttribute.only(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    ]);
  }

  /// Wraps the widget with an align modifier
  T wrapAlign(Alignment alignment) {
    return modifiers([AlignModifierAttribute.only(alignment: alignment)]);
  }

  /// Wraps the widget with a center modifier
  T wrapCenter() {
    return modifiers([
      AlignModifierAttribute.only(alignment: Alignment.center),
    ]);
  }

  /// Wraps the widget with a fractionally sized box modifier
  T wrapFractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    Alignment alignment = Alignment.center,
  }) {
    return modifiers([
      FractionallySizedBoxModifierAttribute.only(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    ]);
  }

  /// Wraps the widget with a rotated box modifier
  T wrapRotatedBox(int quarterTurns) {
    return modifiers([
      RotatedBoxModifierAttribute.only(quarterTurns: quarterTurns),
    ]);
  }

  /// Wraps the widget with an intrinsic width modifier
  T wrapIntrinsicWidth() {
    return modifiers([const IntrinsicWidthModifierAttribute()]);
  }

  /// Wraps the widget with an intrinsic height modifier
  T wrapIntrinsicHeight() {
    return modifiers([const IntrinsicHeightModifierAttribute()]);
  }

  /// Wraps the widget with a mouse cursor modifier
  T wrapMouseCursor(MouseCursor cursor) {
    return modifiers([
      MouseCursorDecoratorSpecAttribute.only(mouseCursor: cursor),
    ]);
  }

  /// Wraps the widget with a default text style modifier
  T wrapDefaultTextStyle(TextStyle style) {
    return modifiers([
      DefaultTextStyleModifierAttribute.only(style: TextStyleMix.value(style)),
    ]);
  }
}
