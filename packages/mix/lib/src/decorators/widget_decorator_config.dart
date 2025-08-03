import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/style.dart';
import '../core/widget_decorator.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import '../specs/text/text_attribute.dart';
import 'align_decorator.dart';
import 'aspect_ratio_decorator.dart';
import 'clip_decorator.dart';
import 'default_text_style_decorator.dart';
import 'flexible_decorator.dart';
import 'fractionally_sized_box_decorator.dart';
import 'icon_theme_decorator.dart';
import 'internal/reset_decorator.dart';
import 'intrinsic_decorator.dart';
import 'opacity_decorator.dart';
import 'padding_decorator.dart';
import 'rotated_box_decorator.dart';
import 'sized_box_decorator.dart';
import 'transform_decorator.dart';
import 'visibility_decorator.dart';

final class WidgetDecoratorConfig with Equatable {
  final List<Type>? $orderOfDecorators;
  final List<WidgetDecoratorMix>? $decorators;

  const WidgetDecoratorConfig({
    List<WidgetDecoratorMix>? decorators,
    List<Type>? orderOfDecorators,
  }) : $decorators = decorators,
       $orderOfDecorators = orderOfDecorators;

  factory WidgetDecoratorConfig.decorator(WidgetDecoratorMix value) {
    return WidgetDecoratorConfig(decorators: [value]);
  }

  factory WidgetDecoratorConfig.decorators(List<WidgetDecoratorMix> value) {
    return WidgetDecoratorConfig(decorators: value);
  }

  factory WidgetDecoratorConfig.orderOfDecorators(List<Type> value) {
    return WidgetDecoratorConfig(orderOfDecorators: value);
  }

  factory WidgetDecoratorConfig.opacity(double opacity) {
    return WidgetDecoratorConfig.decorator(
      OpacityWidgetDecoratorMix(opacity: opacity),
    );
  }

  factory WidgetDecoratorConfig.aspectRatio(double aspectRatio) {
    return WidgetDecoratorConfig.decorator(
      AspectRatioWidgetDecoratorMix(aspectRatio: aspectRatio),
    );
  }

  factory WidgetDecoratorConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipOvalWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipRectWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipRRectWidgetDecoratorMix(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  factory WidgetDecoratorConfig.clipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipPathWidgetDecoratorMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipTriangle({Clip? clipBehavior}) {
    return WidgetDecoratorConfig.decorator(
      ClipTriangleWidgetDecoratorMix(clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.transform({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return WidgetDecoratorConfig.decorator(
      TransformWidgetDecoratorMix(transform: transform, alignment: alignment),
    );
  }

  /// Scale using tarnsform
  factory WidgetDecoratorConfig.scale(
    double scale, {
    Alignment alignment = Alignment.center,
  }) {
    return WidgetDecoratorConfig.transform(
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      alignment: alignment,
    );
  }

  factory WidgetDecoratorConfig.visibility(bool visible) {
    return WidgetDecoratorConfig.decorator(
      VisibilityWidgetDecoratorMix(visible: visible),
    );
  }

  factory WidgetDecoratorConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return WidgetDecoratorConfig.decorator(
      AlignWidgetDecoratorMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory WidgetDecoratorConfig.padding(EdgeInsetsGeometryMix? padding) {
    return WidgetDecoratorConfig.decorator(
      PaddingWidgetDecoratorMix(padding: padding),
    );
  }

  factory WidgetDecoratorConfig.sizedBox({double? width, double? height}) {
    return WidgetDecoratorConfig.decorator(
      SizedBoxWidgetDecoratorMix(width: width, height: height),
    );
  }

  factory WidgetDecoratorConfig.flexible({int? flex, FlexFit? fit}) {
    return WidgetDecoratorConfig.decorator(
      FlexibleWidgetDecoratorMix(flex: flex, fit: fit),
    );
  }

  factory WidgetDecoratorConfig.rotatedBox(int quarterTurns) {
    return WidgetDecoratorConfig.decorator(
      RotatedBoxWidgetDecoratorMix(quarterTurns: quarterTurns),
    );
  }

  factory WidgetDecoratorConfig.intrinsicHeight() {
    return WidgetDecoratorConfig.decorator(
      const IntrinsicHeightWidgetDecoratorMix(),
    );
  }

  factory WidgetDecoratorConfig.intrinsicWidth() {
    return WidgetDecoratorConfig.decorator(
      const IntrinsicWidthWidgetDecoratorMix(),
    );
  }

  factory WidgetDecoratorConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return WidgetDecoratorConfig.decorator(
      FractionallySizedBoxWidgetDecoratorMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  factory WidgetDecoratorConfig.defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      DefaultTextStyleWidgetDecoratorMix(
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }

  factory WidgetDecoratorConfig.defaultText(TextMix textMix) {
    return WidgetDecoratorConfig.decorator(
      DefaultTextStyleWidgetDecoratorMix.raw(
        style: textMix.$style,
        textAlign: textMix.$textAlign,
        softWrap: textMix.$softWrap,
        overflow: textMix.$overflow,
        maxLines: textMix.$maxLines,
        textWidthBasis: textMix.$textWidthBasis,
        textHeightBehavior: textMix.$textHeightBehavior,
      ),
    );
  }

  factory WidgetDecoratorConfig.iconTheme({
    Color? color,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    double? opacity,
    List<Shadow>? shadows,
    bool? applyTextScaling,
  }) {
    return WidgetDecoratorConfig.decorator(
      IconThemeWidgetDecoratorMix(
        color: color,
        size: size,
        fill: fill,
        weight: weight,
        grade: grade,
        opticalSize: opticalSize,
        opacity: opacity,
        shadows: shadows?.map((shadow) => ShadowMix.value(shadow)).toList(),
        applyTextScaling: applyTextScaling,
      ),
    );
  }

  /// Orders decorators according to the specified order or default order
  ///
  @visibleForTesting
  List<WidgetDecorator> reorderDecorators(List<WidgetDecorator> decorators) {
    if (decorators.isEmpty) return decorators;

    final orderOfDecorators = {
      // Prioritize the order of decorators provided by the user.
      ...?$orderOfDecorators,
      // Add the default order of decorators.
      ..._defaultOrder,
      // Add any remaining decorators that were not included in the order.
      ...decorators.map((e) => e.runtimeType),
    }.toList();

    final orderedSpecs = <WidgetDecorator>[];

    for (final decoratorType in orderOfDecorators) {
      // Find and add decorators matching this type
      final decorator = decorators
          .where((e) => e.runtimeType == decoratorType)
          .firstOrNull;
      if (decorator != null) {
        orderedSpecs.add(decorator);
      }
    }

    return orderedSpecs;
  }

  WidgetDecoratorConfig scale(
    double scale, {
    Alignment alignment = Alignment.center,
  }) {
    return merge(WidgetDecoratorConfig.scale(scale, alignment: alignment));
  }

  WidgetDecoratorConfig opacity(double value) {
    return merge(WidgetDecoratorConfig.opacity(value));
  }

  WidgetDecoratorConfig aspectRatio(double value) {
    return merge(WidgetDecoratorConfig.aspectRatio(value));
  }

  WidgetDecoratorConfig clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetDecoratorConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetDecoratorConfig clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetDecoratorConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetDecoratorConfig decorators(List<WidgetDecoratorMix> value) {
    return merge(WidgetDecoratorConfig.decorators(value));
  }

  WidgetDecoratorConfig clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetDecoratorConfig.clipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetDecoratorConfig clipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetDecoratorConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetDecoratorConfig clipTriangle({Clip? clipBehavior}) {
    return merge(
      WidgetDecoratorConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  WidgetDecoratorConfig transform({Matrix4? transform, Alignment? alignment}) {
    return merge(
      WidgetDecoratorConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  WidgetDecoratorConfig visibility(bool visible) {
    return merge(WidgetDecoratorConfig.visibility(visible));
  }

  WidgetDecoratorConfig align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return merge(
      WidgetDecoratorConfig.align(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  WidgetDecoratorConfig padding(EdgeInsetsGeometryMix? padding) {
    return merge(WidgetDecoratorConfig.padding(padding));
  }

  WidgetDecoratorConfig sizedBox({double? width, double? height}) {
    return merge(WidgetDecoratorConfig.sizedBox(width: width, height: height));
  }

  WidgetDecoratorConfig flexible({int? flex, FlexFit? fit}) {
    return merge(WidgetDecoratorConfig.flexible(flex: flex, fit: fit));
  }

  WidgetDecoratorConfig rotatedBox(int quarterTurns) {
    return merge(WidgetDecoratorConfig.rotatedBox(quarterTurns));
  }

  WidgetDecoratorConfig intrinsicHeight() {
    return merge(WidgetDecoratorConfig.intrinsicHeight());
  }

  WidgetDecoratorConfig intrinsicWidth() {
    return merge(WidgetDecoratorConfig.intrinsicWidth());
  }

  WidgetDecoratorConfig fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return merge(
      WidgetDecoratorConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  WidgetDecoratorConfig defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return merge(
      WidgetDecoratorConfig.defaultTextStyle(
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }

  WidgetDecoratorConfig defaultText(TextMix textMix) {
    return merge(WidgetDecoratorConfig.defaultText(textMix));
  }

  WidgetDecoratorConfig decorator(WidgetDecoratorMix value) {
    return merge(WidgetDecoratorConfig.decorator(value));
  }

  WidgetDecoratorConfig orderOfDecorators(List<Type> value) {
    return merge(WidgetDecoratorConfig.orderOfDecorators(value));
  }

  WidgetDecoratorConfig merge(WidgetDecoratorConfig? other) {
    if (other == null) return this;

    return WidgetDecoratorConfig(
      decorators: mergeDecoratorLists($decorators, other.$decorators),
      orderOfDecorators: (other.$orderOfDecorators?.isNotEmpty == true)
          ? other.$orderOfDecorators
          : $orderOfDecorators,
    );
  }

  @protected
  List<WidgetDecoratorMix>? mergeDecoratorLists(
    List<WidgetDecoratorMix>? current,
    List<WidgetDecoratorMix>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, WidgetDecoratorMix> merged = {};

    // Add current decorators
    for (final decorator in current) {
      merged[decorator.mergeKey] = decorator;
    }

    // Merge or add other decorators
    for (final decorator in other) {
      final key = decorator.mergeKey;

      /// If the other decorators is a reset, clear the merged map
      if (key == ResetWidgetDecoratorMix().mergeKey) {
        merged.clear();
        continue;
      }
      final existing = merged[key];
      merged[key] = existing != null ? existing.merge(decorator) : decorator;
    }

    return merged.values.toList();
  }

  /// Resolves the decorators into a properly ordered list ready for rendering.
  /// Its important to order the list before resolving to ensure the correct order of decorators
  List<WidgetDecorator> resolve(BuildContext context) {
    if ($decorators == null || $decorators!.isEmpty) return [];

    // Resolve each decorator attribute to its corresponding decorator spec
    final resolvedDecorators = <WidgetDecorator>[];
    for (final attribute in $decorators!) {
      final resolved = attribute.resolve(context);
      resolvedDecorators.add(resolved as WidgetDecorator);
    }

    return reorderDecorators(resolvedDecorators).cast();
  }

  @override
  List<Object?> get props => [$orderOfDecorators, $decorators];
}

const _defaultOrder = [
  // === PHASE 1: CONTEXT & BEHAVIOR SETUP ===

  // 1. FlexibleWidgetDecorator: Controls flex behavior when used inside Row, Column, or Flex widgets.
  // Applied first to establish how the widget participates in flex layouts.
  FlexibleWidgetDecorator,

  // 2. VisibilityWidgetDecorator: Controls overall visibility with early exit optimization.
  // If invisible, subsequent modifiers are skipped, improving performance.
  VisibilityWidgetDecorator,

  // 3. IconThemeWidgetDecorator: Provides default icon styling context to descendant Icon widgets.
  // Applied early to establish icon theme before any layout calculations.
  IconThemeWidgetDecorator,

  // 4. DefaultTextStyleWidgetDecorator: Provides default text styling context to descendant Text widgets.
  // Applied early alongside IconTheme to establish text theme context before layout.
  DefaultTextStyleWidgetDecorator,

  // === PHASE 2: SIZE ESTABLISHMENT ===

  // 5. SizedBoxWidgetDecorator: Explicitly sets widget dimensions with fixed constraints.
  // Applied early to establish concrete size before relative sizing adjustments.
  SizedBoxWidgetDecorator,

  // 6. FractionallySizedBoxWidgetDecorator: Sets size relative to parent dimensions.
  // Applied after explicit sizing to allow responsive scaling within constraints.
  FractionallySizedBoxWidgetDecorator,

  // 7. IntrinsicHeightWidgetDecorator: Adjusts height based on child's intrinsic content height.
  // Applied to allow content-driven height calculations before aspect ratio constraints.
  IntrinsicHeightWidgetDecorator,

  // 8. IntrinsicWidthWidgetDecorator: Adjusts width based on child's intrinsic content width.
  // Applied alongside intrinsic height for complete content-driven sizing.
  IntrinsicWidthWidgetDecorator,

  // 9. AspectRatioWidgetDecorator: Maintains aspect ratio within established size constraints.
  // Applied after all other sizing to preserve aspect ratio in final dimensions.
  AspectRatioWidgetDecorator,

  // === PHASE 3: LAYOUT MODIFICATIONS ===

  // 10. RotatedBoxWidgetDecorator: Rotates widget and changes its layout dimensions.
  // CRITICAL: Must come before AlignWidgetDecorator because it changes layout space
  // (e.g., 200×100 widget becomes 100×200, affecting alignment calculations).
  RotatedBoxWidgetDecorator,

  // 11. AlignWidgetDecorator: Positions widget within its allocated space.
  // Applied after RotatedBox to align based on final layout dimensions.
  AlignWidgetDecorator,

  // === PHASE 4: SPACING ===

  // 12. PaddingWidgetDecorator: Adds spacing around the widget content.
  // Applied after layout positioning to add space without affecting layout calculations.
  PaddingWidgetDecorator,

  // === PHASE 5: VISUAL-ONLY EFFECTS ===

  // 13. TransformWidgetDecorator: Applies visual transformations (scale, rotate, translate).
  // IMPORTANT: Visual-only - doesn't affect layout space, unlike RotatedBoxWidgetDecorator.
  TransformWidgetDecorator,

  // 14. Clip Decorators: Applies visual clipping in various shapes.
  // Applied near the end to clip the widget's final visual appearance.
  ClipOvalWidgetDecorator,
  ClipRRectWidgetDecorator,
  ClipPathWidgetDecorator,
  ClipTriangleWidgetDecorator,
  ClipRectWidgetDecorator,

  // 15. OpacityWidgetDecorator: Applies transparency as the final visual effect.
  // Always applied last to ensure optimal performance and correct visual layering.
  OpacityWidgetDecorator,
];
