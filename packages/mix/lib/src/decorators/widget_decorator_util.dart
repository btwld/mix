import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/typography/text_style_mix.dart';
import 'align_decorator.dart';
import 'aspect_ratio_decorator.dart';
import 'clip_decorator.dart';
import 'flexible_decorator.dart';
import 'fractionally_sized_box_decorator.dart';
import 'icon_theme_decorator.dart';
import 'internal/reset_decorator.dart';
import 'intrinsic_decorator.dart';
import 'mouse_cursor_decorator.dart';
import 'opacity_decorator.dart';
import 'padding_decorator.dart';
import 'rotated_box_decorator.dart';
import 'sized_box_decorator.dart';
import 'transform_decorator.dart';
import 'visibility_decorator.dart';
import 'widget_decorator_config.dart';

/// Provides utilities for applying decorators to styles.
final class WidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, WidgetDecoratorMix> {
  /// Opacity decorator utility.
  late final opacity = OpacityWidgetDecoratorUtility<T>(builder);

  /// Transform decorator utility.
  late final transform = TransformWidgetDecoratorUtility<T>(builder);

  /// Visibility decorator utility.
  late final visibility = VisibilityWidgetDecoratorUtility<T>(builder);

  /// Aspect ratio decorator utility.
  late final aspectRatio = AspectRatioWidgetDecoratorUtility<T>(builder);

  /// Align decorator utility.
  late final align = AlignWidgetDecoratorUtility<T>(builder);

  /// Padding decorator utility.
  late final padding = PaddingWidgetDecoratorUtility<T>(builder);

  /// Sized box decorator utility.
  late final sizedBox = SizedBoxWidgetDecoratorUtility<T>(builder);

  /// Flexible decorator utility.
  late final flexible = FlexibleWidgetDecoratorUtility<T>(builder);

  /// Fractionally sized box decorator utility.
  late final fractionallySizedBox =
      FractionallySizedBoxWidgetDecoratorUtility<T>(builder);

  /// Rotated box decorator utility.
  late final rotatedBox = RotatedBoxWidgetDecoratorUtility<T>(builder);

  /// Icon theme decorator utility.
  late final iconTheme = IconThemeWidgetDecoratorUtility<T>(builder);

  WidgetDecoratorUtility(super.builder);

  /// Scales the widget by the given [value].
  T scale(double value) => transform.scale(value);

  /// Rotates the widget by the given [value] in radians.
  T rotate(double value) => transform.rotate(value);

  /// Makes the widget take up only its intrinsic width.
  T intrinsicWidth() => builder(const IntrinsicWidthWidgetDecoratorMix());

  /// Makes the widget take up only its intrinsic height.
  T intrinsicHeight() => builder(const IntrinsicHeightWidgetDecoratorMix());

  /// Clips the widget to an oval shape.
  T clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a rounded rectangle.
  T clipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectWidgetDecoratorMix(
        borderRadius: BorderRadiusMix.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Clips the widget to a rectangle.
  T clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Clips the widget to a triangle shape.
  T clipTriangle({Clip? clipBehavior}) {
    return builder(ClipTriangleWidgetDecoratorMix(clipBehavior: clipBehavior));
  }

  /// Clips the widget to a custom path.
  T clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Resets all decorators.
  T reset() => builder(const ResetWidgetDecoratorMix());
}

/// Provides convenient decorator methods for spec attributes.
mixin StyleWidgetDecoratorMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  /// Applies the given [value] decorator configuration.
  T widgetDecorator(WidgetDecoratorConfig value);

  T wrap(WidgetDecoratorConfig value) {
    return widgetDecorator(value);
  }

  /// Wraps the widget with an opacity decorator.
  T wrapOpacity(double opacity) {
    return widgetDecorator(WidgetDecoratorConfig.opacity(opacity));
  }

  /// Wraps the widget with a padding decorator.
  T wrapPadding(EdgeInsetsGeometryMix padding) {
    return widgetDecorator(WidgetDecoratorConfig.padding(padding));
  }

  /// Wraps the widget with a clip oval decorator.
  T wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip rect decorator.
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip path decorator.
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  /// Wraps the widget with a clip triangle decorator.
  T wrapClipTriangle({Clip? clipBehavior}) {
    return widgetDecorator(
      WidgetDecoratorConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip rounded rectangle decorator.
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

  /// Wraps the widget with a visibility decorator.
  T wrapVisibility(bool visible) {
    return widgetDecorator(WidgetDecoratorConfig.visibility(visible));
  }

  /// Wraps the widget with an aspect ratio decorator.
  T wrapAspectRatio(double aspectRatio) {
    return widgetDecorator(WidgetDecoratorConfig.aspectRatio(aspectRatio));
  }

  /// Wraps the widget with a flexible decorator.
  T wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return widgetDecorator(
      WidgetDecoratorConfig.flexible(flex: flex, fit: fit),
    );
  }

  /// Wraps the widget with an expanded decorator.
  T wrapExpanded({int flex = 1}) {
    return widgetDecorator(
      WidgetDecoratorConfig.flexible(flex: flex, fit: FlexFit.tight),
    );
  }

  /// Wraps the widget with a scale transform decorator.
  T wrapScale(double scale, {Alignment alignment = Alignment.center}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a rotate transform decorator.
  T wrapRotate(double angle, {Alignment alignment = Alignment.center}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.rotationZ(angle),
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a translate transform decorator.
  T wrapTranslate({double x = 0, double y = 0}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: Matrix4.translationValues(x, y, 0),
      ),
    );
  }

  /// Wraps the widget with a transform decorator.
  T wrapTransform(Matrix4 transform, {Alignment? alignment}) {
    return widgetDecorator(
      WidgetDecoratorConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  /// Wraps the widget with a sized box decorator.
  T wrapSizedBox({double? width, double? height}) {
    return widgetDecorator(
      WidgetDecoratorConfig.sizedBox(width: width, height: height),
    );
  }

  /// Wraps the widget with constrained box decorator.
  T wrapConstrainedBox(BoxConstraints constraints) {
    // Convert BoxConstraints to SizedBox for simplicity
    return widgetDecorator(
      WidgetDecoratorConfig.sizedBox(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    );
  }

  /// Wraps the widget with an align decorator.
  T wrapAlign(AlignmentGeometry alignment) {
    return widgetDecorator(WidgetDecoratorConfig.align(alignment: alignment));
  }

  /// Wraps the widget with a center decorator.
  T wrapCenter() {
    return widgetDecorator(
      WidgetDecoratorConfig.align(alignment: Alignment.center),
    );
  }

  /// Wraps the widget with a fractionally sized box decorator.
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

  /// Wraps the widget with a rotated box decorator.
  T wrapRotatedBox(int quarterTurns) {
    return widgetDecorator(WidgetDecoratorConfig.rotatedBox(quarterTurns));
  }

  /// Wraps the widget with an intrinsic width decorator.
  T wrapIntrinsicWidth() {
    return widgetDecorator(WidgetDecoratorConfig.intrinsicWidth());
  }

  /// Wraps the widget with an intrinsic height decorator.
  T wrapIntrinsicHeight() {
    return widgetDecorator(WidgetDecoratorConfig.intrinsicHeight());
  }

  /// Wraps the widget with a mouse cursor decorator.
  T wrapMouseCursor(MouseCursor cursor) {
    // Note: MouseCursorDecoratorMix needs to be wrapped in ModifierConfig
    return widgetDecorator(
      WidgetDecoratorConfig.decorator(
        MouseCursorDecoratorMix(mouseCursor: cursor),
      ),
    );
  }

  /// Wraps the widget with a default text style decorator.
  T wrapDefaultTextStyle(TextStyleMix style) {
    return widgetDecorator(
      WidgetDecoratorConfig.defaultTextStyle(style: style),
    );
  }

  /// Wraps the widget with an icon theme decorator.
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
