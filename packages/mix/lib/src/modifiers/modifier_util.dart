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
import 'modifier_config.dart';
import 'mouse_cursor_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

/// Provides utilities for applying modifiers to styles.
final class ModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, WidgetDecoratorStyle> {
  /// Opacity modifier utility.
  late final opacity = OpacityModifierUtility<T>(builder);

  /// Transform modifier utility.
  late final transform = TransformModifierUtility<T>(builder);

  /// Visibility modifier utility.
  late final visibility = VisibilityModifierUtility<T>(builder);

  /// Aspect ratio modifier utility.
  late final aspectRatio = AspectRatioModifierUtility<T>(builder);

  /// Align modifier utility.
  late final align = AlignModifierUtility<T>(builder);

  /// Padding modifier utility.
  late final padding = PaddingModifierUtility<T>(builder);

  /// Sized box modifier utility.
  late final sizedBox = SizedBoxModifierUtility<T>(builder);

  /// Flexible modifier utility.
  late final flexible = FlexibleModifierUtility<T>(builder);

  /// Fractionally sized box modifier utility.
  late final fractionallySizedBox = FractionallySizedBoxModifierUtility<T>(
    builder,
  );

  /// Rotated box modifier utility.
  late final rotatedBox = RotatedBoxWidgetDecoratorUtility<T>(builder);

  /// Icon theme modifier utility.
  late final iconTheme = IconThemeModifierUtility<T>(builder);

  ModifierUtility(super.builder);

  /// Scales the widget by the given [value].
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => builder(const IntrinsicWidthModifierAttribute());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => builder(const IntrinsicHeightModifierAttribute());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectModifierAttribute(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return builder(ClipTriangleModifierAttribute(clipBehavior: clipBehavior));
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Resets all modifiers.
  T reset() => builder(const ResetModifierAttribute());
}

/// Provides convenient modifier methods for spec attributes.
mixin StyleModifierMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  /// Applies the given [value] modifier configuration.
  T modifier(WidgetDecoratorConfig value);

  /// Wraps the widget with an opacity modifier.
  T wrapOpacity(double opacity) {
    return modifier(WidgetDecoratorConfig.opacity(opacity));
  }

  /// Wraps the widget with a padding modifier.
  T wrapPadding(EdgeInsetsGeometryMix padding) {
    return modifier(WidgetDecoratorConfig.padding(padding));
  }

  /// Wraps the widget with a clip oval modifier.
  T wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return modifier(
      WidgetDecoratorConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip rect modifier.
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return modifier(
      WidgetDecoratorConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip path modifier.
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return modifier(
      WidgetDecoratorConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip triangle modifier.
  T wrapClipTriangle({Clip? clipBehavior}) {
    return modifier(
      WidgetDecoratorConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip rounded rectangle modifier.
  T wrapClipRRect({
    required BorderRadius borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return modifier(
      WidgetDecoratorConfig.clipRRect(
        borderRadius: BorderRadiusMix.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a visibility modifier.
  T wrapVisibility(bool visible) {
    return modifier(WidgetDecoratorConfig.visibility(visible));
  }

  /// Wraps the widget with an aspect ratio modifier.
  T wrapAspectRatio(double aspectRatio) {
    return modifier(WidgetDecoratorConfig.aspectRatio(aspectRatio));
  }

  /// Wraps the widget with a flexible modifier.
  T wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return modifier(WidgetDecoratorConfig.flexible(flex: flex, fit: fit));
  }

  /// Wraps the widget with an expanded modifier.
  T wrapExpanded({int flex = 1}) {
    return modifier(
      WidgetDecoratorConfig.flexible(flex: flex, fit: FlexFit.tight),
    );
  }

  /// Wraps the widget with a scale transform modifier.
  T wrapScale(double scale, {Alignment alignment = Alignment.center}) {
    return modifier(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotate transform modifier.
  T wrapRotate(double angle, {Alignment alignment = Alignment.center}) {
    return modifier(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.rotationZ(angle),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a translate transform modifier.
  T wrapTranslate({double x = 0, double y = 0}) {
    return modifier(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.translationValues(x, y, 0),
      ),
    );
  }

  /// Wraps the widget with a transform modifier.
  T wrapTransform(Matrix4 transform, {Alignment? alignment}) {
    return modifier(
      WidgetDecoratorConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a sized box modifier.
  T wrapSizedBox({double? width, double? height}) {
    return modifier(
      WidgetDecoratorConfig.sizedBox(width: width, height: height),
    );
  }

  /// Wraps the widget with constrained box modifier.
  T wrapConstrainedBox(BoxConstraints constraints) {
    // Convert BoxConstraints to SizedBox for simplicity
    return modifier(
      WidgetDecoratorConfig.sizedBox(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    );
  }

  /// Wraps the widget with an align modifier.
  T wrapAlign(AlignmentGeometry alignment) {
    return modifier(WidgetDecoratorConfig.align(alignment: alignment));
  }

  /// Wraps the widget with a center modifier.
  T wrapCenter() {
    return modifier(WidgetDecoratorConfig.align(alignment: Alignment.center));
  }

  /// Wraps the widget with a fractionally sized box modifier.
  T wrapFractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return modifier(
      WidgetDecoratorConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotated box modifier.
  T wrapRotatedBox(int quarterTurns) {
    return modifier(WidgetDecoratorConfig.rotatedBox(quarterTurns));
  }

  /// Wraps the widget with an intrinsic width modifier.
  T wrapIntrinsicWidth() {
    return modifier(WidgetDecoratorConfig.intrinsicWidth());
  }

  /// Wraps the widget with an intrinsic height modifier.
  T wrapIntrinsicHeight() {
    return modifier(WidgetDecoratorConfig.intrinsicHeight());
  }

  /// Wraps the widget with a mouse cursor modifier.
  T wrapMouseCursor(MouseCursor cursor) {
    // Note: MouseCursorDecoratorMix needs to be wrapped in ModifierConfig
    return modifier(
      WidgetDecoratorConfig.decorator(
        MouseCursorDecoratorMix(mouseCursor: cursor),
      ),
    );
  }

  /// Wraps the widget with a default text style modifier.
  T wrapDefaultTextStyle(TextStyleMix style) {
    return modifier(WidgetDecoratorConfig.defaultTextStyle(style: style));
  }

  /// Wraps the widget with an icon theme modifier.
  T wrapIconTheme(IconThemeData data) {
    return modifier(
      WidgetDecoratorConfig.iconTheme(
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
