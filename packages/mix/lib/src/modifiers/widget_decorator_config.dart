import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/modifier.dart';
import '../core/style.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import '../specs/text/text_attribute.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'clip_modifier.dart';
import 'default_text_style_modifier.dart';
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'icon_theme_modifier.dart';
import 'intrinsic_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

final class WidgetDecoratorConfig with Equatable {
  final List<Type>? $orderOfDecorators;
  final List<WidgetDecoratorStyle>? $decorators;

  const WidgetDecoratorConfig({
    List<WidgetDecoratorStyle>? decorators,
    List<Type>? orderOfDecorators,
  }) : $decorators = decorators,
       $orderOfDecorators = orderOfDecorators;

  factory WidgetDecoratorConfig.decorator(WidgetDecoratorStyle value) {
    return WidgetDecoratorConfig(decorators: [value]);
  }

  factory WidgetDecoratorConfig.decorators(List<WidgetDecoratorStyle> value) {
    return WidgetDecoratorConfig(decorators: value);
  }

  factory WidgetDecoratorConfig.orderOfDecorators(List<Type> value) {
    return WidgetDecoratorConfig(orderOfDecorators: value);
  }

  factory WidgetDecoratorConfig.opacity(double opacity) {
    return WidgetDecoratorConfig.decorator(
      OpacityModifierAttribute(opacity: opacity),
    );
  }

  factory WidgetDecoratorConfig.aspectRatio(double aspectRatio) {
    return WidgetDecoratorConfig.decorator(
      AspectRatioWidgetDecoratorStyle(aspectRatio: aspectRatio),
    );
  }

  factory WidgetDecoratorConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipOvalModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipRectModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetDecoratorConfig.decorator(
      ClipRRectModifierAttribute(
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
      ClipPathModifierAttribute(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.clipTriangle({Clip? clipBehavior}) {
    return WidgetDecoratorConfig.decorator(
      ClipTriangleModifierAttribute(clipBehavior: clipBehavior),
    );
  }

  factory WidgetDecoratorConfig.transform({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return WidgetDecoratorConfig.decorator(
      TransformModifierAttribute(transform: transform, alignment: alignment),
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
      VisibilityModifierAttribute(visible: visible),
    );
  }

  factory WidgetDecoratorConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return WidgetDecoratorConfig.decorator(
      AlignModifierAttribute(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory WidgetDecoratorConfig.padding(EdgeInsetsGeometryMix? padding) {
    return WidgetDecoratorConfig.decorator(
      PaddingModifierAttribute(padding: padding),
    );
  }

  factory WidgetDecoratorConfig.sizedBox({double? width, double? height}) {
    return WidgetDecoratorConfig.decorator(
      SizedBoxModifierAttribute(width: width, height: height),
    );
  }

  factory WidgetDecoratorConfig.flexible({int? flex, FlexFit? fit}) {
    return WidgetDecoratorConfig.decorator(
      FlexibleModifierAttribute(flex: flex, fit: fit),
    );
  }

  factory WidgetDecoratorConfig.rotatedBox(int quarterTurns) {
    return WidgetDecoratorConfig.decorator(
      RotatedBoxWidgetDecoratorStyle(quarterTurns: quarterTurns),
    );
  }

  factory WidgetDecoratorConfig.intrinsicHeight() {
    return WidgetDecoratorConfig.decorator(
      const IntrinsicHeightModifierAttribute(),
    );
  }

  factory WidgetDecoratorConfig.intrinsicWidth() {
    return WidgetDecoratorConfig.decorator(
      const IntrinsicWidthModifierAttribute(),
    );
  }

  factory WidgetDecoratorConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return WidgetDecoratorConfig.decorator(
      FractionallySizedBoxModifierAttribute(
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
      DefaultTextStyleModifierAttribute(
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
      DefaultTextStyleModifierAttribute.raw(
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
      IconThemeModifierAttribute(
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

  /// Orders modifiers according to the specified order or default order
  ///
  @visibleForTesting
  List<WidgetDecorator> reorderDecorators(List<WidgetDecorator> modifiers) {
    if (modifiers.isEmpty) return modifiers;

    final orderOfDecorators = {
      // Prioritize the order of modifiers provided by the user.
      ...?$orderOfDecorators,
      // Add the default order of modifiers.
      ..._defaultOrder,
      // Add any remaining modifiers that were not included in the order.
      ...modifiers.map((e) => e.runtimeType),
    }.toList();

    final orderedSpecs = <WidgetDecorator>[];

    for (final modifierType in orderOfDecorators) {
      // Find and add modifiers matching this type
      final modifier = modifiers
          .where((e) => e.runtimeType == modifierType)
          .firstOrNull;
      if (modifier != null) {
        orderedSpecs.add(modifier);
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

  WidgetDecoratorConfig modifiers(List<WidgetDecoratorStyle> value) {
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

  WidgetDecoratorConfig modifier(WidgetDecoratorStyle value) {
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
  List<WidgetDecoratorStyle>? mergeDecoratorLists(
    List<WidgetDecoratorStyle>? current,
    List<WidgetDecoratorStyle>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, WidgetDecoratorStyle> merged = {};

    // Add current modifiers
    for (final modifier in current) {
      merged[modifier.mergeKey] = modifier;
    }

    // Merge or add other modifiers
    for (final modifier in other) {
      final key = modifier.mergeKey;
      final existing = merged[key];
      merged[key] = existing != null ? existing.merge(modifier) : modifier;
    }

    return merged.values.toList();
  }

  /// Resolves the modifiers into a properly ordered list ready for rendering.
  /// Its important to order the list before resolving to ensure the correct order of modifiers
  List<WidgetDecorator> resolve(BuildContext context) {
    if ($decorators == null || $decorators!.isEmpty) return [];

    // Resolve each modifier attribute to its corresponding modifier spec
    final resolvedModifiers = <WidgetDecorator>[];
    for (final attribute in $decorators!) {
      final resolved = attribute.resolve(context);
      resolvedModifiers.add(resolved as WidgetDecorator);
    }

    return reorderDecorators(resolvedModifiers).cast();
  }

  @override
  List<Object?> get props => [$orderOfDecorators, $decorators];
}

const _defaultOrder = [
  // === PHASE 1: CONTEXT & BEHAVIOR SETUP ===

  // 1. FlexibleModifier: Controls flex behavior when used inside Row, Column, or Flex widgets.
  // Applied first to establish how the widget participates in flex layouts.
  FlexibleModifier,

  // 2. VisibilityModifier: Controls overall visibility with early exit optimization.
  // If invisible, subsequent modifiers are skipped, improving performance.
  VisibilityModifier,

  // 3. IconThemeModifier: Provides default icon styling context to descendant Icon widgets.
  // Applied early to establish icon theme before any layout calculations.
  IconThemeModifier,

  // 4. DefaultTextStyleModifier: Provides default text styling context to descendant Text widgets.
  // Applied early alongside IconTheme to establish text theme context before layout.
  DefaultTextStyleModifier,

  // === PHASE 2: SIZE ESTABLISHMENT ===

  // 5. SizedBoxModifier: Explicitly sets widget dimensions with fixed constraints.
  // Applied early to establish concrete size before relative sizing adjustments.
  SizedBoxModifier,

  // 6. FractionallySizedBoxModifier: Sets size relative to parent dimensions.
  // Applied after explicit sizing to allow responsive scaling within constraints.
  FractionallySizedBoxModifier,

  // 7. IntrinsicHeightModifier: Adjusts height based on child's intrinsic content height.
  // Applied to allow content-driven height calculations before aspect ratio constraints.
  IntrinsicHeightModifier,

  // 8. IntrinsicWidthModifier: Adjusts width based on child's intrinsic content width.
  // Applied alongside intrinsic height for complete content-driven sizing.
  IntrinsicWidthModifier,

  // 9. AspectRatioModifier: Maintains aspect ratio within established size constraints.
  // Applied after all other sizing to preserve aspect ratio in final dimensions.
  AspectRatioWidgetDecorator,

  // === PHASE 3: LAYOUT MODIFICATIONS ===

  // 10. RotatedBoxModifier: Rotates widget and changes its layout dimensions.
  // CRITICAL: Must come before AlignModifier because it changes layout space
  // (e.g., 200×100 widget becomes 100×200, affecting alignment calculations).
  RotatedBoxWidgetDecorator,

  // 11. AlignModifier: Positions widget within its allocated space.
  // Applied after RotatedBox to align based on final layout dimensions.
  AlignModifier,

  // === PHASE 4: SPACING ===

  // 12. PaddingModifier: Adds spacing around the widget content.
  // Applied after layout positioning to add space without affecting layout calculations.
  PaddingModifier,

  // === PHASE 5: VISUAL-ONLY EFFECTS ===

  // 13. TransformModifier: Applies visual transformations (scale, rotate, translate).
  // IMPORTANT: Visual-only - doesn't affect layout space, unlike RotatedBoxModifier.
  TransformModifier,

  // 14. Clip Modifiers: Applies visual clipping in various shapes.
  // Applied near the end to clip the widget's final visual appearance.
  ClipOvalModifier,
  ClipRRectModifier,
  ClipPathModifier,
  ClipTriangleModifier,
  ClipRectModifier,

  // 15. OpacityModifier: Applies transparency as the final visual effect.
  // Always applied last to ensure optimal performance and correct visual layering.
  OpacityModifier,
];
