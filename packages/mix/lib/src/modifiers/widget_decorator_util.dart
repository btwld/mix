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
import 'widget_decorator_config.dart';

/// Provides utilities for applying modifiers to styles.
final class WidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, WidgetDecoratorStyle> {
  /// Opacity modifier utility.
  late final opacity = OpacityWidgetDecoratorUtility<T>(builder);

  /// Transform modifier utility.
  late final transform = TransformWidgetDecoratorUtility<T>(builder);

  /// Visibility modifier utility.
  late final visibility = VisibilityWidgetDecoratorUtility<T>(builder);

  /// Aspect ratio modifier utility.
  late final aspectRatio = AspectRatioWidgetDecoratorUtility<T>(builder);

  /// Align modifier utility.
  late final align = AlignWidgetDecoratorUtility<T>(builder);

  /// Padding modifier utility.
  late final padding = PaddingWidgetDecoratorUtility<T>(builder);

  /// Sized box modifier utility.
  late final sizedBox = SizedBoxWidgetDecoratorUtility<T>(builder);

  /// Flexible modifier utility.
  late final flexible = FlexibleWidgetDecoratorUtility<T>(builder);

  /// Fractionally sized box modifier utility.
  late final fractionallySizedBox = FractionallySizedBoxWidgetDecoratorUtility<T>(
    builder,
  );

  /// Rotated box modifier utility.
  late final rotatedBox = RotatedBoxWidgetDecoratorUtility<T>(builder);

  /// Icon theme modifier utility.
  late final iconTheme = IconThemeWidgetDecoratorUtility<T>(builder);

  WidgetDecoratorUtility(super.builder);

  /// Scales the widget by the given [value].
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => builder(const IntrinsicWidthWidgetDecoratorStyle());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => builder(const IntrinsicHeightWidgetDecoratorStyle());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalWidgetDecoratorStyle(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectWidgetDecoratorStyle(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectWidgetDecoratorStyle(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return builder(ClipTriangleWidgetDecoratorStyle(clipBehavior: clipBehavior));
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathWidgetDecoratorStyle(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Resets all modifiers.
  T reset() => builder(const ResetWidgetDecoratorStyle());
}

/// Provides convenient modifier methods for spec attributes.
mixin StyleWidgetDecoratorMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  /// Applies the given [value] modifier configuration.
  T widgetDecorator(WidgetDecoratorConfig value);

  /// Wraps the widget with an opacity modifier.
  T wrapOpacity(double opacity) {
    return widgetDecorator(WidgetDecoratorConfig.opacity(opacity));
  }

  /// Wraps the widget with a padding modifier.
  T wrapPadding(EdgeInsetsGeometryMix padding) {
    return widgetDecorator(WidgetDecoratorConfig.padding(padding));
  }

  /// Wraps the widget with a clip oval modifier.
  T wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip rect modifier.
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip path modifier.
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip triangle modifier.
  T wrapClipTriangle({Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip rounded rectangle modifier.
  T wrapClipRRect({
    required BorderRadius borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipRRect(
        borderRadius: BorderRadiusMix.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a visibility modifier.
  T wrapVisibility(bool visible) {
    return widgetDecorator(WidgetDecoratorConfig.visibility(visible));
  }

  /// Wraps the widget with an aspect ratio modifier.
  T wrapAspectRatio(double aspectRatio) {
    return widgetDecorator(WidgetDecoratorConfig.aspectRatio(aspectRatio));
  }

  /// Wraps the widget with a flexible modifier.
  T wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return widgetDecorator(
      WidgetDecoratorConfig.flexible(flex: flex, fit: fit),
    );
  }

  /// Wraps the widget with an expanded modifier.
  T wrapExpanded({int flex = 1}) {
    return widgetDecorator(
      WidgetDecoratorConfig.flexible(flex: flex, fit: FlexFit.tight),
    );
  }

  /// Wraps the widget with a scale transform modifier.
  T wrapScale(double scale, {Alignment alignment = Alignment.center}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotate transform modifier.
  T wrapRotate(double angle, {Alignment alignment = Alignment.center}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.rotationZ(angle),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a translate transform modifier.
  T wrapTranslate({double x = 0, double y = 0}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.translationValues(x, y, 0),
      ),
    );
  }

  /// Wraps the widget with a transform modifier.
  T wrapTransform(Matrix4 transform, {Alignment? alignment}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a sized box modifier.
  T wrapSizedBox({double? width, double? height}) {
    return widgetDecorator(
      WidgetDecoratorConfig.sizedBox(width: width, height: height),
    );
  }

  /// Wraps the widget with constrained box modifier.
  T wrapConstrainedBox(BoxConstraints constraints) {
    // Convert BoxConstraints to SizedBox for simplicity
    return widgetDecorator(
      WidgetDecoratorConfig.sizedBox(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    );
  }

  /// Wraps the widget with an align modifier.
  T wrapAlign(AlignmentGeometry alignment) {
    return widgetDecorator(WidgetDecoratorConfig.align(alignment: alignment));
  }

  /// Wraps the widget with a center modifier.
  T wrapCenter() {
    return widgetDecorator(
      WidgetDecoratorConfig.align(alignment: Alignment.center),
    );
  }

  /// Wraps the widget with a fractionally sized box modifier.
  T wrapFractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return widgetDecorator(
      WidgetDecoratorConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotated box modifier.
  T wrapRotatedBox(int quarterTurns) {
    return widgetDecorator(WidgetDecoratorConfig.rotatedBox(quarterTurns));
  }

  /// Wraps the widget with an intrinsic width modifier.
  T wrapIntrinsicWidth() {
    return widgetDecorator(WidgetDecoratorConfig.intrinsicWidth());
  }

  /// Wraps the widget with an intrinsic height modifier.
  T wrapIntrinsicHeight() {
    return widgetDecorator(WidgetDecoratorConfig.intrinsicHeight());
  }

  /// Wraps the widget with a mouse cursor modifier.
  T wrapMouseCursor(MouseCursor cursor) {
    // Note: MouseCursorDecoratorMix needs to be wrapped in ModifierConfig
    return widgetDecorator(
      WidgetDecoratorConfig.decorator(
        MouseCursorDecoratorMix(mouseCursor: cursor),
      ),
    );
  }

  /// Wraps the widget with a default text style modifier.
  T wrapDefaultTextStyle(TextStyleMix style) {
    return widgetDecorator(
      WidgetDecoratorConfig.defaultTextStyle(style: style),
    );
  }

  /// Wraps the widget with an icon theme modifier.
  T wrapIconTheme(IconThemeData data) {
    return widgetDecorator(
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
