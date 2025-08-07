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
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'icon_theme_modifier.dart';
import 'internal/reset_modifier.dart';
import 'intrinsic_modifier.dart';
import 'mouse_cursor_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';
import 'widget_modifier_config.dart';

/// Provides utilities for applying modifiers to styles.
final class WidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, WidgetModifierMix> {
  /// Opacity modifier utility.
  late final opacity = OpacityWidgetModifierUtility<T>(builder);

  /// Transform modifier utility.
  late final transform = TransformWidgetModifierUtility<T>(builder);

  /// Visibility modifier utility.
  late final visibility = VisibilityWidgetModifierUtility<T>(builder);

  /// Aspect ratio modifier utility.
  late final aspectRatio = AspectRatioWidgetModifierUtility<T>(builder);

  /// Align modifier utility.
  late final align = AlignWidgetModifierUtility<T>(builder);

  /// Padding modifier utility.
  late final padding = PaddingWidgetModifierUtility<T>(builder);

  /// Sized box modifier utility.
  late final sizedBox = SizedBoxWidgetModifierUtility<T>(builder);

  /// Flexible modifier utility.
  late final flexible = FlexibleWidgetModifierUtility<T>(builder);

  /// Fractionally sized box modifier utility.
  late final fractionallySizedBox =
      FractionallySizedBoxWidgetModifierUtility<T>(builder);

  /// Rotated box modifier utility.
  late final rotatedBox = RotatedBoxWidgetModifierUtility<T>(builder);

  /// Icon theme modifier utility.
  late final iconTheme = IconThemeWidgetModifierUtility<T>(builder);

  WidgetModifierUtility(super.builder);

  /// Scales the widget by the given [value].
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => builder(const IntrinsicWidthWidgetModifierMix());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => builder(const IntrinsicHeightWidgetModifierMix());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectWidgetModifierMix(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return builder(ClipTriangleWidgetModifierMix(clipBehavior: clipBehavior));
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Resets all modifiers.
  T reset() => builder(const ResetWidgetModifierMix());
}

/// Provides convenient modifier methods for spec attributes.
mixin StyleWidgetModifierMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  /// Applies the given [value] modifier configuration.
  T wrap(WidgetModifierConfig value);

  /// Wraps the widget with an opacity modifier.
  T wrapOpacity(double opacity) {
    return wrap(WidgetModifierConfig.opacity(opacity));
  }

  /// Wraps the widget with a padding modifier.
  T wrapPadding(EdgeInsetsGeometryMix padding) {
    return wrap(WidgetModifierConfig.padding(padding));
  }

  /// Wraps the widget with a clip oval modifier.
  T wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip rect modifier.
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip path modifier.
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip triangle modifier.
  T wrapClipTriangle({Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip rounded rectangle modifier.
  T wrapClipRRect({
    required BorderRadius borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return wrap(
      WidgetModifierConfig.clipRRect(
        borderRadius: BorderRadiusMix.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a visibility modifier.
  T wrapVisibility(bool visible) {
    return wrap(WidgetModifierConfig.visibility(visible));
  }

  /// Wraps the widget with an aspect ratio modifier.
  T wrapAspectRatio(double aspectRatio) {
    return wrap(WidgetModifierConfig.aspectRatio(aspectRatio));
  }

  /// Wraps the widget with a flexible modifier.
  T wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return wrap(
      WidgetModifierConfig.flexible(flex: flex, fit: fit),
    );
  }

  /// Wraps the widget with an expanded modifier.
  T wrapExpanded({int flex = 1}) {
    return wrap(
      WidgetModifierConfig.flexible(flex: flex, fit: FlexFit.tight),
    );
  }

  /// Wraps the widget with a scale transform modifier.
  T wrapScale(double scale, {Alignment alignment = Alignment.center}) {
    return wrap(
      WidgetModifierConfig.transform(
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotate transform modifier.
  T wrapRotate(double angle, {Alignment alignment = Alignment.center}) {
    return wrap(
      WidgetModifierConfig.transform(
        transform: Matrix4.rotationZ(angle),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a translate transform modifier.
  T wrapTranslate({double x = 0, double y = 0}) {
    return wrap(
      WidgetModifierConfig.transform(
        transform: Matrix4.translationValues(x, y, 0),
      ),
    );
  }

  /// Wraps the widget with a transform modifier.
  T wrapTransform(Matrix4 transform, {Alignment? alignment}) {
    return wrap(
      WidgetModifierConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a sized box modifier.
  T wrapSizedBox({double? width, double? height}) {
    return wrap(
      WidgetModifierConfig.sizedBox(width: width, height: height),
    );
  }

  /// Wraps the widget with constrained box modifier.
  T wrapConstrainedBox(BoxConstraints constraints) {
    // Convert BoxConstraints to SizedBox for simplicity
    return wrap(
      WidgetModifierConfig.sizedBox(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    );
  }

  /// Wraps the widget with an align modifier.
  T wrapAlign(AlignmentGeometry alignment) {
    return wrap(WidgetModifierConfig.align(alignment: alignment));
  }

  /// Wraps the widget with a center modifier.
  T wrapCenter() {
    return wrap(
      WidgetModifierConfig.align(alignment: Alignment.center),
    );
  }

  /// Wraps the widget with a fractionally sized box modifier.
  T wrapFractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return wrap(
      WidgetModifierConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotated box modifier.
  T wrapRotatedBox(int quarterTurns) {
    return wrap(WidgetModifierConfig.rotatedBox(quarterTurns));
  }

  /// Wraps the widget with an intrinsic width modifier.
  T wrapIntrinsicWidth() {
    return wrap(WidgetModifierConfig.intrinsicWidth());
  }

  /// Wraps the widget with an intrinsic height modifier.
  T wrapIntrinsicHeight() {
    return wrap(WidgetModifierConfig.intrinsicHeight());
  }

  /// Wraps the widget with a mouse cursor modifier.
  T wrapMouseCursor(MouseCursor cursor) {
    // Note: MouseCursorModifierMix needs to be wrapped in ModifierConfig
    return wrap(
      WidgetModifierConfig.modifier(
        MouseCursorModifierMix(mouseCursor: cursor),
      ),
    );
  }

  /// Wraps the widget with a default text style modifier.
  T wrapDefaultTextStyle(TextStyleMix style) {
    return wrap(
      WidgetModifierConfig.defaultTextStyle(style: style),
    );
  }

  /// Wraps the widget with an icon theme modifier.
  T wrapIconTheme(IconThemeData data) {
    return wrap(
      WidgetModifierConfig.iconTheme(
        color: data.color,
        size: data.size,
        fill: data.fill,
        weight: data.weight,
        grade: data.grade,
        opticalSize: data.opticalSize,
        opacity: data.opacity,
        shadows: data.shadows,
        applyTextScaling: data.applyTextScaling,
      ),
    );
  }
}
