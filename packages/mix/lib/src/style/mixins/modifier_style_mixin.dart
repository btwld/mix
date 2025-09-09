import 'package:flutter/widgets.dart';

import '../../core/spec.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/mouse_cursor_modifier.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../specs/box/box_style.dart';

/// Provides convenient modifier styling methods for spec attributes.
mixin ModifierStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
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
      WidgetModifierConfig.clipOval(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip rect modifier.
  T wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipRect(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip path modifier.
  T wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return wrap(
      WidgetModifierConfig.clipPath(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  /// Wraps the widget with a clip triangle modifier.
  T wrapClipTriangle({Clip? clipBehavior}) {
    return wrap(WidgetModifierConfig.clipTriangle(clipBehavior: clipBehavior));
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
    return wrap(WidgetModifierConfig.flexible(flex: flex, fit: fit));
  }

  /// Wraps the widget with an expanded modifier.
  T wrapExpanded({int flex = 1}) {
    return wrap(WidgetModifierConfig.flexible(flex: flex, fit: FlexFit.tight));
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
  T wrapTranslate(double x, double y, [double z = 0.0]) {
    return wrap(
      WidgetModifierConfig.transform(transform: Matrix4.translationValues(x, y, z)),
    );
  }

  /// Wraps the widget with a transform modifier.
  T wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center}) {
    return wrap(
      WidgetModifierConfig.transform(transform: transform, alignment: alignment),
    );
  }

  /// Wraps the widget with a sized box modifier.
  T wrapSizedBox({double? width, double? height}) {
    return wrap(WidgetModifierConfig.sizedBox(width: width, height: height));
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
    return wrap(WidgetModifierConfig.align(alignment: Alignment.center));
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
    // Note: MouseCursorModifierMix needs to be wrapped in WidgetModifierConfig
    return wrap(
      WidgetModifierConfig.widgetModifier(MouseCursorModifierMix(mouseCursor: cursor)),
    );
  }

  /// Wraps the widget with a default text style modifier.
  T wrapDefaultTextStyle(TextStyleMix style) {
    return wrap(WidgetModifierConfig.defaultTextStyle(style: style));
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

  // TODO: Fix ShaderCallbackBuilder type issue
  // /// Wraps the widget with a shader mask modifier.
  // T wrapShaderMask({
  //   required ShaderCallbackBuilder shaderCallback,
  //   BlendMode blendMode = BlendMode.modulate,
  // }) {
  //   return wrap(
  //     WidgetModifierConfig.shaderMask(
  //       shaderCallback: shaderCallback,
  //       blendMode: blendMode,
  //     ),
  //   );
  // }

  /// Wraps the widget with a box modifier.
  T wrapBox(BoxStyler spec) {
    return wrap(WidgetModifierConfig.box(spec));
  }
}